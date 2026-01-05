local Theme = require(script.Parent.Parent:WaitForChild("Theme"))

local PreviewStats = {}

local function makeRow(parent, labelText)
	local row = Instance.new("Frame")
	row.Size = UDim2.fromScale(1, 0)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.BackgroundTransparency = 1
	row.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0.02, 0)
	layout.Parent = row

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(0.6, 1)
	label.BackgroundTransparency = 1
	label.Font = Theme.Fonts.Body
	label.TextSize = 12
	label.TextColor3 = Theme.Colors.TextMuted
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = labelText
	label.Parent = row

	local value = Instance.new("TextLabel")
	value.Size = UDim2.fromScale(0.4, 1)
	value.BackgroundTransparency = 1
	value.Font = Theme.Fonts.BodyBold
	value.TextSize = 12
	value.TextColor3 = Theme.Colors.Text
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.Text = "0"
	value.Parent = row

	return value
end

function PreviewStats.Create(parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0.08, 0)
	layout.Parent = container

	local strengthValue = makeRow(container, "Forca total")
	local weightValue = makeRow(container, "Peso maximo")
	local breakValue = makeRow(container, "Chance de quebra")
	local efficiencyValue = makeRow(container, "Eficiencia")

	local function update(stats)
		strengthValue.Text = tostring(stats.strength or 0)
		weightValue.Text = tostring(stats.maxWeight or 0)
		breakValue.Text = string.format("%d%%", stats.breakChance or 0)
		efficiencyValue.Text = tostring(stats.efficiency or 0)
	end

	return {
		Root = container,
		Update = update,
	}
end

return PreviewStats
