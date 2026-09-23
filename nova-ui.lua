local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- KeyboardEnabled reads true on plenty of phones because of the on-screen
-- keyboard, so it cannot decide this alone. A real mouse is the dependable
-- desktop tell, and where a device claims one anyway the viewport gives it away.
local function detectMobile()
	local forced = getgenv and getgenv().nova_mobile
	if type(forced) == "boolean" then
		return forced
	end
	if not UserInputService.TouchEnabled then
		return false
	end
	if not UserInputService.MouseEnabled then
		return true
	end
	local camera = workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize
	return viewport ~= nil and math.min(viewport.X, viewport.Y) <= 900
end

local Library = {
	Folder = "Nova",
	Mobile = detectMobile(),
	Toggles = {},
	Options = {},
	Keybinds = {},
	Connections = {},
	Windows = {},
	Chat = { ZyroMode = true },
	Unloaded = false,
}

local Theme = {
	Window = Color3.fromRGB(14, 14, 17),
	Rail = Color3.fromRGB(9, 9, 11),
	Card = Color3.fromRGB(19, 19, 23),
	Control = Color3.fromRGB(24, 24, 29),
	Track = Color3.fromRGB(33, 33, 40),
	Hover = Color3.fromRGB(27, 27, 33),
	Border = Color3.fromRGB(38, 38, 47),
	Divider = Color3.fromRGB(26, 26, 32),
	Text = Color3.fromRGB(238, 238, 240),
	Muted = Color3.fromRGB(112, 113, 124),
	Dim = Color3.fromRGB(92, 93, 103),
	Knob = Color3.fromRGB(246, 246, 248),
	Accent = Color3.fromRGB(113, 0, 255),
	AccentDeep = Color3.fromRGB(68, 0, 153),
	AccentLift = Color3.fromRGB(163, 89, 255),
	Danger = Color3.fromRGB(232, 96, 96),
}

local Metrics = {
	Width = 880,
	Height = 520,
	RailWidth = 230,
	HeaderHeight = 56,
	ContentPadding = 16,
	ColumnGap = 16,
	NavRowHeight = 34,
	NavRowGap = 4,
	NavMarkHeight = 18,
	NavGroupGap = 17,
	SectionLabelHeight = 22,
	SectionGap = 14,
	ScrollGutter = 10,
	SearchHeight = 30,
	ActionRowWidth = 195,
	ActionHeight = 32,
	ActionIconSize = 18,
	RailEdge = 1,
	DialogWidth = 320,
	DialogHeight = 148,
	DialogButtonWidth = 82,
	BorderTransparency = 0.55,
	ActionDividerHeight = 18,
	ProfileWidth = 168,
	StatWidth = 62,
	StatInterval = 0.25,
	DragResponse = 18,
	RowHeight = 42,
	WindowRadius = 12,
	CardRadius = 8,
	ControlRadius = 6,
	CheckRadius = 5,
	CheckSize = 16,
	ControlWidth = 150,
	ControlHeight = 26,
	TrackHeight = 10,
	KnobSize = 6,
	KnobMargin = 2,
	SliderValueWidth = 52,
	SliderValueHeight = 22,
	OptionHeight = 26,
	OptionGap = 2,
	MenuPadding = 6,
	MenuGap = 4,
	MenuMaxHeight = 210,
	CloudEndpoint = "https://configs-app-production.up.railway.app",
	CloudPresets = {
		[9908641400] = {
			{ Name = "Legit WR + QB Aimbot", Code = "65YQJE" },
			{ Name = "Blatant WR + QB Aimbot", Code = "KNRGAM" },
		},
	},
	ChatChannel = "nova-global",
	ChatBatch = 50,
	ChatPoll = 3,
	AgentPoll = 5,
	BannerWidth = 340,
	BannerHeight = 52,
	PresencePoll = 30,
	ModalWidth = 420,
	ToastWidth = 250,
	ToastHeight = 44,
	ToastLife = 4,
	ToastMargin = 16,
	ChatInputHeight = 32,
	ModalHeight = 380,
	SwatchWidth = 40,
	SwatchHeight = 20,
	PickerWidth = 220,
	PickerPadding = 12,
	SVWidth = 174,
	SVHeight = 128,
	StripWidth = 14,
	StripHeight = 12,
	RainbowPeriod = 5,
	SubPanelWidth = 296,
	SubPanelPadding = 8,
	SubPanelGap = 8,
	SliderResponse = 0.0001,
	IconSize = 16,
	Logo = "https://configs-app-production.up.railway.app/logo.png",
	DevName = "developer",
	DevDetail = "d1 chud",
	DevAvatar = "https://static.wikia.nocookie.net/roshidere/images/4/43/Alisa_Mikhailovna_Kujou_Light_Novel.png/revision/latest/scale-to-width-down/1200?cb=20251123032100",
	ClosedScale = 0.97,
	FitMargin = 16,
	LauncherSize = 54,
	LauncherRadius = 14,
	LauncherCaption = 16,
	LauncherSpawn = 0.06,
	LauncherHint = "Double tap to lock",
	ActionButtonWidth = 84,
	TapTravel = 6,
	DoubleTap = 0.32,
	KeyWidth = 400,
	KeyFormWidth = 640,
	KeySideWidth = 236,
	KeyStripHeight = 52,
	KeyPadding = 20,
	KeyFieldHeight = 38,
	KeyButtonHeight = 34,
	KeyStatusHeight = 30,
	KeyFooterHeight = 40,
	KeyDismiss = 1.8,
	KeyAvatarSize = 64,
	KeyHandoffGrace = 3,
	KeyProfileTimeout = 4,
	KeyHandoffTimeout = 25,
	DiscordFile = "discord.json",
	KeyStageDwell = 0.7,
	KeyTileSize = 60,
	KeyFile = "key.txt",
	KeySite = "getnova.cc",
	KeyLink = "getnova.cc/key",
	KeyDiscord = "dsc.gg/getnova",
	LuarmorSdk = "https://sdkapi-public.luarmor.net/library.lua",
	LuarmorMain = "53e855696b112994c13a029e3f511876",
	MainGames = {
		[6858584271] = "Philly Streetz 2",
		[10648640958] = "Hood Rivals",
		[10563114921] = "Steal An Egg",
		[1160789089] = "Flag Wars",
		[111958650] = "Arsenal",
		[4931927012] = "Basketball Legends",
		[9893475671] = "OT7 Football",
		[8795154789] = "Flick",
		[5113572498] = "College Football",
		[7326934954] = "99 Nights in the Forest",
		[7128251171] = "Superstar Baseball",
		[6331902150] = "Forsaken",
		[6931042565] = "Volleyball Legends",
		[7884563721] = "Arcade Basketball",
		[6260656796] = "Playground Basketball",
		[6061766680] = "Fight in a School",
		[2251388500] = "Twisted",
		[1008451066] = "Da Hood",
		[6035872082] = "Rivals",
		[4864117649] = "Untitled Tag Game",
		[8558141897] = "Flag Football",
		[2583564222] = "Boxing Beta",
		[533435040] = "Flicker",
		[66654135] = "Murder Mystery 2",
		[3647333358] = "Evade",
		[372226183] = "Flee the Facility",
		[5674379281] = "The Bronx 3",
		[5012222382] = "Gunfight Arena",
		[1281592938] = "Entrenched",
		[7931158824] = "Pure Soccer",
		[7264587281] = "Sniper Duels",
		[8307114974] = "Operation One",
		[6739698191] = "Violence District",
		[9199655655] = "Gakuran",
		[4348829796] = "Murderers VS Sheriffs Duels",
		[2287245386] = "Hoopz",
	},
	LuarmorScripts = {
		[9908641400] = { Name = "Football Fusion 3", Id = "0530b1fddfc5c9d6e64dec3820802840" },
		[184199275] = { Name = "NFL Universe Football", Id = "36df1bb6c0fd5035f9206e229c76f010" },
		[6505338302] = { Name = "Football Legends", Id = "528ed318de01e4d36977743ad3c78d8e" },
		[5113572498] = { Name = "College Football", Id = "a4ec574c31e02d5bc051c5f4b879ec9b" },
		[7633926880] = { Name = "Bloxstrike", Id = "ae8ea6dbf229231a3b4ddc503cdd3052" },
		[73885730] = { Name = "Prison Life", Id = "f1e884f9203bf01df7741218b2973238" },
	},
}

local Motion = {
	Quick = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Smooth = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	Pop = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	Progress = TweenInfo.new(2.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	Launch = TweenInfo.new(10, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	Ping = TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	Breathe = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
}

Library.Theme = Theme
-- touch targets: the window is downscaled to fit a phone viewport, so the fixed
-- desktop metrics land around 10px on screen. a smaller logical canvas downscales
-- less, and the taller rows survive what downscaling is left.
if Library.Mobile then
	Metrics.Width = 760
	Metrics.Height = 430
	Metrics.RailWidth = 190
	Metrics.FitMargin = 8
	Metrics.RowHeight = 50
	Metrics.NavRowHeight = 40
	Metrics.ControlHeight = 32
	Metrics.CheckSize = 20
	Metrics.SliderValueHeight = 26
	Metrics.OptionHeight = 32
	Metrics.SearchHeight = 36
	Metrics.ActionHeight = 36
	Metrics.KeyFieldHeight = 44
	Metrics.KeyButtonHeight = 40
end

Library.Metrics = Metrics
Library.Motion = Motion

-- Roblox names controller buttons after an Xbox pad, so the short labels follow it.
-- Thumbsticks are deliberately absent: they are axes that only surface through
-- InputChanged, and a bind needs something that reports a press and a release.
local GamepadNames = {
	ButtonA = "A", ButtonB = "B", ButtonX = "X", ButtonY = "Y",
	ButtonL1 = "LB", ButtonR1 = "RB",
	ButtonL2 = "LT", ButtonR2 = "RT",
	ButtonL3 = "LS", ButtonR3 = "RS",
	ButtonStart = "Start", ButtonSelect = "Select", ButtonBack = "Back",
	DPadUp = "D-Up", DPadDown = "D-Down", DPadLeft = "D-Left", DPadRight = "D-Right",
}

local function isGamepadKey(value)
	return typeof(value) == "EnumItem" and GamepadNames[value.Name] ~= nil
end

local function isGamepadInput(input)
	local kind = input.UserInputType
	return typeof(kind) == "EnumItem" and string.sub(kind.Name, 1, 7) == "Gamepad"
end


local UiFamily = Font.fromEnum(Enum.Font.BuilderSans).Family
local function face(weight)
	return Font.new(UiFamily, weight or Enum.FontWeight.Medium)
end

local function new(class, props, children)
	local instance = Instance.new(class)
	local parent = props.Parent
	props.Parent = nil
	for key, value in props do
		instance[key] = value
	end
	if children then
		for _, child in children do
			child.Parent = instance
		end
	end
	instance.Parent = parent
	props.Parent = parent
	return instance
end

local function tween(instance, goal, info)
	local animation = TweenService:Create(instance, info or Motion.Smooth, goal)
	animation:Play()
	return animation
end

local function corner(radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function stroke(color, transparency, thickness)
	return new("UIStroke", {
		Color = color or Theme.Border,
		Transparency = transparency or 0.4,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function padding(top, right, bottom, left)
	return new("UIPadding", {
		PaddingTop = UDim.new(0, top),
		PaddingRight = UDim.new(0, right or top),
		PaddingBottom = UDim.new(0, bottom or top),
		PaddingLeft = UDim.new(0, left or right or top),
	})
end

local function text(props)
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.FontFace = props.FontFace or face()
	props.TextColor3 = props.TextColor3 or Theme.Text
	props.TextSize = props.TextSize or 13
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	return new("TextLabel", props)
end

local AccentListeners = {}

function Library:OnAccent(callback)
	table.insert(AccentListeners, callback)
	callback()
	return callback
end

function Library:SetAccent(color)
	local hue, saturation, value = Color3.toHSV(color)
	Theme.Accent = color
	Theme.AccentLift = Color3.fromHSV(hue, math.max(saturation - 0.35, 0), math.min(value + 0.2, 1))
	Theme.AccentDeep = Color3.fromHSV(hue, math.min(saturation + 0.1, 1), value * 0.6)

	for _, callback in AccentListeners do
		callback()
	end
end

function Library:Connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(self.Connections, connection)
	return connection
end

local ImageCache = {}
local ImageWaiters = {}

local function imagesSupported()
	return type(getcustomasset) == "function"
		and type(writefile) == "function"
		and type(isfile) == "function"
end

local function ensureFolder(path)
	if type(isfolder) ~= "function" or type(makefolder) ~= "function" then
		return
	end
	local built = nil
	for segment in string.gmatch(path, "[^/]+") do
		built = built and (built .. "/" .. segment) or segment
		if not isfolder(built) then
			pcall(makefolder, built)
		end
	end
end

function Library:RequestImage(path, url, apply)
	local cached = ImageCache[path]
	if cached ~= nil then
		if cached and apply then
			apply(cached)
		end
		return cached or nil
	end

	if not imagesSupported() then
		ImageCache[path] = false
		return nil
	end

	if isfile(path) then
		local loaded, asset = pcall(getcustomasset, path)
		ImageCache[path] = loaded and asset or false
		if ImageCache[path] and apply then
			apply(ImageCache[path])
		end
		return ImageCache[path] or nil
	end

	if ImageWaiters[path] then
		table.insert(ImageWaiters[path], apply)
		return nil
	end

	ImageWaiters[path] = { apply }
	task.spawn(function()
		ensureFolder(string.match(path, "^(.*)/[^/]+$") or self.Folder)

		local asset = false
		local fetched, body = pcall(game.HttpGet, game, url)
		if fetched and type(body) == "string" and #body >= 64 then
			pcall(writefile, path, body)
			local loaded, custom = pcall(getcustomasset, path)
			asset = loaded and custom or false
		end

		ImageCache[path] = asset
		for _, waiter in ImageWaiters[path] do
			if asset and waiter then
				waiter(asset)
			end
		end
		ImageWaiters[path] = nil
	end)

	return nil
end

function Library:RequestIcon(name, apply)
	if type(name) == "string" then
		local raw
		if name:match("^rbxassetid://") or name:match("^rbxasset://") then
			raw = name
		elseif name:match("^%d+$") then
			raw = "rbxassetid://" .. name
		else
			local id = name:match("[?&]id=(%d+)")
			if id then raw = "rbxassetid://" .. id end
		end
		if raw then
			if apply then apply(raw) end
			return raw
		end
	end

	local set, glyph = string.match(name, "^([%w%-]+):(.+)$")
	set = set or "lucide"
	glyph = glyph or name

	local url = string.format(
		"https://wsrv.nl/?url=api.iconify.design%%2F%s%%2F%s.svg%%3Fcolor%%3Dwhite&output=png&w=96",
		set,
		glyph
	)
	return self:RequestImage(string.format("%s/icons/%s-%s.png", self.Folder, set, glyph), url, apply)
end

local IconFallbacks = {
	search = "?",
	["chevron-down"] = "v",
	["chevron-right"] = ">",
	["chevron-left"] = "<",
	["eye-off"] = "-",
	send = ">",
	["user-plus"] = "+",
	["layout-grid"] = "#",
	keyboard = "=",
	["message-circle"] = "=",
	settings = "*",
	folder = "[]",
	check = "+",
	minus = "-",
	x = "X",
}

local function icon(props, name)
	local color = props.Color or Theme.Muted
	local size = props.Size or Metrics.IconSize
	local base = {
		Name = name,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size, size),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder,
		Parent = props.Parent,
	}

	if imagesSupported() then
		base.ImageColor3 = color
		base.ScaleType = Enum.ScaleType.Fit
		local image = new("ImageLabel", base)
		Library:RequestIcon(name, function(asset)
			image.Image = asset
		end)
		return image, "ImageTransparency", "ImageColor3"
	end

	base.Text = IconFallbacks[name] or "-"
	base.TextColor3 = color
	base.TextSize = size - 3
	base.TextXAlignment = Enum.TextXAlignment.Center
	local label = text(base)
	return label, "TextTransparency", "TextColor3"
end

Library.Icon = icon
Library.New = new
Library.Tween = tween
Library.Face = face
Library.Text = text
Library.Corner = corner
Library.Stroke = stroke
Library.Padding = padding

local function encodeUrl(value)
	return (string.gsub(value, "[^%w%-%.%_%~]", function(char)
		return string.format("%%%02X", string.byte(char))
	end))
end

local function scalar(value)
	return (type(value) == "string" or type(value) == "number") and value or nil
end

local function luarmorGlobal(name)
	local env = getfenv and getfenv(2) or {}
	return scalar(rawget(_G, name)) or scalar(env[name])
end

function Library:LuarmorSeconds()
	local seconds = self.LuarmorSecondsLeft
	if seconds == nil then
		seconds = luarmorGlobal("LRM_SecondsLeft")
	end
	return tonumber(seconds)
end

function Library:IsObfuscated()
	if self.Obfuscated ~= nil then
		return self.Obfuscated
	end
	return rawget(_G, "LPH_OBFUSCATED") == true
end

local function formatRemaining(seconds)
	if seconds == math.huge then
		return "Lifetime"
	end

	local days = math.floor(seconds / 86400)
	local hours = math.floor((seconds % 86400) / 3600)
	local minutes = math.floor((seconds % 3600) / 60)

	if days > 0 then
		return string.format("%dd %dh left", days, hours)
	end
	return string.format("%dh %dm left", hours, minutes)
end

function Library:Profile()
	local player = Players.LocalPlayer
	local name = player and player.DisplayName or "Player"
	local seconds = self:LuarmorSeconds()

	if seconds then
		local identity = self:DiscordIdentity()
		return {
			Name = identity and identity.username or name,
			Avatar = identity and identity.avatar and self:DiscordAvatarUrl(identity),
			AvatarPath = identity and identity.avatar and self:DiscordAvatarPath(identity),
			Detail = formatRemaining(seconds),
			Kind = "key",
			Expiring = seconds ~= math.huge and seconds < 86400,
			Premium = luarmorGlobal("LRM_IsUserPremium") == true,
			Discord = luarmorGlobal("LRM_LinkedDiscordID"),
		}
	end

	if self:IsObfuscated() then
		return {
			Name = name,
			Detail = os.date("%d %b %Y"),
			Kind = "session",
		}
	end

	return {
		Name = Metrics.DevName,
		Detail = Metrics.DevDetail,
		Kind = "dev",
		Avatar = Metrics.DevAvatar,
	}
end

local function hostGui(name)
	local gui = new("ScreenGui", {
		Name = name,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 999,
	})

	if type(gethui) == "function" then
		local ok, container = pcall(gethui)
		if ok and container then
			gui.Parent = container
			return gui
		end
	end

	if type(syn) == "table" and type(syn.protect_gui) == "function" then
		pcall(syn.protect_gui, gui)
	end

	gui.Parent = RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")
		or game:GetService("CoreGui")

	return gui
end

local function bindDrag(window, handle)
	local dragging = false
	local origin, startOffset
	local targetX, targetY = 0, 0
	local currentX, currentY = 0, 0

	Library:Connect(handle.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		dragging = true
		origin = input.Position
		startOffset = window.Root.Position
		currentX, currentY = startOffset.X.Offset, startOffset.Y.Offset
		targetX, targetY = currentX, currentY
	end)

	Library:Connect(UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local delta = input.Position - origin
		targetX = startOffset.X.Offset + delta.X
		targetY = startOffset.Y.Offset + delta.Y
	end)

	Library:Connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	Library:Connect(RunService.RenderStepped, function(dt)
		local dx, dy = targetX - currentX, targetY - currentY
		if not dragging and dx * dx + dy * dy < 0.02 then
			return
		end

		local alpha = 1 - math.exp(-dt * Metrics.DragResponse)
		currentX += dx * alpha
		currentY += dy * alpha

		local position = window.Root.Position
		window.Root.Position = UDim2.new(
			position.X.Scale,
			math.round(currentX),
			position.Y.Scale,
			math.round(currentY)
		)
	end)
end

local function iconButton(parent, name, size, hoverColor)
	local button = new("TextButton", {
		Name = name,
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Control,
		BackgroundTransparency = 0.35,
		Size = UDim2.fromOffset(size, size),
		Parent = parent,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.55) })

	local glyph, _, tintKey = icon({
		Parent = button,
		Color = Theme.Muted,
		Size = Metrics.IconSize,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, name)

	Library:Connect(button.MouseEnter, function()
		tween(button, { BackgroundTransparency = 0 }, Motion.Quick)
		tween(glyph, { [tintKey] = hoverColor or Theme.Text }, Motion.Quick)
	end)
	Library:Connect(button.MouseLeave, function()
		tween(button, { BackgroundTransparency = 0.35 }, Motion.Quick)
		tween(glyph, { [tintKey] = Theme.Muted }, Motion.Quick)
	end)

	return button
end

local Window = {}
Window.__index = Window

function Library:CreateWindow(config)
	config = config or {}

	local width = config.Width or Metrics.Width
	local height = config.Height or Metrics.Height

	if config.Accent then
		Theme.Accent = config.Accent
	end
	if config.Folder then
		Library.Folder = config.Folder
	end

	local window = setmetatable({
		Title = config.Title or "Title",
		Subtitle = config.Subtitle or "Subtitle",
		MenuKey = config.MenuKey or Enum.KeyCode.LeftControl,
		Expiry = config.Expiry or "Lifetime",
		Open = true,
		Minimized = false,
		Tabs = {},
		SystemTabs = {},
		Searchable = {},
	}, Window)

	window.Width = width
	window.Height = height
	window.Gui = hostGui(config.GuiName or "Nova")

	local root = new("CanvasGroup", {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = Theme.Window,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = window.Gui,
	}, { corner(Metrics.WindowRadius) })

	window.RootStroke = new("UIStroke", {
		Color = Theme.Border,
		Transparency = Metrics.BorderTransparency,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = root,
	})

	local scale = new("UIScale", { Scale = 1, Parent = root })

	window.Root = root
	window.Scale = scale
	window.UserScale = 1
	window.FitScale = 1

	local rail = new("Frame", {
		Name = "Rail",
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		Size = UDim2.new(0, Metrics.RailWidth, 1, 0),
		Parent = root,
	})

	window.Rail = rail

	local railBody = new("Frame", {
		Name = "RailBody",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = rail,
	})

	window.RailBody = railBody

	new("Frame", {
		Name = "RailEdge",
		BackgroundColor3 = Theme.Divider,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, Metrics.RailEdge, 1, 0),
		Parent = rail,
	})

	local header = new("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Metrics.HeaderHeight),
		Parent = root,
	})

	local brand = new("Frame", {
		Name = "Brand",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, Metrics.RailWidth, 1, 0),
		Parent = header,
	}, {
		padding(0, Metrics.ContentPadding + 2),
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		}),
	})

	local wordmark = string.upper(window.Title)
	local order = 0
	for first, last in utf8.graphemes(wordmark) do
		order += 1
		text({
			Name = "Letter",
			Text = string.sub(wordmark, first, last),
			FontFace = face(Enum.FontWeight.Bold),
			TextSize = 28,
			TextXAlignment = Enum.TextXAlignment.Center,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = order,
			Parent = brand,
		})
	end

	local controls = new("Frame", {
		Name = "Controls",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(Metrics.RailWidth, 0),
		Size = UDim2.new(1, -Metrics.RailWidth, 1, 0),
		Parent = header,
	}, { padding(0, Metrics.ContentPadding) })

	local profile = new("Frame", {
		Name = "Profile",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.ProfileWidth, 32),
		Parent = controls,
	})

	local avatar = new("ImageLabel", {
		Name = "Avatar",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(32, 32),
		Parent = profile,
	}, { corner(9) })

	local displayName = text({
		Name = "Name",
		Text = "...",
		FontFace = face(Enum.FontWeight.SemiBold),
		TextSize = 13,
		Position = UDim2.fromOffset(41, 2),
		Size = UDim2.new(1, -41, 0, 15),
		Parent = profile,
	})

	local expiry = text({
		Name = "Expiry",
		Text = "",
		TextColor3 = Theme.Dim,
		TextSize = 11,
		Position = UDim2.fromOffset(41, 17),
		Size = UDim2.new(1, -41, 0, 13),
		Parent = profile,
	})

	window.Avatar = avatar
	window.NameLabel = displayName
	window.ExpiryLabel = expiry

	local player = Players.LocalPlayer

	function window:RefreshProfile()
		local profile = Library:Profile()
		displayName.Text = profile.Name
		expiry.Text = config.Expiry or profile.Detail
		expiry.TextColor3 = profile.Expiring and Theme.Danger
			or (profile.Kind == "dev" and Theme.Accent or Theme.Dim)
		self.ProfileKind = profile.Kind
		self.ProfileAvatar = profile.Avatar
		return profile
	end

	local profile = window:RefreshProfile()

	Library:OnAccent(function()
		window:RefreshProfile()
	end)

	if profile.Discord then
		Library:CacheDiscord(tostring(profile.Discord))
	end

	if profile.Avatar then
		Library:RequestImage(
			profile.AvatarPath or string.format("%s/dev.png", Library.Folder),
			string.format("https://wsrv.nl/?url=%s&output=png&w=128", encodeUrl(profile.Avatar)),
			function(asset)
				avatar.Image = asset
			end
		)
	elseif player then
		task.spawn(function()
			local ok, content = pcall(
				Players.GetUserThumbnailAsync,
				Players,
				player.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size100x100
			)
			if ok and content then
				avatar.Image = content
			end
		end)
	end

	window.StatsDivider = new("Frame", {
		Name = "ProfileDivider",
		BackgroundColor3 = Theme.Divider,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, Metrics.ProfileWidth + 4, 0.5, 0),
		Size = UDim2.fromOffset(1, 26),
		Parent = controls,
	})

	local function stat(caption, xOffset)
		local holder = new("Frame", {
			Name = caption,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, xOffset, 0.5, 0),
			Size = UDim2.fromOffset(Metrics.StatWidth, 30),
			Parent = controls,
		})

		text({
			Name = "Caption",
			Text = caption,
			TextColor3 = Theme.Dim,
			TextSize = 10,
			Size = UDim2.new(1, 0, 0, 12),
			Parent = holder,
		})

		return text({
			Name = "Value",
			Text = "0",
			FontFace = face(Enum.FontWeight.SemiBold),
			TextSize = 13,
			Position = UDim2.fromOffset(0, 13),
			Size = UDim2.new(1, 0, 0, 15),
			Parent = holder,
		})
	end

	local statsLeft = Metrics.ProfileWidth + 21
	window.PingLabel = stat("Ping", statsLeft)
	window.FpsLabel = stat("FPS", statsLeft + Metrics.StatWidth)

	local frames, elapsed = 0, 0
	Library:Connect(RunService.RenderStepped, function(dt)
		frames += 1
		elapsed += dt
		if elapsed < Metrics.StatInterval then
			return
		end

		window.FpsLabel.Text = tostring(math.round(frames / elapsed))

		if player then
			local ok, ping = pcall(player.GetNetworkPing, player)
			window.PingLabel.Text = ok and (math.round(ping * 1000) .. " ms") or "-"
		end

		frames, elapsed = 0, 0
	end)

	local function windowButton(name, order, hoverColor)
		local button = iconButton(controls, name, 26, hoverColor)
		button.AnchorPoint = Vector2.new(1, 0.5)
		button.Position = UDim2.new(1, -(order - 1) * 32, 0.5, 0)
		return button
	end

	window.CloseButton = windowButton("x", 1, Theme.Danger)
	window.MinimizeButton = windowButton("minus", 2)
	window.HideButton = windowButton("eye-off", 3)

	Library:Connect(window.CloseButton.MouseButton1Click, function()
		window:Confirm({
			Title = "Close " .. window.Title,
			Body = "this unloads the hub completely. you'll have to run the script again to get it back",
			ConfirmText = "Close",
			Danger = true,
			OnConfirm = function()
				Library:Unload()
			end,
		})
	end)

	Library:Connect(window.MinimizeButton.MouseButton1Click, function()
		window:SetMinimized(not window.Minimized)
	end)

	Library:Connect(window.HideButton.MouseButton1Click, function()
		window:SetOpen(false)
	end)

	local search = new("Frame", {
		Name = "Search",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(Metrics.ContentPadding, Metrics.HeaderHeight),
		Size = UDim2.new(1, -Metrics.ContentPadding * 2, 0, Metrics.SearchHeight),
		Parent = railBody,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.6) })

	icon({
		Parent = search,
		Color = Theme.Dim,
		Size = 14,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 9, 0.5, 0),
	}, "search")

	window.SearchBox = new("TextBox", {
		Name = "Input",
		Text = "",
		PlaceholderText = "Search",
		PlaceholderColor3 = Theme.Dim,
		TextColor3 = Theme.Text,
		FontFace = face(),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -9, 0.5, 0),
		Size = UDim2.new(1, -37, 1, 0),
		Parent = search,
	})

	local navTop = Metrics.HeaderHeight + Metrics.SearchHeight + Metrics.ContentPadding + 8

	new("Frame", {
		Name = "NavDivider",
		BackgroundColor3 = Theme.Divider,
		BorderSizePixel = 0,
		Position = UDim2.new(0, Metrics.ContentPadding, 0, navTop - 9),
		Size = UDim2.new(1, -Metrics.ContentPadding * 2, 0, 1),
		Parent = railBody,
	})

	local railInset = Metrics.ContentPadding - 6
	local actionsHeight = Metrics.ActionHeight
	local actionsTop = -(actionsHeight + Metrics.ContentPadding)

	window.RailInset = railInset
	window.NavHeight = height - navTop + actionsTop - Metrics.NavGroupGap

	window.Nav = new("ScrollingFrame", {
		Name = "Nav",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(railInset, navTop),
		Size = UDim2.new(1, -railInset * 2, 0, window.NavHeight),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Track,
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		Parent = railBody,
	})

	local actionCount = 3
	local actionsWidth = Metrics.ActionRowWidth
	local actionSlot = actionsWidth / actionCount
	local actionsLeft = math.floor((Metrics.RailWidth - Metrics.RailEdge - actionsWidth) / 2)

	local actions = new("Frame", {
		Name = "Actions",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, actionsLeft, 1, -Metrics.ContentPadding),
		Size = UDim2.fromOffset(actionsWidth, Metrics.ActionHeight),
		Parent = railBody,
	})

	window.Actions = {}

	local function railAction(key, iconName, order)
		local button = new("TextButton", {
			Name = key,
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Hover,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset((order - 1) * actionSlot, 0),
			Size = UDim2.fromOffset(actionSlot, Metrics.ActionHeight),
			Parent = actions,
		}, { corner(Metrics.ControlRadius) })

		local glyph, _, tintKey = icon({
			Parent = button,
			Color = Theme.Dim,
			Size = Metrics.ActionIconSize,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		}, iconName)

		Library:Connect(button.MouseEnter, function()
			tween(button, { BackgroundTransparency = 0.5 }, Motion.Quick)
			tween(glyph, { [tintKey] = Theme.Text }, Motion.Quick)
		end)

		Library:Connect(button.MouseLeave, function()
			tween(button, { BackgroundTransparency = 1 }, Motion.Quick)
			tween(glyph, { [tintKey] = Theme.Dim }, Motion.Quick)
		end)

		Library:Connect(button.MouseButton1Click, function()
			local handler = window.Actions[key]
			if handler then
				handler(window)
			end
		end)

		return button
	end

	for gap = 1, actionCount - 1 do
		new("Frame", {
			Name = "ActionDivider" .. gap,
			BackgroundColor3 = Theme.Divider,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, gap * actionSlot, 0.5, 0),
			Size = UDim2.fromOffset(1, Metrics.ActionDividerHeight),
			Parent = actions,
		})
	end

	window.GlobalChatButton = railAction("GlobalChat", "message-circle", 1)
	window.ConfigsButton = railAction("Configs", "folder", 2)
	window.SettingsButton = railAction("Settings", "settings", 3)

	window.NavTop = navTop
	window.NavOffset = 0

	window.NavIndicator = new("Frame", {
		Name = "NavIndicator",
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, navTop),
		Size = UDim2.fromOffset(3, Metrics.NavMarkHeight),
		Parent = railBody,
	}, { corner(2) })

	Library:OnAccent(function()
		window.NavIndicator.BackgroundColor3 = Theme.Accent
	end)

	Library:Connect(window.Nav:GetPropertyChangedSignal("CanvasPosition"), function()
		window:PlaceNavIndicator()
	end)

	window.Body = new("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(Metrics.RailWidth, Metrics.HeaderHeight),
		Size = UDim2.new(1, -Metrics.RailWidth, 1, -Metrics.HeaderHeight),
		Parent = root,
	})

	local body = window.Body

	local crumb = new("Frame", {
		Name = "Breadcrumb",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(Metrics.ContentPadding, 0),
		Size = UDim2.new(1, -Metrics.ContentPadding * 2, 0, Metrics.SearchHeight),
		Parent = body,
	}, {
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 7),
		}),
	})

	window.CrumbRoot = text({
		Name = "Root",
		Text = "",
		TextSize = 13,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		LayoutOrder = 1,
		Parent = crumb,
	})

	window.CrumbArrow = icon({
		Parent = crumb,
		Color = Theme.Dim,
		Size = 13,
		LayoutOrder = 2,
	}, "chevron-right")

	window.CrumbLeaf = text({
		Name = "Leaf",
		Text = "",
		TextColor3 = Theme.Muted,
		TextSize = 13,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		LayoutOrder = 3,
		Parent = crumb,
	})

	window.Pages = new("Frame", {
		Name = "Pages",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, Metrics.SearchHeight + 4),
		Size = UDim2.new(1, 0, 1, -(Metrics.SearchHeight + 4)),
		Parent = body,
	})

	window.PanelScrim = new("TextButton", {
		Name = "PanelScrim",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 1,
		Parent = nil,
	})

	window.PickerScrim = new("TextButton", {
		Name = "PickerScrim",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 5,
		Parent = nil,
	})

	window.MenuScrim = new("TextButton", {
		Name = "MenuScrim",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 3,
		Parent = nil,
	})

	window.Overlay = new("Frame", {
		Name = "Overlay",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 20,
		Parent = root,
	})

	window.ToastOrder = 1
	window.Toasts = new("Frame", {
		Name = "Toasts",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -Metrics.ToastMargin, 1, -Metrics.ToastMargin),
		Size = UDim2.fromOffset(Metrics.ToastWidth, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 100,
		Parent = window.Gui,
	}, {
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		}),
	})

	window.PanelScrim.Parent = window.Overlay
	Library:Connect(window.PanelScrim.MouseButton1Click, function()
		window:ClosePanel()
	end)

	Library:Connect(window.SearchBox:GetPropertyChangedSignal("Text"), function()
		window:ApplySearch(window.SearchBox.Text)
	end)

	window.MenuScrim.Parent = window.Overlay
	Library:Connect(window.MenuScrim.MouseButton1Click, function()
		window:CloseMenu()
	end)

	window.PickerScrim.Parent = window.Overlay
	Library:Connect(window.PickerScrim.MouseButton1Click, function()
		window:ClosePicker()
	end)

	window:SetBreadcrumb("", "")
	bindDrag(window, header)

	if config.Launcher ~= false and (config.Launcher or Library.Mobile) then
		window:BuildLauncher()
	end

	window:BuildChatTab()
	window:BuildConfigsTab()
	window:BuildSettingsTab()

	window:SetRailAction("GlobalChat", function()
		window.ChatTab:Select()
	end)

	window:SetRailAction("Configs", function()
		window.ConfigsTab:Select()
	end)

	window:SetRailAction("Settings", function()
		window.SettingsTab:Select()
	end)

	Library:Connect(UserInputService.InputBegan, function(input, processed)
		if Library.Unloaded then
			return
		end
		if processed and not isGamepadInput(input) then
			return
		end
		if input.KeyCode == window.MenuKey then
			window:Toggle()
		end
	end)

	Library:Connect(window.Gui:GetPropertyChangedSignal("AbsoluteSize"), function()
		window:RefreshFit()
	end)

	root.GroupTransparency = 1
	window.RootStroke.Transparency = 1
	window.Open = false
	window:RefreshFit()
	window:ApplyScale(true)
	window.Open = true

	tween(root, { GroupTransparency = 0 }, Motion.Smooth)
	tween(window.RootStroke, { Transparency = Metrics.BorderTransparency }, Motion.Smooth)
	window:ApplyScale()

	local handoff = (type(getgenv) == "function" and getgenv() or _G).NovaKeyHandoff
	if type(handoff) == "function" then
		task.spawn(handoff)
	end

	table.insert(Library.Windows, window)
	return window
