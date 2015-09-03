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
In a default installation, this would be `http://127.0.0.1:9200/_cluster/stats`, but the port or path may be
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
| ELASTIC\_SEARCH\_STATUS | |
| ELASTIC\_SEARCH\_NODE\_COUNT | |
| ELASTIC\_SEARCH\_INDEX\_COUNT | |
| ELASTIC\_SEARCH\_DOCUMENT\_COUNT | |
| ELASTIC\_SEARCH\_STORE\_SIZE | |
| ELASTIC\_SEARCH\_SEGMENT\_COUNT | |
| ELASTIC\_SEARCH\_TOTAL\_SHARDS | |
| ELASTIC\_SEARCH\_PRIMARY\_SHARDS | |
| ELASTIC\_SEARCH\_FIELDDATA\_MEMORY\_SIZE | |
| ELASTIC\_SEARCH\_FIELDDATA\_EVICTIONS | |
| ELASTIC\_SEARCH\_FILTER\_CACHE\_MEMORY\_SIZE | |
| ELASTIC\_SEARCH\_FILTER\_CACHE\_EVICTIONS | |
| ELASTIC\_SEARCH\_ID\_CACHE\_MEMORY\_SIZE | |
| ELASTIC\_SEARCH\_COMPLETION\_SIZE | |

### Dashboards

- Elasticsearch

### References

None
