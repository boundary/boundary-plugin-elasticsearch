local framework            = require('framework')
local url                  = require('url')
local table                = require('table')
local json                 = require('json')
local Plugin               = framework.Plugin
local pack                 = framework.util.pack
local WebRequestDataSource = framework.WebRequestDataSource
local Cache                = framework.Cache
local params               = framework.params
params.pollInterval        = params.pollInterval and tonumber(params.pollInterval)*1000 or 1000
params.name                = 'Boundary Plugin Elasticsearch'
params.version             = '2.0'
params.tags                = 'elasticsearch'
local options              = url.parse(params.url)
options.wait_for_end       = false
local ds                   = WebRequestDataSource:new(options)


local plugin = Plugin:new(params, ds)
function plugin:onParseValues(data)
  local result = {}
  local data = json.parse(data)
  -- table.insert(result, pack('ELASTIC_SEARCH_STATUS', data.status, nil))
  table.insert(result, pack('ELASTIC_SEARCH_NODE_COUNT', data.nodes.count.total, nil))
  table.insert(result, pack('ELASTIC_SEARCH_INDEX_COUNT', data.indices.count, nil))
  table.insert(result, pack('ELASTIC_SEARCH_DOCUMENT_COUNT', data.indices.docs.count, nil))
  table.insert(result, pack('ELASTIC_SEARCH_STORE_SIZE', data.indices.store.size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_SEGMENT_COUNT', data.indices.segments.count, nil))
  table.insert(result, pack('ELASTIC_SEARCH_TOTAL_SHARDS', (data.indices.shards.total or 0.0), nil))
  table.insert(result, pack('ELASTIC_SEARCH_PRIMARY_SHARDS', (data.indices.shards.primaries or 0.0), nil))
  table.insert(result, pack('ELASTIC_SEARCH_FIELDDATA_MEMORY_SIZE', data.indices.fielddata.memory_size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_FIELDDATA_EVICTIONS', data.indices.fielddata.evictions, nil))
  table.insert(result, pack('ELASTIC_SEARCH_FILTER_CACHE_MEMORY_SIZE', data.indices.filter_cache.memory_size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_FILTER_CACHE_EVICTIONS', data.indices.filter_cache.evictions, nil))
  table.insert(result, pack('ELASTIC_SEARCH_ID_CACHE_MEMORY_SIZE', data.indices.id_cache.memory_size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_COMPLETION_SIZE', data.indices.completion.size_in_bytes, nil))
  return result
end

plugin:run()