end

function Window:RequestLogo(apply)
	Library:RequestImage(string.format("%s/brand.png", Library.Folder), Metrics.Logo, apply)
end

function Window:SetBreadcrumb(root, leaf)
	local hasLeaf = leaf ~= nil and leaf ~= ""
	self.CrumbRoot.Text = root or ""
	self.CrumbRoot.TextColor3 = hasLeaf and Theme.Text or Theme.Muted
	self.CrumbLeaf.Text = hasLeaf and leaf or ""
	self.CrumbLeaf.Visible = hasLeaf
	self.CrumbArrow.Visible = hasLeaf
end

local function dialogButton(parent, label, order, danger)
	local button = new("TextButton", {
		Name = label,
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = danger and Theme.Danger or Theme.Control,
		BackgroundTransparency = danger and 0 or 0.2,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -(order - 1) * (Metrics.DialogButtonWidth + 8), 1, 0),
		Size = UDim2.fromOffset(Metrics.DialogButtonWidth, 30),
		Parent = parent,
	}, { corner(Metrics.ControlRadius), stroke(danger and Theme.Danger or Theme.Border, danger and 1 or 0.5) })

	local caption = text({
		Name = "Label",
		Text = label,
		TextColor3 = danger and Theme.Text or Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.fromScale(1, 1),
		Parent = button,
	})

	Library:Connect(button.MouseEnter, function()
		tween(button, { BackgroundTransparency = danger and 0.15 or 0 }, Motion.Quick)
		tween(caption, { TextColor3 = Theme.Text }, Motion.Quick)
	end)

	Library:Connect(button.MouseLeave, function()
		tween(button, { BackgroundTransparency = danger and 0 or 0.2 }, Motion.Quick)
		tween(caption, { TextColor3 = danger and Theme.Text or Theme.Muted }, Motion.Quick)
	end)

	return button, caption
end

function Window:BuildDialog()
	if self.Dialog then
		return self.Dialog
	end

	local scrim = new("TextButton", {
		Name = "Scrim",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 30,
		Parent = self.Overlay,
	})

	local card = new("CanvasGroup", {
		Name = "Dialog",
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(Metrics.DialogWidth, Metrics.DialogHeight),
		ZIndex = 31,
		Parent = scrim,
	}, { corner(10), stroke(Theme.Border, 0.35), padding(16) })

	local scale = new("UIScale", { Scale = 1, Parent = card })

	local title = text({
		Name = "Title",
		Text = "",
		FontFace = face(Enum.FontWeight.SemiBold),
		TextSize = 14,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = card,
	})

	local body = text({
		Name = "Body",
		Text = "",
		TextColor3 = Theme.Muted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Position = UDim2.fromOffset(0, 26),
		Size = UDim2.new(1, 0, 0, 48),
		Parent = card,
	})

	local confirm, confirmLabel = dialogButton(card, "Confirm", 1, true)
	local cancel = dialogButton(card, "Cancel", 2, false)

	self.Dialog = {
		Scrim = scrim,
		Card = card,
		Scale = scale,
		Title = title,
		Body = body,
		Confirm = confirm,
		ConfirmLabel = confirmLabel,
		Cancel = cancel,
	}

	Library:Connect(cancel.MouseButton1Click, function()
		self:CloseDialog()
	end)

	Library:Connect(scrim.MouseButton1Click, function()
		self:CloseDialog()
	end)

	Library:Connect(confirm.MouseButton1Click, function()
		local handler = self.DialogHandler
		self:CloseDialog()
		if handler then
			handler(self)
		end
	end)

	return self.Dialog
end

function Window:Confirm(options)
	local dialog = self:BuildDialog()

	dialog.Title.Text = options.Title or "Are you sure?"
	dialog.Body.Text = options.Body or ""
	dialog.ConfirmLabel.Text = options.ConfirmText or "Confirm"
	self.DialogHandler = options.OnConfirm

	self.DialogOpen = true
	dialog.Scrim.Visible = true
	dialog.Scrim.BackgroundTransparency = 1
	dialog.Card.GroupTransparency = 1
	dialog.Scale.Scale = 0.94

	tween(dialog.Scrim, { BackgroundTransparency = 0.45 }, Motion.Quick)
	tween(dialog.Card, { GroupTransparency = 0 }, Motion.Smooth)
	tween(dialog.Scale, { Scale = 1 }, Motion.Pop)
end

function Window:CloseDialog()
	if not self.DialogOpen then
		return
	end
	self.DialogOpen = false
	self.DialogHandler = nil

	local dialog = self.Dialog
	tween(dialog.Scrim, { BackgroundTransparency = 1 }, Motion.Quick)
	tween(dialog.Scale, { Scale = 0.94 }, Motion.Quick)

	local fade = tween(dialog.Card, { GroupTransparency = 1 }, Motion.Quick)
	fade.Completed:Once(function()
		if not self.DialogOpen then
			dialog.Scrim.Visible = false
		end
	end)
end

function Window:ApplySearch(query)
	query = string.lower(string.gsub(query or "", "^%s*(.-)%s*$", "%1"))
	self.SearchQuery = query

	local sectionHits, tabHits = {}, {}

	for _, entry in self.Searchable do
		local shown = query == "" or string.find(entry.Text, query, 1, true) ~= nil
		entry.Row.Visible = shown
		if shown then
			sectionHits[entry.Section] = true
			tabHits[entry.Tab] = true
		end
	end

	for _, entry in self.Searchable do
		entry.Section.Holder.Visible = sectionHits[entry.Section] == true
	end

	for _, tab in self.Tabs do
		tab.Row.Visible = query == "" or tabHits[tab] == true
	end

	if query == "" then
		return
	end

	if self.ActiveTab and tabHits[self.ActiveTab] then
		return
	end

	for _, tab in self.Tabs do
		if tabHits[tab] then
			tab:Select()
			return
		end
	end
end

function Window:BuildLauncher()
	local size = Metrics.LauncherSize
	local caption = Metrics.LauncherCaption

	local holder = new("Frame", {
		Name = "Launcher",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(size, size),
		Size = UDim2.fromOffset(size, size + caption),
		ZIndex = 50,
		Parent = self.Gui,
	})

	local button = new("ImageButton", {
		Name = "Button",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Image = "",
		ScaleType = Enum.ScaleType.Crop,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.fromOffset(size, size),
		ClipsDescendants = true,
		Parent = holder,
	}, { corner(Metrics.LauncherRadius) })

	local ring = new("UIStroke", {
		Color = Theme.Accent,
		Transparency = 0.35,
		Thickness = 2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = button,
	})

	local gradient = new("UIGradient", {
		Color = ColorSequence.new(Theme.AccentLift, Theme.Accent),
		Rotation = 115,
		Parent = button,
	})

	local glyph = icon({
		Parent = button,
		Color = Theme.Text,
		Size = 22,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, "layout-grid")

	local label = text({
		Name = "Caption",
		Text = Metrics.LauncherHint,
		TextColor3 = Theme.Muted,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 20, 0, caption),
		Parent = holder,
	})

	Library:OnAccent(function()
		button.BackgroundColor3 = Theme.Accent
		ring.Color = Theme.Accent
		gradient.Color = ColorSequence.new(Theme.AccentLift, Theme.Accent)
		if self.LauncherLocked then
			label.TextColor3 = Theme.Accent
		end
	end)

	self:RequestLogo(function(asset)
		button.Image = asset
		glyph.Visible = false
	end)

	local viewport = self.Gui.AbsoluteSize
	local targetX = math.max(size, viewport.X * Metrics.LauncherSpawn)
	local targetY = viewport.Y / 2
	local currentX, currentY = targetX, targetY
	local dragging, origin, grabX, grabY, travel, lastTap = false, nil, 0, 0, 0, 0

	local function clamp(x, y)
		local bounds = self.Gui.AbsoluteSize
		local halfX = size / 2
		return math.clamp(x, halfX, math.max(halfX, bounds.X - halfX)),
			math.clamp(y, size / 2, math.max(size / 2, bounds.Y - size / 2 - caption))
	end

	targetX, targetY = clamp(targetX, targetY)
	currentX, currentY = targetX, targetY
	holder.Position = UDim2.fromOffset(math.round(currentX), math.round(currentY))

	local function setLocked(state)
		self.LauncherLocked = state
		label.Text = state and "Locked" or Metrics.LauncherHint
		tween(label, { TextColor3 = state and Theme.Accent or Theme.Muted }, Motion.Quick)
		tween(ring, { Transparency = state and 0 or 0.35 }, Motion.Quick)
	end

	setLocked(false)

	Library:Connect(button.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		dragging = true
		travel = 0
		origin = input.Position
		grabX, grabY = targetX, targetY
		tween(button, { Size = UDim2.fromOffset(size - 4, size - 4) }, Motion.Quick)
	end)

	Library:Connect(UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local dx = input.Position.X - origin.X
		local dy = input.Position.Y - origin.Y
		travel = math.max(travel, dx * dx + dy * dy)

		if not self.LauncherLocked then
			targetX, targetY = clamp(grabX + dx, grabY + dy)
		end
	end)

	Library:Connect(UserInputService.InputEnded, function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		dragging = false
		tween(button, { Size = UDim2.fromOffset(size, size) }, Motion.Pop)

		if travel > Metrics.TapTravel * Metrics.TapTravel then
			return
		end

		local now = os.clock()
		if now - lastTap <= Metrics.DoubleTap then
			lastTap = 0
			self:Toggle()
			setLocked(not self.LauncherLocked)
			return
		end

		lastTap = now
		self:Toggle()
	end)

	Library:Connect(RunService.RenderStepped, function(dt)
		local dx, dy = targetX - currentX, targetY - currentY
		if not dragging and dx * dx + dy * dy < 0.02 then
			return
		end

		local alpha = 1 - math.exp(-dt * Metrics.DragResponse)
		currentX += dx * alpha
		currentY += dy * alpha
		holder.Position = UDim2.fromOffset(math.round(currentX), math.round(currentY))
	end)

	Library:Connect(self.Gui:GetPropertyChangedSignal("AbsoluteSize"), function()
		targetX, targetY = clamp(targetX, targetY)
	end)

	self.Launcher = holder
	self.LauncherButton = button
	self.LauncherCaption = label
	return holder
end

function Window:SetRailAction(key, callback)
	self.Actions[key] = callback
end

function Window:SetMinimized(state)
	if self.Minimized == state then
		return
	end
	self.Minimized = state

	self.RailBody.Visible = not state
	self.Body.Visible = not state

	local height = state and Metrics.HeaderHeight or self.Height
	tween(self.Root, { Size = UDim2.fromOffset(self.Width, height) }, Motion.Smooth)
end

