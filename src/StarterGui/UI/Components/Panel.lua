local Theme = require(script.Parent.Parent:WaitForChild("Theme"))

local Panel = {}

function Panel.Create(parent, size, position)
	local frame = Instance.new("Frame")
	frame.Size = size or UDim2.fromScale(0.8, 0.8)
	frame.Position = position or UDim2.fromScale(0.5, 0.5)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Theme.Colors.Panel
	frame.BackgroundTransparency = 0.12
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Colors.PanelStroke
	stroke.Thickness = 1
	stroke.Parent = frame

	return frame
end

return Panel
