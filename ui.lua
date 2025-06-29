local library = {}
local windowCount = 0
local sizes = {}
local listOffset = {}
local windows = {}
local pastSliders = {}
local dropdowns = {}
local dropdownSizes = {}
local destroyed

local colorPickers = {}

-- Theme definitions
local themes = {
    Shadow = {
        primary = Color3.fromRGB(20, 20, 20),        -- Dark black
        secondary = Color3.fromRGB(139, 0, 0),       -- Dark red
        accent = Color3.fromRGB(220, 20, 60),        -- Crimson
        background = Color3.fromRGB(25, 25, 25),     -- Very dark gray
        text = Color3.fromRGB(255, 255, 255),        -- White text
        border = Color3.fromRGB(139, 0, 0),          -- Dark red border
        gradient = {
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(20, 20, 20)),    -- Black
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(139, 0, 0)),     -- Dark red
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(220, 20, 60))    -- Crimson
        }
    },
    Sonic = {
    primary = Color3.fromRGB(20, 20, 20),  
    secondary = Color3.fromRGB(255, 255, 255),   -- Pure white
    accent = Color3.fromRGB(0, 82, 204),        -- Sonic's shoe buckle gold
    background = Color3.fromRGB(25, 25, 25),  
    text = Color3.fromRGB(255, 255, 255),      
    border = Color3.fromRGB(0, 82, 204),         -- Sonic blue border
    gradient = {
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 82, 204)),    -- Sonic blue
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(135, 206, 250)), -- Sky blue
    }
}
}

if game.CoreGui:FindFirstChild('GGHUiLib') then
    game.CoreGui:FindFirstChild('GGHUiLib'):Destroy()
    destroyed = true
end

function Lerp(a, b, c)
    return a + ((b - a) * c)
end

local Service = setmetatable({}, {
	__call = function(GGH, key)
		return (cloneref or function(Service) return Service end)(game.GetService(game, key))
	end
})

local players = Service('Players');
local player = players.LocalPlayer;
local mouse = player:GetMouse();
local run = Service('RunService');
local stepped = run.Stepped;
local TweenService = Service("TweenService")
local UserInputService = Service("UserInputService")

-- Animation functions
local function animateIn(obj, targetProps, duration)
    duration = duration or 0.3
    local tween = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), targetProps)
    tween:Play()
    return tween
end

local function animateOut(obj, targetProps, duration)
    duration = duration or 0.2
    local tween = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.In), targetProps)
    tween:Play()
    return tween
end

-- Screen size calculation
local screenGui = game.Players.LocalPlayer.PlayerGui
local screenSize = workspace.CurrentCamera.ViewportSize
local maxWindowHeight = math.min(screenSize.Y - 100, 380) -- Max height for window (fits ~11 components)

function Dragify(obj)
	spawn(function()
		local minitial;
		local initial;
		local isdragging;
	    obj.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isdragging = true;
				minitial = input.Position;
				initial = obj.Position;
				local con;
                con = stepped:Connect(function()
        			if isdragging then
						local delta = Vector3.new(mouse.X, mouse.Y, 0) - minitial;
						TweenService:Create(obj, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(initial.X.Scale, initial.X.Offset + delta.X, initial.Y.Scale, initial.Y.Offset + delta.Y)}):Play();
					else
						con:Disconnect();
					end;
                end);
                input.Changed:Connect(function()
    			    if input.UserInputState == Enum.UserInputState.End then
					    isdragging = false;
				    end;
			    end);
		end;
	end);
end)
end

local function protect_gui(Main) 
spawn(function()
    if get_hidden_gui or gethui then
    local hiddenUI = get_hidden_gui or gethui
    Main.Parent = hiddenUI()
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
    syn.protect_gui(Main)
    Main.Parent = Service("CoreGui")
elseif Service("CoreGui"):FindFirstChild("RobloxGui") then
    Main.Parent = Service("CoreGui").RobloxGui
else
    Main.Parent = Service("CoreGui") 
end
end)
end

local TurtleUiLib = Instance.new("ScreenGui")
TurtleUiLib.Name = "GGHUiLib"
TurtleUiLib.DisplayOrder = 1
TurtleUiLib.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
TurtleUiLib.SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension
protect_gui(TurtleUiLib)

local xOffset = 20
local uis = game:GetService("UserInputService")
local keybindConnection

function library:Destroy()
    TurtleUiLib:Destroy()
    if keybindConnection then
        keybindConnection:Disconnect()
    end
end

function library:Keybind(key)
    if keybindConnection then keybindConnection:Disconnect() end
    keybindConnection = uis.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode[key] then
            TurtleUiLib.Enabled = not TurtleUiLib.Enabled
        end
    end)
end

function library:Toggle(state)
    if type(state) == "boolean" then
    TurtleUiLib.Enabled = state
    else
    TurtleUiLib.Enabled = not TurtleUiLib.Enabled
    end
end

