-- Client entry point: shows the player's coins on screen.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local CoinsChanged = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CoinsChanged")

local gui = Instance.new("ScreenGui")
gui.Name = "HUD"
gui.ResetOnSpawn = false

local label = Instance.new("TextLabel")
label.Name = "Coins"
label.Size = UDim2.fromOffset(180, 44)
label.Position = UDim2.new(0, 16, 1, -60)
label.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
label.BackgroundTransparency = 0.2
label.TextColor3 = Color3.fromRGB(255, 215, 80)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.Text = "Coins: 0"
label.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = label

gui.Parent = player:WaitForChild("PlayerGui")

CoinsChanged.OnClientEvent:Connect(function(amount: number)
	label.Text = "Coins: " .. amount
end)
