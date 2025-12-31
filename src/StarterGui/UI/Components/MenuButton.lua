local TweenService = game:GetService("TweenService")

local Theme = require(script.Parent.Parent:WaitForChild("Theme"))

local MenuButton = {}

function MenuButton.Create(parent, label, iconId, options)
	local opt = options or {}
	local isPrimary = opt.primary == true
	local height = opt.height or (isPrimary and 54 or 44)
	local zIndex = opt.zIndex or 6

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, height)
	button.BackgroundColor3 = isPrimary and Theme.Colors.Accent or Theme.Colors.Button
	button.AutoButtonColor = false
	button.Text = ""
	button.ZIndex = zIndex
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = isPrimary and Theme.Colors.AccentHover or Theme.Colors.PanelStroke
	stroke.Thickness = 1
	stroke.Parent = button

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = button

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 14)
	padding.PaddingRight = UDim.new(0, 14)
	padding.Parent = button

	local iconHolder = Instance.new("Frame")
	iconHolder.Size = UDim2.new(0, 28, 0, 28)
	iconHolder.BackgroundColor3 = Theme.Colors.Panel
	iconHolder.BorderSizePixel = 0
	iconHolder.LayoutOrder = 1
	iconHolder.ZIndex = zIndex + 1
	iconHolder.Parent = button

	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 8)
	iconCorner.Parent = iconHolder

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.fromScale(0.7, 0.7)
	icon.Position = UDim2.fromScale(0.15, 0.15)
	icon.BackgroundTransparency = 1
	icon.Image = iconId or ""
	icon.ImageColor3 = Theme.Colors.IconTint
	icon.ZIndex = zIndex + 2
	icon.Parent = iconHolder

	local labelText = Instance.new("TextLabel")
	labelText.Size = UDim2.new(1, -100, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.Font = Theme.Fonts.BodyBold
	labelText.TextSize = isPrimary and 18 or 16
	labelText.TextColor3 = Theme.Colors.Text
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Text = label or ""
	labelText.LayoutOrder = 2
	labelText.ZIndex = zIndex + 1
	labelText.Parent = button

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 18, 1, 0)
	arrow.BackgroundTransparency = 1
	arrow.Font = Theme.Fonts.BodyBold
	arrow.TextSize = 16
	arrow.TextColor3 = Theme.Colors.TextMuted
	arrow.Text = ">"
	arrow.LayoutOrder = 3
	arrow.ZIndex = zIndex + 1
	arrow.Parent = button

	local baseColor = button.BackgroundColor3
	local hoverColor = isPrimary and Theme.Colors.AccentHover or Theme.Colors.ButtonHover

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = hoverColor }):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = baseColor }):Play()
	end)

	return button
end

return MenuButton
