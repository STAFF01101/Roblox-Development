-- Server entry point: wires up services when players join and leave.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local DataService = require(script.Parent.Services.DataService)
local CoinService = require(script.Parent.Services.CoinService)

local function onPlayerAdded(player: Player)
	DataService.Load(player)
	CoinService.Setup(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, p in Players:GetPlayers() do
	task.spawn(onPlayerAdded, p)
end

Players.PlayerRemoving:Connect(function(player)
	DataService.Release(player)
end)

game:BindToClose(function()
	DataService.SaveAll()
end)

task.spawn(function()
	while true do
		task.wait(Config.AutoSaveInterval)
		DataService.SaveAll()
	end
end)
