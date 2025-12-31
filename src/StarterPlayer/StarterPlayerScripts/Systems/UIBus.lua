local Players = game:GetService("Players")

local UIBus = {}

function UIBus.Get()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

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

return UIBus
