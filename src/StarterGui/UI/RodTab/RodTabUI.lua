local Theme = require(script.Parent.Parent:WaitForChild("Theme"))
local Panel = require(script.Parent.Parent:WaitForChild("Components"):WaitForChild("Panel"))

local RodTabUI = {}

local function addFade(parent)
	local fade = Instance.new("Frame")
	fade.Name = "Fade"
	fade.Size = UDim2.fromScale(1, 1)
	fade.BackgroundColor3 = Theme.Colors.Fade
	fade.BackgroundTransparency = 1
	fade.BorderSizePixel = 0
	fade.ZIndex = 20
	fade.Parent = parent
	return fade
end

local function buildBackground(parent)
	local background = Instance.new("Frame")
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = Theme.Colors.Background
	background.BorderSizePixel = 0
	background.Parent = parent

	local wallpaper = Instance.new("ImageLabel")
	wallpaper.Name = "Wallpaper"
	wallpaper.Size = UDim2.fromScale(1, 1)
	wallpaper.BackgroundTransparency = 1
	wallpaper.Image = Theme.Assets.Wallpaper
	wallpaper.ScaleType = Enum.ScaleType.Crop
	wallpaper.ImageTransparency = 0.2
	wallpaper.Parent = background

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(Theme.Gradients.Primary)
	gradient.Rotation = 120
	gradient.Parent = background

	return background
end