function library:Window(name, themeName) 
    windowCount = windowCount + 1
    local winCount = windowCount
    local zindex = winCount * 7
    local currentTheme = themes[themeName] or themes.Shadow
    
    local UiWindow = Instance.new("Frame")
    UiWindow.Name = "UiWindow"
    UiWindow.Parent = TurtleUiLib
    UiWindow.BackgroundColor3 = currentTheme.primary
    UiWindow.BorderColor3 = currentTheme.border
    UiWindow.Position = UDim2.new(0, xOffset, 0, 20)
    UiWindow.Size = UDim2.new(0, 207, 0, maxWindowHeight)
    UiWindow.ZIndex = 1
    UiWindow.Active = true
    UiWindow.ClipsDescendants = false
    
    local c = UiWindow:Clone()
    c.Parent = TurtleUiLib
    c.Size = UDim2.new(0, 207, 0, 26)
    c.BackgroundTransparency = 1
    c.ZIndex = 9181
    Dragify(c)
    UiWindow.Parent = c
    UiWindow.Position = UDim2.new(0, 0, 0, 0)
    

    -- Animate window in
    UiWindow.Size = UDim2.new(0, 0, 0, 33)
    animateIn(UiWindow, {Size = UDim2.new(0, 207, 0, 33)}, 0.5)

    xOffset = xOffset + 230

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = UiWindow
    Header.BackgroundColor3 = currentTheme.secondary
    Header.BorderColor3 = currentTheme.border
    Header.Position = UDim2.new(0, 0, -0.0202544238, 0)
    Header.Size = UDim2.new(0, 207, 0, 26)
    Header.ZIndex = 5 + zindex

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Name = "HeaderText"
    HeaderText.Parent = Header
    HeaderText.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HeaderText.BackgroundTransparency = 1.000
    HeaderText.Position = UDim2.new(0, 0, -0.0020698905, 0)
    HeaderText.Size = UDim2.new(0, 206, 0, 33)
    HeaderText.ZIndex = 6 + zindex
    HeaderText.Font = Enum.Font.SourceSansBold
    HeaderText.Text = name or "Window"
    HeaderText.TextColor3 = currentTheme.text
    HeaderText.TextSize = 17.000

    local Minimise = Instance.new("TextButton")
    local Window = Instance.new("ScrollingFrame") -- Changed to ScrollingFrame
    
    Minimise.Name = "Minimise"
    Minimise.Parent = Header
    Minimise.BackgroundColor3 = currentTheme.accent
    Minimise.BorderColor3 = currentTheme.border
    Minimise.Position = UDim2.new(0, 185, 0, 2)
    Minimise.Size = UDim2.new(0, 22, 0, 22)
    Minimise.ZIndex = 7 + zindex
    Minimise.Font = Enum.Font.SourceSansLight
    Minimise.Text = "--"
    Minimise.TextColor3 = currentTheme.text
    Minimise.TextSize = 20.000
    Minimise.BackgroundTransparency = 1
    Minimise.AutoButtonColor = false

    -- Add hover animation to minimize button
    Minimise.MouseEnter:Connect(function()
        animateIn(Minimise, {BackgroundColor3 = currentTheme.text, TextColor3 = currentTheme.primary}, 0.2)
    end)
    Minimise.MouseLeave:Connect(function()
        animateIn(Minimise, {BackgroundColor3 = currentTheme.accent, TextColor3 = currentTheme.text}, 0.2)
    end)

    Minimise.MouseButton1Up:connect(function()
    if Window.Visible then
        -- Minimize animation
        local currentHeight = Window.Size.Y.Offset
        animateIn(Window, {Size = UDim2.new(0, 207, 0, 0)}, 0.3).Completed:Wait()
            Window.Visible = false
            Minimise.Text = "+"
            animateIn(UiWindow, {Size = UDim2.new(0, 207, 0, 33)}, 0.3) -- Only header visible
    else
        -- Show animation
        Window.Visible = true
        Minimise.Text = "--"
        local targetHeight = math.min(sizes[winCount], maxWindowHeight)
        Window.Size = UDim2.new(0, 207, 0, 0) -- Start from 0
        animateOut(UiWindow, {Size = UDim2.new(0, 207, 0, targetHeight + 33)}, 0.3) -- Update container
        Header.Size = UDim2.new(0, 207, 0, 26)
        animateOut(Window, {Size = UDim2.new(0, 207, 0, targetHeight)}, 0.3)
    end
end)

    -- ScrollingFrame setup for window
Window.Name = "Window"
Window.Parent = Header
Window.BackgroundColor3 = currentTheme.background
Window.BackgroundTransparency = 0
Window.BorderColor3 = currentTheme.border
Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 0, 1, 0)
    Window.Size = UDim2.new(0, 207, 0, 33)
    Window.ZIndex = 1 + zindex
    Window.Active = true
    Window.ScrollBarThickness = 0
    Window.ClipsDescendants = true
    Window.ScrollBarImageColor3 = currentTheme.accent
    Window.CanvasSize = UDim2.new(0, 0, 0, 33)
    Window.ScrollingDirection = Enum.ScrollingDirection.Y
    Window.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    Window.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    Window.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(currentTheme.gradient)
    gradient.Rotation = 90
    gradient.Parent = Header

    local functions = {}
    sizes[winCount] = 33
    listOffset[winCount] = -17
    
-- Update window size function
local function updateWindowSize()
    local actualSize = sizes[winCount]
    
    for i,v in pairs(dropdowns) do 
        if v and v.Visible and v:IsDescendantOf(UiWindow) then
            actualSize += v.Size.Y.Offset
        end
    end
    
    local windowHeight = math.min(actualSize, maxWindowHeight)
    
    if Window.Visible then
        -- Smooth resize
        animateOut(Window, {Size = UDim2.new(0, 207, 0, windowHeight)}, 0.2)
        animateOut(Window, {CanvasSize = UDim2.new(0, 0, 0, actualSize)}, 0.2)
        
        -- Keep header size fixed and adjust container
        Header.Size = UDim2.new(0, 207, 0, 26)
        animateOut(UiWindow, {Size = UDim2.new(0, 207, 0, windowHeight + 33)}, 0.2) 
    else
        animateOut(Window, {CanvasSize = UDim2.new(0, 0, 0, actualSize)}, 0.2)
        Header.Size = UDim2.new(0, 207, 0, 26) -- Keep header fixed
    end
end

local OldPos = {}
-- Function to move content below a certain position
local function moveContentBelow(v)
    if not v.Visible then return end
    for _, child in pairs(Window:GetChildren()) do
        if child and child.Position.Y.Offset > v.Parent.Position.Y.Offset then
            if v.Size.Y.Offset ~= 0 and not OldPos[v] then OldPos[v] = v.Size.Y.Offset end
            local X = child.Position.X.Offset
            local Y = child.Position.Y.Offset
            local new = Y + v.Size.Y.Offset
            if v.Size.Y.Offset == 0 then
            animateOut(child, {Position = UDim2.fromOffset(X,Y - OldPos[v])}, 0.2)
            else
            animateOut(child, {Position = UDim2.fromOffset(X,new)}, 0.2)
            end
        end
    end
end

local gradient4 = gradient:Clone()
gradient4.Rotation = 45
    
    function functions:Button(name, callback)
        local name = name or "Button"
        local callback = callback or function() end

        sizes[winCount] = sizes[winCount] + 32
updateWindowSize()

        local Button = Instance.new("TextButton")
        listOffset[winCount] = listOffset[winCount] + 32
        Button.Name = "Button"
        Button.Parent = Window
        Button.BackgroundColor3 = currentTheme.primary
        Button.BorderColor3 = currentTheme.accent
        Button.Position = UDim2.new(0, 12, 0, listOffset[winCount])
        Button.Size = UDim2.new(0, 182, 0, 26)
        Button.ZIndex = 2 + zindex
        Button.Selected = true
        Button.Font = Enum.Font.SourceSansBold
        Button.TextColor3 = currentTheme.text
        Button.TextSize = 16.000
        Button.TextStrokeTransparency = 123.000
        Button.TextWrapped = true
        Button.Text = name
        Button.AutoButtonColor = false
        
        -- Add hover animation to buttons
