-- Copyright 2015 BMC Software, Inc.
-- --
-- -- Licensed under the Apache License, Version 2.0 (the "License");
-- -- you may not use this file except in compliance with the License.
-- -- You may obtain a copy of the License at
-- --
-- --    http://www.apache.org/licenses/LICENSE-2.0
-- --
-- -- Unless required by applicable law or agreed to in writing, software
-- -- distributed under the License is distributed on an "AS IS" BASIS,
-- -- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- -- See the License for the specific language governing permissions and
-- -- limitations under the License.

--Framework imports.
local framework = require('framework')

local Plugin = framework.Plugin
local WebRequestDataSource = framework.WebRequestDataSource
local DataSourcePoller = framework.DataSourcePoller
local PollerCollection = framework.PollerCollection
local isHttpSuccess = framework.util.isHttpSuccess
local ipack = framework.util.ipack
local parseJson = framework.util.parseJson

--Getting the parameters from params.json.
local params = framework.params

local CLUSTER_STATS = 'cluster_stats'
local CLUSTER_HEALTH = 'cluster_health'
local NODES_STATS = 'nodes_stats'

local function createOptions(item)

	local options = {}
	options.host = item.host
	options.port = item.port
	options.wait_for_end = true

	return options
end

local function createClusterStats(item)

        local options = createOptions(item)

	options.path = "/_cluster/stats"
	options.meta = {CLUSTER_STATS, item}

        return WebRequestDataSource:new(options)
end

local function createClusterHealth(item)

	local options = createOptions(item)

	options.path = "/_cluster/health"
	options.meta = {CLUSTER_HEALTH, item}

	return WebRequestDataSource:new(options)
end

local function createNodesStats(item)
	local options = createOptions(item)

        options.path = "/_nodes/stats"
	options.meta = {NODES_STATS, item}

        return WebRequestDataSource:new(options)
end

local function createPollers(params)
	local pollers = PollerCollection:new()

	for _, item in pairs(params.items) do
		local cs = createClusterStats(item)
		local clusterStatsPoller = DataSourcePoller:new(item.pollInterval, cs)
		pollers:add(clusterStatsPoller)

		local ch = createClusterHealth(item)
		local clusterHealthPoller = DataSourcePoller:new(item.pollInterval, ch)
		pollers:add(clusterHealthPoller)

		local ns = createNodesStats(item)
		local nodesStatsPoller = DataSourcePoller:new(item.pollInterval, ns)
	        pollers:add(nodesStatsPoller) 
	end

	return pollers
end

local function clusterStatsExtractor (data, item)
	local result = {}
	local metric = function (...) ipack(result, ...) end

	local src = data.cluster_name
	
	if data.status ~= nil then
		if data.status == 'green' then
			metric('ELASTIC_SEARCH_STATUS',1,nil,src)
		else
			metric('ELASTIC_SEARCH_STATUS',0,nil,src)

		end
	end
	if data.nodes.count.total ~= nil then
        	metric('ELASTIC_SEARCH_NODE_COUNT', data.nodes.count.total,nil,src)
  	end

  	if data.indices.count ~= nil then
        	metric('ELASTIC_SEARCH_INDEX_COUNT', data.indices.count,nil,src)
  	end

  	if data.indices.docs.count ~= nil then
        	metric('ELASTIC_SEARCH_DOCUMENT_COUNT', data.indices.docs.count,nil,src)
  	end

  	if data.indices.store.size_in_bytes ~= nil then
        	metric('ELASTIC_SEARCH_STORE_SIZE', data.indices.store.size_in_bytes,nil,src)
  	end

  	if data.indices.segments.count ~= nil then
        	metric('ELASTIC_SEARCH_SEGMENT_COUNT', data.indices.segments.count,nil,src)
  	end

  	if data.indices.shards ~= nil then
        	if data.indices.shards.total ~= nil then
                	metric('ELASTIC_SEARCH_TOTAL_SHARDS', data.indices.shards.total,nil,src)
        	end
        	if data.indices.shards.primaries ~= nil then
                	metric('ELASTIC_SEARCH_PRIMARY_SHARDS',data.indices.shards.primaries, nil, src)
        	end
  	end
  	if data.indices.fielddata ~= nil then
        	if data.indices.fielddata.memory_size_in_bytes ~= nil then
                	metric('ELASTIC_SEARCH_FIELDDATA_MEMORY_SIZE', data.indices.fielddata.memory_size_in_bytes,nil,src)
        	end
        	if data.indices.fielddata.evictions ~= nil then
                	metric('ELASTIC_SEARCH_FIELDDATA_EVICTIONS', data.indices.fielddata.evictions,nil,src)
        	end
	end

	if data.indices.filter_cache ~= nil  then
      		metric('ELASTIC_SEARCH_FILTER_CACHE_MEMORY_SIZE', data.indices.filter_cache.memory_size_in_bytes,nil,src)
      		metric('ELASTIC_SEARCH_FILTER_CACHE_EVICTIONS',data.indices.filter_cache.evictions,nil,src)
  	else
      		metric('ELASTIC_SEARCH_QUERY_CACHE_MEMORY_SIZE', data.indices.query_cache.memory_size_in_bytes,nil,src)
      		metric('ELASTIC_SEARCH_QUERY_CACHE_EVICTIONS', data.indices.query_cache.evictions,nil,src)
  	end
  	if data.indices.id_cache ~= nil then
      		metric('ELASTIC_SEARCH_ID_CACHE_MEMORY_SIZE', data.indices.id_cache.memory_size_in_bytes,nil,src)
  	end
		
	metric('ELASTIC_SEARCH_COMPLETION_SIZE', data.indices.completion.size_in_bytes,nil,src)	

	--#######################################################
	return result