function RodTabUI.Create(parent)
	local background = buildBackground(parent)
	local fade = addFade(background)

	local frame = Panel.Create(background, UDim2.fromScale(0.86, 0.84), UDim2.fromScale(0.5, 0.52))
	frame.BackgroundTransparency = 0.15
	frame.ZIndex = 5

	local frameSize = Instance.new("UISizeConstraint")
	frameSize.MinSize = Vector2.new(560, 360)
	frameSize.MaxSize = Vector2.new(1100, 760)
	frameSize.Parent = frame

	local mainPadding = Instance.new("UIPadding")
	mainPadding.PaddingLeft = UDim.new(0.03, 0)
	mainPadding.PaddingRight = UDim.new(0.03, 0)
	mainPadding.PaddingTop = UDim.new(0.03, 0)
	mainPadding.PaddingBottom = UDim.new(0.03, 0)
	mainPadding.Parent = frame

	local container = Instance.new("Frame")
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.ZIndex = 6
	container.Parent = frame

	local containerLayout = Instance.new("UIListLayout")
	containerLayout.FillDirection = Enum.FillDirection.Vertical
	containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	containerLayout.Padding = UDim.new(0.03, 0)
	containerLayout.Parent = container

	local header = Instance.new("Frame")
	header.Size = UDim2.fromScale(1, 0.12)
	header.BackgroundTransparency = 1
	header.ZIndex = 6
	header.Parent = container

	local headerLayout = Instance.new("UIListLayout")
	headerLayout.FillDirection = Enum.FillDirection.Horizontal
	headerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	headerLayout.Padding = UDim.new(0.02, 0)
	headerLayout.Parent = header

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(0.65, 1)
	title.BackgroundTransparency = 1
	title.Font = Theme.Fonts.Heading
	title.TextSize = 18
	title.TextColor3 = Theme.Colors.Text
	title.Text = "Cana"
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 6
	title.Parent = header

	local backButton = Instance.new("TextButton")
	backButton.Size = UDim2.fromScale(0.3, 0.75)
	backButton.BackgroundColor3 = Theme.Colors.Button
	backButton.TextColor3 = Theme.Colors.Text
	backButton.Font = Theme.Fonts.BodyBold
	backButton.TextSize = 14
	backButton.Text = "Voltar"
	backButton.AutoButtonColor = false
	backButton.ZIndex = 6
	backButton.Parent = header

	local backCorner = Instance.new("UICorner")
	backCorner.CornerRadius = UDim.new(0.2, 0)
	backCorner.Parent = backButton

	local backStroke = Instance.new("UIStroke")
	backStroke.Color = Theme.Colors.PanelStroke
	backStroke.Thickness = 1
	backStroke.Parent = backButton

	local body = Instance.new("Frame")
	body.Size = UDim2.fromScale(1, 0.82)
	body.BackgroundTransparency = 1
	body.ZIndex = 6
	body.Parent = container

	local bodyLayout = Instance.new("UIListLayout")
	bodyLayout.FillDirection = Enum.FillDirection.Horizontal
	bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
	bodyLayout.Padding = UDim.new(0.03, 0)
	bodyLayout.Parent = body

	local leftPanel = Instance.new("Frame")
	leftPanel.Size = UDim2.fromScale(0.42, 1)
	leftPanel.BackgroundTransparency = 1
	leftPanel.ZIndex = 6
	leftPanel.Parent = body

	local leftLayout = Instance.new("UIListLayout")
	leftLayout.FillDirection = Enum.FillDirection.Vertical
	leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	leftLayout.Padding = UDim.new(0.03, 0)
	leftLayout.Parent = leftPanel

	local slotsPanel = Instance.new("Frame")
	slotsPanel.Size = UDim2.fromScale(1, 0.52)
	slotsPanel.BackgroundColor3 = Theme.Colors.Button
	slotsPanel.BackgroundTransparency = 0.08
	slotsPanel.BorderSizePixel = 0
	slotsPanel.ZIndex = 6
	slotsPanel.Parent = leftPanel

	local slotsCorner = Instance.new("UICorner")
	slotsCorner.CornerRadius = UDim.new(0.08, 0)
	slotsCorner.Parent = slotsPanel

	local slotsStroke = Instance.new("UIStroke")
	slotsStroke.Color = Theme.Colors.PanelStroke
	slotsStroke.Thickness = 1
	slotsStroke.Parent = slotsPanel

	local slotsPadding = Instance.new("UIPadding")
	slotsPadding.PaddingLeft = UDim.new(0.05, 0)
	slotsPadding.PaddingRight = UDim.new(0.05, 0)
	slotsPadding.PaddingTop = UDim.new(0.05, 0)
	slotsPadding.PaddingBottom = UDim.new(0.05, 0)
	slotsPadding.Parent = slotsPanel

	local slotsHeader = Instance.new("TextLabel")
	slotsHeader.Size = UDim2.fromScale(1, 0.12)
	slotsHeader.BackgroundTransparency = 1
	slotsHeader.Font = Theme.Fonts.BodyBold
	slotsHeader.TextSize = 14
	slotsHeader.TextColor3 = Theme.Colors.Text
	slotsHeader.Text = "Slots"
	slotsHeader.TextXAlignment = Enum.TextXAlignment.Left
	slotsHeader.ZIndex = 7
	slotsHeader.Parent = slotsPanel

	local slotsList = Instance.new("Frame")
	slotsList.Size = UDim2.fromScale(1, 0.88)
	slotsList.BackgroundTransparency = 1
	slotsList.ZIndex = 7
	slotsList.Parent = slotsPanel

	local slotsLayout = Instance.new("UIListLayout")
	slotsLayout.FillDirection = Enum.FillDirection.Vertical
	slotsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	slotsLayout.Padding = UDim.new(0.04, 0)
	slotsLayout.Parent = slotsList

	local statsPanel = Instance.new("Frame")
	statsPanel.Size = UDim2.fromScale(1, 0.3)
	statsPanel.BackgroundColor3 = Theme.Colors.Button
	statsPanel.BackgroundTransparency = 0.08
	statsPanel.BorderSizePixel = 0
	statsPanel.ZIndex = 6
	statsPanel.Parent = leftPanel

	local statsCorner = Instance.new("UICorner")
	statsCorner.CornerRadius = UDim.new(0.08, 0)
	statsCorner.Parent = statsPanel

	local statsStroke = Instance.new("UIStroke")
	statsStroke.Color = Theme.Colors.PanelStroke
	statsStroke.Thickness = 1
	statsStroke.Parent = statsPanel

	local statsPadding = Instance.new("UIPadding")
	statsPadding.PaddingLeft = UDim.new(0.05, 0)
	statsPadding.PaddingRight = UDim.new(0.05, 0)
	statsPadding.PaddingTop = UDim.new(0.05, 0)
	statsPadding.PaddingBottom = UDim.new(0.05, 0)
	statsPadding.Parent = statsPanel

	local statsHeader = Instance.new("TextLabel")
	statsHeader.Size = UDim2.fromScale(1, 0.2)
	statsHeader.BackgroundTransparency = 1
	statsHeader.Font = Theme.Fonts.BodyBold
	statsHeader.TextSize = 14
	statsHeader.TextColor3 = Theme.Colors.Text
	statsHeader.Text = "Preview de stats"
	statsHeader.TextXAlignment = Enum.TextXAlignment.Left
	statsHeader.ZIndex = 7
	statsHeader.Parent = statsPanel

	local statsBody = Instance.new("Frame")
	statsBody.Size = UDim2.fromScale(1, 0.8)
	statsBody.BackgroundTransparency = 1
	statsBody.ZIndex = 7
	statsBody.Parent = statsPanel

	local buttonsRow = Instance.new("Frame")
	buttonsRow.Size = UDim2.fromScale(1, 0.12)
	buttonsRow.BackgroundTransparency = 1
	buttonsRow.ZIndex = 6
	buttonsRow.Parent = leftPanel

	local buttonsLayout = Instance.new("UIListLayout")
	buttonsLayout.FillDirection = Enum.FillDirection.Horizontal
	buttonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	buttonsLayout.Padding = UDim.new(0.04, 0)
	buttonsLayout.Parent = buttonsRow

	local equipButton = Instance.new("TextButton")
	equipButton.Size = UDim2.fromScale(0.56, 1)
	equipButton.BackgroundColor3 = Theme.Colors.Accent
	equipButton.TextColor3 = Theme.Colors.Text
	equipButton.Font = Theme.Fonts.BodyBold
	equipButton.TextSize = 14
	equipButton.Text = "Equipar Cana"
	equipButton.AutoButtonColor = false
	equipButton.ZIndex = 7
	equipButton.Parent = buttonsRow

	local equipCorner = Instance.new("UICorner")
	equipCorner.CornerRadius = UDim.new(0.2, 0)
	equipCorner.Parent = equipButton

	local equipStroke = Instance.new("UIStroke")
	equipStroke.Color = Theme.Colors.AccentHover
	equipStroke.Thickness = 1
	equipStroke.Parent = equipButton

	local removeButton = Instance.new("TextButton")
	removeButton.Size = UDim2.fromScale(0.4, 1)
	removeButton.BackgroundColor3 = Theme.Colors.Button
	removeButton.TextColor3 = Theme.Colors.Text
	removeButton.Font = Theme.Fonts.BodyBold
	removeButton.TextSize = 14
	removeButton.Text = "Remover Peca"
	removeButton.AutoButtonColor = false
	removeButton.ZIndex = 7
	removeButton.Parent = buttonsRow

	local removeCorner = Instance.new("UICorner")
	removeCorner.CornerRadius = UDim.new(0.2, 0)
	removeCorner.Parent = removeButton

	local removeStroke = Instance.new("UIStroke")
	removeStroke.Color = Theme.Colors.PanelStroke
	removeStroke.Thickness = 1
	removeStroke.Parent = removeButton

	local rightPanel = Instance.new("Frame")
	rightPanel.Size = UDim2.fromScale(0.55, 1)
	rightPanel.BackgroundColor3 = Theme.Colors.Button
	rightPanel.BackgroundTransparency = 0.08
	rightPanel.BorderSizePixel = 0
	rightPanel.ZIndex = 6
	rightPanel.Parent = body

	local rightCorner = Instance.new("UICorner")
	rightCorner.CornerRadius = UDim.new(0.08, 0)
	rightCorner.Parent = rightPanel

	local rightStroke = Instance.new("UIStroke")
	rightStroke.Color = Theme.Colors.PanelStroke
	rightStroke.Thickness = 1
	rightStroke.Parent = rightPanel

	local rightPadding = Instance.new("UIPadding")
	rightPadding.PaddingLeft = UDim.new(0.05, 0)
	rightPadding.PaddingRight = UDim.new(0.05, 0)
	rightPadding.PaddingTop = UDim.new(0.05, 0)
	rightPadding.PaddingBottom = UDim.new(0.05, 0)
	rightPadding.Parent = rightPanel

	local rightLayout = Instance.new("UIListLayout")
	rightLayout.FillDirection = Enum.FillDirection.Vertical
	rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rightLayout.Padding = UDim.new(0.03, 0)
	rightLayout.Parent = rightPanel

	local listTitle = Instance.new("TextLabel")
	listTitle.Size = UDim2.fromScale(1, 0.08)
	listTitle.BackgroundTransparency = 1
	listTitle.Font = Theme.Fonts.BodyBold
	listTitle.TextSize = 14
	listTitle.TextColor3 = Theme.Colors.Text
	listTitle.Text = "Itens disponiveis"
	listTitle.TextXAlignment = Enum.TextXAlignment.Left
	listTitle.ZIndex = 7
	listTitle.Parent = rightPanel

	local listClip = Instance.new("Frame")
	listClip.Size = UDim2.fromScale(1, 0.92)
	listClip.BackgroundTransparency = 1
	listClip.ClipsDescendants = true
	listClip.ZIndex = 7
	listClip.Parent = rightPanel

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.fromScale(1, 1)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.ScrollBarThickness = 6
	list.ZIndex = 7
	list.Parent = listClip

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0.03, 0)
	listLayout.Parent = list

	return {
		Background = background,
		Fade = fade,
		Frame = frame,
		BackButton = backButton,
		SlotsContainer = slotsList,
		StatsContainer = statsBody,
		EquipButton = equipButton,
		RemoveButton = removeButton,
		ItemsList = list,
		ItemsLayout = listLayout,
		BodyLayout = bodyLayout,
	}
end

return RodTabUI
