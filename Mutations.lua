-- Shadow the Hedgehog Vision UI - Compact Notification Style
-- Maintains 16:9 aspect ratio while being small and positioned at top center
local function CreateVisionUI()
    -- Services
    local cloneref = cloneref or function(o) return o end

    local Players = cloneref(game:GetService("Players"))
    local TweenService = cloneref(game:GetService("TweenService"))
    local UserInputService = cloneref(game:GetService("UserInputService"))
    local RunService = cloneref(game:GetService("RunService"))
    
    -- Constants
    local ASPECT_RATIO = 16/9
    local SHADOW_RED = Color3.fromRGB(226, 0, 0)
    local SHADOW_BLACK = Color3.fromRGB(20, 20, 22)
    local SHADOW_GRAY = Color3.fromRGB(40, 40, 45)
    
    -- Mutation Colors
    local MUTATION_COLORS = {
        Gold = Color3.fromRGB(255, 215, 0),
        Celestial = Color3.fromRGB(142, 210, 255),
        Rainbow = Color3.fromRGB(255, 100, 255), -- Will be changed with rainbow effect
        Wet = Color3.fromRGB(0, 170, 255),
        Shocked = Color3.fromRGB(255, 255, 0),
        Moonlit = Color3.fromRGB(200, 200, 255),
        Bloodlit = Color3.fromRGB(190, 0, 0),
        Frozen = Color3.fromRGB(150, 240, 255)
    }
    
    -- Local player reference
    local player = Players.LocalPlayer
    
    -- Utility Functions
    
    function hide(Main)
     if tostring(identifyexecutor()) == "Solara" then
        Main.Parent = PlayerGui
        Parent = PlayerGui
        return
    end 
    spawn(function()
    if get_hidden_gui or gethui then
    local hiddenUI = get_hidden_gui or gethui
    Main.Parent = hiddenUI()
    Parent = Main.Parent
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
    syn.protect_gui(Main)
    Main.Parent = player.PlayerGui
    Parent = Main.Parent
else
    Main.Parent = player.PlayerGui
    Parent = Main.Parent
end
end)
end 

    local function roundCorners(element, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(radius or 0.1, 0)
        corner.Parent = element
        return corner
    end
    
    local function addShadow(element, transparency, size)
        local shadow = Instance.new("ImageLabel")
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://6015897843"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = transparency or 0.6
        shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Size = UDim2.new(1, size or 15, 1, size or 15)
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.ZIndex = element.ZIndex - 1
        shadow.Parent = element
        return shadow
    end
    
    local function addStroke(element, color, thickness, transparency)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color or Color3.new(1, 1, 1)
        stroke.Thickness = thickness or 1.5
        stroke.Transparency = transparency or 0
        stroke.Parent = element
        return stroke
    end
    
    -- Apply Shadow-inspired gradient
    local function applyShadowGradient(element)
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, SHADOW_BLACK),
            ColorSequenceKeypoint.new(0.7, SHADOW_BLACK),
            ColorSequenceKeypoint.new(1, SHADOW_RED)
        })
        gradient.Rotation = 45
        gradient.Parent = element
        return gradient
    end
    
    -- Rainbow effect for Rainbow mutation
    local function startRainbowEffect(textLabel)
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not textLabel or not textLabel.Parent then
                connection:Disconnect()
                return
            end
            
            -- Smooth rainbow cycle
            local hue = (tick() % 5) / 5
            textLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
        end)
        return connection
    end
    
    -- Check if VisionUI already exists and destroy it
    local existingUI = player.PlayerGui:FindFirstChild("ShadowVisionUI")
    if existingUI then
        existingUI:Destroy()
    end
    
    -- Main UI
    local visionUI = Instance.new("ScreenGui")
    visionUI.Name = "ShadowVisionUI"
    visionUI.ResetOnSpawn = false
    visionUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    visionUI.Enabled = false -- Start hidden for animation
    hide(visionUI)
    
    -- Calculate base size (16:9 ratio) - MUCH SMALLER for notification style
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    -- Calculate relative width - use a smaller percentage of screen width
    local relWidth = math.min(screenSize.X * 0.2, 300) -- Cap at 300px for large screens
    --[[  isMobile then
        relWidth = math.min(screenSize.X * 0.2, 300) -- Slightly wider on mobile
    end ]]
    
    -- Calculate height based on 16:9 ratio
    local relHeight = relWidth / ASPECT_RATIO
    
    -- Main Panel - Notification-style container with aspect ratio
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, relWidth, 0, relHeight)
    mainPanel.Position = UDim2.new(0, 0, 0, 0) -- Start above screen for animation
    mainPanel.AnchorPoint = Vector2.new(-1, 0)
    mainPanel.BackgroundColor3 = SHADOW_BLACK
    mainPanel.BorderSizePixel = 0
    mainPanel.ZIndex = 10
    mainPanel.Parent = visionUI
    
    -- Force 16:9 aspect ratio
    local aspectRatio = Instance.new("UIAspectRatioConstraint")
    aspectRatio.AspectRatio = ASPECT_RATIO
    aspectRatio.AspectType = Enum.AspectType.FitWithinMaxSize
    aspectRatio.DominantAxis = Enum.DominantAxis.Width
    aspectRatio.Parent = mainPanel
    
    -- Apply styling
    roundCorners(mainPanel, 0.1) -- More rounded for notification style
    addShadow(mainPanel, 0.3, 15)
    applyShadowGradient(mainPanel)
    addStroke(mainPanel, SHADOW_RED, 1, 0.7)
    
    -- Item Name (Top Section)
    local itemName = Instance.new("TextLabel")
    itemName.Name = "ItemName"
    itemName.Size = UDim2.new(0.7, 0, 0.35, 0)
    itemName.Position = UDim2.new(0.05, 0, 0.05, 0)
    itemName.BackgroundTransparency = 1
    itemName.Text = "Tomato"
    itemName.TextColor3 = Color3.new(1, 1, 1)
    itemName.Font = Enum.Font.GothamBold
    itemName.TextSize = relHeight * 0.2
    itemName.TextXAlignment = Enum.TextXAlignment.Left
    itemName.ZIndex = 11
    itemName.TextWrapped = true
    itemName.TextScaled = true
    itemName.Parent = mainPanel
    
    roundCorners(closeButton, 0.3)
    
    -- Horizontal line divider
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0.42, 0)
    divider.BackgroundColor3 = SHADOW_RED
    divider.BorderSizePixel = 0
    divider.Transparency = 0.7
    divider.ZIndex = 11
    divider.Parent = mainPanel
    
    -- Mutations Container (Horizontal Layout)
    local mutationsContainer = Instance.new("Frame")
    mutationsContainer.Name = "MutationsContainer"
    mutationsContainer.Size = UDim2.new(0.9, 0, 0.3, 0)
    mutationsContainer.Position = UDim2.new(0.05, 0, 0.45, 0)
    mutationsContainer.BackgroundTransparency = 1
    mutationsContainer.ZIndex = 11
    mutationsContainer.Parent = mainPanel
    
    -- Create horizontal layout for mutations
    local horizontalLayout = Instance.new("UIListLayout")
    horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
    horizontalLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
    horizontalLayout.Padding = UDim.new(0.03, 0)
    horizontalLayout.Parent = mutationsContainer
    
    -- Create mutation labels horizontally
    local exampleMutations = {"Gold", "Rainbow", "Celestial"}
    
    spawn(function()
    for i, mutation in ipairs(exampleMutations) do
        local mutationLabel = Instance.new("TextLabel")
        mutationLabel.Name = "Mutation_" .. mutation
        mutationLabel.Size = UDim2.new(0, 0, 1, 0) -- Width will be determined by text
        mutationLabel.AutomaticSize = Enum.AutomaticSize.X
        mutationLabel.BackgroundTransparency = 1
        mutationLabel.Text = mutation
        mutationLabel.TextColor3 = MUTATION_COLORS[mutation] or Color3.new(1, 1, 1)
        mutationLabel.Font = Enum.Font.GothamSemibold
        mutationLabel.TextSize = relHeight * 0.13
        mutationLabel.LayoutOrder = i
        mutationLabel.ZIndex = 12
        mutationLabel.Parent = mutationsContainer
        
        -- Add shadow to text for better visibility
        local textShadow = Instance.new("TextLabel")
        textShadow.Name = "Shadow"
        textShadow.Size = UDim2.new(1, 0, 1, 0)
        textShadow.Position = UDim2.new(0, 1, 0, 1)
        textShadow.BackgroundTransparency = 1
        textShadow.Text = mutation
        textShadow.TextColor3 = Color3.new(0, 0, 0)
        textShadow.TextTransparency = 0.6
        textShadow.Font = Enum.Font.GothamSemibold
        textShadow.TextSize = relHeight * 0.13
        textShadow.ZIndex = 11
        textShadow.Parent = mutationLabel
        
        -- Apply rainbow effect to Rainbow mutation
        if mutation == "Rainbow" then
            startRainbowEffect(mutationLabel)
        end
    end
    end)
    
    -- Collect Button (Bottom)
    local collectButton = Instance.new("TextButton")
    collectButton.Name = "CollectButton"
    collectButton.Size = UDim2.new(0.7, 0, 0.22, 0)
    collectButton.Position = UDim2.new(0.5, 0, 0.75, 0)
    collectButton.AnchorPoint = Vector2.new(0.5, 0)
    collectButton.BackgroundColor3 = SHADOW_RED
    collectButton.BorderSizePixel = 0
    collectButton.Text = "COLLECT"
    collectButton.TextColor3 = Color3.new(1, 1, 1)
    collectButton.Font = Enum.Font.GothamBold
    collectButton.TextSize = relHeight * 0.12
    collectButton.ZIndex = 11
    collectButton.Parent = mainPanel
    
    roundCorners(collectButton, 0.2)
    addShadow(collectButton, 0.5, 6)
    
    -- Button hover effect
    local originalColor = collectButton.BackgroundColor3
    local hoverColor = Color3.fromRGB(255, 50, 50)
    
    collectButton.MouseEnter:Connect(function()
        TweenService:Create(
            collectButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = hoverColor}
        ):Play()
    end)
    
    collectButton.MouseLeave:Connect(function()
        TweenService:Create(
            collectButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = originalColor}
        ):Play()
    end)
    
    -- Button click effect
    collectButton.MouseButton1Down:Connect(function()
        TweenService:Create(
            collectButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0.68, 0, 0.21, 0), Position = UDim2.new(0.5, 0, 0.755, 0)}
        ):Play()
    end)
    
    collectButton.MouseButton1Up:Connect(function()
        TweenService:Create(
            collectButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0.7, 0, 0.22, 0), Position = UDim2.new(0.5, 0, 0.75, 0)}
        ):Play()
    end)
    
    -- Function to update the UI based on screen size
    local function updateUISize()
        local newScreenSize = workspace.CurrentCamera.ViewportSize
        local newWidth = math.min(newScreenSize.X * (isMobile and 0.4 or 0.25), 300)
        
        -- Update main panel size
        mainPanel.Size = UDim2.new(0, newWidth, 0, newWidth / ASPECT_RATIO)
        
        -- Update text sizes
        itemName.TextSize = (newWidth / ASPECT_RATIO) * 0.2
        collectButton.TextSize = (newWidth / ASPECT_RATIO) * 0.12
        
        -- Update mutation text sizes
        for _, mutation in ipairs(mutationsContainer:GetChildren()) do
            if mutation:IsA("TextLabel") then
                mutation.TextSize = (newWidth / ASPECT_RATIO) * 0.13
                local shadow = mutation:FindFirstChild("Shadow")
                if shadow then
                    shadow.TextSize = (newWidth / ASPECT_RATIO) * 0.13
                end
            end
        end
    end
    
    -- Connect to screen size changes
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateUISize)
    