Button.MouseEnter:Connect(function()
    gradient4.Parent = Button
    -- animateIn(Button, {BackgroundColor3 = currentTheme.accent}, 0.2)
end)
Button.MouseLeave:Connect(function()
    gradient4.Parent = nil
    -- animateIn(Button, {BackgroundColor3 = currentTheme.primary}, 0.2)
end)

Button.MouseButton1Click:Connect(function()
    --[[ animateOut(Button, {BackgroundColor3 = currentTheme.accent}, 0.1).Completed:Connect(function()
        animateIn(Button, {BackgroundColor3 = currentTheme.primary}, 0.1)
    end) ]]
    callback()
end)
        pastSliders[winCount] = false
    end

    function functions:Label(text, color)
        local color = color or currentTheme.text

        sizes[winCount] = sizes[winCount] + 32
        updateWindowSize()

        listOffset[winCount] = listOffset[winCount] + 32
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Parent = Window
        Label.BackgroundColor3 = currentTheme.text
        Label.BackgroundTransparency = 1.000
        Label.BorderColor3 = currentTheme.border
        Label.Position = UDim2.new(0, 0, 0, listOffset[winCount])
        Label.Size = UDim2.new(0, 206, 0, 29)
        Label.Font = Enum.Font.SourceSans
        Label.Text = text or "Label"
        Label.TextSize = 16.000
        Label.ZIndex = 2 + zindex

        if type(color) == "boolean" and color then
            spawn(function()
                while wait() do
                    local hue = tick() % 5 / 5
                    Label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                end
            end)
        else
            Label.TextColor3 = color
        end
        pastSliders[winCount] = false
    end

    function functions:Toggle(text, on, callback)
        local callback = callback or function() end

        sizes[winCount] = sizes[winCount] + 32
        updateWindowSize()
        
        listOffset[winCount] = listOffset[winCount] + 32

        local ToggleDescription = Instance.new("TextLabel")
        local ToggleButton = Instance.new("TextButton")
        local ToggleFiller = Instance.new("Frame")

        ToggleDescription.Name = "ToggleDescription"
        ToggleDescription.Parent = Window
        ToggleDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleDescription.BackgroundTransparency = 1.000
        ToggleDescription.Position = UDim2.new(0, 14, 0, listOffset[winCount])
        ToggleDescription.Size = UDim2.new(0, 131, 0, 26)
        ToggleDescription.Font = Enum.Font.SourceSans
        ToggleDescription.Text = text or "Toggle"
        ToggleDescription.TextColor3 = currentTheme.text
        ToggleDescription.TextSize = 16.000
        ToggleDescription.TextWrapped = true
        ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDescription.ZIndex = 2 + zindex

        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleDescription
        ToggleButton.BackgroundColor3 = currentTheme.primary
        ToggleButton.BorderColor3 = currentTheme.accent
        ToggleButton.Position = UDim2.new(1.2061069, 0, 0.0769230798, 0)
        ToggleButton.Size = UDim2.new(0, 22, 0, 22)
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleButton.TextSize = 14.000
        ToggleButton.ZIndex = 2 + zindex
        ToggleButton.AutoButtonColor = false
        
        ToggleButton.MouseButton1Up:Connect(function()
            ToggleFiller.Visible = not ToggleFiller.Visible
            callback(ToggleFiller.Visible)
        end)

        ToggleFiller.Name = "ToggleFiller"
        ToggleFiller.Parent = ToggleButton
        ToggleFiller.BackgroundColor3 = Color3.fromRGB(255,255,255)
        ToggleFiller.BorderColor3 = currentTheme.primary
        ToggleFiller.Position = UDim2.new(0, 5, 0, 5)
        ToggleFiller.Size = UDim2.new(0, 12, 0, 12)
        ToggleFiller.Visible = on
        ToggleFiller.ZIndex = 2 + zindex
        local gradient2 = gradient:Clone()
        gradient2.Parent = ToggleFiller
        gradient2.Rotation = 45
        
        pastSliders[winCount] = false
        
        return {
            Switch = function(_,state)
                if type(state) == "boolean" then
                ToggleFiller.Visible = state
                print(state)
                callback(ToggleFiller.Visible)
                end
            end,
            
            ChangeName = function(_,Name)
                if Name and type(Name) == "string" or type(Name) == "number" then
                ToggleDescription.Text = Name
                end
            end
        }
    end

    function functions:Box(text, callback)
        local callback = callback or function() end

        sizes[winCount] = sizes[winCount] + 32
        updateWindowSize()
        
        listOffset[winCount] = listOffset[winCount] + 32
        local TextBox = Instance.new("TextBox")
        local BoxDescription = Instance.new("TextLabel")
        TextBox.Parent = Window
        TextBox.BackgroundColor3 = currentTheme.primary
        TextBox.BorderColor3 = currentTheme.accent
        TextBox.Position = UDim2.new(0, 99, 0, listOffset[winCount])
        TextBox.Size = UDim2.new(0, 95, 0, 26)
        TextBox.Font = Enum.Font.SourceSans
        TextBox.PlaceholderColor3 = currentTheme.text
        TextBox.PlaceholderText = "..."
        TextBox.Text = ""
        TextBox.TextColor3 = currentTheme.text
        TextBox.TextSize = 16.000
        TextBox.TextStrokeColor3 = currentTheme.text
        TextBox.ZIndex = 2 + zindex
        TextBox:GetPropertyChangedSignal('Text'):connect(function()
            callback(TextBox.Text, false)
        end)
        TextBox.FocusLost:Connect(function()
            callback(TextBox.Text, true)
        end)

        BoxDescription.Name = "BoxDescription"
        BoxDescription.Parent = TextBox
        BoxDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BoxDescription.BackgroundTransparency = 1.000
        BoxDescription.Position = UDim2.new(-0.894736826, 0, 0, 0)
        BoxDescription.Size = UDim2.new(0, 75, 0, 26)
        BoxDescription.Font = Enum.Font.SourceSans
        BoxDescription.Text = text or "Box"
        BoxDescription.TextColor3 = currentTheme.text
        BoxDescription.TextSize = 16.000
        BoxDescription.TextXAlignment = Enum.TextXAlignment.Left
        BoxDescription.ZIndex = 2 + zindex
        pastSliders[winCount] = false
    end

    function functions:Slider(text, min, max, default, callback)
        local text = text or "Slider"
        local min = min or 1
        local max = max or 100
        local default = default or max/2
        local callback = callback or function() end
        local offset = 70
        if default > max then
            default = max
        elseif default < min then
            default = min
        end

        if pastSliders[winCount] then
            offset = 60
        end

        sizes[winCount] = sizes[winCount] + offset
        updateWindowSize()
        listOffset[winCount] = listOffset[winCount] + offset

        local Slider = Instance.new("Frame")
        local SliderButton = Instance.new("TextButton")
        local Description = Instance.new("TextLabel")
        local SilderFiller = Instance.new("Frame")
        local Current = Instance.new("TextLabel")
        local Min = Instance.new("TextLabel")
        local Max = Instance.new("TextLabel")

        function SliderMovement(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isdragging = true;
                minitial = input.Position.X;
                initial = SliderButton.Position.X.Offset;
                local delta1 = SliderButton.AbsolutePosition.X - initial
                local con;
                con = stepped:Connect(function()
                    if isdragging then
                        local xOffset = mouse.X - delta1 - 3
                        if xOffset > 175 then
                            xOffset = 175
                        elseif xOffset< 0 then
                            xOffset = 0
                        end
                        SliderButton.Position = UDim2.new(0, xOffset , -1.33333337, 0);
                        SilderFiller.Size = UDim2.new(0, xOffset, 0, 6)
                        local value = Lerp(min, max, SliderButton.Position.X.Offset/(Slider.Size.X.Offset-5))
                        Current.Text = tostring(math.round(value))
                    else
                        con:Disconnect();
                    end;
                end);
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isdragging = false;
                    end;
                end);
            end;
        end
        
        function SliderEnd(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local value = Lerp(min, max, SliderButton.Position.X.Offset/(Slider.Size.X.Offset-5))
                callback(math.round(value))
            end
        end

        Slider.Name = "Slider"
        Slider.Parent = Window
        Slider.BackgroundColor3 = currentTheme.primary
        Slider.BorderColor3 = currentTheme.accent
        Slider.Position = UDim2.new(0, 13, 0, listOffset[winCount])
        Slider.Size = UDim2.new(0, 180, 0, 6)
        Slider.ZIndex = 2 + zindex
        Slider.Active = true
        Slider.InputBegan:Connect(SliderMovement) 
        Slider.InputEnded:Connect(SliderEnd)      

        SliderButton.Position = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((default - min)/(max-min)), -1.333337, 0)
        SliderButton.Name = "SliderButton"
        SliderButton.Parent = Slider
        SliderButton.BackgroundColor3 = currentTheme.primary
        SliderButton.BorderColor3 = currentTheme.accent
        SliderButton.Size = UDim2.new(0, 6, 0, 22)
        SliderButton.ZIndex = 3 + zindex
        SliderButton.InputBegan:Connect(SliderMovement)
        SliderButton.InputEnded:Connect(SliderEnd)  
        SliderButton.Active = true
        SliderButton.Text = ''
        SliderButton.AutoButtonColor = false

        Current.Name = "Current"
        Current.Parent = SliderButton
        Current.BackgroundTransparency = 1.000
        Current.Position = UDim2.new(0, 3, 0, 22)
        Current.Size = UDim2.new(0, 0, 0, 18)
        Current.Font = Enum.Font.SourceSans
        Current.Text = tostring(default)
        Current.TextColor3 = currentTheme.text
        Current.TextSize = 14.000  
        Current.ZIndex = 2 + zindex

        Description.Name = "Description"
        Description.Parent = Slider
        Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Description.BackgroundTransparency = 1.000
        Description.Position = UDim2.new(0, -10, 0, -35)
        Description.Size = UDim2.new(0, 200, 0, 21)
        Description.Font = Enum.Font.SourceSans
        Description.Text = text
        Description.TextColor3 = currentTheme.text
        Description.TextSize = 16.000
        Description.ZIndex = 2 + zindex

        SilderFiller.Name = "SilderFiller"
        SilderFiller.Parent = Slider
        SilderFiller.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SilderFiller.BorderColor3 = currentTheme.primary
        SilderFiller.Size = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((default - min)/(max-min)), 0, 6)
        SilderFiller.ZIndex = 2 + zindex
        SilderFiller.BorderMode = Enum.BorderMode.Inset
        local gradient3 = gradient:Clone()
        gradient3.Parent = SilderFiller
        gradient3.Rotation = 45

        Min.Name = "Min"
        Min.Parent = Slider
        Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Min.BackgroundTransparency = 1.000
        Min.Position = UDim2.new(-0.00555555569, 0, -7.33333397, 0)
        Min.Size = UDim2.new(0, 77, 0, 50)
        Min.Font = Enum.Font.SourceSans
        Min.Text = tostring(min)
        Min.TextColor3 = currentTheme.text
        Min.TextSize = 14.000
        Min.TextXAlignment = Enum.TextXAlignment.Left
        Min.ZIndex = 2 + zindex

        Max.Name = "Max"
        Max.Parent = Slider
        Max.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Max.BackgroundTransparency = 1.000
        Max.Position = UDim2.new(0.577777743, 0, -7.33333397, 0)
        Max.Size = UDim2.new(0, 77, 0, 50)
        Max.Font = Enum.Font.SourceSans
        Max.Text = tostring(max)
        Max.TextColor3 = currentTheme.text
        Max.TextSize = 14.000
        Max.TextXAlignment = Enum.TextXAlignment.Right
        Max.ZIndex = 2 + zindex
        pastSliders[winCount] = true
    end

    function functions:Dropdown(text, buttons, callback, multiSelect)
    local text = text or "Dropdown"
    local buttons = buttons or {}
    local callback = callback or function() end
    local multiSelect = multiSelect or false -- New parameter for multi-select
    local selectedItems = {} -- Track selected items
    local isExpanded = false
    local originalListOffset = listOffset[winCount] -- Store original position

    sizes[winCount] = sizes[winCount] + 32
    updateWindowSize()
    listOffset[winCount] = listOffset[winCount] + 32

    local Dropdown = Instance.new("TextButton")
    local DownSign = Instance.new("TextLabel")
    local DropdownFrame = Instance.new("ScrollingFrame")

    Dropdown.Name = "Dropdown"
    Dropdown.Parent = Window
    Dropdown.BackgroundColor3 = currentTheme.primary
    Dropdown.BorderColor3 = currentTheme.accent
    Dropdown.Position = UDim2.new(0, 12, 0, listOffset[winCount])
    Dropdown.Size = UDim2.new(0, 182, 0, 26)
    Dropdown.Selected = true
    Dropdown.Font = Enum.Font.SourceSans
    Dropdown.Text = tostring(text)
    Dropdown.TextColor3 = currentTheme.text
    Dropdown.TextSize = 16.000
    Dropdown.TextStrokeTransparency = 123.000
    Dropdown.TextWrapped = true
    Dropdown.ZIndex = 3 + zindex
    Dropdown.AutoButtonColor = false

    DownSign.Name = "DownSign"
    DownSign.Parent = Dropdown
    DownSign.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DownSign.BackgroundTransparency = 1.000
    DownSign.Position = UDim2.new(0, 155, 0, 2)
    DownSign.Size = UDim2.new(0, 27, 0, 22)
    DownSign.Font = Enum.Font.SourceSans
    DownSign.Text = "^"
    DownSign.TextColor3 = currentTheme.text
    DownSign.TextSize = 20.000
    DownSign.ZIndex = 4 + zindex
    DownSign.TextYAlignment = Enum.TextYAlignment.Bottom

    -- Fixed size dropdown with scrolling
    DropdownFrame.Name = "DropdownFrame"
    DropdownFrame.Parent = Dropdown
    DropdownFrame.Active = true
    DropdownFrame.BackgroundColor3 = currentTheme.primary
    DropdownFrame.BorderColor3 = currentTheme.accent
    DropdownFrame.Position = UDim2.new(0, 0, 0, 28)
    DropdownFrame.Size = UDim2.new(0, 182, 0, 0)
    DropdownFrame.Visible = false
    DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    DropdownFrame.ScrollBarThickness = 4
    DropdownFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    DropdownFrame.ZIndex = 5 + zindex
    DropdownFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    DropdownFrame.ScrollBarImageColor3 = currentTheme.accent
    DropdownFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    DropdownFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    
    table.insert(dropdowns, DropdownFrame)
    
    local dropFunctions = {}
    local canvasSize = 0
    
        -- Add hover animation to dropdown
    Dropdown.MouseEnter:Connect(function()
        gradient4.Parent = Dropdown
        -- animateIn(Dropdown, {BackgroundColor3 = currentTheme.accent}, 0.2)
    end)
    Dropdown.MouseLeave:Connect(function()
        gradient4.Parent = nil
        -- animateIn(Dropdown, {BackgroundColor3 = currentTheme.primary}, 0.2)
    end)

    local db = false
    Dropdown.MouseButton1Click:Connect(function()
        if db then return end
        db = true
    --[[ for i, v in pairs(dropdowns) do
        if v ~= DropdownFrame then
            -- Close other dropdowns and move content back
            if v.Visible then
                animateOut(v, {Size = UDim2.new(0, 182, 0, 0)}, 0.2).Completed:Connect(function()
                    v.Visible = false
                    -- Move content back up for other dropdowns
                    local otherDropdown = v.Parent
                    local dropdownPosition = otherDropdown.Position.Y.Offset
                    moveContentBelow(DropdownFrame)
                end)
            end
            if v.Parent and v.Parent:FindFirstChild("DownSign") then
                animateIn(v.Parent:FindFirstChild("DownSign"), {Rotation = 0}, 0.2)
            end
        end
    end ]]
    
    if isExpanded then
        -- Collapse
        isExpanded = false
        animateIn(DownSign, {Rotation = 0}, 0.2)
        local dropdownHeight = DropdownFrame.Size.Y.Offset
        animateOut(DropdownFrame, {Size = UDim2.new(0, 182, 0, 0)}, 0.2).Completed:Wait()
            moveContentBelow(DropdownFrame)
            updateWindowSize()
            DropdownFrame.Visible = false
    else
    -- Expand
    isExpanded = true
    DropdownFrame.Visible = true
    animateIn(DownSign, {Rotation = 180}, 0.2)

    local itemCount = 0
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            itemCount = itemCount + 1
        end
    end
    local calculatedHeight = math.max(itemCount * 27, 27) -- Minimum 1 item height
    local maxDropHeight = math.min(calculatedHeight, 135) -- Max 5 items visible
    
    animateIn(DropdownFrame, {Size = UDim2.new(0, 182, 0, maxDropHeight)}, 0.3).Completed:Wait()
    
    moveContentBelow(DropdownFrame)
    -- sizes[winCount] = sizes[winCount] + maxDropHeight
    updateWindowSize()
end
db = false
end)
    
    function dropFunctions:Button(name, isSelected)
    local name = name or ""
    local isSelected = isSelected or false
    local Button_2 = Instance.new("TextButton")
    
    Button_2.Name = "Button"
    Button_2.Parent = DropdownFrame
    Button_2.BackgroundColor3 = currentTheme.primary
    Button_2.BorderColor3 = currentTheme.accent
    Button_2.BorderSizePixel = 0
    Button_2.Position = UDim2.new(0, 6, 0, canvasSize + 1)
    Button_2.Size = UDim2.new(0, 170, 0, 26)
    Button_2.Selected = true
    Button_2.Font = Enum.Font.SourceSans
    Button_2.TextColor3 = currentTheme.text
    Button_2.TextSize = 16.000
    Button_2.TextStrokeTransparency = 123.000
    Button_2.ZIndex = 6 + zindex
    Button_2.Text = name
    Button_2.TextWrapped = true
    Button_2.BackgroundTransparency = 1
    Button_2.AutoButtonColor = false
    
    -- Add selection indicator gradient for selected items
    if isSelected then
        local selectionGradient = Instance.new("UIGradient")
        selectionGradient.Color = ColorSequence.new(currentTheme.gradient)
        selectionGradient.Rotation = 45
        selectionGradient.Parent = Button_2
        selectionGradient.Name = "SelectionGradient"
        selectedItems[name] = true
    end
    
    --[[ Enhanced hover animation
    Button_2.MouseEnter:Connect(function()
        if not selectedItems[name] then
            animateIn(Button_2, {TextColor3 = currentTheme.accent}, 0.15)
        end
    end)
    Button_2.MouseLeave:Connect(function()
        if not selectedItems[name] then
            animateIn(Button_2, {TextColor3 = currentTheme.text}, 0.15)
        end
    end) ]]
    
    canvasSize = canvasSize + 27
    DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, canvasSize + 1)
    
    Button_2.MouseButton1Click:Connect(function()
        Button_2.TextColor3 = currentTheme.text
        if multiSelect then
    -- Multi-select logic
    if selectedItems[name] then
        -- Deselect
        selectedItems[name] = nil
        local gradient = Button_2:FindFirstChild("SelectionGradient")
        if gradient then
            gradient:Destroy()
        end
    else
        -- Select
        selectedItems[name] = true
        local selectionGradient = Instance.new("UIGradient")
        selectionGradient.Color = ColorSequence.new(currentTheme.gradient)
        selectionGradient.Rotation = 45
        selectionGradient.Parent = Button_2
        selectionGradient.Name = "SelectionGradient"
    end
    
    -- Return all selected items
    local selected = {}
    for item, _ in pairs(selectedItems) do
        table.insert(selected, item)
    end
    callback(selected, name)
        else
    -- Single select logic - Clear all previous selections
    selectedItems = {}
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1 -- Reset background
            local gradient = child:FindFirstChild("SelectionGradient")
            if gradient then
                gradient:Destroy()
            end
        end
    end
    
    -- Select this item
    selectedItems[name] = true
    local selectionGradient = Instance.new("UIGradient")
    selectionGradient.Color = ColorSequence.new(currentTheme.gradient)
    selectionGradient.Rotation = 45
    selectionGradient.Parent = Button_2
    selectionGradient.Name = "SelectionGradient"
    
    callback(name)
    
    -- Close dropdown after single selection
    isExpanded = false
    animateIn(DownSign, {Rotation = 0}, 0.2)
    local dropdownHeight = DropdownFrame.Size.Y.Offset
    animateOut(DropdownFrame, {Size = UDim2.new(0, 182, 0, 0)}, 0.2).Completed:Connect(function()
        moveContentBelow(DropdownFrame)
        updateWindowSize()
        DropdownFrame.Visible = false
           end)
        end
    end)
    
    return Button_2