function Window:SetOpen(state)
	if self.Open == state then
		return
	end
	self.Open = state

	if state then
		self.Root.Visible = true
		tween(self.Root, { GroupTransparency = 0 }, Motion.Smooth)
		tween(self.RootStroke, { Transparency = Metrics.BorderTransparency }, Motion.Smooth)
		self:ApplyScale()
		return
	end

	self:ApplyScale()
	tween(self.RootStroke, { Transparency = 1 }, Motion.Smooth)
	local fade = tween(self.Root, { GroupTransparency = 1 }, Motion.Smooth)
	fade.Completed:Once(function()
		if not self.Open then
			self.Root.Visible = false
		end
	end)
end

function Window:TargetScale()
	return self.UserScale * self.FitScale * (self.Open and 1 or Metrics.ClosedScale)
end

function Window:ApplyScale(instant)
	if instant then
		self.Scale.Scale = self:TargetScale()
		return
	end
	tween(self.Scale, { Scale = self:TargetScale() }, Motion.Smooth)
end

function Window:RefreshFit()
	local viewport = self.Gui.AbsoluteSize
	if viewport.X <= 0 or viewport.Y <= 0 then
		return
	end

	self.FitScale = math.min(
		1,
		(viewport.X - Metrics.FitMargin * 2) / self.Width,
		(viewport.Y - Metrics.FitMargin * 2) / self.Height
	)

	self:ApplyScale()
end

function Window:SetScale(value)
	self.UserScale = math.clamp(tonumber(value) or 1, 0.5, 2)
	self:ApplyScale()
end

function Window:Toggle()
	self:SetOpen(not self.Open)
end

function Window:IsVisible()
	return self.Open == true
end

function Window:Destroy()
	Library:Unload()
end

local function registerSearchable(section, row, label)
	local tab = section.Tab
	local window = tab and tab.Window
	if not window then
		return
	end

	table.insert(window.Searchable, {
		Tab = tab,
		Section = section,
		Row = row,
		Text = string.lower(label or ""),
	})
end

local FadedTransparency = 0.62

local function fadeParts(row)
	local parts = {}
	for _, obj in ipairs(row:GetDescendants()) do
		if obj:IsA("UIStroke") then
			table.insert(parts, { Object = obj, Property = "Transparency" })
		elseif obj:IsA("GuiObject") then
			if obj.BackgroundTransparency < 1 then
				table.insert(parts, { Object = obj, Property = "BackgroundTransparency" })
			end
			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
				table.insert(parts, { Object = obj, Property = "TextTransparency" })
			elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				table.insert(parts, { Object = obj, Property = "ImageTransparency" })
			end
		end
	end
	return parts
end

local function attachFade(entry)
	local row = entry.Row
	if not row then
		return
	end

	entry.Faded = false

	function entry:SetFaded(state)
		state = state == true
		if self.Faded == state then
			return
		end
		self.Faded = state
		row.Interactable = not state

		if state then
			self.FadeParts = fadeParts(row)
			for _, part in ipairs(self.FadeParts) do
				part.Base = part.Object[part.Property]
				tween(part.Object, { [part.Property] = part.Base + (1 - part.Base) * FadedTransparency }, Motion.Quick)
			end
			return
		end

		for _, part in ipairs(self.FadeParts or {}) do
			if part.Object.Parent then
				tween(part.Object, { [part.Property] = part.Base }, Motion.Quick)
			end
		end
		self.FadeParts = nil
	end
end

local Section = {}
Section.__index = Section

local buildKeybind

local Tab = {}
Tab.__index = Tab

function Window:AddNavGroup()
	local inset = Metrics.ContentPadding - self.RailInset

	new("Frame", {
		Name = "NavGroupDivider",
		BackgroundColor3 = Theme.Divider,
		BorderSizePixel = 0,
		Position = UDim2.new(0, inset, 0, self.NavOffset + math.floor(Metrics.NavGroupGap / 2)),
		Size = UDim2.new(1, -inset * 2, 0, 1),
		Parent = self.Nav,
	})

	self.NavOffset += Metrics.NavGroupGap
end

function Window:RevealNavRow(tab)
	local top = tab.NavOffset
	local bottom = top + Metrics.NavRowHeight
	local view = self.Nav.CanvasPosition.Y

	if top < view then
		self.Nav.CanvasPosition = Vector2.new(0, top)
	elseif bottom > view + self.NavHeight then
		self.Nav.CanvasPosition = Vector2.new(0, bottom - self.NavHeight)
	end
end

-- the mark lives outside the scroller so it can sit flush against the rail edge,
-- which means it has to be re-placed by hand whenever the nav scrolls
function Window:PlaceNavIndicator(animate)
	local offset = self.NavMark
	if not offset then
		return
	end

	local y = offset - self.Nav.CanvasPosition.Y
	local inside = y >= 0 and y + Metrics.NavMarkHeight <= self.NavHeight

	self.NavIndicator.Visible = inside
	if not inside then
		return
	end

	if self.NavSlide then
		self.NavSlide:Cancel()
		self.NavSlide = nil
	end

	local position = UDim2.fromOffset(0, self.NavTop + y)
	if animate then
		self.NavSlide = tween(self.NavIndicator, { Position = position }, Motion.Smooth)
	else
		self.NavIndicator.Position = position
	end
end

local function buildPage(window, name)
	local page = new("CanvasGroup", {
		Name = name,
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Visible = false,
		Size = UDim2.fromScale(1, 1),
		Parent = window.Pages,
	})

	local scroller = new("ScrollingFrame", {
		Name = "Scroller",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Theme.Track,
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		Parent = page,
	}, {
		padding(0, Metrics.ContentPadding + Metrics.ScrollGutter, Metrics.ContentPadding, Metrics.ContentPadding),
	})

	local columnWidth = (window.Width - Metrics.RailWidth
		- Metrics.ContentPadding * 2 - Metrics.ScrollGutter - Metrics.ColumnGap) / 2

	local function column(order, xOffset, parent)
		return new("Frame", {
			Name = "Column" .. order,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(xOffset, 0),
			Size = UDim2.fromOffset(columnWidth, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = parent,
		}, {
			new("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, Metrics.SectionGap),
			}),
		})
	end

	return page, scroller, columnWidth, column
end

function Window:AddSystemTab(name)
	local page, scroller, columnWidth, column = buildPage(self, name)

	local tab = setmetatable({
		Window = self,
		Name = name,
		System = true,
		Page = page,
		Scroller = scroller,
		ColumnWidth = columnWidth,
		BuildColumn = column,
		Left = column(1, 0, scroller),
		Right = column(2, columnWidth + Metrics.ColumnGap, scroller),
		Sections = {},
		Subpages = {},
	}, Tab)

	table.insert(self.SystemTabs, tab)
	return tab
end

function Tab:AddSubpage(name)
	local holder = new("Frame", {
		Name = name,
		BackgroundTransparency = 1,
		Visible = next(self.Subpages) == nil,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.Scroller,
	})

	local subpage = {
		Holder = holder,
		Left = self.BuildColumn(1, 0, holder),
		Right = self.BuildColumn(2, self.ColumnWidth + Metrics.ColumnGap, holder),
	}

	self.Subpages[name] = subpage

	if next(self.Subpages) == name then
		self.Left = subpage.Left
		self.Right = subpage.Right
	end

	return subpage
end

function Tab:UseSubpage(name)
	local subpage = self.Subpages[name]
	if not subpage then
		return
	end
	self.Left = subpage.Left
	self.Right = subpage.Right
end

function Tab:ShowSubpage(name)
	for other, subpage in self.Subpages do
		subpage.Holder.Visible = other == name
	end

	local active = self.Subpages[name]
	if active then
		self.Left = active.Left
		self.Right = active.Right
		self.Subpage = name
		if self.Window.ActiveTab == self then
			self.Window:SetBreadcrumb(self.Name, name)
		end
	end
end

function Window:AddSubtabStrip(tab, names)
	local strip = new("Frame", {
		Name = "Subtabs",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.ControlWidth, Metrics.ControlHeight - 2),
		Visible = false,
		ZIndex = 3,
		Parent = tab.Page.Parent.Parent,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5) })

	strip.Position = UDim2.new(1, -Metrics.ContentPadding, 0, 2)
	strip.AnchorPoint = Vector2.new(1, 0)

	local slot = Metrics.ControlWidth / #names

	local marker = new("Frame", {
		Name = "Marker",
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(slot - 6, Metrics.ControlHeight - 8),
		Parent = strip,
	}, { corner(Metrics.ControlRadius - 2) })

	Library:OnAccent(function()
		marker.BackgroundColor3 = Theme.Accent
	end)

	local labels = {}

	local function select(name)
		local order = table.find(names, name) or 1
		tween(marker, { Position = UDim2.fromOffset((order - 1) * slot + 3, 3) }, Motion.Smooth)
		for other, label in labels do
			tween(label, { TextColor3 = other == name and Theme.Text or Theme.Muted }, Motion.Quick)
		end
		tab:ShowSubpage(name)
	end

	for order, name in names do
		local button = new("TextButton", {
			Name = name,
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset((order - 1) * slot, 0),
			Size = UDim2.fromOffset(slot, Metrics.ControlHeight - 2),
			Parent = strip,
		})

		labels[name] = text({
			Name = "Label",
			Text = name,
			TextColor3 = Theme.Muted,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromScale(1, 1),
			Parent = button,
		})

		Library:Connect(button.MouseButton1Click, function()
			select(name)
		end)
	end

	tab.SubtabStrip = strip
	-- the tab may already be selected: Tab:Select ran before this strip existed,
	-- so it never got the chance to reveal it
	strip.Visible = self.ActiveTab == tab
	select(names[1])
	return select
end

function Window:AddTab(name, iconName)
	local offset = self.NavOffset
	self.NavOffset += Metrics.NavRowHeight + Metrics.NavRowGap

	local row = new("TextButton", {
		Name = name,
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Hover,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, offset),
		Size = UDim2.new(1, 0, 0, Metrics.NavRowHeight),
		Parent = self.Nav,
	}, { corner(Metrics.ControlRadius) })

	local glyph, _, tintKey = icon({
		Parent = row,
		Color = Theme.Dim,
		Size = Metrics.IconSize,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
	}, iconName or "circle")

	local label = text({
		Name = "Label",
		Text = name,
		TextColor3 = Theme.Dim,
		Position = UDim2.new(0, 36, 0, 0),
		Size = UDim2.new(1, -44, 1, 0),
		Parent = row,
	})

	local page, scroller, columnWidth, column = buildPage(self, name)

	local tab = setmetatable({
		Window = self,
		Name = name,
		Row = row,
		Label = label,
		Glyph = glyph,
		TintKey = tintKey,
		Page = page,
		Scroller = scroller,
		NavOffset = offset,
		ColumnWidth = columnWidth,
		BuildColumn = column,
		Left = column(1, 0, scroller),
		Right = column(2, columnWidth + Metrics.ColumnGap, scroller),
		Sections = {},
		Subpages = {},
	}, Tab)

	Library:Connect(row.MouseEnter, function()
		if self.ActiveTab ~= tab then
			tween(row, { BackgroundTransparency = 0.5 }, Motion.Quick)
			tween(label, { TextColor3 = Theme.Muted }, Motion.Quick)
			tween(glyph, { [tintKey] = Theme.Muted }, Motion.Quick)
		end
	end)

	Library:Connect(row.MouseLeave, function()
		if self.ActiveTab ~= tab then
			tween(row, { BackgroundTransparency = 1 }, Motion.Quick)
			tween(label, { TextColor3 = Theme.Dim }, Motion.Quick)
			tween(glyph, { [tintKey] = Theme.Dim }, Motion.Quick)
		end
	end)

	Library:Connect(row.MouseButton1Click, function()
		tab:Select()
	end)

	table.insert(self.Tabs, tab)

	if not self.ActiveTab then
		tab:Select()
	end

	return tab
end

function Tab:Select()
	local window = self.Window
	if window.ActiveTab == self then
		return
	end

	local previous = window.ActiveTab
	window.ActiveTab = self

	if previous then
		if previous.Row then
			tween(previous.Row, { BackgroundTransparency = 1 }, Motion.Quick)
			tween(previous.Label, { TextColor3 = Theme.Dim }, Motion.Quick)
			tween(previous.Glyph, { [previous.TintKey] = Theme.Dim }, Motion.Quick)
		end
		if previous.SubtabStrip then
			previous.SubtabStrip.Visible = false
		end

		local exit = tween(previous.Page, { GroupTransparency = 1 }, Motion.Quick)
		exit.Completed:Once(function()
			if window.ActiveTab ~= previous then
				previous.Page.Visible = false
			end
		end)
	end

	if self.Row then
		tween(self.Row, { BackgroundTransparency = 0 }, Motion.Quick)
		tween(self.Label, { TextColor3 = Theme.Text }, Motion.Quick)
		tween(self.Glyph, { [self.TintKey] = Theme.Text }, Motion.Quick)

		window.NavMark = self.NavOffset
			+ math.floor((Metrics.NavRowHeight - Metrics.NavMarkHeight) / 2)
		window:RevealNavRow(self)

		if previous and previous.Row then
			window:PlaceNavIndicator(true)
		else
			window:PlaceNavIndicator()
			tween(window.NavIndicator, { BackgroundTransparency = 0 }, Motion.Smooth)
		end
	else
		tween(window.NavIndicator, { BackgroundTransparency = 1 }, Motion.Quick)
	end

	if self.SubtabStrip then
		self.SubtabStrip.Visible = true
	end

	self.Page.Visible = true
	self.Page.GroupTransparency = 1
	self.Page.Position = UDim2.fromOffset(0, 8)
	tween(self.Page, { GroupTransparency = 0, Position = UDim2.new() }, Motion.Smooth)

	window:CloseMenu()
	window:ClosePanel()
	window:ClosePicker()
	window:SetBreadcrumb(self.Name, self.Subpage)

	if self.OnSelect then
		self.OnSelect(self)
	end
end

function Tab:SetSubpage(name)
	self.Subpage = name
	if self.Window.ActiveTab == self then
		self.Window:SetBreadcrumb(self.Name, name)
	end
end

function Tab:AddSection(side, title)
	local column = side == "Right" and self.Right or self.Left

	for _, existing in self.Sections do
		if existing.Title == title and existing.Column == column then
			return existing
		end
	end

	local holder = new("Frame", {
		Name = title,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = #self.Sections + 1,
		Parent = column,
	})

	text({
		Name = "Caption",
		Text = title,
		TextColor3 = Theme.Muted,
		Size = UDim2.new(1, 0, 0, Metrics.SectionLabelHeight),
		Parent = holder,
	})

	local card = new("Frame", {
		Name = "Card",
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, Metrics.SectionLabelHeight),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = holder,
	}, {
		corner(Metrics.CardRadius),
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})

	local section = setmetatable({
		Tab = self,
		Title = title,
		Column = column,
		Holder = holder,
		Card = card,
		Rows = {},
		ContentHeight = 0,
	}, Section)

	table.insert(self.Sections, section)
	return section
end

function Tab:AddLeftSection(title)
	return self:AddSection("Left", title)
end

function Tab:AddRightSection(title)
	return self:AddSection("Right", title)
end

function Section:AddRow(height)
	local index = #self.Rows + 1
	local auto = height == "Auto"

	local row = new("Frame", {
		Name = "Row" .. index,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, auto and 0 or (height or Metrics.RowHeight)),
		AutomaticSize = auto and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
		LayoutOrder = index,
		Parent = self.Card,
	}, { padding(auto and 12 or 0, 12) })

	if index > 1 then
		new("Frame", {
			Name = "Hairline",
			BackgroundColor3 = Theme.Divider,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Parent = row,
		})
	end

	if not auto then
		self.ContentHeight += height or Metrics.RowHeight
	end

	table.insert(self.Rows, row)
	return row
end

function Section:AddToggle(index, options)
	options = options or {}

	local tab = self.Tab
	local window = tab.Window
	local row = self:AddRow()
	local value = options.Default == true

	local hit = new("TextButton", {
		Name = "Hit",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Hover,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(-6, 0),
		Size = UDim2.new(1, 12, 1, 0),
		Parent = row,
	}, { corner(Metrics.ControlRadius) })

	local box = new("Frame", {
		Name = "Box",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.CheckSize, Metrics.CheckSize),
		Parent = row,
	}, { corner(Metrics.CheckRadius) })

	local boxStroke = new("UIStroke", {
		Color = Theme.Border,
		Transparency = 0.3,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = box,
	})

	local boxScale = new("UIScale", { Scale = 1, Parent = box })

	local check, checkFade = icon({
		Parent = box,
		Color = Theme.Text,
		Size = 12,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, "check")
	check[checkFade] = 1

	registerSearchable(self, row, options.Text or index)

	local labelInset = Metrics.CheckSize + 12
	local label = text({
		Name = "Label",
		Text = options.Text or index,
		TextColor3 = Theme.Muted,
		Position = UDim2.new(0, labelInset, 0, 0),
		Size = UDim2.new(1, -(labelInset + 22), 1, 0),
		Parent = row,
	})

	local entry = {
		Type = "Toggle",
		Index = index,
		Value = value,
		Row = row,
		Label = label,
		Box = box,
		Section = self,
		Window = window,
		Callbacks = {},
	}

	function entry:SetValue(state, silent)
		state = state == true
		self.Value = state

		tween(box, { BackgroundColor3 = state and Theme.Accent or Theme.Control }, Motion.Quick)
		tween(boxStroke, { Transparency = state and 1 or 0.3 }, Motion.Quick)
		tween(check, { [checkFade] = state and 0 or 1 }, Motion.Quick)
		tween(label, { TextColor3 = state and Theme.Text or Theme.Muted }, Motion.Quick)

		boxScale.Scale = 0.86
		tween(boxScale, { Scale = 1 }, Motion.Pop)

		if silent then
			return
		end

		if options.Callback then
			options.Callback(state)
		end
		for _, callback in self.Callbacks do
			callback(state)
		end
	end

	function entry:OnChanged(callback)
		table.insert(self.Callbacks, callback)
		return self
	end

	Library:Connect(hit.MouseEnter, function()
		tween(hit, { BackgroundTransparency = 0.6 }, Motion.Quick)
	end)

	Library:Connect(hit.MouseLeave, function()
		tween(hit, { BackgroundTransparency = 1 }, Motion.Quick)
	end)

	Library:Connect(hit.MouseButton1Click, function()
		entry:SetValue(not entry.Value)
	end)

	entry:SetValue(value, true)
	Library:OnAccent(function()
		if entry.Value then
			box.BackgroundColor3 = Theme.Accent
		end
	end)
	attachFade(entry)
	Library.Toggles[index] = entry

	local bind = options.Keybind or {}

	local chevronButton = new("TextButton", {
		Name = "Expand",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 2, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		ZIndex = 3,
		Parent = row,
	})

	local chevron, _, chevronTint = icon({
		Parent = chevronButton,
		Color = Theme.Dim,
		Size = 14,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, "chevron-right")

	local holder = new("CanvasGroup", {
		Name = "SubPanel",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Visible = false,
		Size = UDim2.fromOffset(Metrics.SubPanelWidth, 0),
		ZIndex = 2,
		Parent = window.Overlay,
	}, { corner(Metrics.CardRadius) })

	local holderStroke = new("UIStroke", {
		Color = Theme.Border,
		Transparency = 1,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = holder,
	})

	local card = new("ScrollingFrame", {
		Name = "Rows",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(Metrics.SubPanelPadding, Metrics.SubPanelPadding),
		Size = UDim2.new(1, -Metrics.SubPanelPadding * 2, 1, -Metrics.SubPanelPadding * 2),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Track,
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		Parent = holder,
	}, {
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})

	local panelSection = setmetatable({
		Tab = self.Tab,
		Title = index,
		Holder = holder,
		Card = card,
		Rows = {},
		ContentHeight = 0,
	}, Section)

	entry.Panel = {
		Row = row,
		Holder = holder,
		Stroke = holderStroke,
		Chevron = chevron,
		Section = panelSection,
		SlideFrom = -Metrics.SubPanelGap,
	}
	entry.Section = panelSection

	local keybind
	keybind = panelSection:AddKeybind(bind.Index or (index .. "Key"), {
		Text = "Keybind",
		Default = bind.Default,
		Mode = bind.Mode,
		OnFire = function(state)
			if keybind.Mode == "Hold" then
				entry:SetValue(state)
			else
				entry:SetValue(not entry.Value)
			end
		end,
	})

	local mode = panelSection:AddSegmented(bind.ModeIndex or (index .. "Mode"), {
		Text = "Mode",
		Values = { "Toggle", "Hold" },
		Default = keybind.Mode,
		Callback = function(value)
			keybind.Mode = value
			keybind.Active = false
		end,
	})

	entry.Keybind = keybind
	entry.ModePicker = mode

	Library:Connect(chevronButton.MouseEnter, function()
		tween(chevron, { [chevronTint] = Theme.Text }, Motion.Quick)
	end)

	Library:Connect(chevronButton.MouseLeave, function()
		tween(chevron, { [chevronTint] = Theme.Dim }, Motion.Quick)
	end)

	Library:Connect(chevronButton.MouseButton1Click, function()
		window:OpenPanelFor(entry.Panel)
	end)

	return entry
end

function Section:AddLabel(content)
	local row = self:AddRow("Auto")
	registerSearchable(self, row, content)

	local label = text({
		Name = "Label",
		Text = content,
		TextColor3 = Theme.Muted,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = row,
	})

	return {
		Instance = row,
		SetText = function(_, value)
			label.Text = value
		end,
	}
end

local function controlRow(section, label)
	local row = section:AddRow()
	registerSearchable(section, row, label)

	local caption = text({
		Name = "Label",
		Text = label,
		TextColor3 = Theme.Muted,
		Size = UDim2.new(1, -(Metrics.ControlWidth + 10), 1, 0),
		Parent = row,
	})

	return row, caption
end

local function roundTo(value, places)
	local factor = 10 ^ (places or 0)
	return math.floor(value * factor + 0.5) / factor
end

function Section:AddSlider(index, options)
	options = options or {}

	local min = options.Min or 0
	local max = options.Max or 100
	local rounding = options.Rounding or 0
	local suffix = options.Suffix or ""

	local row, caption = controlRow(self, options.Text or index)

	local readout = new("TextBox", {
		Name = "Value",
		Text = "",
		TextColor3 = Theme.Text,
		FontFace = face(Enum.FontWeight.SemiBold),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundColor3 = Theme.Control,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.SliderValueWidth, Metrics.SliderValueHeight),
		Parent = row,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5) })

	local trackWidth = Metrics.ControlWidth - Metrics.SliderValueWidth - 8

	local track = new("Frame", {
		Name = "Track",
		BackgroundColor3 = Theme.Track,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -(Metrics.SliderValueWidth + 8), 0.5, 0),
		Size = UDim2.fromOffset(trackWidth, Metrics.TrackHeight),
		Parent = row,
	}, { corner(Metrics.TrackHeight / 2) })

	local fill = new("Frame", {
		Name = "Fill",
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(0, Metrics.TrackHeight),
		Parent = track,
	}, { corner(Metrics.TrackHeight / 2) })

	local knob = new("Frame", {
		Name = "Knob",
		BackgroundColor3 = Theme.Window,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, Metrics.KnobMargin + Metrics.KnobSize / 2, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.KnobSize, Metrics.KnobSize),
		Parent = fill,
	}, { corner(Metrics.KnobSize / 2) })

	local hit = new("TextButton", {
		Name = "Hit",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -(Metrics.SliderValueWidth + 8), 0.5, 0),
		Size = UDim2.fromOffset(trackWidth, Metrics.RowHeight),
		Parent = row,
	})

	local dragging = false

	local entry = {
		Type = "Slider",
		Index = index,
		Value = math.clamp(options.Default or min, min, max),
		Min = min,
		Max = max,
		Row = row,
		Label = caption,
		Track = track,
		Fill = fill,
		Knob = knob,
		Readout = readout,
		Callbacks = {},
	}

	local minFill = Metrics.KnobSize + Metrics.KnobMargin * 2

	local function fillWidth(alpha)
		return math.max(minFill, alpha * trackWidth)
	end

	local function knobPosition(alpha)
		return UDim2.new(0, fillWidth(alpha) - Metrics.KnobMargin - Metrics.KnobSize / 2, 0.5, 0)
	end

	function entry:SetValue(value, silent)
		value = math.clamp(roundTo(tonumber(value) or self.Value, rounding), min, max)
		self.Value = value

		local alpha = max > min and (value - min) / (max - min) or 0
		readout.Text = tostring(value) .. suffix

		local width = fillWidth(alpha)
		if dragging then
			fill.Size = UDim2.fromOffset(width, Metrics.TrackHeight)
			knob.Position = knobPosition(alpha)
		else
			tween(fill, { Size = UDim2.fromOffset(width, Metrics.TrackHeight) }, Motion.Smooth)
			tween(knob, { Position = knobPosition(alpha) }, Motion.Smooth)
		end

		if silent then
			return
		end

		if options.Callback then
			options.Callback(value)
		end
		for _, callback in self.Callbacks do
			callback(value)
		end
	end

	function entry:OnChanged(callback)
		table.insert(self.Callbacks, callback)
		return self
	end

	local function valueFromX(x)
		local width = track.AbsoluteSize.X
		if width <= 0 then
			return entry.Value
		end
		local alpha = math.clamp((x - track.AbsolutePosition.X) / width, 0, 1)
		return min + (max - min) * alpha
	end

	local function setGrabbed(state)
		tween(track, { BackgroundColor3 = state and Theme.Border or Theme.Track }, Motion.Quick)
	end

	Library:Connect(hit.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		dragging = true
		setGrabbed(true)
		entry:SetValue(valueFromX(input.Position.X))
	end)

	Library:Connect(UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		entry:SetValue(valueFromX(input.Position.X))
	end)

	Library:Connect(UserInputService.InputEnded, function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			setGrabbed(false)
		end
	end)

	Library:Connect(readout.Focused, function()
		readout.Text = tostring(entry.Value)
		tween(readout, { BackgroundTransparency = 0 }, Motion.Quick)
	end)

	Library:Connect(readout.FocusLost, function()
		tween(readout, { BackgroundTransparency = 0.2 }, Motion.Quick)
		local typed = tonumber(string.match(readout.Text, "-?%d+%.?%d*"))
		entry:SetValue(typed or entry.Value)
	end)

	entry:SetValue(entry.Value, true)
	Library:OnAccent(function()
		fill.BackgroundColor3 = Theme.Accent
	end)
	attachFade(entry)
	Library.Options[index] = entry

	return entry
