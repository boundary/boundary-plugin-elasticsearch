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

In order for the plugin to collect statistics from Elasticsearch, it needs access to the cluster stats, cluster health and nodes stats API endpoint. In a default installation, this would be `http://127.0.0.1:9200/_cluster/stats`, `http://127.0.0.1:9200/_cluster/health`, `http://127.0.0.1:9200/_nodes/stats` but the port or path may be modified in configuration.

### Plugin Configuration Fields

|Field Name    | Description                                                                                              |
|:-------------|:---------------------------------------------------------------------------------------------------------|
|Source        | The Source to display in the legend for the elastic search data.It will default to the hostname of the server.|
|Host          | The Elastic Search hostname or IP.                                                                       |
|Port          | The Elastic Search port.                                                                                 |
|Poll Interval | How often should the plugin poll for metrics.                                                            |

### Metrics Collected

|Metric Name                                   |Description                                                               |
|:---------------------------------------------|:-------------------------------------------------------------------------|
| ELASTIC\_SEARCH\_STATUS                      | Current status of the cluster either: 1 green, or 0, either yellow or red|
| ELASTIC\_SEARCH\_NODE\_COUNT                 | Number of nodes in the cluster                                           |
| ELASTIC\_SEARCH\_INDEX\_COUNT                | Number of indexes in the cluster                                         |
| ELASTIC\_SEARCH\_DOCUMENT\_COUNT             | Number of documents in all indexes                                       |
| ELASTIC\_SEARCH\_STORE\_SIZE                 | Amount of storage in bytes used by indexes                               |
| ELASTIC\_SEARCH\_SEGMENT\_COUNT              | Total number of segments in the cluster                                  |
| ELASTIC\_SEARCH\_TOTAL\_SHARDS               | Total number of shards                                                   |
| ELASTIC\_SEARCH\_PRIMARY\_SHARDS             | Total number of primary shards                                           |
| ELASTIC\_SEARCH\_FIELDDATA\_MEMORY\_SIZE     | Amount of memory in bytes used by the field data caches                  |
| ELASTIC\_SEARCH\_FIELDDATA\_EVICTIONS        | Number of field data dropped due to LRU (Least Recently Used) policy     |
| ELASTIC\_SEARCH\_FILTER\_CACHE\_MEMORY\_SIZE | Amount of memory in bytes of the filter cache                            |
| ELASTIC\_SEARCH\_FILTER\_CACHE\_EVICTIONS    | Number of filters dropped due to LRU (Least Recently Used) policy        |
| ELASTIC\_SEARCH\_QUERY\_CACHE\_MEMORY\_SIZE  | Amount of memory in bytes of the Query cache (added for Elasticsearch 2.x )         |
| ELASTIC\_SEARCH\_QUERY\_CACHE\_EVICTIONS     | Number of Queries dropped due to LRU (Least Recently Used) policy ( added for Elasticsearch 2.x )        |
| ELASTIC\_SEARCH\_ID\_CACHE\_MEMORY\_SIZE     | Amount of memory in bytes of the id cache                                |
| ELASTIC\_SEARCH\_COMPLETION\_SIZE            | Number of completion suggestions returned                                |
| ELASTIC\_SEARCH\_NO\_OF\_NODES               | Number of Nodes                                                          |
| ELASTIC\_SEARCH\_NO\_OF\_DATA\_NODES         | Number of Data Nodes                                                     |
| ELASTIC\_SEARCH\_ACTIVE\_PRIMARY\_SHARDS     | Number of Active Primary Shards                                          |
| ELASTIC\_SEARCH\_ACTIVE\_SHARDS              | Number of  Active Shards                                                 |
| ELASTIC\_SEARCH\_RELOCATING\_SHARDS          | Number of Relocating Shards                                              |
| ELASTIC\_SEARCH\_INITIALISING\_SHARDS        | Number of Initialising Shards                                            |
| ELASTIC\_SEARCH\_UNASSIGNED\_SHARDS          | Number of Unassigned Shards                                              |
| ELASTIC\_SEARCH\_JVM\_UPTIME\_IN\_MILLIS     | JVM uptime in milliseconds                                               |
| ELASTIC\_SEARCH\_JVM\_MEM\_HEAP\_USED\_PERCENT| JVM heap memory used percent                                            |
| ELASTIC\_SEARCH\_PROCESS\_OPEN\_FILE\_DESCRIPTORS | Process open file descriptors                                       |
| ELASTIC\_SEARCH\_PROCESS\_MAX\_FILE\_DESCRIPTORS | Process max file descriptors                                         |
| ELASTIC\_SEARCH\_FS\_DATA\_AVAILABLE\_IN\_BYTES | FS data available in bytes                                            |
| ELASTIC\_SEARCH\_BREAKERS\_FIELDDATA\_TRIPPED | Breakers field data tripped                                             |

### Dashboards

- ES ClusterStats
- ES ClusterStats v2
- ES ClusterHealth
- ES NodesStats

### References

None