end
    
    -- Add these functions to dropFunctions
function dropFunctions:SetMultiSelect(enabled)
    multiSelect = enabled
    if not enabled then
        -- Clear all selections if switching to single select
        selectedItems = {}
        for _, child in pairs(DropdownFrame:GetChildren()) do
            if child:IsA("TextButton") then
                animateIn(child, {BackgroundColor3 = currentTheme.primary}, 0.2)
                if child:FindFirstChild("selectionGradient") then
                    child.selectionGradient:Destroy()
                    child.selectionGradient = nil
                end
            end
        end
    end
end

function dropFunctions:GetSelected()
    if multiSelect then
        local selected = {}
        for item, _ in pairs(selectedItems) do
            table.insert(selected, item)
        end
        return selected
    else
        for item, _ in pairs(selectedItems) do
            return item -- Return first (and only) selected item
        end
        return nil
    end
end

function dropFunctions:ClearSelection()
    selectedItems = {}
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            animateIn(child, {BackgroundColor3 = currentTheme.primary}, 0.2)
            if child.selectionGradient then
                child.selectionGradient:Destroy()
                child.selectionGradient = nil
            end
        end
    end
end
    
    function dropFunctions:Remove(name)
    local foundIt = false
    local removedButton = nil
    
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Text == name then
            foundIt = true
            removedButton = child
            break
        end
    end
    
    if foundIt and removedButton then
        local removedPosition = removedButton.Position.Y.Offset
        
        -- Remove from selection
        selectedItems[name] = nil
        
        -- Animate removal
        animateOut(removedButton, {
            Size = UDim2.new(0, 0, 0, 26), 
            BackgroundTransparency = 1, 
            TextTransparency = 1
        }, 0.2).Completed:Connect(function()
            removedButton:Destroy()
            
            -- Move other buttons up
            for _, child in pairs(DropdownFrame:GetChildren()) do
                if child:IsA("TextButton") and child.Position.Y.Offset > removedPosition then
                    animateIn(child, {Position = UDim2.new(0, 6, 0, child.Position.Y.Offset - 27)}, 0.2)
                end
            end
            
            -- Update canvas size
            canvasSize = canvasSize - 27
            DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, math.max(canvasSize, 27))
        end)
    else
        warn("The button you tried to remove didn't exist!")
    end