end

local function controlShell(row, height)
	return new("TextButton", {
		Name = "Control",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Control,
		BackgroundTransparency = 0.2,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.ControlWidth, height or Metrics.ControlHeight),
		Parent = row,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5), padding(0, 8) })
end

function Window:ClosePanel()
	local panel = self.OpenPanel
	if not panel then
		return
	end

	self.OpenPanel = nil
	self.PanelScrim.Visible = false

	local resting = panel.Holder.Position
	tween(panel.Chevron, { Rotation = 0 }, Motion.Smooth)
	tween(panel.Stroke, { Transparency = 1 }, Motion.Quick)

	local fade = tween(panel.Holder, {
		GroupTransparency = 1,
		Position = UDim2.fromOffset(resting.X.Offset + panel.SlideFrom, resting.Y.Offset),
	}, Motion.Quick)

	fade.Completed:Once(function()
		if self.OpenPanel ~= panel then
			panel.Holder.Visible = false
		end
	end)
end

function Window:OpenPanelFor(panel)
	if self.OpenPanel == panel then
		self:ClosePanel()
		return
	end

	self:CloseMenu()
	self:ClosePanel()

	local root = self.Root
	local row = panel.Row
	local rowX = row.AbsolutePosition.X - root.AbsolutePosition.X
	local rowY = row.AbsolutePosition.Y - root.AbsolutePosition.Y
	local ceiling = self.Height - Metrics.HeaderHeight - Metrics.ContentPadding * 2
	local height = math.min(panel.Section.ContentHeight + Metrics.SubPanelPadding * 2, ceiling)

	local right = rowX + row.AbsoluteSize.X + Metrics.SubPanelGap
	local placeLeft = right + Metrics.SubPanelWidth > self.Width - Metrics.ContentPadding
	local x = placeLeft and (rowX - Metrics.SubPanelWidth - Metrics.SubPanelGap) or right
	local y = math.clamp(rowY, Metrics.HeaderHeight, math.max(Metrics.HeaderHeight,
		self.Height - Metrics.ContentPadding - height))

	panel.SlideFrom = placeLeft and Metrics.SubPanelGap or -Metrics.SubPanelGap

	panel.Section.Card.CanvasPosition = Vector2.zero
	panel.Holder.Size = UDim2.fromOffset(Metrics.SubPanelWidth, height)
	panel.Holder.Position = UDim2.fromOffset(x + panel.SlideFrom, y)
	panel.Holder.GroupTransparency = 1
	panel.Holder.Visible = true
	panel.Stroke.Transparency = 1

	self.OpenPanel = panel
	self.PanelScrim.Visible = true

	tween(panel.Chevron, { Rotation = 180 }, Motion.Smooth)
	tween(panel.Stroke, { Transparency = 0.35 }, Motion.Smooth)
	tween(panel.Holder, {
		GroupTransparency = 0,
		Position = UDim2.fromOffset(x, y),
	}, Motion.Smooth)
end

function Window:CloseMenu()
	local menu = self.OpenMenu
	if not menu then
		return
	end

	self.OpenMenu = nil
	self.MenuScrim.Visible = false

	tween(menu.Arrow, { Rotation = 0 }, Motion.Smooth)
	tween(menu.Stroke, { Transparency = 1 }, Motion.Quick)

	local collapse = tween(menu.Holder, { GroupTransparency = 1 }, Motion.Quick)
	collapse.Completed:Once(function()
		if self.OpenMenu ~= menu then
			menu.Holder.Visible = false
		end
	end)
end

function Window:OpenMenuFor(menu)
	if self.OpenMenu == menu then
		self:CloseMenu()
		return
	end

	self:CloseMenu()

	local control = menu.Control
	local root = self.Root
	local x = control.AbsolutePosition.X - root.AbsolutePosition.X
	local top = control.AbsolutePosition.Y - root.AbsolutePosition.Y
	local below = top + control.AbsoluteSize.Y + Metrics.MenuGap
	local height = menu.Height

	local y = below
	if below + height > self.Height - Metrics.ContentPadding then
		y = math.max(Metrics.HeaderHeight, top - height - Metrics.MenuGap)
	end

	menu.List.CanvasPosition = Vector2.zero
	menu.Holder.Size = UDim2.fromOffset(Metrics.ControlWidth, height)
	menu.Holder.Position = UDim2.fromOffset(x, y)
	menu.Holder.GroupTransparency = 1
	menu.Holder.Visible = true
	menu.Stroke.Transparency = 1

	self.OpenMenu = menu
	self.MenuScrim.Visible = true

	tween(menu.Arrow, { Rotation = 180 }, Motion.Smooth)
	tween(menu.Stroke, { Transparency = 0.4 }, Motion.Smooth)
	tween(menu.Holder, { GroupTransparency = 0 }, Motion.Smooth)
end

function Section:AddDropdown(index, options)
	options = options or {}

	local multi = options.Multi == true
	local values = options.Values or {}

	local window = self.Tab.Window
	local row, caption = controlRow(self, options.Text or index)
	local control = controlShell(row)

	local display = text({
		Name = "Display",
		Text = "",
		TextColor3 = Theme.Muted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, -16, 1, 0),
		Parent = control,
	})

	local arrow = icon({
		Parent = control,
		Color = Theme.Dim,
		Size = 13,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
	}, "chevron-down")

	local holder = new("CanvasGroup", {
		Name = "Menu",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Visible = false,
		Size = UDim2.fromOffset(Metrics.ControlWidth, 0),
		ZIndex = 4,
		Parent = window.Overlay,
	}, { corner(Metrics.ControlRadius), padding(Metrics.MenuPadding, 4) })

	local holderStroke = new("UIStroke", {
		Color = Theme.Border,
		Transparency = 1,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = holder,
	})

	local list = new("ScrollingFrame", {
		Name = "Options",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Track,
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		Parent = holder,
	}, {
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Metrics.OptionGap),
		}),
	})

	local menu = {
		Control = control,
		Holder = holder,
		List = list,
		Stroke = holderStroke,
		Arrow = arrow,
		Height = 0,
	}

	local entry = {
		Type = "Dropdown",
		Index = index,
		Multi = multi,
		Values = values,
		Value = multi and {} or (options.Default or values[1]),
		Row = row,
		Label = caption,
		Control = control,
		Display = display,
		Menu = menu,
		Callbacks = {},
	}

	if multi and type(options.Default) == "table" then
		for _, name in options.Default do
			entry.Value[name] = true
		end
	end

	local function describe()
		if not multi then
			return entry.Value or "None"
		end
		local picked = {}
		for _, name in entry.Values do
			if entry.Value[name] then
				table.insert(picked, name)
			end
		end
		return #picked > 0 and table.concat(picked, ", ") or "None"
	end

	local optionRows = {}

	local function paint()
		display.Text = describe()
		for name, option in optionRows do
			local on = multi and entry.Value[name] == true or entry.Value == name
			tween(option.Label, { TextColor3 = on and Theme.Text or Theme.Muted }, Motion.Quick)
			tween(option.Tick, { [option.FadeKey] = on and 0 or 1 }, Motion.Quick)
		end
	end

	function entry:SetValue(value, silent)
		if multi then
			local picked = {}
			if type(value) == "table" then
				for key, flag in value do
					if type(key) == "number" then
						picked[flag] = true
					elseif flag then
						picked[key] = true
					end
				end
			end
			self.Value = picked
		else
			self.Value = value
		end

		paint()

		if silent then
			return
		end

		if options.Callback then
			options.Callback(self.Value)
		end
		for _, callback in self.Callbacks do
			callback(self.Value)
		end
	end

	function entry:OnChanged(callback)
		table.insert(self.Callbacks, callback)
		return self
	end

	function entry:SetValues(list)
		self.Values = list
		for _, option in optionRows do
			option.Button:Destroy()
		end
		table.clear(optionRows)
		self:BuildOptions()
		paint()
	end

	function entry:BuildOptions()
		for order, name in self.Values do
			local button = new("TextButton", {
				Name = name,
				Text = "",
				AutoButtonColor = false,
				BackgroundColor3 = Theme.Hover,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Metrics.OptionHeight),
				LayoutOrder = order,
				Parent = list,
			}, { corner(Metrics.ControlRadius), padding(0, 6) })

			local label = text({
				Name = "Label",
				Text = name,
				TextColor3 = Theme.Muted,
				TextSize = 12,
				Size = UDim2.new(1, -16, 1, 0),
				Parent = button,
			})

			local tick, fadeKey = icon({
				Parent = button,
				Color = Theme.Accent,
				Size = 13,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
			}, "check")
			tick[fadeKey] = 1

			optionRows[name] = { Button = button, Label = label, Tick = tick, FadeKey = fadeKey }

			Library:Connect(button.MouseEnter, function()
				tween(button, { BackgroundTransparency = 0.5 }, Motion.Quick)
			end)

			Library:Connect(button.MouseLeave, function()
				tween(button, { BackgroundTransparency = 1 }, Motion.Quick)
			end)

			Library:Connect(button.MouseButton1Click, function()
				if multi then
					local picked = {}
					for key, flag in self.Value do
						picked[key] = flag
					end
					picked[name] = not picked[name] or nil
					self:SetValue(picked)
				else
					self:SetValue(name)
					window:CloseMenu()
				end
			end)
		end

		local count = #self.Values
		local full = count * Metrics.OptionHeight
			+ math.max(count - 1, 0) * Metrics.OptionGap
			+ Metrics.MenuPadding * 2

		menu.Height = math.min(full, Metrics.MenuMaxHeight)
	end

	entry:BuildOptions()
	entry:SetValue(entry.Value, true)

	Library:Connect(control.MouseEnter, function()
		tween(control, { BackgroundTransparency = 0 }, Motion.Quick)
	end)

	Library:Connect(control.MouseLeave, function()
		tween(control, { BackgroundTransparency = 0.2 }, Motion.Quick)
	end)

	Library:Connect(control.MouseButton1Click, function()
		window:OpenMenuFor(menu)
	end)

	attachFade(entry)
	Library.Options[index] = entry
	return entry
end

local RainbowPickers = {}

local function ensureRainbowDriver()
	if Library.RainbowDriver then
		return
	end

	Library.RainbowDriver = true
	Library.RainbowPhase = 0

	Library:Connect(RunService.RenderStepped, function(dt)
		if not next(RainbowPickers) then
			return
		end

		Library.RainbowPhase = (Library.RainbowPhase + dt / Metrics.RainbowPeriod) % 1
		local color = Color3.fromHSV(Library.RainbowPhase, 1, 1)
		for entry in RainbowPickers do
			entry:SetValue(color)
		end
	end)
end

local function hexOf(color)
	return string.format(
		"%02X%02X%02X",
		math.round(color.R * 255),
		math.round(color.G * 255),
		math.round(color.B * 255)
	)
end

local function colorFromHex(value)
	local digits = string.match(tostring(value), "(%x%x%x%x%x%x)")
	if not digits then
		return nil
	end
	return Color3.fromRGB(
		tonumber(string.sub(digits, 1, 2), 16),
		tonumber(string.sub(digits, 3, 4), 16),
		tonumber(string.sub(digits, 5, 6), 16)
	)
end

local function dragArea(area, apply)
	local dragging = false

	Library:Connect(area.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		dragging = true
		apply(input.Position)
	end)

	Library:Connect(UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		apply(input.Position)
	end)

	Library:Connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function Window:ClosePicker()
	local picker = self.OpenPicker
	if not picker then
		return
	end

	self.OpenPicker = nil
	self.PickerScrim.Visible = false

	tween(picker.Stroke, { Transparency = 1 }, Motion.Quick)
	local fade = tween(picker.Holder, { GroupTransparency = 1 }, Motion.Quick)
	fade.Completed:Once(function()
		if self.OpenPicker ~= picker then
			picker.Holder.Visible = false
		end
	end)
end

function Window:OpenPickerFor(picker)
	if self.OpenPicker == picker then
		self:ClosePicker()
		return
	end

	self:CloseMenu()
	self:ClosePicker()

	local root = self.Root
	local swatch = picker.Swatch
	local x = swatch.AbsolutePosition.X + swatch.AbsoluteSize.X - root.AbsolutePosition.X
		- Metrics.PickerWidth
	local top = swatch.AbsolutePosition.Y - root.AbsolutePosition.Y

	local below = top + swatch.AbsoluteSize.Y + Metrics.MenuGap
	local y = below
	if below + picker.Height > self.Height - Metrics.ContentPadding then
		y = math.max(Metrics.HeaderHeight, top - picker.Height - Metrics.MenuGap)
	end

	picker.Holder.Position = UDim2.fromOffset(math.max(Metrics.ContentPadding, x), y)
	picker.Holder.GroupTransparency = 1
	picker.Holder.Visible = true
	picker.Stroke.Transparency = 1

	self.OpenPicker = picker
	self.PickerScrim.Visible = true

	tween(picker.Stroke, { Transparency = 0.4 }, Motion.Smooth)
	tween(picker.Holder, { GroupTransparency = 0 }, Motion.Smooth)
end

function Section:AddColorpicker(index, options)
	options = options or {}

	local window = self.Tab.Window
	local allowAlpha = options.Alpha == true
	local row, caption = controlRow(self, options.Text or index)

	local swatch = new("TextButton", {
		Name = "Swatch",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = options.Default or Theme.Accent,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.SwatchWidth, Metrics.SwatchHeight),
		Parent = row,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.35) })

	local pickerHeight = Metrics.PickerPadding * 2
		+ 18 + 10
		+ Metrics.SVHeight + 10
		+ (allowAlpha and (Metrics.StripHeight + 10) or 0)
		+ Metrics.ControlHeight + 10
		+ Metrics.ControlHeight

	local holder = new("CanvasGroup", {
		Name = "Picker",
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Visible = false,
		Size = UDim2.fromOffset(Metrics.PickerWidth, pickerHeight),
		ZIndex = 6,
		Parent = window.Overlay,
	}, { corner(Metrics.CardRadius), padding(Metrics.PickerPadding) })

	local holderStroke = new("UIStroke", {
		Color = Theme.Border,
		Transparency = 1,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = holder,
	})

	text({
		Name = "Title",
		Text = options.Text or index,
		FontFace = face(Enum.FontWeight.SemiBold),
		TextSize = 13,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = holder,
	})

	local svTop = 28

	local field = new("Frame", {
		Name = "Field",
		BackgroundColor3 = Color3.fromHSV(0, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, svTop),
		Size = UDim2.fromOffset(Metrics.SVWidth, Metrics.SVHeight),
		Parent = holder,
	}, { corner(6) })

	new("Frame", {
		Name = "Saturation",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = field,
	}, {
		corner(6),
		new("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	new("Frame", {
		Name = "Value",
		BackgroundColor3 = Color3.new(),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = field,
	}, {
		corner(6),
		new("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(1, 0),
			}),
		}),
	})

	local cursor = new("Frame", {
		Name = "Cursor",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		ZIndex = 2,
		Parent = field,
	}, { corner(5), stroke(Color3.new(1, 1, 1), 0, 2) })

	local hue = new("Frame", {
		Name = "Hue",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(Metrics.SVWidth + 8, svTop),
		Size = UDim2.fromOffset(Metrics.StripWidth, Metrics.SVHeight),
		Parent = holder,
	}, {
		corner(Metrics.StripWidth / 2),
		new("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
				ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
				ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
				ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
				ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
			}),
		}),
	})

	local hueKnob = new("Frame", {
		Name = "Knob",
		BackgroundColor3 = Theme.Knob,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.fromOffset(Metrics.StripWidth + 4, 5),
		Parent = hue,
	}, { corner(3) })

	local alpha, alphaKnob, alphaRamp
	local alphaTop = svTop + Metrics.SVHeight + 10

	if allowAlpha then
		alpha = new("Frame", {
			Name = "Alpha",
			BackgroundColor3 = Theme.Track,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, alphaTop),
			Size = UDim2.new(1, 0, 0, Metrics.StripHeight),
			Parent = holder,
		}, { corner(Metrics.StripHeight / 2) })

		alphaRamp = new("Frame", {
			Name = "Ramp",
			BackgroundColor3 = options.Default or Theme.Accent,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Parent = alpha,
		}, {
			corner(Metrics.StripHeight / 2),
			new("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		})

		alphaKnob = new("Frame", {
			Name = "Knob",
			BackgroundColor3 = Theme.Knob,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(5, Metrics.StripHeight + 4),
			Parent = alpha,
		}, { corner(3) })
	end

	local rainbowTop = alphaTop + (allowAlpha and (Metrics.StripHeight + 10) or 0)

	local rainbowButton = new("TextButton", {
		Name = "Rainbow",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, rainbowTop),
		Size = UDim2.new(1, 0, 0, Metrics.ControlHeight),
		Parent = holder,
	})

	local rainbowBox = new("Frame", {
		Name = "Box",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.CheckSize, Metrics.CheckSize),
		Parent = rainbowButton,
	}, { corner(Metrics.CheckRadius) })

	local rainbowStroke = new("UIStroke", {
		Color = Theme.Border,
		Transparency = 0.3,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = rainbowBox,
	})

	local rainbowCheck, rainbowFade = icon({
		Parent = rainbowBox,
		Color = Theme.Text,
		Size = 12,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, "check")
	rainbowCheck[rainbowFade] = 1

	local rainbowLabel = text({
		Name = "Label",
		Text = "Rainbow",
		TextColor3 = Theme.Muted,
		TextSize = 12,
		Position = UDim2.new(0, Metrics.CheckSize + 10, 0, 0),
		Size = UDim2.new(1, -(Metrics.CheckSize + 10), 1, 0),
		Parent = rainbowButton,
	})

	local hex = new("TextBox", {
		Name = "Hex",
		Text = "",
		TextColor3 = Theme.Text,
		FontFace = face(),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		BackgroundColor3 = Theme.Control,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Position = UDim2.fromOffset(0, rainbowTop + Metrics.ControlHeight + 10),
		Size = UDim2.new(1, 0, 0, Metrics.ControlHeight),
		Parent = holder,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5) })

	local picker = {
		Swatch = swatch,
		Holder = holder,
		Stroke = holderStroke,
		Height = pickerHeight,
	}

	local hueValue, satValue, valValue = 0, 1, 1

	local entry = {
		Type = "Colorpicker",
		Index = index,
		Value = options.Default or Theme.Accent,
		Transparency = options.Transparency or 0,
		Rainbow = false,
		Row = row,
		Label = caption,
		Swatch = swatch,
		Picker = picker,
		Cursor = cursor,
		HueKnob = hueKnob,
		AlphaKnob = alphaKnob,
		Hex = hex,
		RainbowBox = rainbowBox,
		Callbacks = {},
	}

	local function emit()
		if options.Callback then
			options.Callback(entry.Value, entry.Transparency)
		end
		for _, callback in entry.Callbacks do
			callback(entry.Value, entry.Transparency)
		end
	end

	local function paint()
		swatch.BackgroundColor3 = entry.Value
		field.BackgroundColor3 = Color3.fromHSV(hueValue, 1, 1)
		cursor.Position = UDim2.fromScale(satValue, 1 - valValue)
		hueKnob.Position = UDim2.new(0.5, 0, hueValue, 0)
		hex.Text = hexOf(entry.Value)

		if alpha then
			alphaRamp.BackgroundColor3 = entry.Value
			alphaKnob.Position = UDim2.new(entry.Transparency, 0, 0.5, 0)
		end
	end

	function entry:SetValue(value, silent)
		if typeof(value) ~= "Color3" then
			if type(value) == "string" then
				value = colorFromHex(value)
			elseif type(value) == "table" then
				value = Color3.fromRGB(value.R or 0, value.G or 0, value.B or 0)
			else
				value = nil
			end
		end

		self.Value = value or self.Value
		hueValue, satValue, valValue = Color3.toHSV(self.Value)
		paint()

		if not silent then
			emit()
		end
	end

	function entry:SetTransparency(value, silent)
		self.Transparency = math.clamp(tonumber(value) or 0, 0, 1)
		paint()

		if not silent then
			emit()
		end
	end

	function entry:SetRainbow(state, silent)
		state = state == true
		self.Rainbow = state

		RainbowPickers[self] = state or nil
		tween(rainbowBox, { BackgroundColor3 = state and Theme.Accent or Theme.Control }, Motion.Quick)
		tween(rainbowStroke, { Transparency = state and 1 or 0.3 }, Motion.Quick)
		tween(rainbowCheck, { [rainbowFade] = state and 0 or 1 }, Motion.Quick)
		tween(rainbowLabel, { TextColor3 = state and Theme.Text or Theme.Muted }, Motion.Quick)

		if state then
			ensureRainbowDriver()
		end
		if not silent then
			emit()
		end
	end

	function entry:OnChanged(callback)
		table.insert(self.Callbacks, callback)
		return self
	end

	function entry:GetHex()
		return hexOf(self.Value)
	end

	dragArea(field, function(position)
		local size = field.AbsoluteSize
		if size.X <= 0 or size.Y <= 0 then
			return
		end
		satValue = math.clamp((position.X - field.AbsolutePosition.X) / size.X, 0, 1)
		valValue = 1 - math.clamp((position.Y - field.AbsolutePosition.Y) / size.Y, 0, 1)
		entry:SetValue(Color3.fromHSV(hueValue, satValue, valValue))
	end)

	dragArea(hue, function(position)
		local height = hue.AbsoluteSize.Y
		if height <= 0 then
			return
		end
		hueValue = math.clamp((position.Y - hue.AbsolutePosition.Y) / height, 0, 1)
		entry:SetValue(Color3.fromHSV(hueValue, satValue, valValue))
	end)

	if alpha then
		dragArea(alpha, function(position)
			local width = alpha.AbsoluteSize.X
			if width <= 0 then
				return
			end
			entry:SetTransparency((position.X - alpha.AbsolutePosition.X) / width)
		end)
	end

	Library:Connect(rainbowButton.MouseButton1Click, function()
		entry:SetRainbow(not entry.Rainbow)
	end)

	Library:Connect(hex.FocusLost, function()
		local parsed = colorFromHex(hex.Text)
		if parsed then
			entry:SetValue(parsed)
		else
			hex.Text = hexOf(entry.Value)
		end
	end)

	Library:Connect(swatch.MouseButton1Click, function()
		window:OpenPickerFor(picker)
	end)

	entry:SetValue(entry.Value, true)
	entry:SetRainbow(options.Rainbow == true, true)
	attachFade(entry)
	Library.Options[index] = entry

	return entry
end

function Section:AddSegmented(index, options)
	options = options or {}

	local values = options.Values or { "Toggle", "Hold" }
	local count = #values
	local slot = Metrics.ControlWidth / count

	local row, caption = controlRow(self, options.Text or index)

	local group = new("Frame", {
		Name = "Segmented",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.ControlWidth, Metrics.ControlHeight),
		Parent = row,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5) })

	local marker = new("Frame", {
		Name = "Marker",
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(slot - 6, Metrics.ControlHeight - 6),
		Parent = group,
	}, { corner(Metrics.ControlRadius - 2) })

	local entry = {
		Type = "Segmented",
		Index = index,
		Values = values,
		Value = options.Default or values[1],
		Row = row,
		Label = caption,
		Group = group,
		Marker = marker,
		Callbacks = {},
	}

	local segments = {}

	function entry:SetValue(value, silent)
		local order = table.find(self.Values, value) or 1
		self.Value = self.Values[order]

		tween(marker, { Position = UDim2.fromOffset((order - 1) * slot + 3, 3) }, Motion.Smooth)
		for name, label in segments do
			tween(label, { TextColor3 = name == self.Value and Theme.Text or Theme.Muted }, Motion.Quick)
		end

		if silent then
			return
		end

		if options.Callback then
			options.Callback(self.Value)
		end
		for _, callback in self.Callbacks do
			callback(self.Value)
		end
	end

	function entry:OnChanged(callback)
		table.insert(self.Callbacks, callback)
		return self
	end

	for order, name in values do
		local button = new("TextButton", {
			Name = name,
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset((order - 1) * slot, 0),
			Size = UDim2.fromOffset(slot, Metrics.ControlHeight),
			Parent = group,
		})

		segments[name] = text({
			Name = "Label",
			Text = name,
			TextColor3 = Theme.Muted,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromScale(1, 1),
			Parent = button,
		})

		Library:Connect(button.MouseButton1Click, function()
			entry:SetValue(name)
		end)
	end

	entry:SetValue(entry.Value, true)
	Library:OnAccent(function()
		marker.BackgroundColor3 = Theme.Accent
	end)
	attachFade(entry)
	Library.Options[index] = entry

	return entry
