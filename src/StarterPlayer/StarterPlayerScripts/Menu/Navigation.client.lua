local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local root = script:FindFirstAncestor("StarterPlayerScripts") or script.Parent.Parent
local UIBus = require(root:WaitForChild("Systems"):WaitForChild("UIBus"))
local uiBus = UIBus.Get()

uiBus.Event:Connect(function(action)
	if action == "OpenPanel" then
		playerGui:SetAttribute("MenuOpen", true)
	elseif action == "CloseAll" then
		playerGui:SetAttribute("MenuOpen", false)
	end
end)
