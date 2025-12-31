local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local uiRoot = playerGui:WaitForChild("UI")
local Theme = require(uiRoot:WaitForChild("Theme"))
local Colors = Theme.Colors

local root = script:FindFirstAncestor("StarterPlayerScripts") or script.Parent.Parent
local UIBus = require(root:WaitForChild("Systems"):WaitForChild("UIBus"))
local uiBus = UIBus.Get()

local function getHud()
	local hud = playerGui:FindFirstChild("NotificationHud")
	if not hud then
		hud = Instance.new("ScreenGui")
		hud.Name = "NotificationHud"
		hud.ResetOnSpawn = false
		hud.Parent = playerGui
	end
	return hud
end

local function getLabel(hud)
	local label = hud:FindFirstChild("NotifyLabel")
	if not label then
		label = Instance.new("TextLabel")
		label.Name = "NotifyLabel"
		label.Size = UDim2.new(0, 320, 0, 36)
		label.Position = UDim2.new(0.5, -160, 0, 70)
		label.BackgroundColor3 = Colors.NotificationBackground
		label.TextColor3 = Colors.Text
		label.Font = Enum.Font.GothamSemibold
		label.TextSize = 14
		label.Text = ""
		label.Visible = false
		label.Parent = hud

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = label

		local stroke = Instance.new("UIStroke")
		stroke.Color = Colors.PanelStroke
		stroke.Thickness = 1
		stroke.Parent = label
	end
	return label
end

local hud = getHud()
local label = getLabel(hud)
local hideTask

local function showMessage(text)
	label.Text = text
	label.Visible = true
	label.TextTransparency = 0
	label.BackgroundTransparency = 0

	TweenService:Create(label, TweenInfo.new(0.15), { BackgroundTransparency = 0.05 }):Play()

	if hideTask then
		task.cancel(hideTask)
	end

	hideTask = task.delay(2.0, function()
		TweenService:Create(label, TweenInfo.new(0.2), {
			TextTransparency = 1,
			BackgroundTransparency = 1,
		}):Play()
		task.delay(0.25, function()
			label.Visible = false
			label.TextTransparency = 0
			label.BackgroundTransparency = 0
		end)
	end)
end

uiBus.Event:Connect(function(action, payload)
	if action == "Notify" then
		showMessage(tostring(payload or ""))
	end
end)