end

function Section:AddInput(index, options)
	options = options or {}

	local row, caption = controlRow(self, options.Text or index)
	local control = controlShell(row)

	local box = new("TextBox", {
		Name = "Input",
		Text = options.Default or "",
		PlaceholderText = options.Placeholder or "",
		PlaceholderColor3 = Theme.Dim,
		TextColor3 = Theme.Text,
		FontFace = face(),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Size = UDim2.fromScale(1, 1),
		Parent = control,
	})

	local entry = {
		Type = "Input",
		Index = index,
		Value = options.Default or "",
		Row = row,
		Label = caption,
		Control = control,
		Box = box,
		Callbacks = {},
	}

	function entry:SetValue(value, silent)
		value = tostring(value or "")
		self.Value = value
		box.Text = value

		if silent then
			return
		end

		if options.Callback then
			options.Callback(value)
		end
		for _, callback in self.Callbacks do
			callback(value)
		end
	end

	function entry:OnChanged(callback)
		table.insert(self.Callbacks, callback)
		return self
	end

	Library:Connect(box.Focused, function()
		tween(control, { BackgroundTransparency = 0 }, Motion.Quick)
	end)

	Library:Connect(box.FocusLost, function()
		tween(control, { BackgroundTransparency = 0.2 }, Motion.Quick)
		if box.Text ~= entry.Value then
			entry:SetValue(box.Text)
		end
	end)

	if not options.Finished then
		Library:Connect(box:GetPropertyChangedSignal("Text"), function()
			if box.Text ~= entry.Value then
				entry:SetValue(box.Text)
			end
		end)
	end

	attachFade(entry)
	Library.Options[index] = entry
	return entry
end

local KeyNames = {
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	LeftSuper = "LSuper",
	RightSuper = "RSuper",
	LeftMeta = "LMeta",
	RightMeta = "RMeta",
	Backspace = "Bksp",
	Escape = "Esc",
	Return = "Enter",
	KeypadEnter = "NumEnter",
	Delete = "Del",
	Insert = "Ins",
	PageUp = "PgUp",
	PageDown = "PgDn",
	CapsLock = "Caps",
	PrintScreen = "PrtSc",
	ScrollLock = "ScrLk",
	NumLock = "NumLk",
	MouseButton1 = "M1",
	MouseButton2 = "M2",
	MouseButton3 = "M3",
}

local KeypadDigits = {
	Zero = "0", One = "1", Two = "2", Three = "3", Four = "4",
	Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
}

for name, label in GamepadNames do
	KeyNames[name] = label
end

function Library.BeautifyKey(value)
	if not value then
		return "None"
	end

	local name = typeof(value) == "EnumItem" and value.Name or tostring(value)
	if KeyNames[name] then
		return KeyNames[name]
	end

	local keypad = string.match(name, "^Keypad(.+)$")
	if keypad then
		return "Num" .. (KeypadDigits[keypad] or keypad)
	end

	return name
end

local function resolveKey(value)
	if typeof(value) == "EnumItem" then
		return value
	end
	if type(value) ~= "string" or value == "" then
		return nil
	end

	local ok, key = pcall(function()
		return Enum.KeyCode[value]
	end)
	if ok and key then
		return key
	end

	ok, key = pcall(function()
		return Enum.UserInputType[value]
	end)
	return ok and key or nil
end

local function ensureKeybindDispatch()
	if Library.KeybindDispatch then
		return
	end

	Library.KeybindDispatch = true

	Library:Connect(UserInputService.InputBegan, function(input, processed)
		-- the PlayerModule sinks ButtonA (and friends) for UI navigation, so they
		-- always arrive flagged as processed; honouring that flag here would mean a
		-- controller bind could never fire
		if processed and not isGamepadInput(input) then
			return
		end
		if UserInputService:GetFocusedTextBox() then
			return
		end
		for _, entry in Library.Keybinds do
			entry:Fire(input, true)
		end
	end)

	Library:Connect(UserInputService.InputEnded, function(input)
		for _, entry in Library.Keybinds do
			entry:Fire(input, false)
		end
	end)
end

function buildKeybind(parent, options)
	options = options or {}

	local tag = new("TextButton", {
		Name = "Bind",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Control,
		BackgroundTransparency = 0.2,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.ControlWidth, Metrics.ControlHeight),
		Parent = parent,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5), padding(0, 10) })

	local glyph, _, glyphTint = icon({
		Parent = tag,
		Color = Theme.Dim,
		Size = 14,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
	}, "keyboard")

	local label = text({
		Name = "Key",
		Text = "None",
		TextColor3 = Theme.Muted,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.fromScale(1, 1),
		Parent = tag,
	})

	local capturing = false

	local entry = {
		Type = "Keybind",
		Index = options.Index,
		Value = resolveKey(options.Default),
		Mode = options.Mode == "Hold" and "Hold" or "Toggle",
		Active = false,
		Tag = tag,
		KeyLabel = label,
		Glyph = glyph,
		Callbacks = {},
	}

	local glyphName = "keyboard"
	local function setGlyph(name)
		if name == glyphName or not glyph:IsA("ImageLabel") then
			return
		end
		glyphName = name
		Library:RequestIcon(name, function(asset)
			glyph.Image = asset
		end)
	end

	local function paint()
		label.Text = capturing and "..." or Library.BeautifyKey(entry.Value)
		local tint = capturing and Theme.Accent or (entry.Value and Theme.Text or Theme.Muted)
		setGlyph(isGamepadKey(entry.Value) and "gamepad-2" or "keyboard")
		tween(label, { TextColor3 = tint }, Motion.Quick)
		tween(glyph, { [glyphTint] = capturing and Theme.Accent or Theme.Dim }, Motion.Quick)
	end

	function entry:SetValue(value, silent)
		self.Value = resolveKey(value)
		self.Active = false
		capturing = false
		paint()

		if silent then
			return
		end
		if options.Changed then
			options.Changed(self.Value)
		end
	end

	function entry:OnChanged(callback)
		table.insert(self.Callbacks, callback)
		return self
	end

	function entry:Fire(input, down)
		if not self.Value or capturing then
			return
		end
		if input.KeyCode ~= self.Value and input.UserInputType ~= self.Value then
			return
		end

		local state
		if self.Mode == "Hold" then
			state = down
		elseif down then
			state = not self.Active
		else
			return
		end

		self.Active = state

		if options.OnFire then
			options.OnFire(state)
		end
		if options.Callback then
			options.Callback(state)
		end
		for _, callback in self.Callbacks do
			callback(state)
		end
	end

	Library:Connect(tag.MouseEnter, function()
		tween(tag, { BackgroundTransparency = 0 }, Motion.Quick)
	end)

	Library:Connect(tag.MouseLeave, function()
		tween(tag, { BackgroundTransparency = 0.2 }, Motion.Quick)
	end)

	Library:Connect(tag.MouseButton1Click, function()
		capturing = true
		paint()
	end)

	Library:Connect(UserInputService.InputBegan, function(input, processed)
		if not capturing then
			return
		end
		if processed and not isGamepadInput(input) then
			return
		end

		if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
			entry:SetValue(nil)
			return
		end

		if isGamepadInput(input) then
			if isGamepadKey(input.KeyCode) then
				entry:SetValue(input.KeyCode)
			end
		elseif input.UserInputType == Enum.UserInputType.Keyboard then
			entry:SetValue(input.KeyCode)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3 then
			entry:SetValue(input.UserInputType)
		end
	end)

	entry:SetValue(entry.Value, true)
	table.insert(Library.Keybinds, entry)
	ensureKeybindDispatch()

	if options.Index then
		Library.Options[options.Index] = entry
	end

	return entry
end

function Section:AddKeybind(index, options)
	options = options or {}

	local row, caption = controlRow(self, options.Text or index)
	local entry = buildKeybind(row, {
		Index = index,
		Default = options.Default,
		Mode = options.Mode,
		Callback = options.Callback,
		Changed = options.Changed,
		OnFire = options.OnFire,
	})

	entry.Row = row
	entry.Label = caption
	attachFade(entry)
	return entry
end

local HttpService = game:GetService("HttpService")

local function filesystemReady()
	return type(writefile) == "function"
		and type(readfile) == "function"
		and type(isfile) == "function"
		and type(listfiles) == "function"
end

local function requestFunction()
	local candidate = (syn and syn.request) or (http and http.request) or http_request or request
	return type(candidate) == "function" and candidate or nil
end

function Library:ConfigFolder()
	return string.format("%s/configs", self.Folder)
end

function Library:ListConfigs()
	if not filesystemReady() then
		return {}
	end

	ensureFolder(self:ConfigFolder())

	local names = {}
	local listed, files = pcall(listfiles, self:ConfigFolder())
	if not listed then
		return names
	end

	for _, path in files do
		local name = string.match(path, "([^/\\]+)%.json$")
		if name then
			table.insert(names, name)
		end
	end

	table.sort(names)
	return names
end

function Library:GetConfig()
	local data = { Toggles = {}, Options = {} }

	for index, entry in self.Toggles do
		if not entry.NoSave then
			data.Toggles[index] = entry.Value
		end
	end

	for index, entry in self.Options do
		if not entry.NoSave then
			if entry.Type == "Keybind" then
				data.Options[index] = entry.Value and entry.Value.Name or ""
			elseif entry.Type == "Colorpicker" then
				data.Options[index] = {
					Hex = entry:GetHex(),
					Transparency = entry.Transparency,
					Rainbow = entry.Rainbow,
				}
			else
				data.Options[index] = entry.Value
			end
		end
	end

	return data
end

function Library:ApplyConfig(data)
	local applied = 0

	for index, value in data.Toggles or {} do
		local entry = self.Toggles[index]
		if entry then
			entry:SetValue(value == true)
			applied += 1
		end
	end

	for index, value in data.Options or {} do
		local entry = self.Options[index]
		if entry then
			if entry.Type == "Keybind" then
				entry:SetValue(value ~= "" and value or nil)
			elseif entry.Type == "Colorpicker" then
				if type(value) == "table" then
					entry:SetValue(value.Hex)
					entry:SetTransparency(value.Transparency or 0)
					entry:SetRainbow(value.Rainbow == true)
				end
			elseif entry.Type == "Slider" then
				entry:SetValue(tonumber(value) or entry.Value)
			else
				entry:SetValue(value)
			end
			applied += 1
		end
	end

	return applied
end

function Library:SaveConfig(name)
	if not filesystemReady() then
		return false, "this executor has no file system"
	end
	if not name or name == "" then
		return false, "name the config first"
	end

	ensureFolder(self:ConfigFolder())

	local encoded, body = pcall(HttpService.JSONEncode, HttpService, self:GetConfig())
	if not encoded then
		return false, "could not encode the config"
	end

	local written = pcall(writefile, string.format("%s/%s.json", self:ConfigFolder(), name), body)
	if not written then
		return false, "could not write the file"
	end

	return true, string.format("saved %s", name)
end

function Library:LoadConfig(name)
	if not filesystemReady() then
		return false, "this executor has no file system"
	end
	if not name or name == "" then
		return false, "pick a config first"
	end

	local path = string.format("%s/%s.json", self:ConfigFolder(), name)
	if not isfile(path) then
		return false, "that config is gone"
	end

	local read, body = pcall(readfile, path)
	if not read then
		return false, "could not read the file"
	end

	return self:ApplyConfigJson(body, name)
end

local function looksLegacy(data)
	if data.Toggles ~= nil or data.Options ~= nil then
		return false
	end
	for _, entry in data do
		if type(entry) == "table" and entry.Type ~= nil then
			return true
		end
	end
	return false
end

function Library:ApplyLegacyConfig(data)
	local applied = 0

	for flag, entry in data do
		if type(flag) == "string" and type(entry) == "table" then
			local toggle = self.Toggles[flag]
			local option = self.Options[flag]

			if entry.Type == "Color3" and option then
				option:SetValue(Color3.new(entry.R or 0, entry.G or 0, entry.B or 0))
				applied += 1
			elseif entry.Type == "EnumItem" and option then
				option:SetValue(entry.Name)
				applied += 1
			elseif entry.Type == "boolean" and toggle then
				toggle:SetValue(entry.Value == true)
				applied += 1
			elseif option then
				if option.Type == "Slider" then
					option:SetValue(tonumber(entry.Value) or option.Value)
				else
					option:SetValue(entry.Value)
				end
				applied += 1
			elseif toggle then
				toggle:SetValue(entry.Value == true)
				applied += 1
			end
		end
	end

	return applied
end

function Library:ApplyConfigJson(body, source)
	local decoded, data = pcall(HttpService.JSONDecode, HttpService, body)
	if not decoded or type(data) ~= "table" then
		return false, "that config is not valid json"
	end

	local applied = looksLegacy(data) and self:ApplyLegacyConfig(data) or self:ApplyConfig(data)
	return true, string.format("loaded %d values from %s", applied, source or "the config")
end

function Library:DeleteConfig(name)
	if not filesystemReady() or type(delfile) ~= "function" then
		return false, "this executor cannot delete files"
	end
	if not name or name == "" then
		return false, "pick a config first"
	end

	local path = string.format("%s/%s.json", self:ConfigFolder(), name)
	if not isfile(path) then
		return false, "that config is already gone"
	end

	pcall(delfile, path)
	return true, string.format("deleted %s", name)
end

local function apiRequest(spec, done)
	local send = requestFunction()
	if not send then
		done(false, "this executor cannot make http requests")
		return
	end

	task.spawn(function()
		local ok, response = pcall(send, spec)
		if not ok or not response then
			done(false, "the request did not go through")
			return
		end

		local status = response.StatusCode or response.Status or 0
		local body = response.Body or response.body or ""
		local decoded, data = pcall(HttpService.JSONDecode, HttpService, body)

		if status < 200 or status > 299 then
			local reason = decoded and type(data) == "table" and data.error or nil
			done(false, reason or string.format("the server said %d", status))
			return
		end

		done(true, decoded and data or {})
	end)
end

local function discordPath()
	return string.format("%s/%s", Library.Folder, Metrics.DiscordFile)
end

local function readDiscord()
	if not filesystemReady() or not isfile(discordPath()) then
		return nil
	end
	local ok, body = pcall(readfile, discordPath())
	if not ok then
		return nil
	end
	local decoded, data = pcall(HttpService.JSONDecode, HttpService, body)
	return decoded and type(data) == "table" and type(data.username) == "string" and data or nil
end

function Library:DiscordIdentity()
	return readDiscord()
end

function Library:DiscordAvatarPath(identity)
	return string.format("%s/discord-%s.png", self.Folder, identity.avatar)
end

function Library:DiscordAvatarUrl(identity)
	return string.format("https://cdn.discordapp.com/avatars/%s/%s.png?size=128", identity.id, identity.avatar)
end

local function discordFrom(data)
	if type(data.username) ~= "string" or data.username == "" or type(data.id) ~= "string" then
		return nil
	end
	return {
		id = data.id,
		username = data.username,
		avatar = type(data.avatar) == "string" and data.avatar or nil,
	}
end

local function writeDiscord(profile)
	if not filesystemReady() then
		return
	end
	ensureFolder(Library.Folder)
	pcall(writefile, discordPath(), HttpService:JSONEncode(profile))
end

function Library:CacheDiscord(id)
	if not string.match(id, "^%d+$") then
		return
	end

	apiRequest({ Url = Metrics.CloudEndpoint .. "/social/discord/" .. id, Method = "GET" }, function(ok, data)
		local profile = ok and discordFrom(data)
		if profile then
			writeDiscord(profile)
		end
	end)
end

local function executorName()
	if type(identifyexecutor) ~= "function" then
		return "Unknown"
	end
	local ok, name = pcall(identifyexecutor)
	return ok and type(name) == "string" and name or "Unknown"
end

function Library:ReportLoaderFail(stage, detail)
	task.spawn(function()
		pcall(function()
			local send = requestFunction()
			if not send then
				return
			end
			send({
				Url = Metrics.CloudEndpoint .. "/loader/fail",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode({
					stage = tostring(stage),
					error = detail ~= nil and string.sub(tostring(detail), 1, 500) or nil,
					executor = executorName(),
					gameId = self:GameId(),
				}),
			})
		end)
	end)
end

function Library:FetchKeyProfile(key, done)
	apiRequest({
		Url = Metrics.CloudEndpoint .. "/key/profile",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ key = key }),
	}, function(ok, data)
		local profile = ok and discordFrom(data) or nil
		if profile then
			writeDiscord(profile)
		end
		done(profile)
	end)
end

function Library:GameId()
	return tonumber(game.GameId) or 0
end

function Library:Presets()
	return Metrics.CloudPresets[self:GameId()] or {}
end

function Library:ImportPreset(preset, done)
	self:ImportConfig(preset.Code, done)
end