end

    for i,v in pairs(buttons) do
        dropFunctions:Button(v)
    end

    return dropFunctions
end

    function functions:ColorPicker(name, default, callback)
        local callback = callback or function() end

        local ColorPicker = Instance.new("TextButton")
        local PickerCorner = Instance.new("UICorner")
        local PickerDescription = Instance.new("TextLabel")
        local ColorPickerFrame = Instance.new("Frame")
        local ToggleRGB = Instance.new("TextButton")
        local ToggleFiller_2 = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local ClosePicker = Instance.new("TextButton")
        local Canvas = Instance.new("Frame")
        local CanvasGradient = Instance.new("UIGradient")
        local Cursor = Instance.new("ImageLabel")
        local Color = Instance.new("Frame")
        local ColorGradient = Instance.new("UIGradient")
        local ColorSlider = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local UICorner = Instance.new("UICorner")
        local ColorCorner = Instance.new("UICorner")
        local BlackOverlay = Instance.new("ImageLabel")

        sizes[winCount] = sizes[winCount] + 32
        updateWindowSize()
        listOffset[winCount] = listOffset[winCount] + 32

        ColorPicker.Name = "ColorPicker"
        ColorPicker.Parent = Window
        ColorPicker.Position = UDim2.new(0, 137, 0, listOffset[winCount])
        ColorPicker.Size = UDim2.new(0, 57, 0, 26)
        ColorPicker.Font = Enum.Font.SourceSans
        ColorPicker.Text = ""
        ColorPicker.TextColor3 = Color3.fromRGB(0, 0, 0)
        ColorPicker.TextSize = 14.000
        ColorPicker.ZIndex = 4 + zindex
        ColorPicker.MouseButton1Up:Connect(function()
           --[[ for i, v in pairs(colorPickers) do
                v.Visible = false
            end ]]
            ColorPickerFrame.Visible = not ColorPickerFrame.Visible
        end)

        PickerCorner.Parent = ColorPicker
        PickerCorner.Name = "PickerCorner"
        PickerCorner.CornerRadius = UDim.new(0,2)

        PickerDescription.Name = "PickerDescription"
        PickerDescription.Parent = ColorPicker
        PickerDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PickerDescription.BackgroundTransparency = 1.000
        PickerDescription.Position = UDim2.new(-2.15789509, 0, 0, 0)
        PickerDescription.Size = UDim2.new(0, 116, 0, 26)
        PickerDescription.Font = Enum.Font.SourceSans
        PickerDescription.Text = name or "Color picker"
        PickerDescription.TextColor3 = currentTheme.text
        PickerDescription.TextSize = 16.000
        PickerDescription.TextXAlignment = Enum.TextXAlignment.Left
        PickerDescription.ZIndex = 4 + zindex

        ColorPickerFrame.Name = "ColorPickerFrame"
        ColorPickerFrame.Parent = UiWindow
        ColorPickerFrame.BackgroundColor3 = currentTheme.primary
        ColorPickerFrame.BorderColor3 = currentTheme.primary
        ColorPickerFrame.Position = UDim2.new(1.05, 0, 0.1, 0)
        ColorPickerFrame.Size = UDim2.new(0, 158, 0, 155)
        ColorPickerFrame.ZIndex = 5 + zindex
        ColorPickerFrame.Visible = false
        ColorPickerFrame.Active = true

        local draggingColor = false
        local hue = 0
        local sat = 1
        local brightness = 1
        local con
        local color3

        table.insert(colorPickers, ColorPickerFrame)

        local colorFuncs = {}
        
        ToggleRGB.Name = "ToggleRGB"
        ToggleRGB.Parent = ColorPickerFrame
        ToggleRGB.BackgroundColor3 = currentTheme.primary
        ToggleRGB.BorderColor3 = currentTheme.accent
        ToggleRGB.Position = UDim2.new(0, 125, 0, 127)
        ToggleRGB.Size = UDim2.new(0, 22, 0, 22)
        ToggleRGB.Font = Enum.Font.SourceSans
        ToggleRGB.Text = ""
        ToggleRGB.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleRGB.TextSize = 14.000
        ToggleRGB.ZIndex = 6 + zindex

        ToggleFiller_2.Name = "ToggleFiller"
        ToggleFiller_2.Parent = ToggleRGB
        ToggleFiller_2.BackgroundColor3 = currentTheme.accent
        ToggleFiller_2.BorderColor3 = currentTheme.primary
        ToggleFiller_2.Position = UDim2.new(0, 5, 0, 5)
        ToggleFiller_2.Size = UDim2.new(0, 12, 0, 12)
        ToggleFiller_2.ZIndex = 14 + zindex
        ToggleFiller_2.Visible = false

        TextLabel.Parent = ToggleRGB
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.Position = UDim2.new(-5.13636351, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 106, 0, 22)
        TextLabel.Font = Enum.Font.SourceSans
        TextLabel.Text = "Rainbow"
        TextLabel.TextColor3 = currentTheme.text
        TextLabel.TextSize = 16.000
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 5 + zindex

        ClosePicker.Name = "ClosePicker"
        ClosePicker.Parent = ColorPickerFrame
        ClosePicker.BackgroundColor3 = currentTheme.primary
        ClosePicker.BorderColor3 = currentTheme.primary
        ClosePicker.Position = UDim2.new(0, 132, 0, 5)
        ClosePicker.Size = UDim2.new(0, 21, 0, 21)
        ClosePicker.Font = Enum.Font.SourceSans
        ClosePicker.Text = "X"
        ClosePicker.TextColor3 = currentTheme.text
        ClosePicker.TextSize = 18.000
        ClosePicker.ZIndex = 5 + zindex
        ClosePicker.MouseButton1Down:Connect(function()
            ColorPickerFrame.Visible = not ColorPickerFrame.Visible
        end)

        Canvas.Name = "Canvas"
        Canvas.Parent = ColorPickerFrame
        Canvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Canvas.Position = UDim2.new(0, 5, 0, 34)
        Canvas.Size = UDim2.new(0, 148, 0, 64)
        Canvas.ZIndex = 5 + zindex

        CanvasGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
        CanvasGradient.Name = "CanvasGradient"
        CanvasGradient.Parent = Canvas

        BlackOverlay.Name = "BlackOverlay"
        BlackOverlay.Parent = Canvas
        BlackOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BlackOverlay.BackgroundTransparency = 1.000
        BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
        BlackOverlay.Image = "rbxassetid://5107152095"
        BlackOverlay.ZIndex = 6 + zindex

        UICorner.Parent = Canvas
        UICorner.Name = "UICorner"
        UICorner.CornerRadius = UDim.new(0,2)

        Cursor.Name = "Cursor"
        Cursor.Parent = Canvas
        Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Cursor.BackgroundTransparency = 1.000
        Cursor.Size = UDim2.new(0, 8, 0, 8)
        Cursor.Image = "rbxassetid://5100115962"
        Cursor.ZIndex = 6 + zindex

        ToggleRGB.MouseButton1Down:Connect(function()
            ToggleFiller_2.Visible = not ToggleFiller_2.Visible
            if ToggleFiller_2.Visible then
                con = stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local hue2 = tick() % 5 / 5
                        color3 = Color3.fromHSV(hue2, 1, 1)
                        callback(color3, true)
                        ColorPicker.BackgroundColor3 = color3
                    else
                        con:Disconnect()
                    end
                end)
            end
        end)

        local canvasSize, canvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition
