-- Loads, caches and saves each player's data.
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

-- GetDataStore errors in places that aren't published yet; play without saving then.
local okStore, store = pcall(function()
	return DataStoreService:GetDataStore(Config.DataStoreName)
end)
if not okStore then
	warn("[DataService] Saving disabled (publish the place to enable DataStores)")
	store = nil
end
local sessions: {[Player]: {[string]: any}} = {}

local DataService = {}

local function copyDefaults()
	local t = {}
	for k, v in Config.DefaultData do
		t[k] = v
	end
	return t
end

function DataService.Load(player: Player)
	local key = "player_" .. player.UserId
	if not store then
		sessions[player] = copyDefaults()
		return sessions[player]
	end
	local ok, saved = pcall(function()
		return store:GetAsync(key)
	end)
	local data = copyDefaults()
	if ok and type(saved) == "table" then
		for k, v in saved do
			data[k] = v
		end
	elseif not ok then
		warn("[DataService] Load failed for", player.Name, saved)
	end
	sessions[player] = data
	return data
end

function DataService.Get(player: Player)
	return sessions[player]
end

function DataService.Save(player: Player)
	local data = sessions[player]
	if not data or not store then return end
	local key = "player_" .. player.UserId
	local ok, err = pcall(function()
		store:SetAsync(key, data)
	end)
	if not ok then
		warn("[DataService] Save failed for", player.Name, err)
	end
end

function DataService.Release(player: Player)
	DataService.Save(player)
	sessions[player] = nil
end

function DataService.SaveAll()
	for player in sessions do
		DataService.Save(player)
	end
end

return DataService
