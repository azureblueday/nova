local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local NewLoader = 'loadstring(game:HttpGet("https://getnova.cc/loader"))()'

local Theme = {
    Window = Color3.fromRGB(13, 11, 17),
    Card = Color3.fromRGB(19, 17, 25),
    Control = Color3.fromRGB(26, 24, 34),
    Border = Color3.fromRGB(36, 33, 46),
    Text = Color3.fromRGB(237, 236, 240),
    Muted = Color3.fromRGB(112, 110, 120),
    Dim = Color3.fromRGB(66, 64, 74),
    Accent = Color3.fromRGB(113, 0, 255),
    AccentLift = Color3.fromRGB(163, 89, 255),
}

local Motion = {
    Quick = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Pop = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

local function new(class, props, children)
    local inst = Instance.new(class)
    local parent = props.Parent
    props.Parent = nil
    for k, v in props do
        inst[k] = v
    end
    for _, child in children or {} do
        child.Parent = inst
    end
    inst.Parent = parent
    return inst
end

local function tween(inst, info, props)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

local gui = new("ScreenGui", {
    Name = "NovaNotice",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 9999,
})

if gethui then
    gui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(gui)
    gui.Parent = game:GetService("CoreGui")
else
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local card = new("CanvasGroup", {
    Parent = gui,
    GroupTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(452, 214),
    BackgroundColor3 = Theme.Window,
    BorderSizePixel = 0,
}, {
    new("UICorner", { CornerRadius = UDim.new(0, 12) }),
    new("UIStroke", { Color = Theme.Border, Transparency = 0.25 }),
})

new("Frame", {
    Parent = card,
    Position = UDim2.fromOffset(18, 0),
    Size = UDim2.new(1, -36, 0, 2),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
}, {
    new("UIGradient", {
        Color = ColorSequence.new(Theme.Accent, Theme.AccentLift),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
    }),
})

new("TextLabel", {
    Parent = card,
    Position = UDim2.fromOffset(24, 26),
    Size = UDim2.new(1, -72, 0, 22),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "this script moved",
    TextSize = 18,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
})

new("TextLabel", {
    Parent = card,
    Position = UDim2.fromOffset(24, 52),
    Size = UDim2.new(1, -48, 0, 18),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "the old link is dead. grab this one instead",
    TextSize = 13,
    TextColor3 = Theme.Muted,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local box = new("Frame", {
    Parent = card,
    Position = UDim2.fromOffset(24, 100),
    Size = UDim2.new(1, -48, 0, 50),
    BackgroundColor3 = Theme.Card,
    BorderSizePixel = 0,
}, {
    new("UICorner", { CornerRadius = UDim.new(0, 8) }),
    new("UIStroke", { Color = Theme.Border, Transparency = 0.4 }),
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
    }),
})

new("TextBox", {
    Parent = box,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    TextEditable = false,
    Font = Enum.Font.Code,
    Text = NewLoader,
    TextSize = 12,
    TextColor3 = Theme.Muted,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
})

local copy = new("TextButton", {
    Parent = card,
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -24, 1, -22),
    Size = UDim2.fromOffset(104, 32),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Font = Enum.Font.GothamMedium,
    Text = "copy",
    TextSize = 13,
    TextColor3 = Theme.Text,
}, {
    new("UICorner", { CornerRadius = UDim.new(0, 7) }),
})

local dismiss = new("TextButton", {
    Parent = card,
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 24, 1, -22),
    Size = UDim2.fromOffset(104, 32),
    BackgroundColor3 = Theme.Control,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Font = Enum.Font.GothamMedium,
    Text = "close",
    TextSize = 13,
    TextColor3 = Theme.Muted,
}, {
    new("UICorner", { CornerRadius = UDim.new(0, 7) }),
    new("UIStroke", { Color = Theme.Border, Transparency = 0.4 }),
})

local connections = {}

local function track(conn)
    connections[#connections + 1] = conn
end

local function hoverFill(button, base, hovered)
    track(button.MouseEnter:Connect(function()
        tween(button, Motion.Quick, { BackgroundColor3 = hovered })
    end))
    track(button.MouseLeave:Connect(function()
        tween(button, Motion.Quick, { BackgroundColor3 = base })
    end))
end

hoverFill(copy, Theme.Accent, Theme.AccentLift)
hoverFill(dismiss, Theme.Control, Theme.Border)

local closed = false

local function close()
    if closed then
        return
    end
    closed = true
    for _, conn in connections do
        conn:Disconnect()
    end
    tween(card, Motion.Smooth, { Size = UDim2.fromOffset(438, 208), GroupTransparency = 1 })
    task.delay(0.2, function()
        gui:Destroy()
    end)
end

local copyGeneration = 0

track(copy.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(NewLoader)
    end
    copyGeneration += 1
    local generation = copyGeneration
    copy.Text = setclipboard and "copied" or "no clipboard"
    task.delay(1.6, function()
        if generation == copyGeneration and not closed then
            copy.Text = "copy"
        end
    end)
end))

track(dismiss.MouseButton1Click:Connect(close))

track(UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Escape then
        close()
    end
end))

card.Size = UDim2.fromOffset(438, 208)
tween(card, Motion.Pop, { Size = UDim2.fromOffset(452, 214) })
tween(card, Motion.Smooth, { GroupTransparency = 0 })