spawn(function()
    while Canvas.Parent do
        wait(0.1)
        canvasSize, canvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition
    end
end)

Canvas.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local isdragging = true
        local con
        
        con = stepped:Connect(function()
            if isdragging then
                -- Update canvas position in real-time
                canvasSize, canvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition
                
                -- Calculate relative position
                local relativeX = math.clamp((mouse.X - canvasPosition.X) / canvasSize.X, 0, 1)
                local relativeY = math.clamp((mouse.Y - canvasPosition.Y) / canvasSize.Y, 0, 1)
                
                -- Calculate saturation and brightness
                sat = 1 - relativeX  -- Left = full saturation, Right = no saturation
                brightness = 1 - relativeY  -- Top = full brightness, Bottom = no brightness
                
                -- Create color from HSV
                color3 = Color3.fromHSV(hue, sat, brightness)
                
                -- Update cursor position
                local cursorX = math.clamp(relativeX * canvasSize.X - 4, 0, canvasSize.X - 8)
                local cursorY = math.clamp(relativeY * canvasSize.Y - 4, 0, canvasSize.Y - 8)
                Cursor.Position = UDim2.fromOffset(cursorX, cursorY)
                
                -- Update color picker
                ColorPicker.BackgroundColor3 = color3
                callback(color3)
            else
                con:Disconnect()
            end
        end)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isdragging = false
            end
        end)
    end
