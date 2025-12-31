local Theme = {}

Theme.Assets = {
	Logo = "rbxassetid://82425580179801",
	Wallpaper = "rbxassetid://88755976907991",
}

Theme.Colors = {
	Background = Color3.fromRGB(8, 30, 38),
	Panel = Color3.fromRGB(10, 26, 34),
	PanelStroke = Color3.fromRGB(90, 150, 170),
	Button = Color3.fromRGB(16, 40, 52),
	ButtonHover = Color3.fromRGB(20, 52, 66),
	Accent = Color3.fromRGB(18, 150, 170),
	AccentHover = Color3.fromRGB(26, 170, 190),
	AccentAlt = Color3.fromRGB(18, 120, 140),
	AccentAltHover = Color3.fromRGB(22, 140, 160),
	Text = Color3.fromRGB(240, 240, 240),
	TextMuted = Color3.fromRGB(170, 210, 220),
	TextSoft = Color3.fromRGB(190, 220, 235),
	IconTint = Color3.fromRGB(210, 235, 245),
	Fade = Color3.fromRGB(4, 12, 16),
	HudBackground = Color3.fromRGB(15, 15, 20),
	NotificationBackground = Color3.fromRGB(18, 32, 40),
	Disabled = Color3.fromRGB(70, 90, 100),
	Success = Color3.fromRGB(30, 90, 70),
	SuccessText = Color3.fromRGB(235, 255, 245),
	Warning = Color3.fromRGB(255, 190, 80),
	RarityEpic = Color3.fromRGB(90, 170, 255),
	RarityLegendary = Color3.fromRGB(220, 90, 255),
}

Theme.Gradients = {
	Primary = {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 40, 54)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 92, 114)),
	},
	Sun = {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 180)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 90)),
	},
}

Theme.Sun = {
	Fill = Color3.fromRGB(255, 210, 140),
	Transparency = 0.35,
}

Theme.Fonts = {
	Title = Enum.Font.GothamBlack,
	Heading = Enum.Font.GothamBold,
	Body = Enum.Font.Gotham,
	BodyBold = Enum.Font.GothamSemibold,
}

return Theme