-- Modify the openUI function to allow positioning on the left side
local function openUI(position)
    -- Default position is top center if none specified
    position = position or "center"
    
    visionUI.Enabled = true
    
    -- Set initial position above screen
    if position == "left" then
        -- For left position, set X anchor to 0 (left side) with a small margin
        mainPanel.Position = UDim2.new(0, -relWidth, 0, 15)
        mainPanel.AnchorPoint = Vector2.new(0, 0)
        
        -- Slide-in animation from left
        TweenService:Create(
            mainPanel, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, 15, 0, 15)} -- 15px margin from left and top
        ):Play()
    elseif position == "right" then
        -- For right position
        mainPanel.Position = UDim2.new(1, relWidth, 0, 15)
        mainPanel.AnchorPoint = Vector2.new(1, 0)
        
        -- Slide-in animation from right
        TweenService:Create(
            mainPanel, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, -15, 0, 15)} -- 15px margin from right and top
        ):Play()
    else -- center (default)
        -- For center position
        mainPanel.Position = UDim2.new(0.5, 0, 0, -relHeight)
        mainPanel.AnchorPoint = Vector2.new(0.5, 0)
        
        -- Slide-in animation from top
        TweenService:Create(
            mainPanel, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 15)} -- Position at top center
        ):Play()
    end
