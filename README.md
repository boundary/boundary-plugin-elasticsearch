Boundary Elasticsearch Plugin
-----------------------------
Collects metrics from Elasticsearch.

### Platforms
- Linux

### Prerequisites
- Python 2.6 or later
- Elasticsearch

### Plugin Configuration

In order for the plugin to collect statistics from Elasticsearch, it needs access to the cluster stats API endpoint.
In a default installation, this would be "http://127.0.0.1:9200/_cluster/stats", but the port or path may be
modified in configuration.
