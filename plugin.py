from __future__ import (absolute_import, division, print_function, unicode_literals)
import logging
import datetime
import time
import sys
import urllib2
import json

import boundary_plugin
import boundary_accumulator

"""
If getting statistics fails, we will retry up to this number of times before
giving up and aborting the plugin.  Use 0 for unlimited retries.
"""
PLUGIN_RETRY_COUNT = 0
"""
If getting statistics fails, we will wait this long (in seconds) before retrying.
"""
PLUGIN_RETRY_DELAY = 5


class ElasticsearchPlugin(object):
    def __init__(self, boundary_metric_prefix):
        self.boundary_metric_prefix = boundary_metric_prefix
        self.settings = boundary_plugin.parse_params()
        self.accumulator = boundary_accumulator

    def get_stats(self):
        req = urllib2.urlopen(self.settings.get("stats_url", "http://127.0.0.1:9200/_cluster/stats"))
        res = req.read()
        req.close()

        data = json.loads(res)
        return data

    def get_stats_with_retries(self, *args, **kwargs):
        """
        Calls the get_stats function, taking into account retry configuration.
        """
        retry_range = xrange(PLUGIN_RETRY_COUNT) if PLUGIN_RETRY_COUNT > 0 else iter(int, 1)
        for _ in retry_range:
            try:
                return self.get_stats(*args, **kwargs)
            except Exception as e:
                logging.error("Error retrieving data: %s" % e)
                time.sleep(PLUGIN_RETRY_DELAY)

        logging.fatal("Max retries exceeded retrieving data")
        raise Exception("Max retries exceeded retrieving data")

    @staticmethod
    def get_metric_list():
        return (
            (['status'], 'ELASTIC_SEARCH_STATUS', False),
            (['nodes', 'count', 'total'], 'ELASTIC_SEARCH_NODE_COUNT', False),
            (['indices', 'count'], 'ELASTIC_SEARCH_INDEX_COUNT', False),
            (['indices', 'docs', 'count'], 'ELASTIC_SEARCH_DOCUMENT_COUNT', False),
            (['indices', 'store', 'size_in_bytes'], 'ELASTIC_SEARCH_STORE_SIZE', False),
            (['indices', 'segments', 'count'], 'ELASTIC_SEARCH_SEGMENT_COUNT', False),
            (['indices', 'shards', 'total'], 'ELASTIC_SEARCH_TOTAL_SHARDS', False),
            (['indices', 'shards', 'primaries'], 'ELASTIC_SEARCH_PRIMARY_SHARDS', False),
            (['indices', 'fielddata', 'memory_size_in_bytes'], 'ELASTIC_SEARCH_FIELDDATA_MEMORY_SIZE', False),
            (['indices', 'fielddata', 'evictions'], 'ELASTIC_SEARCH_FIELDDATA_EVICTIONS', True),
            (['indices', 'filter_cache', 'memory_size_in_bytes'], 'ELASTIC_SEARCH_FILTER_CACHE_MEMORY_SIZE', False),
            (['indices', 'filter_cache', 'evictions'], 'ELASTIC_SEARCH_FILTER_CACHE_EVICTIONS', True),
            (['indices', 'id_cache', 'memory_size_in_bytes'], 'ELASTIC_SEARCH_ID_CACHE_MEMORY_SIZE', False),
            (['indices', 'completion', 'size_in_bytes'], 'ELASTIC_SEARCH_COMPLETION_SIZE', False),
        )

    def handle_metrics(self, data):
        for metric_path, boundary_name, accumulate in self.get_metric_list():
            value = data
            try:
                for p in metric_path:
                    value = value[p]
            except KeyError:
                value = None
            if not value:
                # If certain metrics do not exist or have no value
                # (e.g. disabled in the CouchDB server or just inactive) - skip them.
                continue
            if accumulate:
                value = self.accumulator.accumulate(metric_path, value)

            # Exception case for the 'status' metric, which is 'green' iff the cluster is in good shape.
            if metric_path == ['status']:
                value = 1 if value == 'green' else 0

            boundary_plugin.boundary_report_metric(self.boundary_metric_prefix + boundary_name, value)

    def main(self):
        logging.basicConfig(level=logging.ERROR, filename=self.settings.get('log_file', None))
        reports_log = self.settings.get('report_log_file', None)
        if reports_log:
            boundary_plugin.log_metrics_to_file(reports_log)
        boundary_plugin.start_keepalive_subprocess()

        while True:
            data = self.get_stats_with_retries()
            self.handle_metrics(data)
            boundary_plugin.sleep_interval()


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '-v':
        logging.basicConfig(level=logging.INFO)

    plugin = ElasticsearchPlugin('')
    plugin.main()