end)

        Color.Name = "Color"
        Color.Parent = ColorPickerFrame
        Color.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Color.Position = UDim2.new(0, 5, 0, 105)
        Color.Size = UDim2.new(0, 148, 0, 14)
        Color.BorderMode = Enum.BorderMode.Inset
        Color.ZIndex = 5 + zindex
        Color.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingColor = true
        local con
        
        con = stepped:Connect(function()
            if draggingColor then
                -- Get current position and size
                local colorPosition, colorSize = Color.AbsolutePosition, Color.AbsoluteSize
                
                -- Calculate hue (0 to 1)
                local relativeX = math.clamp((mouse.X - colorPosition.X) / colorSize.X, 0, 1)
                hue = relativeX  -- Fixed: don't invert hue
                
                -- Update canvas gradient with new hue
                CanvasGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromHSV(hue, 1, 1)), 
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
                }
                
                -- Update slider position
                local sliderX = math.clamp(relativeX * colorSize.X - 1, 0, colorSize.X - 2)
                ColorSlider.Position = UDim2.fromOffset(sliderX, 0)
                
                -- Update final color
                color3 = Color3.fromHSV(hue, sat, brightness)
                ColorPicker.BackgroundColor3 = color3
                callback(color3)
            else
                con:Disconnect()
            end
        end)
    end
