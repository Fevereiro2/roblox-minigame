local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function getHud()
	local hud = playerGui:FindFirstChild("FishingHud")
	if not hud then
		hud = Instance.new("ScreenGui")
		hud.Name = "FishingHud"
		hud.ResetOnSpawn = false
		hud.Parent = playerGui
	end
	return hud
end

local function getCoinsLabel(hud)
	local label = hud:FindFirstChild("CoinsLabel")
	if not label then
		label = Instance.new("TextLabel")
		label.Name = "CoinsLabel"
		label.Size = UDim2.new(0, 200, 0, 32)
		label.Position = UDim2.new(1, -216, 0, 16)
		label.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		label.TextColor3 = Color3.fromRGB(240, 240, 240)
		label.Font = Enum.Font.GothamSemibold
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = "Moedas: 0"
		label.Parent = hud
	end
	return label
end

local hud = getHud()
local coinsLabel = getCoinsLabel(hud)

local function updateCoins()
	local coins = player:GetAttribute("Coins")
	if typeof(coins) ~= "number" then
		coins = 0
	end
	coinsLabel.Text = string.format("Moedas: %d", coins)
end

player:GetAttributeChangedSignal("Coins"):Connect(updateCoins)
updateCoins()