end

local function clusterHealthExtractor (data, item)
        local result = {}
        local metric = function (...) ipack(result, ...) end
	local src = data.cluster_name


	metric('ELASTIC_SEARCH_NO_OF_NODES',data.number_of_nodes,nil,src)
	metric('ELASTIC_SEARCH_NO_OF_DATA_NODES',data.number_of_data_nodes,nil,src)
	metric('ELASTIC_SEARCH_ACTIVE_PRIMARY_SHARDS',data.active_primary_shards,nil,src)
	metric('ELASTIC_SEARCH_ACTIVE_SHARDS',data.active_shards,nil,src)
	metric('ELASTIC_SEARCH_RELOCATING_SHARDS',data.relocating_shards,nil,src)
	metric('ELASTIC_SEARCH_INITIALISING_SHARDS',data.initializing_shards,nil,src)
	metric('ELASTIC_SEARCH_UNASSIGNED_SHARDS',data.unassigned_shards,nil,src)
        return result
end

local function nodesStatsExtractor (data, item)
        local result = {}
        local metric = function (...) ipack(result, ...) end

        for _,node in pairs(data.nodes) do
		local src = data.cluster_name .. ".Node-" .. node.name
		metric('ELASTIC_SEARCH_JVM_UPTIME_IN_MILLIS',node.jvm.uptime_in_millis,nil,src)
		metric('ELASTIC_SEARCH_JVM_MEM_HEAP_USED_PERCENT',node.jvm.mem.heap_used_percent,nil,src)
		metric('ELASTIC_SEARCH_PROCESS_OPEN_FILE_DESCRIPTORS',node.process.open_file_descriptors,nil,src)
		metric('ELASTIC_SEARCH_PROCESS_MAX_FILE_DESCRIPTORS',node.process.max_file_descriptors,nil,src)
		if #node.fs.data>0 and  node.fs.data[1].available_in_bytes ~= nil  then
			metric('ELASTIC_SEARCH_FS_DATA_AVAILABLE_IN_BYTES',node.fs.data[1].available_in_bytes,nil,src)
        	end
		metric('ELASTIC_SEARCH_BREAKERS_FIELDDATA_TRIPPED',node.breakers.fielddata.tripped,nil,src)
	end
        return result
end

local extractors_map = {}
extractors_map[CLUSTER_STATS] = clusterStatsExtractor
extractors_map[CLUSTER_HEALTH] = clusterHealthExtractor
extractors_map[NODES_STATS] = nodesStatsExtractor


local pollers = createPollers(params)
local plugin = Plugin:new(params, pollers)

--Response returned for each of the pollers.
function plugin:onParseValues(data, extra)

	if not isHttpSuccess(extra.status_code) then
		self:emitEvent('error', ('Http request returned status code %s instead of OK. Please verify configuration.'):format(extra.status_code))
    		return
	end

	local success, data = parseJson(data)
  	if not success then
		self:emitEvent('error', 'Cannot parse metrics. Please verify configuration.') 
		return
	end

	local key, item = unpack(extra.info)
	local extractor = extractors_map[key]
	return extractor(data, item)

end

plugin:run()