end)

Color.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingColor = false
    end
end)

        ColorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), 
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), 
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), 
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), 
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)), 
            ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 0, 255)), 
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
        })
        ColorGradient.Name = "ColorGradient"
        ColorGradient.Parent = Color

        ColorCorner.Parent = Color
        ColorCorner.Name = "ColorCorner"
        ColorCorner.CornerRadius = UDim.new(0,2)

        ColorSlider.Name = "ColorSlider"
        ColorSlider.Parent = Color
        ColorSlider.BackgroundColor3 = currentTheme.text
        ColorSlider.BorderColor3 = currentTheme.text
        ColorSlider.Size = UDim2.new(0, 2, 0, 14)
        ColorSlider.ZIndex = 5 + zindex

        Title.Name = "Title"
        Title.Parent = ColorPickerFrame
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1.000
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Size = UDim2.new(0, 118, 0, 21)
        Title.Font = Enum.Font.SourceSans
        Title.Text = name or "Color picker"
        Title.TextColor3 = currentTheme.text
        Title.TextSize = 16.000
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 5 + zindex

        -- Initialize with default color if provided
if default and type(default) ~= "boolean" then
    ColorPicker.BackgroundColor3 = default
    -- Convert to HSV to set initial values
    local h, s, v = Color3.toHSV(default)
    hue, sat, brightness = h, s, v
    
    -- Update gradient and cursor positions
    CanvasGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromHSV(hue, 1, 1)), 
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
    }
    
    -- Set initial cursor position
    local cursorX = (1 - sat) * 148 - 4
    local cursorY = (1 - brightness) * 64 - 4
    Cursor.Position = UDim2.fromOffset(math.clamp(cursorX, 0, 140), math.clamp(cursorY, 0, 56))
    
    -- Set initial slider position
    ColorSlider.Position = UDim2.fromOffset(hue * 146, 0)
end

        function colorFuncs:UpdateColorPicker(color)
            if type(color) == "userdata" then
                ToggleFiller_2.Visible = false
                ColorPicker.BackgroundColor3 = color
            elseif color and type(color) == "boolean" and not con then
                ToggleFiller_2.Visible = true
                con = stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local hue2 = tick() % 5 / 5
                        color3 = Color3.fromHSV(hue2, 1, 1)
                        callback(color3)
                        ColorPicker.BackgroundColor3 = color3
                    else
                        con:Disconnect()
                    end
                end)
            end
        end
        return colorFuncs
    end

    return functions
end

--[[
local ShadowWindow = library:Window("Shadow Hub", "Shadow")
local SonicWindow = library:Window("Sonic Hub", "Sonic")

ShadowWindow:Box("Walkspeed", function(text, focuslost)
   if focuslost then
   print(text)
   end
end)

-- Single select dropdown
singleDropdown = ShadowWindow:Dropdown("Single Select", {"Option 1", "Option 2", "Option 3"}, function(selected)
    print("Selected:", selected)
end, false) -- false = single select

ShadowWindow:Label("Made by: Shadow The Hedgehog", true) -- Rainbow text



local multiDropdown
local Toggle 
local b = true
SonicWindow:Button("Switch", function()
    b = not b
    Toggle:Switch(b)
end)

SonicWindow:Button("Name", function()
    Toggle:ChangeName(math.random(1,20))
end)

Toggle = SonicWindow:Toggle("switch", true, function(bool)
    multiDropdown:SetMultiSelect(bool)
end)

SonicWindow:Toggle("add/remove", false, function(bool)
    if bool then
        multiDropdown:Button("Uwu")
        else
        multiDropdown:Remove("Uwu")
    end
end)

SonicWindow:ColorPicker("Color Picker", Color3.fromRGB(255, 255, 255), function(color)
   print(color)
end)

SonicWindow:Slider("Example Slider",0,100,20, function(value)
   print(value)
end)

SonicWindow:Box("Walkspeed", function(text, focuslost)
   if focuslost then
   print(text)
   end
end)

-- Multi select dropdown  
multiDropdown = SonicWindow:Dropdown("Multi Select", {"Item A", "Item B", "Item C", "4","5","6","7","8"}, function(selectedArray, clickedItem)
    print("All selected:", table.concat(selectedArray, ", "))
    print("Just clicked:", clickedItem)
end, true) -- true = multi select

SonicWindow:Dropdown("Mun", {"Item A", "Item B", "Item C"}, function(selectedArray, clickedItem)
    print("All selected:", table.concat(selectedArray, ", "))
    print("Just clicked:", clickedItem)
end, true) -- true = multi select


SonicWindow:Label("Made by: Shadow The Hedgehog", true) -- Rainbow text

SonicWindow:Label("Gotta go fast!", Color3.fromRGB(0, 100, 200))
]]

return library
