local Theme = require(script.Parent.Parent:WaitForChild("Theme"))

local Button = {}

function Button.Create(parent, text, options)
	local button = Instance.new("TextButton")
	button.Text = text or ""
	button.AutoButtonColor = false
	button.Font = Theme.Fonts.BodyBold
	button.TextSize = (options and options.textSize) or 16
	button.TextColor3 = Theme.Colors.Text
	button.BackgroundColor3 = (options and options.primary) and Theme.Colors.Accent or Theme.Colors.Button
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = (options and options.primary) and Theme.Colors.AccentHover or Theme.Colors.PanelStroke
	stroke.Thickness = 1
	stroke.Parent = button

	return button
end

return Button
