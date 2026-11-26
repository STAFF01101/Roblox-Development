-- The only place that changes coins. Keeps leaderstats, saved data and the client in sync.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataService = require(script.Parent.DataService)
local CoinsChanged = ReplicatedStorage.Remotes.CoinsChanged

local CoinService = {}

function CoinService.Setup(player: Player)
	local data = DataService.Get(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = data and data.Coins or 0
	coins.Parent = leaderstats
	leaderstats.Parent = player
	CoinsChanged:FireClient(player, coins.Value)
end

function CoinService.Get(player: Player): number
	local data = DataService.Get(player)
	return data and data.Coins or 0
end

function CoinService.Add(player: Player, amount: number)
	local data = DataService.Get(player)
	if not data then return end
	data.Coins = math.max(0, data.Coins + amount)
	local stats = player:FindFirstChild("leaderstats")
	if stats and stats:FindFirstChild("Coins") then
		stats.Coins.Value = data.Coins
	end
	CoinsChanged:FireClient(player, data.Coins)
end

function CoinService.Spend(player: Player, amount: number): boolean
	if CoinService.Get(player) < amount then
		return false
	end
	CoinService.Add(player, -amount)
	return true
end

return CoinService