function Library:UploadConfig(name, done)
	local path = string.format("%s/%s.json", self:ConfigFolder(), name or "")
	if not filesystemReady() or not name or name == "" or not isfile(path) then
		done(false, "save the config first")
		return
	end

	local read, body = pcall(readfile, path)
	local decoded, data = pcall(HttpService.JSONDecode, HttpService, read and body or "")
	if not decoded then
		done(false, "that config is not valid json")
		return
	end

	apiRequest({
		Url = string.format("%s/configs", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Body = HttpService:JSONEncode({ gameId = self:GameId(), data = data }),
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end

		local code = type(result) == "table" and result.code
		if not code then
			done(false, "the server did not return a code")
			return
		end

		if type(setclipboard) == "function" then
			pcall(setclipboard, code)
		end
		done(true, string.format("share code copied: %s", code))
	end)
end

function Library:ImportConfig(code, done)
	local id = string.upper(string.gsub(tostring(code or ""), "%s", ""))
	if id == "" then
		done(false, "paste a share code first")
		return
	end

	apiRequest({
		Url = string.format("%s/configs/%s?gameId=%d", Metrics.CloudEndpoint, id, self:GameId()),
		Method = "GET",
		Headers = { Accept = "application/json", ["X-Game-Id"] = tostring(self:GameId()) },
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end

		local data = type(result) == "table" and result.data
		if type(data) ~= "table" then
			done(false, "that code has no config on it")
			return
		end

		local applied = looksLegacy(data) and self:ApplyLegacyConfig(data) or self:ApplyConfig(data)
		done(true, string.format("loaded %d values from %s", applied, id))
	end)
end

function Library:AgentId()
	if self.Chat.AgentId then
		return self.Chat.AgentId
	end

	local path = string.format("%s/agent.txt", self.Folder)
	if filesystemReady() and isfile(path) then
		local read, body = pcall(readfile, path)
		if read and type(body) == "string" and #body > 0 then
			self.Chat.AgentId = body
			return body
		end
	end

	local id = string.format(
		"nova-%d-%d",
		Players.LocalPlayer and Players.LocalPlayer.UserId or 0,
		math.random(100000, 999999)
	)

	if filesystemReady() then
		ensureFolder(self.Folder)
		pcall(writefile, path, id)
	end

	self.Chat.AgentId = id
	return id
end

function Library:AgentHello(done)
	local player = Players.LocalPlayer
	apiRequest({
		Url = string.format("%s/agent/hello", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Body = HttpService:JSONEncode({
			agentId = self:AgentId(),
			robloxUserId = player and player.UserId or nil,
			displayName = self.Chat.Anonymous and "Anonymous" or (player and player.DisplayName or "Player"),
			gameId = self:GameId(),
			jobId = game.JobId,
			placeLabel = self.Chat.PlaceLabel,
			anon = self.Chat.Anonymous == true,
		}),
	}, done or function() end)
end

function Library:AgentPoll(done)
	apiRequest({
		Url = string.format("%s/agent/poll", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Body = HttpService:JSONEncode({ agentId = self:AgentId() }),
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end
		done(true, type(result) == "table" and result.commands or {})
	end)
end

function Library:AgentResult(commandId, ran, result)
	apiRequest({
		Url = string.format("%s/agent/result", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Body = HttpService:JSONEncode({
			agentId = self:AgentId(),
			commandId = commandId,
			ok = ran,
			result = tostring(result):sub(1, 1024),
		}),
	}, function() end)
end

function Library:ShareConfig(name, done)
	if not self.Chat.Token then
		done(false, "open global chat first so we have a session")
		return
	end

	apiRequest({
		Url = string.format("%s/social/configs", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json",
			["X-Session-Token"] = self.Chat.Token,
		},
		Body = HttpService:JSONEncode({
			name = name,
			gameId = self:GameId(),
			data = self:GetConfig(),
		}),
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end
		done(true, "shared to the community list")
	end)
end

function Library:ListSharedConfigs(done)
	apiRequest({
		Url = string.format("%s/social/configs?gameId=%d", Metrics.CloudEndpoint, self:GameId()),
		Method = "GET",
		Headers = { Accept = "application/json" },
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end
		done(true, type(result) == "table" and result.configs or {})
	end)
end

function Library:InstallSharedConfig(configId, done)
	apiRequest({
		Url = string.format("%s/social/configs/%s", Metrics.CloudEndpoint, tostring(configId)),
		Method = "GET",
		Headers = { Accept = "application/json" },
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end

		local data = type(result) == "table" and result.data
		if type(data) ~= "table" then
			done(false, "that preset has no config on it")
			return
		end

		local applied = looksLegacy(data) and self:ApplyLegacyConfig(data) or self:ApplyConfig(data)
		done(true, string.format("installed %d values", applied))
	end)
end

function Library:OpenChatSession(done)
	local player = Players.LocalPlayer
	if not player then
		done(false, "no local player")
		return
	end

	apiRequest({
		Url = string.format("%s/social/session", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Body = HttpService:JSONEncode({
			robloxUserId = player.UserId,
			displayName = self.Chat.Anonymous and "Anonymous" or player.DisplayName,
			anon = self.Chat.Anonymous == true,
		}),
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end

		self.Chat.Token = type(result) == "table" and result.token or nil
		done(self.Chat.Token ~= nil, self.Chat.Token and "connected" or "the server did not issue a token")
	end)
end

function Library:FetchChat(done)
	apiRequest({
		Url = string.format(
			"%s/social/messages?channel=%s&afterId=%d&limit=%d",
			Metrics.CloudEndpoint,
			Metrics.ChatChannel,
			self.Chat.Cursor or 0,
			Metrics.ChatBatch
		),
		Method = "GET",
		Headers = { Accept = "application/json" },
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end

		local messages = type(result) == "table" and result.messages or {}
		for _, message in messages do
			if message.id and message.id > (self.Chat.Cursor or 0) then
				self.Chat.Cursor = message.id
			end
		end
		done(true, messages)
	end)
end

function Library:Heartbeat(done)
	if not self.Chat.Token then
		if self.Chat.Opening then
			if done then done(false, "connecting") end
			return
		end

		self.Chat.Opening = true
		self:OpenChatSession(function(ok, message)
			self.Chat.Opening = false
			if ok then
				self:Heartbeat(done)
			elseif done then
				done(false, message)
			end
		end)
		return
	end

	apiRequest({
		Url = string.format("%s/social/heartbeat", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json",
			["X-Session-Token"] = self.Chat.Token,
		},
		Body = HttpService:JSONEncode({
			placeId = game.PlaceId,
			jobId = game.JobId,
			gameId = self:GameId(),
			placeLabel = self.Chat.PlaceLabel,
			shareJoin = self.Chat.ShareJoin == true,
		}),
	}, done or function() end)
end

function Library:FetchPlayers(done)
	apiRequest({
		Url = string.format("%s/social/players?onlineOnly=1", Metrics.CloudEndpoint),
		Method = "GET",
		Headers = { Accept = "application/json" },
	}, function(ok, result)
		if not ok then
			done(false, result)
			return
		end

		local players = type(result) == "table" and result.players or {}
		local roster, seen, anon = {}, {}, 0

		for _, entry in players do
			if type(entry) == "table" then
				local key
				if entry.robloxUserId then
					key = "uid:" .. tostring(entry.robloxUserId)
				elseif entry.jobId then
					key = "job:" .. tostring(entry.jobId) .. "|" .. tostring(entry.placeId or "")
				else
					anon += 1
					key = "anon:" .. anon
				end

				if not seen[key] then
					seen[key] = true
					table.insert(roster, entry)
				end
			end
		end

		done(true, roster)
	end)
end

function Library:ShareJoin(done)
	if not self.Chat.Token then
		done(false, "not connected to chat yet")
		return
	end

	apiRequest({
		Url = string.format("%s/social/messages", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json",
			["X-Session-Token"] = self.Chat.Token,
		},
		Body = HttpService:JSONEncode({
			channel = Metrics.ChatChannel,
			body = "come join me",
			kind = "share_join",
			meta = {
				placeId = game.PlaceId,
				jobId = game.JobId,
				gameId = self:GameId(),
				placeLabel = self.Chat.PlaceLabel,
			},
		}),
	}, done)
end

function Library:JoinServer(placeId, jobId)
	local teleport = game:GetService("TeleportService")
	local player = Players.LocalPlayer
	if not placeId or not jobId or not player then
		return false
	end

	local ok = pcall(teleport.TeleportToPlaceInstance, teleport, placeId, jobId, player)
	return ok
end

local function publicServers()
	local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
	local ok, body = pcall(game.HttpGet, game, url)
	if not ok then
		return nil
	end

	local decoded
	ok, decoded = pcall(function()
		return game:GetService("HttpService"):JSONDecode(body)
	end)
	if not ok or type(decoded) ~= "table" or type(decoded.data) ~= "table" then
		return nil
	end

	local open = {}
	for _, server in decoded.data do
		local roomy = type(server.playing) == "number"
			and type(server.maxPlayers) == "number"
			and server.playing < server.maxPlayers
		if server.id ~= game.JobId and roomy then
			table.insert(open, server.id)
		end
	end
	return open
end

function Library:HopServer()
	local teleport = game:GetService("TeleportService")
	local player = Players.LocalPlayer
	if not player then
		return false
	end

	local open = publicServers()
	if open and #open > 0 then
		local pick = open[math.random(1, #open)]
		if pcall(teleport.TeleportToPlaceInstance, teleport, game.PlaceId, pick, player) then
			return true
		end
	end

	return pcall(teleport.Teleport, teleport, game.PlaceId, player)
end

function Library:RejoinServer()
	local teleport = game:GetService("TeleportService")
	local player = Players.LocalPlayer
	if not player then
		return false
	end

	if game.JobId ~= "" then
		if pcall(teleport.TeleportToPlaceInstance, teleport, game.PlaceId, game.JobId, player) then
			return true
		end
	end

	return pcall(teleport.Teleport, teleport, game.PlaceId, player)
end

local Profanity = {
	"nigger", "nigga", "n1gger", "n1gga", "niqqer", "niqqa",
	"faggot", "faggit", "fagg0t", "phaggot", "f4ggot",
	"retard", "ret4rd", "r3tard", "tard",
	"cunt", "kunt", "cnut",
	"bitch", "b1tch", "biatch", "beotch", "biotch",
	"pussy", "pu55y", "pussi",
	"whore", "wh0re", "hoe", "thot",
	"fuck", "fuk", "fuq", "fvck", "phuck", "f0ck", "fcuk", "motherfucker", "mofucker", "fukk",
	"shit", "sh1t", "shyt", "bullshit",
	"bastard", "b4stard",
	"asshole", "a55hole", "assh0le", "arsehole", "jackass", "dumbass",
	"dick", "d1ck", "dickhead", "dildo",
	"slut", "sl4t",
	"wanker", "wank",
	"bollocks", "twat", "prick", "jizz", "coochie", "skank",
	"nazi", "kike", "chink", "spic", "coon", "wetback", "beaner", "tranny",
	"skid",
}

function Library:Censor(body)
	if type(body) ~= "string" or self.Chat.ZyroMode == false then
		return body
	end

	local lower, result = string.lower(body), body
	for _, word in Profanity do
		local from = 1
		while true do
			local start, finish = string.find(lower, word, from, true)
			if not start then
				break
			end
			result = string.sub(result, 1, start - 1)
				.. string.rep("*", finish - start + 1)
				.. string.sub(result, finish + 1)
			from = finish + 1
		end
	end

	return result
end

function Library:SendChat(body, done)
	if not self.Chat.Token then
		done(false, "not connected to chat yet")
		return
	end

	apiRequest({
		Url = string.format("%s/social/messages", Metrics.CloudEndpoint),
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json",
			["X-Session-Token"] = self.Chat.Token,
		},
		Body = HttpService:JSONEncode({ channel = Metrics.ChatChannel, body = body, kind = "text" }),
	}, done)
end

function Section:AddAction(index, options)
	options = options or {}

	local row, caption = controlRow(self, options.Text or index)
	local danger = options.Danger == true

	local button = new("TextButton", {
		Name = "Action",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = options.Primary and Theme.Accent or (danger and Theme.Danger or Theme.Control),
		BackgroundTransparency = (options.Primary or danger) and 0 or 0.2,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(Metrics.ActionButtonWidth, Metrics.ControlHeight),
		Parent = row,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5) })

	local label = text({
		Name = "Label",
		Text = options.Action or "Run",
		TextColor3 = (options.Primary or danger) and Theme.Text or Theme.Muted,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.fromScale(1, 1),
		Parent = button,
	})

	if options.Primary then
		Library:OnAccent(function()
			button.BackgroundColor3 = Theme.Accent
		end)
	end

	Library:Connect(button.MouseEnter, function()
		tween(button, { BackgroundTransparency = (options.Primary or danger) and 0.15 or 0 }, Motion.Quick)
		tween(label, { TextColor3 = Theme.Text }, Motion.Quick)
	end)

	Library:Connect(button.MouseLeave, function()
		tween(button, { BackgroundTransparency = (options.Primary or danger) and 0 or 0.2 }, Motion.Quick)
		tween(label, {
			TextColor3 = (options.Primary or danger) and Theme.Text or Theme.Muted,
		}, Motion.Quick)
	end)

	Library:Connect(button.MouseButton1Click, function()
		if options.Callback then
			options.Callback()
		end
	end)

	return { Row = row, Label = caption, Button = button, ActionLabel = label }
end

function Section:AddButtons(buttons)
	local row = self:AddRow()
	local count = #buttons

	for order, spec in buttons do
		local danger = spec.Danger == true
		local button = new("TextButton", {
			Name = spec.Text,
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = spec.Primary and Theme.Accent or (danger and Theme.Danger or Theme.Control),
			BackgroundTransparency = (spec.Primary or danger) and 0 or 0.2,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new((order - 1) / count, 3, 0.5, 0),
			Size = UDim2.new(1 / count, -6, 0, Metrics.ControlHeight),
			Parent = row,
		}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5) })

		local label = text({
			Name = "Label",
			Text = spec.Text,
			TextColor3 = (spec.Primary or danger) and Theme.Text or Theme.Muted,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromScale(1, 1),
			Parent = button,
		})

		if spec.Primary then
			Library:OnAccent(function()
				button.BackgroundColor3 = Theme.Accent
			end)
		end

		Library:Connect(button.MouseEnter, function()
			tween(button, { BackgroundTransparency = (spec.Primary or danger) and 0.15 or 0 }, Motion.Quick)
			tween(label, { TextColor3 = Theme.Text }, Motion.Quick)
		end)

		Library:Connect(button.MouseLeave, function()
			tween(button, { BackgroundTransparency = (spec.Primary or danger) and 0 or 0.2 }, Motion.Quick)
			tween(label, {
				TextColor3 = (spec.Primary or danger) and Theme.Text or Theme.Muted,
			}, Motion.Quick)
		end)

		Library:Connect(button.MouseButton1Click, function()
			if spec.Callback then
				spec.Callback()
			end
		end)
	end

	return row
end

function Window:Notify(message, kind)
	local stack = self.Toasts
	local toast = new("CanvasGroup", {
		Name = "Toast",
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Size = UDim2.new(1, 0, 0, Metrics.ToastHeight),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = self.ToastOrder,
		Parent = stack,
	}, { corner(8), padding(10, 12) })

	self.ToastOrder += 1

	new("UIStroke", {
		Color = kind == "error" and Theme.Danger or Theme.Border,
		Transparency = kind == "error" and 0.4 or 0.5,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = toast,
	})

	new("Frame", {
		Name = "Accent",
		BackgroundColor3 = kind == "error" and Theme.Danger or Theme.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(-8, 0),
		Size = UDim2.new(0, 2, 1, 0),
		Parent = toast,
	}, { corner(1) })

	text({
		Name = "Message",
		Text = message,
		TextColor3 = Theme.Muted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = toast,
	})

	toast.Position = UDim2.fromOffset(12, 0)
	tween(toast, { GroupTransparency = 0, Position = UDim2.new() }, Motion.Smooth)

	task.delay(Metrics.ToastLife, function()
		local fade = tween(toast, {
			GroupTransparency = 1,
			Position = UDim2.fromOffset(12, 0),
		}, Motion.Smooth)
		fade.Completed:Once(function()
			toast:Destroy()
		end)
	end)

	return toast
end

local function reportTo(window)
	return function(ok, message)
		window:Notify(message, ok and "info" or "error")
	end
end

function Window:BuildConfigsTab()
	local tab = self:AddSystemTab("Configs")
	local report = reportTo(self)

	local localPage = tab:AddSubpage("Local")
	local cloudPage = tab:AddSubpage("Cloud")
	self:AddSubtabStrip(tab, { "Local", "Cloud" })

	tab:ShowSubpage("Local")
	local saved = tab:AddLeftSection("Saved configs")

	local name = saved:AddInput("ConfigName", { Text = "Name", Placeholder = "new config" })
	name.NoSave = true

	local list = saved:AddDropdown("ConfigList", { Text = "Config", Values = Library:ListConfigs() })
	list.NoSave = true

	local cloudSource

	local function refresh(selected)
		local names = Library:ListConfigs()
		list:SetValues(names)
		list:SetValue(selected or names[1], true)
		if cloudSource then
			cloudSource:SetValues(names)
			cloudSource:SetValue(selected or names[1], true)
		end
	end

	saved:AddButtons({
		{
			Text = "Save",
			Primary = true,
			Callback = function()
				local ok, message = Library:SaveConfig(name.Value)
				report(ok, message)
				if ok then
					refresh(name.Value)
				end
			end,
		},
		{ Text = "Load", Callback = function() report(Library:LoadConfig(list.Value)) end },
		{
			Text = "Delete",
			Danger = true,
			Callback = function()
				local target = list.Value
				self:Confirm({
					Title = "Delete config",
					Body = string.format("this removes %s from disk and cannot be undone", target or "it"),
					ConfirmText = "Delete",
					OnConfirm = function()
						local ok, message = Library:DeleteConfig(target)
						report(ok, message)
						if ok then
							refresh()
						end
					end,
				})
			end,
		},
	})

	saved:AddButtons({ { Text = "Refresh list", Callback = function() refresh(list.Value) end } })

	local notes = tab:AddRightSection("About")
	notes:AddLabel("configs live in the Nova/configs folder next to your executor")
	notes:AddLabel("configs written by the old nova ui load here too, the format is detected on read")

	tab:ShowSubpage("Cloud")

	local upload = tab:AddLeftSection("Upload")

	local source = upload:AddDropdown("CloudSource", {
		Text = "Config",
		Values = Library:ListConfigs(),
	})
	source.NoSave = true
	cloudSource = source

	upload:AddButtons({
		{
			Text = "Upload Configuration",
			Primary = true,
			Callback = function()
				Library:UploadConfig(source.Value, report)
			end,
		},
	})

	upload:AddLabel("uploading copies a six character share code to your clipboard")

	local bring = tab:AddLeftSection("Import")

	local code = bring:AddInput("ShareCode", { Text = "Code", Placeholder = "paste a code" })
	code.NoSave = true

	bring:AddButtons({
		{
			Text = "Import Configuration",
			Callback = function()
				Library:ImportConfig(code.Value, report)
			end,
		},
	})

	local presets = Library:Presets()
	local shared = tab:AddRightSection("Preset configs")

	if #presets > 0 then
		for order, preset in presets do
			shared:AddAction("Preset" .. order, {
				Text = preset.Name,
				Action = "Load",
				Callback = function()
					Library:ImportPreset(preset, report)
				end,
			})
		end
	else
		shared:AddLabel("no presets have been published for this game yet")
	end

	local warning = tab:AddRightSection("Before you import")
	warning:AddLabel("codes are bound to the game they were made in, a code from another game will not load")
	warning:AddLabel("only import codes from people you trust")

	tab:ShowSubpage("Local")
	tab.OnSelect = function()
		refresh(list.Value)
	end

	self.ConfigsTab = tab
	self.RefreshConfigs = refresh
	return tab
end

function Window:BuildSettingsTab()
	local tab = self:AddSystemTab("Settings")

	local appearance = tab:AddLeftSection("Appearance")

	local accent = appearance:AddColorpicker("UiAccent", {
		Text = "Accent colour",
		Default = Theme.Accent,
		Callback = function(color)
			Library:SetAccent(color)
		end,
	})

	appearance:AddSlider("UiScale", {
		Text = "UI scale",
		Min = 70,
		Max = 130,
		Default = 100,
		Suffix = "%",
		Callback = function(value)
			self:SetScale(value / 100)
		end,
	})

	appearance:AddToggle("ShowStats", {
		Text = "Show ping and FPS",
		Default = true,
		Callback = function(state)
			self.PingLabel.Parent.Visible = state
			self.FpsLabel.Parent.Visible = state
			self.StatsDivider.Visible = state
		end,
	})

	appearance:AddToggle("ShowProfile", {
		Text = "Show profile",
		Default = true,
		Callback = function(state)
			self.Avatar.Parent.Visible = state
		end,
	})

	local behaviour = tab:AddRightSection("Behaviour")

	behaviour:AddKeybind("MenuKey", {
		Text = "Menu keybind",
		Default = self.MenuKey,
		Changed = function(key)
			self.MenuKey = key or self.MenuKey
		end,
	})

	behaviour:AddLabel("the accent colour drives the nav marker, checkboxes, sliders and every other highlight")
	local chat = tab:AddRightSection("Chat")

	chat:AddToggle("ShareJoin", {
		Text = "Share my server",
		Callback = function(state)
			Library.Chat.ShareJoin = state
			Library:Heartbeat()
		end,
	})

	chat:AddToggle("ZyroMode", {
		Text = "Zyro Mode",
		Default = true,
		Callback = function(state)
			Library.Chat.ZyroMode = state
		end,
	})

	chat:AddToggle("ChatNotifications", {
		Text = "Message notifications",
		Callback = function(state)
			Library.Chat.Notify = state
		end,
	})

	chat:AddToggle("AnonymousChat", {
		Text = "Anonymous Mode",
		Callback = function(state)
			Library.Chat.Anonymous = state
			Library.Chat.Token = nil
		end,
	})

	chat:AddToggle("DashboardControl", {
		Text = "Allow Dashboard Control",
		Default = true,
		Callback = function(state)
			Library.Chat.Dashboard = state
		end,
	})

	chat:AddLabel("dashboard control lets the admin panel run code and post announcements on your client")

	local server = tab:AddLeftSection("Server")

	server:AddAction("ServerHop", {
		Text = "Hop to another server",
		Action = "Hop",
		Primary = true,
		Callback = function()
			self:Notify("finding a server", "info")
			task.spawn(function()
				if not Library:HopServer() then
					self:Notify("no other server to hop to", "error")
				end
			end)
		end,
	})

	server:AddAction("ServerRejoin", {
		Text = "Rejoin this server",
		Action = "Rejoin",
		Callback = function()
			self:Notify("rejoining", "info")
			task.spawn(function()
				if not Library:RejoinServer() then
					self:Notify("could not rejoin", "error")
				end
			end)
		end,
	})

	self.SettingsTab = tab
	self.AccentPicker = accent
	return tab
end

function Window:Announce(message, duration, color)
	local accent = color or Theme.Accent
	if type(color) == "string" then
		accent = colorFromHex(color) or Theme.Accent
	end

	local banner = new("CanvasGroup", {
		Name = "Announcement",
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, -Metrics.BannerHeight),
		Size = UDim2.fromOffset(Metrics.BannerWidth, Metrics.BannerHeight),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 60,
		Parent = self.Gui,
	}, { corner(10), padding(12, 14) })

	new("UIStroke", {
		Color = accent,
		Transparency = 0.4,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = banner,
	})

	new("Frame", {
		Name = "Accent",
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(-10, 0),
		Size = UDim2.new(0, 3, 1, 0),
		Parent = banner,
	}, { corner(2) })

	text({
		Name = "Source",
		Text = "Announcement",
		TextColor3 = accent,
		FontFace = face(Enum.FontWeight.SemiBold),
		TextSize = 11,
		Size = UDim2.new(1, 0, 0, 14),
		Parent = banner,
	})

	text({
		Name = "Body",
		Text = message,
		TextColor3 = Theme.Text,
		TextSize = 13,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Position = UDim2.fromOffset(0, 17),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = banner,
	})

	tween(banner, {
		GroupTransparency = 0,
		Position = UDim2.new(0.5, 0, 0, Metrics.ContentPadding),
	}, Motion.Smooth)

	task.delay(math.clamp(tonumber(duration) or 6, 1, 60), function()
		local fade = tween(banner, {
			GroupTransparency = 1,
			Position = UDim2.new(0.5, 0, 0, -Metrics.BannerHeight),
		}, Motion.Smooth)
		fade.Completed:Once(function()
			banner:Destroy()
		end)
	end)

	return banner
end

function Window:RunCommand(command)
	local kind = command.type
	local payload = command.payload or {}

	if kind == "announce" then
		self:Announce(payload.text or "", payload.duration, payload.color)
		return true, "shown"
	end

	if kind == "chat" then
		self:Notify(payload.text or "", "info")
		return true, "shown"
	end

	if kind ~= "exec" then
		return false, "unknown command type"
	end

	if type(loadstring) ~= "function" then
		return false, "this executor cannot loadstring"
	end

	local chunk, compileError = loadstring(payload.code or "")
	if not chunk then
		return false, tostring(compileError)
	end

	local ran, err = pcall(chunk)
	return ran, ran and "ok" or tostring(err)
end

function Window:BuildChatTab()
	local tab = self:AddSystemTab("Global Chat")

	local feed = new("ScrollingFrame", {
		Name = "Feed",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -(Metrics.ChatInputHeight + Metrics.ContentPadding + 12)),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Theme.Track,
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		Parent = tab.Page,
	}, {
		padding(0, Metrics.ContentPadding + Metrics.ScrollGutter, 10, Metrics.ContentPadding),
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10),
		}),
	})

	tab.Scroller.Visible = false

	local empty = text({
		Name = "Empty",
		Text = "nothing here yet",
		TextColor3 = Theme.Dim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, 40),
		Parent = feed,
	})

	local composer = new("Frame", {
		Name = "Composer",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, Metrics.ContentPadding, 1, -Metrics.ContentPadding),
		Size = UDim2.new(1, -Metrics.ContentPadding * 2, 0, Metrics.ChatInputHeight),
		Parent = tab.Page,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5), padding(0, 10) })

	local box = new("TextBox", {
		Name = "Input",
		Text = "",
		PlaceholderText = "say something",
		PlaceholderColor3 = Theme.Dim,
		TextColor3 = Theme.Text,
		FontFace = face(),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Size = UDim2.new(1, -30, 1, 0),
		Parent = composer,
	})

	local send = new("TextButton", {
		Name = "Send",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		Parent = composer,
	})

	local sendGlyph, _, sendTint = icon({
		Parent = send,
		Color = Theme.Accent,
		Size = 15,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, "send")

	Library:OnAccent(function()
		sendGlyph[sendTint] = Theme.Accent
	end)

	local messageCount = 0

	local function joinCard(parent, meta)
		local card = new("Frame", {
			Name = "Join",
			BackgroundColor3 = Theme.Control,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 34),
			Size = UDim2.new(1, 0, 0, 30),
			Parent = parent,
		}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5), padding(0, 10) })

		text({
			Name = "Place",
			Text = meta.placeLabel or "their server",
			TextColor3 = Theme.Muted,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Size = UDim2.new(1, -60, 1, 0),
			Parent = card,
		})

		local join = new("TextButton", {
			Name = "JoinButton",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Accent,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(52, 20),
			Parent = card,
		}, { corner(4) })

		Library:OnAccent(function()
			join.BackgroundColor3 = Theme.Accent
		end)

		text({
			Name = "Label",
			Text = "Join",
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromScale(1, 1),
			Parent = join,
		})

		Library:Connect(join.MouseButton1Click, function()
			if not Library:JoinServer(tonumber(meta.placeId), meta.jobId) then
				self:Notify("could not join that server", "error")
			end
		end)

		return card
	end

	function tab:PushMessage(author, content, hub, meta, kind)
		empty.Visible = false
		messageCount += 1

		local entry = new("Frame", {
			Name = "Message",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = messageCount,
			Parent = feed,
		})

		text({
			Name = "Author",
			Text = hub and string.format("%s  ·  %s", author, hub) or author,
			FontFace = face(Enum.FontWeight.SemiBold),
			TextSize = 12,
			Size = UDim2.new(1, 0, 0, 15),
			Parent = entry,
		})

		text({
			Name = "Body",
			Text = content,
			TextColor3 = Theme.Muted,
			TextSize = 12,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			Position = UDim2.fromOffset(0, 16),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = entry,
		})

		if kind == "share_join" and type(meta) == "table" and meta.jobId then
			entry.Size = UDim2.new(1, 0, 0, 68)
			entry.AutomaticSize = Enum.AutomaticSize.None
			joinCard(entry, meta)
		end

		return entry
	end

	local function drain()
		Library:FetchChat(function(ok, messages)
			if not ok or #messages == 0 then
				return
			end

			local away = self.ActiveTab ~= tab or tab.Subpage ~= "Chat"
			for _, message in messages do
				local meta = message.meta
				local body = Library:Censor(message.body or "")
				local author = message.displayName or "Anonymous"

				tab:PushMessage(
					author,
					body,
					type(meta) == "table" and meta.hub or nil,
					meta,
					message.kind
				)

				if Library.Chat.Notify and away then
					self:Notify(string.format("%s: %s", author, body), "info")
				end
			end

			task.defer(function()
				feed.CanvasPosition = Vector2.new(0, feed.AbsoluteCanvasSize.Y)
			end)
		end)
	end

	local function connect()
		if Library.Chat.Token then
			drain()
			Library:Heartbeat()
			return
		end

		Library:OpenChatSession(function(ok, message)
			if ok then
				drain()
				Library:Heartbeat()
				Library:AgentHello()
			else
				self:Notify(message, "error")
			end
		end)
	end

	local function submit()
		local content = box.Text
		if content == "" then
			return
		end

		box.Text = ""
		Library:SendChat(content, function(ok, result)
			if ok then
				drain()
			else
				self:Notify(result, "error")
			end
		end)
	end

	local invite = new("TextButton", {
		Name = "Invite",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -28, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		Parent = composer,
	})

	local inviteGlyph, _, inviteTint = icon({
		Parent = invite,
		Color = Theme.Dim,
		Size = 15,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, "user-plus")

	Library:Connect(invite.MouseEnter, function()
		tween(inviteGlyph, { [inviteTint] = Theme.Text }, Motion.Quick)
	end)

	Library:Connect(invite.MouseLeave, function()
		tween(inviteGlyph, { [inviteTint] = Theme.Dim }, Motion.Quick)
	end)

	Library:Connect(invite.MouseButton1Click, function()
		Library:ShareJoin(function(ok, result)
			if ok then
				drain()
			else
				self:Notify(result, "error")
			end
		end)
	end)

	box.Size = UDim2.new(1, -58, 1, 0)

	Library:Connect(send.MouseButton1Click, submit)
	Library:Connect(box.FocusLost, function(enterPressed)
		if enterPressed then
			submit()
		end
	end)

	local pollElapsed, presenceElapsed = 0, 0
	Library:Connect(RunService.Heartbeat, function(dt)
		presenceElapsed += dt
		if presenceElapsed >= Metrics.PresencePoll then
			presenceElapsed = 0
			Library:Heartbeat()
		end

		if self.ActiveTab ~= tab or not Library.Chat.Token then
			return
		end

		pollElapsed += dt
		if pollElapsed < Metrics.ChatPoll then
			return
		end
		pollElapsed = 0
		drain()
	end)

	local players = tab:AddSubpage("Players")
	local shared = tab:AddSubpage("Configs")

	-- These two lists own their own rows outright. The Section helpers keep row
	-- bookkeeping that a repeated rebuild corrupts, so a plain card with a body
	-- frame is both simpler and safe to clear on every refresh.
	local function panel(holder, title)
		local card = new("Frame", {
			Name = title,
			BackgroundColor3 = Theme.Card,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = holder,
		}, { corner(Metrics.CardRadius), stroke(Theme.Border, 0.6) })

		local head = new("Frame", {
			Name = "Head",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 38),
			Parent = card,
		}, { padding(0, 12) })

		local caption = text({
			Name = "Caption",
			Text = title,
			TextColor3 = Theme.Muted,
			TextSize = 12,
			Size = UDim2.new(1, -70, 1, 0),
			Parent = head,
		})

		local refresh = new("TextButton", {
			Name = "Refresh",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Control,
			BackgroundTransparency = 0.2,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(58, 20),
			Parent = head,
		}, { corner(4), stroke(Theme.Border, 0.5) })

		local refreshLabel = text({
			Name = "Label",
			Text = "Refresh",
			TextColor3 = Theme.Muted,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromScale(1, 1),
			Parent = refresh,
		})

		Library:Connect(refresh.MouseEnter, function()
			tween(refresh, { BackgroundTransparency = 0 }, Motion.Quick)
			tween(refreshLabel, { TextColor3 = Theme.Text }, Motion.Quick)
		end)

		Library:Connect(refresh.MouseLeave, function()
			tween(refresh, { BackgroundTransparency = 0.2 }, Motion.Quick)
			tween(refreshLabel, { TextColor3 = Theme.Muted }, Motion.Quick)
		end)

		local body = new("Frame", {
			Name = "Body",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 38),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = card,
		}, {
			new("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})

		return { Card = card, Body = body, Caption = caption, Refresh = refresh }
	end

	local function clearBody(body)
		for _, child in body:GetChildren() do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
	end

	local function emptyRow(body, message)
		local row = new("Frame", {
			Name = "Empty",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 40),
			LayoutOrder = 1,
			Parent = body,
		}, { padding(0, 12) })

		text({
			Name = "Label",
			Text = message,
			TextColor3 = Theme.Dim,
			TextSize = 12,
			Size = UDim2.fromScale(1, 1),
			Parent = row,
		})
	end

	local function listRow(body, order, title, subtitle, actionText, primary, onAction)
		local row = new("Frame", {
			Name = "Row" .. order,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 44),
			LayoutOrder = order,
			Parent = body,
		}, { padding(0, 12) })

		if order > 1 then
			new("Frame", {
				Name = "Hairline",
				BackgroundColor3 = Theme.Divider,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Parent = row,
			})
		end

		text({
			Name = "Title",
			Text = title,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(0, 8),
			Size = UDim2.new(1, -78, 0, 15),
			Parent = row,
		})

		text({
			Name = "Sub",
			Text = subtitle,
			TextColor3 = Theme.Dim,
			TextSize = 11,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(0, 23),
			Size = UDim2.new(1, -78, 0, 13),
			Parent = row,
		})

		if not actionText then
			return row
		end

		local button = new("TextButton", {
			Name = "Action",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = primary and Theme.Accent or Theme.Control,
			BackgroundTransparency = primary and 0 or 0.2,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(64, 22),
			Parent = row,
		}, { corner(4), stroke(Theme.Border, 0.5) })

		local label = text({
			Name = "Label",
			Text = actionText,
			TextColor3 = primary and Theme.Text or Theme.Muted,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromScale(1, 1),
			Parent = button,
		})

		if primary then
			Library:OnAccent(function()
				button.BackgroundColor3 = Theme.Accent
			end)
		end

		Library:Connect(button.MouseEnter, function()
			tween(button, { BackgroundTransparency = primary and 0.15 or 0 }, Motion.Quick)
			tween(label, { TextColor3 = Theme.Text }, Motion.Quick)
		end)

		Library:Connect(button.MouseLeave, function()
			tween(button, { BackgroundTransparency = primary and 0 or 0.2 }, Motion.Quick)
			tween(label, { TextColor3 = primary and Theme.Text or Theme.Muted }, Motion.Quick)
		end)

		Library:Connect(button.MouseButton1Click, onAction)
		return row
	end

	-- the subpage holder lays its two columns out by offset and carries no layout of
	-- its own, so a full width panel needs a container that stacks and bounds it
	local function contentColumn(holder)
		return new("Frame", {
			Name = "Content",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(tab.ColumnWidth * 2 + Metrics.ColumnGap, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = holder,
		}, {
			new("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, Metrics.SectionGap),
			}),
		})
	end

	local rosterPanel = panel(contentColumn(players.Holder), "Online now")
	local sharedColumn = contentColumn(shared.Holder)
	local sharedPanel = panel(sharedColumn, "Shared configs for this game")

	local function refreshPlayers()
		Library:FetchPlayers(function(ok, list)
			clearBody(rosterPanel.Body)

			if not ok then
				emptyRow(rosterPanel.Body, "could not reach the server")
				return
			end

			rosterPanel.Caption.Text = string.format("Online now  ·  %d", #list)

			if #list == 0 then
				emptyRow(rosterPanel.Body, "nobody else is online right now")
				return
			end

			for order, entry in list do
				local joinable = entry.shareJoin == true and entry.jobId ~= nil
				listRow(
					rosterPanel.Body,
					order,
					entry.displayName or "Anonymous",
					entry.placeLabel or "in a game",
					joinable and "Join" or nil,
					joinable,
					function()
						if not Library:JoinServer(tonumber(entry.placeId), entry.jobId) then
							self:Notify("could not join that server", "error")
						end
					end
				)
			end
		end)
	end

	local function refreshShared()
		Library:ListSharedConfigs(function(ok, list)
			clearBody(sharedPanel.Body)

			if not ok then
				emptyRow(sharedPanel.Body, "could not reach the server")
				return
			end

			if #list == 0 then
				emptyRow(sharedPanel.Body, "nothing shared for this game yet")
				return
			end

			for order, entry in list do
				listRow(
					sharedPanel.Body,
					order,
					entry.name or "preset",
					entry.author or "Anonymous",
					"Install",
					false,
					function()
						Library:InstallSharedConfig(entry.configId, reportTo(self))
					end
				)
			end
		end)
	end

	Library:Connect(rosterPanel.Refresh.MouseButton1Click, refreshPlayers)
	Library:Connect(sharedPanel.Refresh.MouseButton1Click, refreshShared)

	local shareRow = new("Frame", {
		Name = "Share",
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 26),
		Parent = sharedColumn,
	})

	local shareButton = new("TextButton", {
		Name = "ShareButton",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Accent,
		Size = UDim2.new(1, 0, 0, 26),
		Parent = shareRow,
	}, { corner(Metrics.ControlRadius), stroke(Theme.Border, 0.5) })

	text({
		Name = "Label",
		Text = "Share my current config",
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.fromScale(1, 1),
		Parent = shareButton,
	})

	Library:OnAccent(function()
		shareButton.BackgroundColor3 = Theme.Accent
	end)

	Library:Connect(shareButton.MouseEnter, function()
		tween(shareButton, { BackgroundTransparency = 0.15 }, Motion.Quick)
	end)

	Library:Connect(shareButton.MouseLeave, function()
		tween(shareButton, { BackgroundTransparency = 0 }, Motion.Quick)
	end)

	Library:Connect(shareButton.MouseButton1Click, function()
		local player = Players.LocalPlayer
		local name = string.format("%s %s", player and player.DisplayName or "Nova", os.date("%m/%d %H:%M"))
		Library:ShareConfig(name, function(ok, message)
			self:Notify(message, ok and "info" or "error")
			if ok then
				refreshShared()
			end
		end)
	end)

	local baseShowSubpage = tab.ShowSubpage
	function tab:ShowSubpage(name)
		baseShowSubpage(self, name)
		local onChat = name == "Chat"
		feed.Visible = onChat
		composer.Visible = onChat
		-- the chat feed sits on the page itself, every other subpage lives in the
		-- scroller, so the scroller has to come back whenever chat is not showing
		self.Scroller.Visible = not onChat
		if name == "Players" then
			refreshPlayers()
		elseif name == "Configs" then
			refreshShared()
		end
	end

	self:AddSubtabStrip(tab, { "Chat", "Players", "Configs" })
	tab:ShowSubpage("Chat")

	local agentElapsed = 0
	Library:Connect(RunService.Heartbeat, function(dt)
		if Library.Chat.Dashboard ~= false then
			agentElapsed += dt
			if agentElapsed >= Metrics.AgentPoll then
				agentElapsed = 0
				Library:AgentPoll(function(ok, commands)
					if not ok or Library.Chat.Dashboard == false then
						return
					end
					for _, command in commands do
						local ran, result = self:RunCommand(command)
						Library:AgentResult(command.id, ran, result)
					end
				end)
			end
		end
	end)

	tab.OnSelect = function()
		connect()
		refreshPlayers()
		refreshShared()
	end
	tab.Feed = feed
	tab.Composer = composer
	tab.Input = box
	tab.RefreshPlayers = refreshPlayers
	tab.RefreshShared = refreshShared

	self.ChatTab = tab
	return tab
end

local KeyMessages = {
	KEY_EXPIRED = "that key has expired, get a new one",
	KEY_BANNED = "that key is blacklisted",
	KEY_HWID_LOCKED = "that key is locked to another device. reset your hwid, then try again",
	KEY_INCORRECT = "that key does not exist, check you copied all of it",
	KEY_INVALID = "that is not a key, they are 32 characters long",
	INVALID_EXECUTOR = "luarmor does not support this executor",
	TIME_ERROR = "your system clock is off, fix it and try again",
}

local function keyPath()
	return string.format("%s/%s", Library.Folder, Metrics.KeyFile)
end

local function readSavedKey()
	if not filesystemReady() or not isfile(keyPath()) then
		return nil
	end
	local ok, body = pcall(readfile, keyPath())
	return ok and type(body) == "string" and string.match(body, "^%s*(%S+)%s*$") or nil
end

local function rememberKey(key)
	if not filesystemReady() then
		return
	end
	ensureFolder(Library.Folder)
	pcall(writefile, keyPath(), key)
end

local function publishKey(key)
	local env = type(getgenv) == "function" and getgenv() or _G
	env.script_key = key
end

local function loadLuarmor(scriptId)
	local ok, api = pcall(function()
		return loadstring(game:HttpGet(Metrics.LuarmorSdk))()
	end)
	if not ok or api == nil then
		return nil
	end
	api.script_id = scriptId
	return api
end

local function keySeconds(status)
	local expire = status.data and tonumber(status.data.auth_expire) or 0
	return expire > 0 and math.max(expire - os.time(), 0) or math.huge
end

local KeyStages = { "Loading", "Connecting to Server", "Verifying Device" }

function Library:KeySystem(config)
	config = config or {}

	local known = Metrics.LuarmorScripts[game.GameId]
	local scriptId = config.ScriptId or (known and known.Id) or Metrics.LuarmorMain
	local mainName = Metrics.MainGames[game.GameId]
	local supported = config.ScriptId ~= nil or known ~= nil or mainName ~= nil
	local gameName = config.GameName or (known and known.Name) or mainName
	local site = config.Site or Metrics.KeySite
	local discord = config.Discord or Metrics.KeyDiscord
	local keyLink = config.KeyLink or Metrics.KeyLink
	local execName = executorName()
	local api

	local function verify(key)
		api = api or loadLuarmor(scriptId)
		if api then
			local ok, status = pcall(api.check_key, key)
			if ok and type(status) == "table" and type(status.code) == "string" then
				return status
			end
		end
		return { code = "REQUEST_FAILED", message = "could not reach luarmor, try again" }
	end

	local identity = readDiscord()
	local onIdentity

	local function accept(key, status)
		publishKey(key)
		rememberKey(key)
		self.LuarmorSecondsLeft = keySeconds(status)

	end

	local function resolveIdentity(key)
		local thread = coroutine.running()
		local settled, waiting = false, false

		local function settle()
			if settled then
				return
			end
			settled = true
			if waiting then
				task.spawn(thread)
			end
		end

		self:FetchKeyProfile(key, function(profile)
			if not profile then
				settle()
				return
			end

			identity = profile
			if onIdentity then
				onIdentity()
			end
			if not (profile.avatar and imagesSupported()) then
				settle()
				return
			end
			self:RequestImage(self:DiscordAvatarPath(profile), self:DiscordAvatarUrl(profile), settle)
		end)

		if identity or settled then
			return
		end
		task.delay(Metrics.KeyProfileTimeout, settle)
		waiting = true
		coroutine.yield()
	end

	local preset = luarmorGlobal("script_key")
	local saved = preset and tostring(preset) or readSavedKey()

	local env = type(getgenv) == "function" and getgenv() or _G
	local finished, closed, busy = false, false, false
	local result
	local done = new("BindableEvent", {})

	local width = Metrics.KeyWidth
	local pad = Metrics.KeyPadding
	local inner = width - pad * 2
	local gui = hostGui("NovaKey")

	local scrim = new("Frame", {
		Name = "Scrim",
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = gui,
	})

	local card = new("CanvasGroup", {
		Name = "Key",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Theme.Window,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = gui,
	}, { corner(Metrics.WindowRadius) })

	local cardStroke = stroke(Theme.Border, 1)
	cardStroke.Parent = card

	local scale = new("UIScale", { Scale = Metrics.ClosedScale, Parent = card })

	local close = iconButton(card, "x", 26, Theme.Danger)
	close.AnchorPoint = Vector2.new(1, 0.5)
	close.Position = UDim2.new(1, -pad + 6, 0, Metrics.KeyStripHeight / 2)
	close.ZIndex = 5

	local function wordmark(parent, size, alignment)
		local row = new("Frame", {
			Name = "Brand",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Parent = parent,
		}, {
			new("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = alignment,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, size * 0.3),
			}),
		})

		local letters = string.upper(config.Title or "Title")
		local order = 0
		for first, last in utf8.graphemes(letters) do
			order += 1
			text({
				Name = "Letter",
				Text = string.sub(letters, first, last),
				FontFace = face(Enum.FontWeight.Bold),
				TextSize = size,
				TextXAlignment = Enum.TextXAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				LayoutOrder = order,
				Parent = row,
			})
		end
		return row
	end

	local cursor = 0
	local function place(height, gap)
		local top = cursor
		cursor += height + (gap or 0)
		return top
	end

	local loader = new("CanvasGroup", {
		Name = "Loader",
		BackgroundTransparency = 1,
		Parent = card,
	})

	cursor = 30
	local tile = new("ImageLabel", {
		Name = "Mark",
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Crop,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, place(Metrics.KeyTileSize, 14)),
		Size = UDim2.fromOffset(Metrics.KeyTileSize, Metrics.KeyTileSize),
		Parent = loader,
	}, { corner(14) })

	local tileStroke = stroke(Theme.Accent, 0.3)
	tileStroke.Parent = tile
	tween(tileStroke, { Transparency = 0.85 }, Motion.Breathe)

	Library:RequestImage(string.format("%s/brand.png", Library.Folder), Metrics.Logo, function(asset)
		tile.Image = asset
	end)

	new("Frame", {
		Name = "BrandRow",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, place(20, 10)),
		Size = UDim2.new(1, 0, 0, 20),
		Parent = loader,
	}, { wordmark(nil, 17, Enum.HorizontalAlignment.Center) })

	local detected = new("CanvasGroup", {
		Name = "Detected",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, place(24, 22)),
		Size = UDim2.fromOffset(0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = loader,
	}, {
		corner(12),
		padding(0, 10),
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
		}),
	})

	local detectedStroke = stroke(Theme.Border, 1)
	detectedStroke.Parent = detected

	local detectedIcon, _, detectedTint = icon({
		Parent = detected,
		Color = Theme.Accent,
		Size = 12,
		LayoutOrder = 1,
	}, "gamepad-2")

	local detectedCaption = text({
		Name = "Caption",
		Text = "Game detected",
		TextColor3 = Theme.Dim,
		TextSize = 11,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		LayoutOrder = 2,
		Parent = detected,
	})

	local gameLabel = text({
		Name = "Game",
		Text = "",
		FontFace = face(Enum.FontWeight.SemiBold),
		TextSize = 11,
		TextTruncate = Enum.TextTruncate.AtEnd,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		LayoutOrder = 3,
		Parent = detected,
	}, { new("UISizeConstraint", { MaxSize = Vector2.new(190, math.huge) }) })

	local stageRow = new("Frame", {
		Name = "Stage",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(pad, place(18, 10)),
		Size = UDim2.fromOffset(inner, 18),
		Parent = loader,
	})

	local stageLabel = text({
		Name = "Label",
		Text = "",
		TextTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = stageRow,
	})

	local counterLabel = text({
		Name = "Counter",
		Text = "",
		TextColor3 = Theme.Dim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.fromScale(1, 1),
		Parent = stageRow,
	})

	local segmentGap = 6
	local segmentWidth = (inner - segmentGap * (#KeyStages - 1)) / #KeyStages
	local segmentTop = place(3, 14)
	local fills = table.create(#KeyStages)

	for index = 1, #KeyStages do
		local track = new("Frame", {
			Name = "Segment" .. index,
			BackgroundColor3 = Theme.Track,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromOffset(pad + (index - 1) * (segmentWidth + segmentGap), segmentTop),
			Size = UDim2.fromOffset(segmentWidth, 3),
			Parent = loader,
		}, { corner(2) })

		fills[index] = new("Frame", {
			Name = "Fill",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 1),
			Parent = track,
		}, {
			corner(2),
			new("UIGradient", {
				Color = ColorSequence.new(Theme.Accent, Theme.AccentLift),
			}),
		})
	end

	local linksTop = place(14, 18)
	for link, alignment in { [site] = Enum.TextXAlignment.Left, [discord] = Enum.TextXAlignment.Right } do
		text({
			Name = link,
			Text = link,
			TextColor3 = Theme.Dim,
			TextSize = 11,
			TextXAlignment = alignment,
			Position = UDim2.fromOffset(pad, linksTop),
			Size = UDim2.fromOffset(inner, 14),
			Parent = loader,
		})
	end

	local loaderHeight = cursor
	loader.Size = UDim2.new(1, 0, 0, loaderHeight)

	local formWidth = Metrics.KeyFormWidth
	local sideWidth = Metrics.KeySideWidth
	local sidePad = 16
	local mainInner = formWidth - sideWidth - pad * 2
	local sideInner = sideWidth - sidePad * 2

	local form = new("CanvasGroup", {
		Name = "Form",
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Visible = false,
		Parent = card,
	})

	local main = new("Frame", {
		Name = "Main",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(pad, pad),
		Parent = form,
	})

	cursor = 0
	local brandTop = place(36, 22)
	local mark = new("ImageLabel", {
		Name = "Mark",
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Crop,
		Position = UDim2.fromOffset(0, brandTop),
		Size = UDim2.fromOffset(36, 36),
		Parent = main,
	}, { corner(10), stroke(Theme.Border, 0.5) })

	Library:RequestImage(string.format("%s/brand.png", Library.Folder), Metrics.Logo, function(asset)
		mark.Image = asset
	end)

	new("Frame", {
		Name = "BrandRow",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(48, brandTop),
		Size = UDim2.fromOffset(mainInner - 48, 20),
		Parent = main,
	}, { wordmark(nil, 17, Enum.HorizontalAlignment.Left) })

	text({
		Name = "Subtitle",
		Text = "Key system",
		TextColor3 = Theme.Dim,
		TextSize = 11,
		Position = UDim2.fromOffset(48, brandTop + 22),
		Size = UDim2.fromOffset(mainInner - 48, 14),
		Parent = main,
	})

	text({
		Name = "FieldCaption",
		Text = "License key",
		TextColor3 = Theme.Muted,
		TextSize = 11,
		Position = UDim2.fromOffset(0, place(14, 6)),
		Size = UDim2.new(1, 0, 0, 14),
		Parent = main,
	})

	local field = new("Frame", {
		Name = "Field",
		BackgroundColor3 = Theme.Control,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, place(Metrics.KeyFieldHeight, 12)),
		Size = UDim2.new(1, 0, 0, Metrics.KeyFieldHeight),
		Parent = main,
	}, { corner(Metrics.ControlRadius) })

	local fieldStroke = stroke(Theme.Border, 0.5)
	fieldStroke.Parent = field

	icon({
		Parent = field,
		Color = Theme.Dim,
		Size = 14,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 11, 0.5, 0),
	}, "key-round")

	local box = new("TextBox", {
		Name = "Input",
		Text = saved or "",
		PlaceholderText = "32 character key",
		PlaceholderColor3 = Theme.Dim,
		TextColor3 = Theme.Text,
		FontFace = face(),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -11, 0.5, 0),
		Size = UDim2.new(1, -44, 1, 0),
		Parent = field,
	})

	local buttonTop = place(Metrics.KeyButtonHeight, 10)
	local buttonSize = UDim2.new(0.5, -4, 0, Metrics.KeyButtonHeight)

	local confirm = new("TextButton", {
		Name = "Continue",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, buttonTop),
		Size = buttonSize,
		Parent = main,
	}, { corner(Metrics.ControlRadius) })

	local confirmLabel = text({
		Name = "Label",
		Text = "Continue",
		FontFace = face(Enum.FontWeight.SemiBold),
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.fromScale(1, 1),
		Parent = confirm,
	})

	local statusLabel = text({
		Name = "Status",
		Text = "",
		TextColor3 = Theme.Muted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Position = UDim2.fromOffset(0, place(Metrics.KeyStatusHeight, 8)),
		Size = UDim2.new(1, 0, 0, Metrics.KeyStatusHeight),
		Parent = main,
	})

	text({
		Name = "Hint",
		Text = config.Caption or "your key is saved, you only enter it once",
		TextColor3 = Theme.Dim,
		TextSize = 11,
		Position = UDim2.fromOffset(0, place(14)),
		Size = UDim2.new(1, 0, 0, 14),
		Parent = main,
	})

	local mainHeight = cursor
	main.Size = UDim2.fromOffset(mainInner, mainHeight)

	local side = new("Frame", {
		Name = "Side",
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, sideWidth, 1, 0),
		Parent = form,
	}, {
		new("Frame", {
			Name = "Edge",
			BackgroundColor3 = Theme.Divider,
			BorderSizePixel = 0,
			Size = UDim2.new(0, Metrics.RailEdge, 1, 0),
		}),
	})

	cursor = pad
	text({
		Name = "GameCaption",
		Text = "Detected game",
		TextColor3 = Theme.Dim,
		TextSize = 11,
		Position = UDim2.fromOffset(sidePad, place(14, 8)),
		Size = UDim2.fromOffset(sideInner, 14),
		Parent = side,
	})

	local gameCard = new("Frame", {
		Name = "Game",
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(sidePad, place(52, 12)),
		Size = UDim2.fromOffset(sideInner, 52),
		Parent = side,
	}, { corner(Metrics.CardRadius), stroke(Theme.Border, 0.6) })

	new("ImageLabel", {
		Name = "Icon",
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		Image = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", game.GameId),
		Position = UDim2.fromOffset(8, 8),
		Size = UDim2.fromOffset(36, 36),
		Parent = gameCard,
	}, { corner(7) })

	local gameTitle = text({
		Name = "Title",
		Text = "",
		FontFace = face(Enum.FontWeight.SemiBold),
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Position = UDim2.fromOffset(52, 10),
		Size = UDim2.new(1, -60, 0, 15),
		Parent = gameCard,
	})

	text({
		Name = "Support",
		Text = "Supported",
		TextColor3 = Theme.AccentLift,
		TextSize = 11,
		Position = UDim2.fromOffset(52, 27),
		Size = UDim2.new(1, -60, 0, 14),
		Parent = gameCard,
	})

	local function fact(label, value)
		local top = place(22)
		text({
			Name = label,
			Text = label,
			TextColor3 = Theme.Dim,
			TextSize = 11,
			Position = UDim2.fromOffset(sidePad, top),
			Size = UDim2.fromOffset(sideInner, 22),
			Parent = side,
		})
		return text({
			Name = label .. "Value",
			Text = value,
			FontFace = face(Enum.FontWeight.SemiBold),
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(sidePad + 64, top),
			Size = UDim2.fromOffset(sideInner - 64, 22),
			Parent = side,
		})
	end

	local player = Players.LocalPlayer
	fact("Executor", executorName())
	fact("Account", identity and identity.username or player and player.DisplayName or "Player")
	local keyState = fact("Status", "Key required")
	keyState.TextColor3 = Theme.Muted

	cursor += 8
	new("Frame", {
		Name = "Divider",
		BackgroundColor3 = Theme.Divider,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(sidePad, place(1, 8)),
		Size = UDim2.fromOffset(sideInner, 1),
		Parent = side,
	})

	local links = {}
	local function linkRow(title, link, iconName)
		local button = new("TextButton", {
			Name = title,
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Hover,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(sidePad - 8, place(38, 2)),
			Size = UDim2.fromOffset(sideInner + 16, 38),
			Parent = side,
		}, { corner(Metrics.ControlRadius) })

		local glyph, _, tintKey = icon({
			Parent = button,
			Color = Theme.Muted,
			Size = 15,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 10, 0.5, 0),
		}, iconName)

		text({
			Name = "Title",
			Text = title,
			TextSize = 12,
			Position = UDim2.fromOffset(36, 4),
			Size = UDim2.new(1, -44, 0, 15),
			Parent = button,
		})

		text({
			Name = "Link",
			Text = link,
			TextColor3 = Theme.Dim,
			TextSize = 11,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(36, 19),
			Size = UDim2.new(1, -44, 0, 14),
			Parent = button,
		})

		button.MouseEnter:Connect(function()
			tween(button, { BackgroundTransparency = 0 }, Motion.Quick)
			tween(glyph, { [tintKey] = Theme.Text }, Motion.Quick)
		end)
		button.MouseLeave:Connect(function()
			tween(button, { BackgroundTransparency = 1 }, Motion.Quick)
			tween(glyph, { [tintKey] = Theme.Muted }, Motion.Quick)
		end)

		links[link] = button
	end

	linkRow("Discord", discord, "message-circle")
	linkRow("Website", site, "globe")

	local formHeight = math.max(mainHeight + pad * 2, cursor + sidePad - 2)
	form.Size = UDim2.new(1, 0, 0, formHeight)

	local height = loaderHeight
	card.Size = UDim2.fromOffset(width, height)

	local function setStatus(message, color)
		statusLabel.Text = message
		statusLabel.TextColor3 = color
		statusLabel.TextTransparency = 1
		tween(statusLabel, { TextTransparency = 0 }, Motion.Quick)
	end

	local function setKeyState(label, color)
		keyState.Text = label
		tween(keyState, { TextColor3 = color }, Motion.Quick)
	end

	local function fail(message, state)
		tween(fieldStroke, { Color = Theme.Danger, Transparency = 0.3 }, Motion.Quick)
		setStatus(message, Theme.Danger)
		setKeyState(state or "Key required", state and Theme.Danger or Theme.Muted)
	end

	local function copyLink(link)
		local url = string.match(link, "^https?://") and link or "https://" .. link
		if type(setclipboard) == "function" and pcall(setclipboard, url) then
			setStatus(link .. " copied, open it in your browser", Theme.Muted)
			return
		end
		setStatus("open " .. link .. " in your browser", Theme.Muted)
	end

	local function fitScale()
		local viewport = gui.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			return 1
		end
		return math.min(
			1,
			(viewport.X - Metrics.FitMargin * 2) / width,
			(viewport.Y - Metrics.FitMargin * 2) / height
		)
	end

	local function finish()
		if finished then
			return
		end
		finished = true

		if env.NovaKeyHandoff == finish then
			env.NovaKeyHandoff = nil
		end

		tween(scrim, { BackgroundTransparency = 1 }, Motion.Smooth)
		tween(cardStroke, { Transparency = 1 }, Motion.Smooth)
		tween(scale, { Scale = fitScale() * Metrics.ClosedScale }, Motion.Smooth)

		local fade = tween(card, { GroupTransparency = 1 }, Motion.Smooth)
		fade.Completed:Once(function()
			gui:Destroy()
			closed = true
			done:Fire()
			done:Destroy()
		end)
	end

	local release

	local function awaitClosed()
		if not closed and not release then
			done.Event:Wait()
		end
		return result, api, release
	end

	local stageToken = 0
	local function showStage(message, counter, color)
		stageToken += 1
		local token = stageToken
		counterLabel.Text = counter

		local out = tween(stageLabel, {
			TextTransparency = 1,
			Position = UDim2.fromOffset(0, -6),
		}, Motion.Quick)
		out.Completed:Once(function()
			if token ~= stageToken then
				return
			end
			stageLabel.Text = message
			stageLabel.TextColor3 = color or Theme.Text
			stageLabel.Position = UDim2.fromOffset(0, 6)
			tween(stageLabel, { TextTransparency = 0, Position = UDim2.new() }, Motion.Smooth)
		end)
	end

	local function runStage(index, work)
		showStage(KeyStages[index], string.format("%d/%d", index, #KeyStages))
		tween(fills[index], { Size = UDim2.fromScale(0.85, 1) }, Motion.Progress)

		local started = os.clock()
		local value = work and work()
		local remaining = Metrics.KeyStageDwell - (os.clock() - started)
		if remaining > 0 then
			task.wait(remaining)
		end

		tween(fills[index], { Size = UDim2.fromScale(1, 1) }, Motion.Quick)
		return value
	end

	local function showUnsupported()
		detectedCaption.Text = "Unsupported game"
		tween(detectedIcon, { [detectedTint] = Theme.Danger }, Motion.Quick)
		tween(tileStroke, { Color = Theme.Danger }, Motion.Smooth)
		showStage("This game is not supported", "", Theme.Danger)

		local fill = fills[1]
		fill.UIGradient.Enabled = false
		fill.BackgroundColor3 = Theme.Danger
		tween(fill, { Size = UDim2.fromScale(1, 1) }, Motion.Quick)
	end

	local function showForm()
		width, height = formWidth, formHeight
		gameTitle.Text = gameName
		form.Visible = true
		form.Position = UDim2.fromOffset(0, 8)

		local fade = tween(loader, { GroupTransparency = 1 }, Motion.Quick)
		fade.Completed:Once(function()
			loader.Visible = false
		end)

		tween(card, { Size = UDim2.fromOffset(width, height) }, Motion.Smooth)
		tween(scale, { Scale = fitScale() }, Motion.Smooth)
		tween(form, { GroupTransparency = 0, Position = UDim2.new() }, Motion.Smooth)
	end

	local function showSuccess(status, greeting)
		local player = Players.LocalPlayer
		local avatarSize = Metrics.KeyAvatarSize

		for _, view in { loader, form } do
			if view.Visible then
				local fade = tween(view, { GroupTransparency = 1 }, Motion.Quick)
				fade.Completed:Once(function()
					view.Visible = false
				end)
			end
		end

		local view = new("Frame", {
			Name = "Success",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Parent = card,
		})

		cursor = 34
		local holder = new("Frame", {
			Name = "Avatar",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, place(avatarSize, 16)),
			Size = UDim2.fromOffset(avatarSize, avatarSize),
			Parent = view,
		})

		local function ping(delay)
			local ring = new("Frame", {
				Name = "Ping",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(avatarSize, avatarSize),
				Parent = holder,
			}, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })

			local ringStroke = stroke(Theme.Accent, 1, 1.5)
			ringStroke.Parent = ring

			task.delay(delay, function()
				ringStroke.Transparency = 0.2
				tween(ring, { Size = UDim2.fromOffset(avatarSize * 1.9, avatarSize * 1.9) }, Motion.Ping)
				tween(ringStroke, { Transparency = 1 }, Motion.Ping)
			end)
		end

		ping(0.12)
		ping(0.42)

		local portrait = new("ImageLabel", {
			Name = "Portrait",
			BackgroundColor3 = Theme.Control,
			BorderSizePixel = 0,
			ImageTransparency = 1,
			Image = player and string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", player.UserId) or "",
			Size = UDim2.fromScale(1, 1),
			Parent = holder,
		}, {
			new("UICorner", { CornerRadius = UDim.new(1, 0) }),
			stroke(Theme.Accent, 0.25, 1.5),
		})

		local portraitScale = new("UIScale", { Scale = 0.7, Parent = holder })
		tween(portraitScale, { Scale = 1 }, Motion.Pop)
		tween(portrait, { ImageTransparency = 0 }, Motion.Smooth)

		local badge = new("Frame", {
			Name = "Badge",
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.86, 0.86),
			Size = UDim2.fromOffset(22, 22),
			ZIndex = 2,
			Parent = holder,
		}, {
			new("UICorner", { CornerRadius = UDim.new(1, 0) }),
			stroke(Theme.Window, 0, 2),
		})

		icon({
			Parent = badge,
			Color = Theme.Knob,
			Size = 12,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		}, "check").ZIndex = 3

		local badgeScale = new("UIScale", { Scale = 0, Parent = badge })
		task.delay(0.2, tween, badgeScale, { Scale = 1 }, Motion.Pop)

		local headingTop = place(20, 12)
		local heading = text({
			Name = "Heading",
			Text = "",
			FontFace = face(Enum.FontWeight.SemiBold),
			TextSize = 16,
			TextTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(pad, headingTop + 8),
			Size = UDim2.fromOffset(inner, 20),
			Parent = view,
		})
		task.delay(0.1, tween, heading, {
			TextTransparency = 0,
			Position = UDim2.fromOffset(pad, headingTop),
		}, Motion.Smooth)

		onIdentity = function()
			local name = identity and identity.username or player and player.DisplayName or "Player"
			heading.Text = string.format("%s, %s", greeting, name)

			if identity and identity.avatar then
				Library:RequestImage(Library:DiscordAvatarPath(identity), Library:DiscordAvatarUrl(identity), function(asset)
					portrait.Image = asset
				end)
			end
		end
		onIdentity()

		local pill = new("Frame", {
			Name = "Expiry",
			BackgroundColor3 = Theme.Control,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, place(24, 28)),
			Size = UDim2.fromOffset(0, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = view,
		}, {
			corner(12),
			padding(0, 10),
			new("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
			}),
		})

		local pillStroke = stroke(Theme.Border, 1)
		pillStroke.Parent = pill

		local pillIcon, pillIconFade = icon({
			Parent = pill,
			Color = Theme.Accent,
			Size = 12,
			LayoutOrder = 1,
		}, "key-round")
		pillIcon[pillIconFade] = 1

		local pillLabel = text({
			Name = "Remaining",
			Text = string.lower(formatRemaining(keySeconds(status))),
			TextColor3 = Theme.Muted,
			TextSize = 11,
			TextTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Parent = pill,
		})

		task.delay(0.2, function()
			tween(pill, { BackgroundTransparency = 0 }, Motion.Smooth)
			tween(pillStroke, { Transparency = 0.5 }, Motion.Smooth)
			tween(pillIcon, { [pillIconFade] = 0 }, Motion.Smooth)
			tween(pillLabel, { TextTransparency = 0 }, Motion.Smooth)
		end)

		local launching = text({
			Name = "Launching",
			Text = gameName and ("Launching " .. gameName) or "Launching",
			TextColor3 = Theme.Dim,
			TextSize = 11,
			TextTransparency = 1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(pad, place(14, 8)),
			Size = UDim2.fromOffset(inner, 14),
			Parent = view,
		})
		task.delay(0.3, tween, launching, { TextTransparency = 0 }, Motion.Smooth)

		local track = new("Frame", {
			Name = "Track",
			BackgroundColor3 = Theme.Track,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromOffset(pad, place(3, 24)),
			Size = UDim2.fromOffset(inner, 3),
			Parent = view,
		}, { corner(2) })

		local fill = new("Frame", {
			Name = "Fill",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 1),
			Parent = track,
		}, {
			corner(2),
			new("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.AccentLift) }),
		})
		local baseHeight = cursor
		local errorLine = text({
			Name = "Error",
			Text = "",
			TextColor3 = Theme.Danger,
			TextSize = 11,
			TextWrapped = true,
			TextTransparency = 1,
			TextYAlignment = Enum.TextYAlignment.Top,
			Visible = false,
			Position = UDim2.fromOffset(pad, baseHeight + 6),
			Size = UDim2.fromOffset(inner, 34),
			Parent = view,
		})

		width, height = Metrics.KeyWidth, baseHeight
		tween(card, { Size = UDim2.fromOffset(width, height) }, Motion.Smooth)
		tween(scale, { Scale = fitScale() }, Motion.Smooth)

		if not config.Preload then
			tween(fill, { Size = UDim2.fromScale(1, 1) }, TweenInfo.new(Metrics.KeyDismiss, Enum.EasingStyle.Linear))
			task.delay(Metrics.KeyDismiss, finish)
			return
		end

		local progress = tween(fill, { Size = UDim2.fromScale(0.9, 1) }, Motion.Launch)
		local handedOff = false

		local function showLoadError(stage, detail)
			if finished or handedOff then
				return
			end
			progress:Cancel()
			fill.UIGradient.Enabled = false
			fill.BackgroundColor3 = Theme.Danger
			tween(fill, { Size = UDim2.fromScale(1, 1) }, Motion.Quick)

			launching.Text = "the script did not start. press F9, then send the red line below in a ticket"
			tween(launching, { TextColor3 = Theme.Muted }, Motion.Quick)

			errorLine.Text = string.format("%s | game %d | %s | %s", stage, game.GameId, execName, tostring(detail or "no window opened"))
			errorLine.Visible = true
			tween(errorLine, { TextTransparency = 0 }, Motion.Quick)

			height = baseHeight + 44
			tween(card, { Size = UDim2.fromOffset(width, height) }, Motion.Smooth)
			tween(scale, { Scale = fitScale() }, Motion.Smooth)

			warn(string.format("[Nova] loader: script did not start (%s) game=%d exec=%s detail=%s", stage, game.GameId, execName, tostring(detail)))
			self:ReportLoaderFail(stage, detail)
		end

		env.NovaKeyHandoff = function()
			handedOff = true
			finish()
		end

		task.delay(Metrics.KeyHandoffTimeout, function()
			showLoadError("script_timeout", "window not built within " .. Metrics.KeyHandoffTimeout .. "s")
		end)

		release = function(loaded, problem)
			if handedOff or finished then
				return
			end
			if loaded == false then
				showLoadError("script_error", problem)
				return
			end
			task.delay(Metrics.KeyHandoffGrace, function()
				showLoadError("script_timeout", "script finished without building a window")
			end)
		end
		done:Fire()
	end

	local function submit()
		if busy or finished or result then
			return
		end

		local key = string.match(box.Text, "^%s*(.-)%s*$")
		if key == "" then
			fail("paste a key first")
			return
		end

		busy = true
		confirmLabel.Text = "Checking"
		setKeyState("Checking", Theme.Text)
		tween(confirm, { BackgroundTransparency = 0.5 }, Motion.Quick)
		setStatus("", Theme.Muted)

		local status = verify(key)
		busy = false
		if finished then
			return
		end

		if status.code ~= "KEY_VALID" then
			confirmLabel.Text = "Continue"
			tween(confirm, { BackgroundTransparency = 0 }, Motion.Quick)
			fail(KeyMessages[status.code] or status.message or status.code, "Key rejected")
			return
		end

		accept(key, status)
		result = status
		resolveIdentity(key)
		if finished then
			return
		end
		showSuccess(status, "Welcome")
	end

	confirm.MouseEnter:Connect(function()
		if not busy then
			tween(confirm, { BackgroundTransparency = 0.12 }, Motion.Quick)
		end
	end)
	confirm.MouseLeave:Connect(function()
		if not busy then
			tween(confirm, { BackgroundTransparency = 0 }, Motion.Quick)
		end
	end)
	confirm.MouseButton1Click:Connect(submit)
	close.MouseButton1Click:Connect(finish)

	box.Focused:Connect(function()
		tween(field, { BackgroundTransparency = 0 }, Motion.Quick)
		tween(fieldStroke, { Color = Theme.Accent, Transparency = 0.35 }, Motion.Quick)
	end)
	box.FocusLost:Connect(function(enterPressed)
		tween(field, { BackgroundTransparency = 0.2 }, Motion.Quick)
		tween(fieldStroke, { Color = Theme.Border, Transparency = 0.5 }, Motion.Quick)
		if enterPressed then
			submit()
		end
	end)

	local getKey, getKeyLabel = dialogButton(main, "Get key", 1, false)
	getKey.AnchorPoint = Vector2.new()
	getKey.Position = UDim2.fromOffset(0, buttonTop)
	getKey.Size = buttonSize
	getKeyLabel.FontFace = face(Enum.FontWeight.SemiBold)

	getKey.MouseButton1Click:Connect(function()
		copyLink(keyLink)
	end)

	for link, button in links do
		button.MouseButton1Click:Connect(function()
			copyLink(link)
		end)
	end

	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if not finished then
			scale.Scale = fitScale()
		end
	end)

	tween(scrim, { BackgroundTransparency = 0.5 }, Motion.Smooth)
	tween(cardStroke, { Transparency = Metrics.BorderTransparency }, Motion.Smooth)
	tween(card, { GroupTransparency = 0 }, Motion.Smooth)
	tween(scale, { Scale = fitScale() }, Motion.Smooth)

	runStage(1, function()
		if not gameName then
			local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
			gameName = ok and type(info) == "table" and info.Name or game.Name
		end
		gameLabel.Text = gameName
		tween(detected, { GroupTransparency = 0 }, Motion.Smooth)
		tween(detectedStroke, { Transparency = 0.5 }, Motion.Smooth)
	end)
	if finished then
		return awaitClosed()
	end

	if not supported then
		showUnsupported()
		return awaitClosed()
	end

	runStage(2, function()
		api = loadLuarmor(scriptId)
	end)
	if finished then
		return awaitClosed()
	end

	local status = runStage(3, saved and function()
		local reply = verify(saved)
		if reply.code == "KEY_VALID" then
			resolveIdentity(saved)
		end
		return reply
	end)
	if finished then
		return awaitClosed()
	end

	if status and status.code == "KEY_VALID" then
		accept(saved, status)
		result = status
		showSuccess(status, "Welcome back")
		return awaitClosed()
	end

	showForm()
	if status then
		fail(KeyMessages[status.code] or status.message or status.code, "Key rejected")
	elseif not api then
		fail("could not reach luarmor, try again")
	end

	return awaitClosed()
end

function Library:Unload()
	if self.Unloaded then
		return
	end
	self.Unloaded = true

	for _, connection in self.Connections do
		pcall(function()
			connection:Disconnect()
		end)
	end
	table.clear(self.Connections)

	for _, window in self.Windows do
		tween(window.RootStroke, { Transparency = 1 }, Motion.Quick)
		local fade = tween(window.Root, { GroupTransparency = 1 }, Motion.Quick)
		fade.Completed:Once(function()
			window.Gui:Destroy()
		end)
	end
	table.clear(self.Windows)
end

return Library
