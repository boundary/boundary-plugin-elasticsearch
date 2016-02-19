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
local notEmpty = framework.string.notEmpty
local isHttpSuccess = framework.util.isHttpSuccess
local parseJson = framework.util.parseJson

local params = framework.params
params.pollInterval = notEmpty(params.pollInterval, 1000)
local options = url.parse(params.stats_url)
options.wait_for_end = false
local ds = WebRequestDataSource:new(options)

local plugin = Plugin:new(params, ds)
function plugin:onParseValues(data, extra)
  if not isHttpSuccess(extra.status_code) then
    self:emitEvent('error', ('Http response status code %s instead of OK. Please check your elasticsearch endpoint configuration.'):format(extra.status_code))
    return
  end
  local success, parsed = parseJson(data)
  if not success then
    self:emitEvent('error', 'Could not parse metrics. Please check your elasticsearch endpoint configuration.')
    return
  end

  local result = {}
  result['ELASTIC_SEARCH_STATUS'] = ((parsed.status == 'green') and 1) or 0
  result['ELASTIC_SEARCH_NODE_COUNT'] = parsed.nodes.count.total
  result['ELASTIC_SEARCH_INDEX_COUNT'] = parsed.indices.count
  result['ELASTIC_SEARCH_DOCUMENT_COUNT'] = parsed.indices.docs.count
  result['ELASTIC_SEARCH_STORE_SIZE'] = parsed.indices.store.size_in_bytes
  result['ELASTIC_SEARCH_SEGMENT_COUNT'] = parsed.indices.segments.count
  result['ELASTIC_SEARCH_TOTAL_SHARDS'] = parsed.indices.shards.total or 0.0
  result['ELASTIC_SEARCH_PRIMARY_SHARDS'] = parsed.indices.shards.primaries or 0.0
  result['ELASTIC_SEARCH_FIELDDATA_MEMORY_SIZE'] = parsed.indices.fielddata.memory_size_in_bytes
  result['ELASTIC_SEARCH_FIELDDATA_EVICTIONS'] = parsed.indices.fielddata.evictions
  if parsed.indices.filter_cache ~= nil  then
      result['ELASTIC_SEARCH_FILTER_CACHE_MEMORY_SIZE'] = parsed.indices.filter_cache.memory_size_in_bytes
      result['ELASTIC_SEARCH_FILTER_CACHE_EVICTIONS'] = parsed.indices.filter_cache.evictions
  else
      result['ELASTIC_SEARCH_QUERY_CACHE_MEMORY_SIZE'] = parsed.indices.query_cache.memory_size_in_bytes
      result['ELASTIC_SEARCH_QUERY_CACHE_EVICTIONS'] = parsed.indices.query_cache.evictions
  end
  if parsed.indices.id_cache ~= nil then
      result['ELASTIC_SEARCH_ID_CACHE_MEMORY_SIZE'] = parsed.indices.id_cache.memory_size_in_bytes
  end
  result['ELASTIC_SEARCH_COMPLETION_SIZE'] = parsed.indices.completion.size_in_bytes
  return result
end

plugin:run()

