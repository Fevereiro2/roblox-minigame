local Theme = require(script.Parent.Parent:WaitForChild("Theme"))

local ItemCard = {}

function ItemCard.Create(parent, title, subtitle)
	local card = Instance.new("Frame")
	card.BackgroundColor3 = Theme.Colors.Button
	card.BorderSizePixel = 0
	card.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Colors.PanelStroke
	stroke.Thickness = 1
	stroke.Parent = card

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.fromScale(1, 0.6)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Theme.Fonts.BodyBold
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = Theme.Colors.Text
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = title or "Item"
	nameLabel.Parent = card

	local subLabel = Instance.new("TextLabel")
	subLabel.Size = UDim2.fromScale(1, 0.4)
	subLabel.Position = UDim2.fromScale(0, 0.6)
	subLabel.BackgroundTransparency = 1
	subLabel.Font = Theme.Fonts.Body
	subLabel.TextSize = 12
	subLabel.TextColor3 = Theme.Colors.TextMuted
	subLabel.TextXAlignment = Enum.TextXAlignment.Left
	subLabel.Text = subtitle or ""
	subLabel.Parent = card

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)
	pad.PaddingTop = UDim.new(0, 8)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.Parent = card

	return card
end

return ItemCard
