# Boundary Elasticsearch Plugin 

Collects metrics from Elasticsearch.

### Prerequisites

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |    v    |    v    |  v   |

#### Boundary Meter versions v4.2 or later

- To install new meter go to Settings->Installation or [see instructions](https://help.boundary.com/hc/en-us/sections/200634331-Installation).
- To upgrade the meter to the latest version - [see instructions](https://help.boundary.com/hc/en-us/articles/201573102-Upgrading-the-Boundary-Meter).

### Plugin Setup

In order for the plugin to collect statistics from Elasticsearch, it needs access to the cluster stats API endpoint.
In a default installation, this would be "http://127.0.0.1:9200/_cluster/stats", but the port or path may be
modified in configuration.

### Plugin Configuration Fields

|Field Name    | Description                                                                                             |
|:-------------|:---------------------------------------------------------------------------------------------------|
|Source        | The Source to display in the legend for the haproxy data.  It will default to the hostname of the server.|
|Statistics URL| The URL endpoint of where the elasticsearch statistics are hosted.   |
|Poll Interval | How often should the plugin poll for metrics.                                                   |

### Metrics Collected

|Metric Name                 |Description                                         |
|:---------------------------|:---------------------------------------------------|
| ELASTIC_SEARCH_STATUS | |
| ELASTIC_SEARCH_NODE_COUNT | |
| ELASTIC_SEARCH_INDEX_COUNT | |
| ELASTIC_SEARCH_DOCUMENT_COUNT | |
| ELASTIC_SEARCH_STORE_SIZE | |
| ELASTIC_SEARCH_SEGMENT_COUNT | |
| ELASTIC_SEARCH_TOTAL_SHARDS | |
| ELASTIC_SEARCH_PRIMARY_SHARDS | |
| ELASTIC_SEARCH_FIELDDATA_MEMORY_SIZE | |
| ELASTIC_SEARCH_FIELDDATA_EVICTIONS | |
| ELASTIC_SEARCH_FILTER_CACHE_MEMORY_SIZE | |
| ELASTIC_SEARCH_FILTER_CACHE_EVICTIONS | |
| ELASTIC_SEARCH_ID_CACHE_MEMORY_SIZE | |
| ELASTIC_SEARCH_COMPLETION_SIZE | |

### Dashboards

- Elasticsearch

### References

None
