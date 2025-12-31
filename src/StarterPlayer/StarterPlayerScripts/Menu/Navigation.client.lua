local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function getUiBus()
	local folder = playerGui:FindFirstChild("UIEvents")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "UIEvents"
		folder.Parent = playerGui
	end

	local bus = folder:FindFirstChild("UIBus")
	if not bus then
		bus = Instance.new("BindableEvent")
		bus.Name = "UIBus"
		bus.Parent = folder
	end

	return bus
end

local uiBus = getUiBus()

uiBus.Event:Connect(function(action)
	if action == "OpenPanel" then
		playerGui:SetAttribute("MenuOpen", true)
	elseif action == "CloseAll" then
		playerGui:SetAttribute("MenuOpen", false)
	end
end)