end

-- Also modify the closeUI function to match the closing animation with the position
local function closeUI()
    -- Get current anchor point to determine direction
    local currentAnchor = mainPanel.AnchorPoint
    
    if currentAnchor.X == 0 then
        -- Left-positioned, slide out to left
        local slideOut = TweenService:Create(
            mainPanel, 
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0, -relWidth, 0, 15)}
        )
        slideOut:Play()
        
        -- Disable UI after animation completes
        slideOut.Completed:Connect(function()
            visionUI.Enabled = false
        end)
    elseif currentAnchor.X == 1 then
        -- Right-positioned, slide out to right
        local slideOut = TweenService:Create(
            mainPanel, 
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(1, relWidth, 0, 15)}
        )
        slideOut:Play()
        
        -- Disable UI after animation completes
        slideOut.Completed:Connect(function()
            visionUI.Enabled = false
        end)
    else
        -- Center-positioned, slide out to top
        local slideOut = TweenService:Create(
            mainPanel, 
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -relHeight)}
        )
        slideOut:Play()
        
        -- Disable UI after animation completes
        slideOut.Completed:Connect(function()
            visionUI.Enabled = false
        end)
    end
end
    
    -- Update UI data function
    local function updateUIData(itemNameText, mutations)
        -- Update item name
        itemName.Text = itemNameText or "Tomato"
        
        -- Clear existing mutations
        for _, child in pairs(mutationsContainer:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Don't destroy the UIListLayout
        if not mutationsContainer:FindFirstChildOfClass("UIListLayout") then
            local newLayout = Instance.new("UIListLayout")
            newLayout.FillDirection = Enum.FillDirection.Horizontal
            newLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            newLayout.SortOrder = Enum.SortOrder.LayoutOrder
            newLayout.Padding = UDim.new(0.03, 0)
            newLayout.Parent = mutationsContainer
        end
        
        spawn(function()
        -- Add new mutations
        mutations = mutations or exampleMutations
        for i, mutation in ipairs(mutations) do
            local mutationLabel = Instance.new("TextLabel")
            mutationLabel.Name = "Mutation_" .. mutation
            mutationLabel.Size = UDim2.new(0, 0, 1, 0)
            mutationLabel.AutomaticSize = Enum.AutomaticSize.X
            mutationLabel.BackgroundTransparency = 1
            mutationLabel.Text = mutation
            mutationLabel.TextColor3 = MUTATION_COLORS[mutation] or Color3.new(1, 1, 1)
            mutationLabel.Font = Enum.Font.GothamSemibold
            mutationLabel.TextSize = relHeight * 0.13
            mutationLabel.LayoutOrder = i
            mutationLabel.ZIndex = 12
            mutationLabel.Parent = mutationsContainer
            
            -- Add shadow to text for better visibility
            local textShadow = Instance.new("TextLabel")
            textShadow.Name = "Shadow"
            textShadow.Size = UDim2.new(1, 0, 1, 0)
            textShadow.Position = UDim2.new(0, 1, 0, 1)
            textShadow.BackgroundTransparency = 1
            textShadow.Text = mutation
            textShadow.TextColor3 = Color3.new(0, 0, 0)
            textShadow.TextTransparency = 0.6
            textShadow.Font = Enum.Font.GothamSemibold
            textShadow.TextSize = relHeight * 0.13
            textShadow.ZIndex = 11
            textShadow.Parent = mutationLabel
            
            -- Apply rainbow effect to Rainbow mutation
            if mutation == "Rainbow" then
                startRainbowEffect(mutationLabel)
            end
        end
        end)
    end
    
    -- Return functions to control the UI
    return {
        UI = visionUI,
        Open = openUI,
        Close = closeUI,
        UpdateData = updateUIData,
        CollectButton = collectButton
    }
end

return CreateVisionUI() 
