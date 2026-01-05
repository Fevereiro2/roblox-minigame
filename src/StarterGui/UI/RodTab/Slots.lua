local Theme = require(script.Parent.Parent:WaitForChild("Theme"))

local Slots = {}

function Slots.Create(parent, config)
	local button = Instance.new("TextButton")
	button.Size = UDim2.fromScale(1, 0)
	button.AutomaticSize = Enum.AutomaticSize.Y
	button.BackgroundColor3 = Theme.Colors.Panel
	button.BackgroundTransparency = 0.1
	button.BorderSizePixel = 0
	button.Text = ""
	button.AutoButtonColor = false
	button.ZIndex = 8
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Colors.PanelStroke
	stroke.Thickness = 1
	stroke.Parent = button

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0.04, 0)
	padding.PaddingRight = UDim.new(0.04, 0)
	padding.PaddingTop = UDim.new(0.08, 0)
	padding.PaddingBottom = UDim.new(0.08, 0)
	padding.Parent = button

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0.03, 0)
	layout.Parent = button

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(1, 0)
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.BackgroundTransparency = 1
	title.Font = Theme.Fonts.BodyBold
	title.TextSize = 13
	title.TextColor3 = Theme.Colors.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = config.label or "Slot"
	title.ZIndex = 9
	title.Parent = button

	local itemLabel = Instance.new("TextLabel")
	itemLabel.Size = UDim2.fromScale(1, 0)
	itemLabel.AutomaticSize = Enum.AutomaticSize.Y
	itemLabel.BackgroundTransparency = 1
	itemLabel.Font = Theme.Fonts.Body
	itemLabel.TextSize = 12
	itemLabel.TextColor3 = Theme.Colors.TextMuted
	itemLabel.TextXAlignment = Enum.TextXAlignment.Left
	itemLabel.Text = "Vazio"
	itemLabel.ZIndex = 9
	itemLabel.Parent = button

	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromScale(1, 0.16)
	bar.BackgroundColor3 = Theme.Colors.Button
	bar.BorderSizePixel = 0
	bar.ZIndex = 9
	bar.Parent = button

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0.5, 0)
	barCorner.Parent = bar

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = Theme.Colors.Accent
	fill.BorderSizePixel = 0
	fill.ZIndex = 10
	fill.Parent = bar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.5, 0)
	fillCorner.Parent = fill

	local durabilityLabel = Instance.new("TextLabel")
	durabilityLabel.Size = UDim2.fromScale(1, 0)
	durabilityLabel.AutomaticSize = Enum.AutomaticSize.Y
	durabilityLabel.BackgroundTransparency = 1
	durabilityLabel.Font = Theme.Fonts.Body
	durabilityLabel.TextSize = 11
	durabilityLabel.TextColor3 = Theme.Colors.TextSoft
	durabilityLabel.TextXAlignment = Enum.TextXAlignment.Left
	durabilityLabel.Text = "Durabilidade: 0%"
	durabilityLabel.ZIndex = 9
	durabilityLabel.Parent = button

	local function setItem(item)
		if item then
			itemLabel.Text = item.name
			local current = (item.durability and item.durability.current) or 0
			local max = (item.durability and item.durability.max) or 0
			local ratio = 0
			if max > 0 then
				ratio = math.clamp(current / max, 0, 1)
			end
			fill.Size = UDim2.fromScale(ratio, 1)
			durabilityLabel.Text = string.format("Durabilidade: %d%%", math.floor(ratio * 100))
		else
			itemLabel.Text = "Vazio"
			fill.Size = UDim2.fromScale(0, 1)
			durabilityLabel.Text = "Durabilidade: 0%"
		end
	end

	local function setSelected(isSelected)
		if isSelected then
			stroke.Color = Theme.Colors.AccentHover
			button.BackgroundColor3 = Theme.Colors.ButtonHover
		else
			stroke.Color = Theme.Colors.PanelStroke
			button.BackgroundColor3 = Theme.Colors.Panel
		end
	end

	return {
		Root = button,
		Key = config.key,
		SetItem = setItem,
		SetSelected = setSelected,
	}
end

return Slots
