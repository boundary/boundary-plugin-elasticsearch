-- Copyright 2015 Boundary, Inc.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local framework = require('framework')
local url = require('url')
local table = require('table')
local json = require('json')
local Plugin = framework.Plugin
local WebRequestDataSource = framework.WebRequestDataSource
local pack = framework.util.pack

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
  local parsed = json.parse(data)
  -- table.insert(result, pack('ELASTIC_SEARCH_STATUS', data.status, nil))
  table.insert(result, pack('ELASTIC_SEARCH_NODE_COUNT', parsed.nodes.count.total, nil))
  table.insert(result, pack('ELASTIC_SEARCH_INDEX_COUNT', parsed.indices.count, nil))
  table.insert(result, pack('ELASTIC_SEARCH_DOCUMENT_COUNT', parsed.indices.docs.count, nil))
  table.insert(result, pack('ELASTIC_SEARCH_STORE_SIZE', parsed.indices.store.size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_SEGMENT_COUNT', parsed.indices.segments.count, nil))
  table.insert(result, pack('ELASTIC_SEARCH_TOTAL_SHARDS', (parsed.indices.shards.total or 0.0), nil))
  table.insert(result, pack('ELASTIC_SEARCH_PRIMARY_SHARDS', (parsed.indices.shards.primaries or 0.0), nil))
  table.insert(result, pack('ELASTIC_SEARCH_FIELDDATA_MEMORY_SIZE', parsed.indices.fielddata.memory_size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_FIELDDATA_EVICTIONS', parsed.indices.fielddata.evictions, nil))
  table.insert(result, pack('ELASTIC_SEARCH_FILTER_CACHE_MEMORY_SIZE', parsed.indices.filter_cache.memory_size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_FILTER_CACHE_EVICTIONS', parsed.indices.filter_cache.evictions, nil))
  table.insert(result, pack('ELASTIC_SEARCH_ID_CACHE_MEMORY_SIZE', parsed.indices.id_cache.memory_size_in_bytes, nil))
  table.insert(result, pack('ELASTIC_SEARCH_COMPLETION_SIZE', parsed.indices.completion.size_in_bytes, nil))
  return result
end

plugin:run()

