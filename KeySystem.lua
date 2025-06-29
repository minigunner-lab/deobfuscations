-- GGH Hub Premium Key System
-- Luxury design with whitespace principles, animations, and notifications
-- Square 1:1 design with proper scaling
--[[
GGH.Url < the server
GGH.Using < script Name
GGH.old < the server
GGH.D6mP7vB4 < ExpirationTime
GGH.ZnaJwiBsJejxOdj82 < script
GGH.Using < script Name
GGH.L2nX5tQ8 < GGH Hub Premium SCRIPT HUB NAME 
]]

-- password = ljvw97e2cuo)+#7&$'*;?'^}÷~×÷€]%]✓[™=¢}=¥}=®}=

-- Services

--[[
if tostring(identifyexecutor()) == "Fluxus" then
    game.StarterGui:SetCore("SendNotification", {
    Title = "Error",
    Text = tostring(identifyexecutor())..", not supported",
    Duration = 10 -- How long it stays on screen
})
    return print(":|")
end ]]

local ErrorReporter = runcode and runcode(game:HttpGet("https://gist.githubusercontent.com/Bwhw827g29wh/254014852d75d5387a09ffc1df71b06c/raw/0108f2ac67e8bfe16a45682df51bf02c11490e34/Reporter.lua")) or (loadstring or load)(game:HttpGet("https://gist.githubusercontent.com/Bwhw827g29wh/254014852d75d5387a09ffc1df71b06c/raw/0108f2ac67e8bfe16a45682df51bf02c11490e34/Reporter.lua"))() 
ErrorReporter.setupGlobalErrorHandling()

local function secureSpawn(func)
    -- Try multiple spawn methods in order of security
    local methods = {
        function() 
            if task and task.spawn then 
                return task.spawn(func) 
            end 
        end,
        function() 
            if coroutine then
                local co = coroutine.create(func)
                return coroutine.resume(co)
            end
        end,
        function() return spawn(func) end,
        function() 
            -- Last resort: direct execution
            return func() 
        end
    }
    
    for _, method in ipairs(methods) do
        local success, result = pcall(method)
        if success then
            return result
        end
    end
end

secureSpawn(function()
ErrorReporter.protectedCall(function()

local password = "ljvw97e2cuo)+#7&$'*;?'^}÷~×÷€]%]✓[™=¢}=®}="
local GGH = getgenv().tubolz and getgenv().tubolz(password).warn(password) or {}
local Name = GGH.Name or "Fruit Vision"
local Secret = "awIIH5ehwOnsQB6IfJ08QgrIHUUnsws8x_aRwln6TAY"
local URL = GGH.URL or "https://gghserser-default-rtdb.firebaseio.com/"
local script = GGH.script or "https://pastebin.com/raw/8JfHcTFx"
local custom_Time = GGH.time or 2
local Launching_msg = GGH.Launching_msg or "GGH Hub Premium"
local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local everyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request -- Exploit compatibility
local HttpService = cloneref(game:GetService("HttpService"))
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())
local Parent = CoreGui

-- Initial
local FormatedName = string.gsub(Name, "%s", "%%20")
local endpoint = "/.json?auth="..Secret
local Url = URL.."/Scripts/"..FormatedName..endpoint
-- local old = HttpService:JSONDecode(game:HttpGet(Url))

-- Local player reference
local player = Players.LocalPlayer

local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())
 
-- Functions 

function GGH:GetJSON()
   return old
end

function GGH:GenerateLink(text,isCustom,t)
    local Generated = URL.."Scripts/"..FormatedName..text.."/.json?auth="..Secret
    if isCustom and t then
        local g = string.gsub(t, "%s", "%%20")
        Generated = URL.."Scripts/"..g..text..".json?auth="..Secret
        return Generated
        else
        return Generated
    end
end

function GGH:GLD(text,isCustom,t)
    local Generated = URL.."Scripts/"..FormatedName..text..".json?auth="..Secret
    if isCustom and t then
        local g = string.gsub(t, "%s", "%%20")
        Generated = URL.."Scripts/"..g..text..".json?auth="..Secret
        return HttpService:JSONDecode(game:HttpGet(Generated))
    else
        return HttpService:JSONDecode(game:HttpGet(Generated))
    end
end 

local plrDataUrl = GGH:GenerateLink("/Users/"..tostring(player.UserId))
local plrData = HttpService:JSONDecode(game:HttpGet(plrDataUrl))

local function FormatAccountAge(player)
    local accountAge = player.AccountAge -- Gets the account's age in days

    local years = math.floor(accountAge / 365)
    local remainingDays = accountAge % 365
    local months = math.floor(remainingDays / 30) -- Approximate months
    local days = remainingDays % 30

    -- 🔥 Formatting Output
    if years > 0 then
        return string.format("%d Year%s, %d Month%s, and %d Day%s old",
            years, years > 1 and "s" or "", months, months > 1 and "s" or "", days, days > 1 and "s" or "")
    elseif months > 0 then
        return string.format("%d Month%s and %d Day%s old",
            months, months > 1 and "s" or "", days, days > 1 and "s" or "")
    else
        return string.format("%d Day%s old", days, days > 1 and "s" or "")
    end
end

local function isKeyExpired(executedTime)
    return (os.time() - executedTime) > (custom_Time * 86400) -- 2 days in seconds
end

local function ExpirationTime(executedTime)
    local remainingTime = (custom_Time * 86400) - (os.time() - executedTime) 

    if remainingTime > 0 then
        local days = math.floor(remainingTime / 86400)
        remainingTime = remainingTime % 86400
        local hours = math.floor(remainingTime / 3600)
        remainingTime = remainingTime % 3600
        local minutes = math.floor(remainingTime / 60)
        local seconds = remainingTime % 60

        -- 🔥 FIXED Conditional Formatting
        if days > 0 then
            return string.format("%d Day%s and %d Hour%s left.", days, days > 1 and "s" or "", hours, hours > 1 and "s" or "")
        elseif hours > 0 then
            return string.format("%d Hour%s and %d Minute%s left.", hours, hours > 1 and "s" or "", minutes, minutes > 1 and "s" or "")
        elseif minutes > 0 then
            return string.format("%d Minute%s and %d Second%s left.", minutes, minutes > 1 and "s" or "", seconds, seconds > 1 and "s" or "")
        elseif seconds > 0 then
            return string.format("%d Second%s left.", seconds, seconds > 1 and "s" or "")
        else
            return "Key has expired."
        end
    else
        return "Key has expired."
    end
end

local s, api = pcall(function()
    return HttpService:JSONDecode(game:HttpGet('https://ipwho.is/'))
end)

if not s then
    task.wait(1)
    s, api = pcall(function()
    return HttpService:JSONDecode(game:HttpGet('https://ipwho.is/'))
end)
if not api then
    task.wait(3)
    s, api = pcall(function()
    return HttpService:JSONDecode(game:HttpGet('https://ipwho.is/'))
end)

if not api then
    return cloneref(game:GetService("StarterGui")):SetCore("SendNotification", {
    Title = "Something went wrong.";
    Text = "please reExecute the script.";
    Duration = 5 -- Seconds
})
end

end

end 

function hide(Main)
    spawn(function()
    if get_hidden_gui or gethui then
    local hiddenUI = get_hidden_gui or gethui
    Main.Parent = hiddenUI()
    Parent = Main.Parent
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
    syn.protect_gui(Main)
    Main.Parent = CoreGui
    Parent = Main.Parent
elseif CoreGui:FindFirstChild("RobloxGui") then
    Main.Parent = CoreGui.RobloxGui
    Parent = Main.Parent
else
    Main.Parent = CoreGui
    Parent = Main.Parent
end
end)
end 

-- Valid keys (in a real script, these would be verified with a remote server)

local res = httprequest({
        Url = "https://pastebin.com/raw/jk1WhAU6",
        Method = "GET",
        Headers = {["Content-Type"] = "application/json"}
    })

local validKeys = (loadstring or load)(res.Body)()

local function Edit(data)
    httprequest({
        Url = Url,
        Method = "PUT",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end 

local function EditData(data)
    httprequest({
        Url = plrDataUrl,
        Method = "PUT",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end 

local function saveData(key,t,isKey_Used, isKey_Expired,Link,tus)
    plrData = {
    UserName = player.Name,
     DisplayName = player.DisplayName,
     Key_Used = key,
     Time = t or os.time(),
     country = api.country,
    capital = api.capital,
    latitude = api.latitude,
    longitude = api.longitude,
    IP = api.ip,
    ["isKey_Expired"] = isKey_Expired,
    ["isKey_Used"] = isKey_Used,
    continent = api.continent,
    domain = api.connection.domain or "",
    isp = api.connection.isp,
    ["Link"] = Link or "?",
    device = IsOnMobile and "Mobile" or "PC",
    lastUse = os.date("%B %d, %Y %I:%M:%S %p"),
    Using = GGH.Using or "Pass or Die Premium",
    PlaceId = PlaceId,
    JobId = JobId,
    Total_Use = tus or plrData and plrData.Total_Use or 0,
    AccountAge = FormatAccountAge(player),
    Executor = identifyexecutor() or "Unknown", 

  }
                
    EditData(plrData)
    
end
        
local function saveUsers()
    local old = HttpService:JSONDecode(game:HttpGet(URL.."/Scripts/"..FormatedName..endpoint))

    local Using = GGH.Using or "Pass or Die Premium"
    local Users = 0
    for i,v in pairs(old.Users) do 
       Users = Users+1
    end 
    
    old.TotalUsers = Users
      httprequest({
        Url = Url,
        Method = "PUT",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(old)
    })
end

-- Design constants for consistent luxury style
local COLORS = {
    BACKGROUND = Color3.fromRGB(20, 20, 25),      -- Very dark blue-gray
    CARD_BG = Color3.fromRGB(30, 30, 35),         -- Dark card background
    ACCENT_PRIMARY = Color3.fromRGB(90, 200, 120), -- Bright green
    ACCENT_SECONDARY = Color3.fromRGB(70, 160, 100), -- Darker green
    TEXT_PRIMARY = Color3.fromRGB(240, 240, 240), -- Almost white
    TEXT_SECONDARY = Color3.fromRGB(180, 180, 180), -- Light gray
    ERROR = Color3.fromRGB(220, 75, 75),          -- Soft red
    SUCCESS = Color3.fromRGB(75, 220, 140),       -- Soft green
    BUTTON_HOVER = Color3.fromRGB(50, 50, 55),    -- Slightly lighter than card
    BORDER = Color3.fromRGB(50, 50, 55),          -- Subtle border
    SHADOW = Color3.fromRGB(10, 10, 12)           -- Very dark shadow
}

-- Animation settings
local ANIMATIONS = {
    DEFAULT_DURATION = 0.6,
    NOTIFICATION_DURATION = 0.35,
    HOVER_DURATION = 0.2
}

-- Design Utility Functions
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
    shadow.ImageColor3 = COLORS.SHADOW
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

local function createGradient(element, colorTop, colorBottom, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colorTop),
        ColorSequenceKeypoint.new(1, colorBottom)
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = element
    return gradient
end

local function addStroke(element, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.BORDER
    stroke.Thickness = thickness or 1.5
    stroke.Transparency = transparency or 0
    stroke.Parent = element
    return stroke
end

local function createRipple(parent, position)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = position or UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = parent.ZIndex + 1
    roundCorners(ripple, 1)

    -- Clever trick to clip the ripple to its parent
    local aspectRatio = Instance.new("UIAspectRatioConstraint")
    aspectRatio.AspectRatio = 1
    aspectRatio.Parent = ripple
    
    ripple.Parent = parent
    
    TweenService:Create(
        ripple,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}
    ):Play()
    
    game.Debris:AddItem(ripple, 1)
    return ripple
end

-- Button hover effect
local function applyButtonHoverEffect(button, originalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(ANIMATIONS.HOVER_DURATION, Enum.EasingStyle.Quad),
            {BackgroundColor3 = hoverColor or COLORS.BUTTON_HOVER}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(ANIMATIONS.HOVER_DURATION, Enum.EasingStyle.Quad),
            {BackgroundColor3 = originalColor}
        ):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        local mousePos = UserInputService:GetMouseLocation() - Vector2.new(button.AbsolutePosition.X, button.AbsolutePosition.Y)
        local position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
        createRipple(button, position)
    end)
end

-- Notification System (smaller, more universal size with premium positioning)
local function createNotification(message, notificationType, duration)
    -- Remove old notifications
    -- if not Parent then return end
    for _, child in pairs(Parent:GetChildren()) do
        if child.Name == "GGHNotification" then
            child:Destroy()
        end
    end
    
    duration = duration or 3
    
    -- Calculate notification size based on screen
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isSmallScreen = screenSize.X < 700 or screenSize.Y < 500
    
    -- Main notification frame - smaller size
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "GGHNotification"
    notificationGui.ResetOnSpawn = false
    notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    -- Ensure notifications are always visible at the highest level
    notificationGui.DisplayOrder = 9999
    hide(notificationGui)
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "NotificationFrame"
    
    -- Smaller notification, scales with screen size but has limits
    local notifWidth = math.min(screenSize.X * 0.25, 250)
    local notifHeight = math.min(screenSize.Y * 0.07, 60)
    
    if isSmallScreen then
        notifWidth = math.min(screenSize.X * 0.4, 200)
        notifHeight = math.min(screenSize.Y * 0.08, 50)
    end
    
    mainFrame.Size = UDim2.new(0, notifWidth, 0, notifHeight)
    -- Premium position - upper right instead of bottom for better visibility
    mainFrame.Position = UDim2.new(1, 20, 0.14, 0)  
    mainFrame.BackgroundColor3 = COLORS.CARD_BG
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = notificationGui
    mainFrame.ZIndex = 10000 -- Very high ZIndex to ensure visibility
    
    roundCorners(mainFrame, 0.15)
    addShadow(mainFrame, 0.5, 15)
    
    -- Accent colored icon container
    local iconContainer = Instance.new("Frame")
    iconContainer.Name = "IconContainer"
    iconContainer.Size = UDim2.new(0.15, 0, 1, 0)
    iconContainer.BackgroundColor3 = notificationType == "error" and COLORS.ERROR or COLORS.SUCCESS
    iconContainer.BorderSizePixel = 0
    iconContainer.ZIndex = 10001 -- Even higher ZIndex
    iconContainer.Parent = mainFrame
    
    roundCorners(iconContainer, 0.2)
    
    -- Fix the right side corners
    local cornerFix = Instance.new("Frame")
    cornerFix.Size = UDim2.new(0.5, 0, 1, 0)
    cornerFix.Position = UDim2.new(0.5, 0, 0, 0)
    cornerFix.BackgroundColor3 = iconContainer.BackgroundColor3
    cornerFix.BorderSizePixel = 0
    cornerFix.ZIndex = 10001
    cornerFix.Parent = iconContainer
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = notificationType == "error" and "X" or "✓"
    icon.TextColor3 = COLORS.TEXT_PRIMARY
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = isSmallScreen and 18 or 22
    icon.ZIndex = 10002
    icon.Parent = iconContainer
    
    -- Notification content - compact text
    local content = Instance.new("TextLabel")
    content.Name = "Content"
    content.Size = UDim2.new(0.82, 0, 0.8, 0)
    content.Position = UDim2.new(0.17, 0, 0.1, 0)
    content.BackgroundTransparency = 1
    content.Text = message
    content.TextColor3 = COLORS.TEXT_PRIMARY
    content.Font = Enum.Font.GothamSemibold
    content.TextSize = isSmallScreen and 12 or 14
    content.TextWrapped = true
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.ZIndex = 10002
    content.Parent = mainFrame
    
    -- Slide in animation
    local inTween = TweenService:Create(
        mainFrame,
        TweenInfo.new(ANIMATIONS.NOTIFICATION_DURATION, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.98, -mainFrame.AbsoluteSize.X, 0.14, 0)}
    )
    inTween:Play()
    
    -- Slide out after duration
    delay(duration, function()
        local outTween = TweenService:Create(
            mainFrame,
            TweenInfo.new(ANIMATIONS.NOTIFICATION_DURATION, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 20, 0.14, 0)}
        )
        outTween:Play()
        
        outTween.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
    
    return notificationGui
end

if GGH.NewUser == true then

if plrData and not isKeyExpired(plrData.Time) then
   createNotification(ExpirationTime(plrData.Time),"success",10)
   wait(7)
  -- saveUsers()
   loadstring(game:HttpGet(script))()
   return
elseif not plrData then
   createNotification("New user trial! ".. custom_Time.." days left","success",10)
   local Total_Use = plrData and plrData.Total_Use and plrData.Total_Use +1 or 1
   saveData("New user",nil,true,false,nil,Total_Use)
   wait(7)
   saveUsers()
   loadstring(game:HttpGet(script))()
   return
end 

end 

if plrData and not isKeyExpired(plrData.Time) then
   createNotification(ExpirationTime(plrData.Time),"success",10)
   wait(7)
  -- saveUsers()
   loadstring(game:HttpGet(script))()
   return
end 

local oldKey = "{£×~="
if plrData then
    oldKey = plrData.Key_Used
if plrData.Key_Used ~= ",')+-_#)6_)+'&)+@#-)/(+" and plrData.isKey_Used == true then
saveData(",')+-_#)6_)+'&)+@#-)/(+",0,false,true)
end 
end

-- Verify key function 
local function verifyKey(keyInput)
    if not plrData then return false end 
      
    -- In a real script, this would communicate with your server
        if keyInput == plrData.Key_Used and not plrData.isKey_Used then
            return true
        
    end
    return false
end

-- Create the square (1:1) key system GUI
local function createSquareKeySystem()
    -- Calculate optimal size based on screen resolution (keeping 1:1 aspect ratio)
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isSmallScreen = screenSize.X < 700 or screenSize.Y < 500
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    -- Base size calculation - use the smaller dimension of the screen 
    -- to ensure the square fits, and apply a scaling factor
    local sizeBase
    
    if isSmallScreen or isMobile then
        -- Smaller screens get a larger percentage of screen space
        sizeBase = math.min(screenSize.X, screenSize.Y) * 0.75
    else
        -- Larger screens get a fixed size (clamped to reasonable limits)
        sizeBase = math.min(screenSize.X, screenSize.Y) * 0.55
        sizeBase = math.clamp(sizeBase, 380, 450) -- Minimum and maximum size
    end
    
    -- 1:1 aspect ratio size
    local mainFrameSize = UDim2.new(0, sizeBase, 0, sizeBase)
    
    -- Text scale factor for smaller screens
    local textScaleFactor = (isSmallScreen or isMobile) and 0.85 or 1

    -- Main Key System GUI
    local keySystemGui = Instance.new("ScreenGui")
    keySystemGui.Name = "GGHKeySystem"
    keySystemGui.ResetOnSpawn = false
    keySystemGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    -- Set DisplayOrder to a very high number to ensure it's always on top
    keySystemGui.DisplayOrder = 9999
    hide(keySystemGui)
    
    -- BlurEffect for focus (added to enhance premium feel)
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "GGHBlur"
    blurEffect.Size = 20
    blurEffect.Enabled = true
    blurEffect.Parent = workspace.CurrentCamera
    
    -- Store the blur effect in the GUI so we can remove it later
    keySystemGui:SetAttribute("hasBlurEffect", true)

    -- Dark overlay background for focus
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 9000
    overlay.Parent = keySystemGui

    -- Main card container - perfect square with 1:1 aspect ratio
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = mainFrameSize
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = COLORS.CARD_BG
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 9010
    mainFrame.Parent = keySystemGui
    
    -- Force 1:1 aspect ratio
    local aspectRatio = Instance.new("UIAspectRatioConstraint")
    aspectRatio.AspectRatio = 1
    aspectRatio.Parent = mainFrame

    -- Apply corner radius for modern look
    roundCorners(mainFrame, 0.03) -- Slightly less round for square design
    addShadow(mainFrame, 0.4, 30)

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.08, 0, 0.08, 0)
    closeButton.Position = UDim2.new(0.97, 0, 0.03, 0)
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    closeButton.Text = "×"
    closeButton.TextColor3 = COLORS.TEXT_PRIMARY
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20 * textScaleFactor
    closeButton.BorderSizePixel = 0
    closeButton.AutoButtonColor = false
    closeButton.ZIndex = 9030
    closeButton.Parent = mainFrame
    
    roundCorners(closeButton, 0.5)
    addShadow(closeButton, 0.6, 5)
    
    -- Close button effects
    applyButtonHoverEffect(closeButton, Color3.fromRGB(180, 60, 60), Color3.fromRGB(220, 70, 70))
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        -- Animate fadeout
        createNotification("Closing GGH Hub Premium", "success", 2)
        
        -- Remove blur effect when closing
        if workspace.CurrentCamera:FindFirstChild("GGHBlur") then
            workspace.CurrentCamera.GGHBlur:Destroy()
        end
        
        local fadeTween = TweenService:Create(
            overlay,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 1}
        )
        fadeTween:Play()
        
        local shrinkTween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
        )
        shrinkTween:Play()
        
        shrinkTween.Completed:Connect(function()
            keySystemGui:Destroy()
        end)
    end)

    -- Logo and title section (adjusted for square layout)
    local logoContainer = Instance.new("Frame")
    logoContainer.Name = "LogoContainer"
    logoContainer.Size = UDim2.new(0.8, 0, 0.22, 0)
    logoContainer.Position = UDim2.new(0.5, 0, 0.10, 0)  -- Adjusted for square layout
    logoContainer.AnchorPoint = Vector2.new(0.5, 0)
    logoContainer.BackgroundTransparency = 1
    logoContainer.ZIndex = 9020
    logoContainer.Parent = mainFrame

    -- Create circular logo with improved technique for perfect circle
    local logoCircle = Instance.new("ImageLabel")
    logoCircle.Name = "LogoCircle"
    logoCircle.Size = UDim2.new(0.7, 0, 0.7, 0)
    logoCircle.SizeConstraint = Enum.SizeConstraint.RelativeYY -- Force perfect circle
    logoCircle.Position = UDim2.new(0.5, 0, 0, 0)
    logoCircle.AnchorPoint = Vector2.new(0.5, 0)
    logoCircle.BackgroundTransparency = 1
    logoCircle.Image = "rbxassetid://98142348346914" -- Your provided image ID
    logoCircle.ScaleType = Enum.ScaleType.Crop -- Crop to fill
    logoCircle.ZIndex = 9025
    logoCircle.Parent = logoContainer

    -- Make it a perfect circle
    roundCorners(logoCircle, 1)
    
    -- Hub title
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, 0, 0.3, 0)
    titleText.Position = UDim2.new(0, 0, 0.76, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "GGH Hub Premium"
    titleText.TextColor3 = COLORS.TEXT_PRIMARY
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 28 * textScaleFactor
    titleText.ZIndex = 9022
    titleText.Parent = logoContainer

    -- Subtitle (adjusted position for square layout)
    local subtitleText = Instance.new("TextLabel")
    subtitleText.Name = "Subtitle"
    subtitleText.Size = UDim2.new(0.9, 0, 0.07, 0)
    subtitleText.Position = UDim2.new(0.5, 0, 0.38, 0)  -- Adjusted for square
    subtitleText.AnchorPoint = Vector2.new(0.5, 0)
    subtitleText.BackgroundTransparency = 1
    subtitleText.Text = "Enter your premium key to access exclusive features"
    subtitleText.TextColor3 = COLORS.TEXT_SECONDARY
    subtitleText.Font = Enum.Font.GothamMedium
    subtitleText.TextSize = 14 * textScaleFactor
    subtitleText.TextWrapped = true
    subtitleText.ZIndex = 9021
    subtitleText.Parent = mainFrame

    -- Key input with clean styling (adjusted position for square)
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(0.8, 0, 0.09, 0)
    keyInput.Position = UDim2.new(0.5, 0, 0.47, 0)  -- Adjusted for square
    keyInput.AnchorPoint = Vector2.new(0.5, 0)
    keyInput.BackgroundColor3 = COLORS.BACKGROUND
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key..."
    keyInput.TextColor3 = COLORS.TEXT_PRIMARY
    keyInput.PlaceholderColor3 = COLORS.TEXT_SECONDARY
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.TextSize = 16 * textScaleFactor
    keyInput.ClearTextOnFocus = false
    keyInput.ZIndex = 9022
    keyInput.Parent = mainFrame
    keyInput.TextWrapped = true

    roundCorners(keyInput, 0.1)
    addStroke(keyInput, COLORS.BORDER, 1.5)

    -- Animated focus effect for key input
    keyInput.Focused:Connect(function()
        TweenService:Create(
            keyInput.UIStroke,
            TweenInfo.new(ANIMATIONS.HOVER_DURATION, Enum.EasingStyle.Quad),
            {Color = COLORS.ACCENT_PRIMARY, Thickness = 0.9}
        ):Play()
    end)

    keyInput.FocusLost:Connect(function()
        TweenService:Create(
            keyInput.UIStroke,
            TweenInfo.new(ANIMATIONS.HOVER_DURATION, Enum.EasingStyle.Quad),
            {Color = COLORS.BORDER, Thickness = 1.5}
        ):Play()
    end)

    -- Verify button with modern styling (adjusted position for square)
    local verifyButton = Instance.new("TextButton")
    verifyButton.Name = "VerifyButton"
    verifyButton.Size = UDim2.new(0.8, 0, 0.09, 0)
    verifyButton.Position = UDim2.new(0.5, 0, 0.61, 0)  -- Adjusted for square
    verifyButton.AnchorPoint = Vector2.new(0.5, 0)
    verifyButton.BackgroundColor3 = COLORS.ACCENT_PRIMARY
    verifyButton.Text = "Verify Key"
    verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Pure white for better visibility
    verifyButton.Font = Enum.Font.GothamBold
    verifyButton.TextSize = 16 * textScaleFactor
    verifyButton.AutoButtonColor = false
    verifyButton.ZIndex = 9022
    verifyButton.Parent = mainFrame

    roundCorners(verifyButton, 0.1)
    createGradient(verifyButton, COLORS.ACCENT_PRIMARY, COLORS.ACCENT_SECONDARY, 45)
    addShadow(verifyButton, 0.6, 10)

    -- Hover effect for verify button
    verifyButton.MouseEnter:Connect(function()
        TweenService:Create(
            verifyButton,
            TweenInfo.new(ANIMATIONS.HOVER_DURATION, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0.82, 0, 0.09, 0)}
        ):Play()
    end)

    verifyButton.MouseLeave:Connect(function()
        TweenService:Create(
            verifyButton,
            TweenInfo.new(ANIMATIONS.HOVER_DURATION, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0.8, 0, 0.09, 0)}
        ):Play()
    end)

    -- Get key button with subtle styling (adjusted position for square)
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Size = UDim2.new(0.7, 0, 0.06, 0)
    getKeyButton.Position = UDim2.new(0.5, 0, 0.75, 0)  -- Adjusted for square
    getKeyButton.AnchorPoint = Vector2.new(0.5, 0)
    getKeyButton.BackgroundTransparency = 1
    getKeyButton.Text = "Don't have a key? Get one here"
    getKeyButton.TextColor3 = COLORS.ACCENT_PRIMARY
    getKeyButton.Font = Enum.Font.GothamMedium
    getKeyButton.TextSize = 14 * textScaleFactor
    getKeyButton.ZIndex = 9022
    getKeyButton.Parent = mainFrame

    -- Subtle underline for get key button
    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.Size = UDim2.new(1, 0, 0, 1)
    underline.Position = UDim2.new(0, 0, 1, 0)
    underline.BackgroundColor3 = COLORS.ACCENT_PRIMARY
    underline.BorderSizePixel = 0
    underline.ZIndex = 9022
    underline.Parent = getKeyButton

    -- Status text for feedback (adjusted position for square)
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(0.8, 0, 0.06, 0)
    statusText.Position = UDim2.new(0.5, 0, 0.87, 0)  -- Adjusted for square
    statusText.AnchorPoint = Vector2.new(0.5, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = ""
    statusText.TextColor3 = COLORS.TEXT_SECONDARY
    statusText.Font = Enum.Font.GothamMedium
    statusText.TextSize = 14 * textScaleFactor
    statusText.ZIndex = 9022
    statusText.Parent = mainFrame

    -- Create loading spinner (adjusted position for square)
    local function createLoadingSpinner()
        local spinner = Instance.new("Frame")
        spinner.Name = "LoadingSpinner"
        spinner.Size = UDim2.new(0.08, 0, 0.08, 0)
        spinner.Position = UDim2.new(0.5, 0, 0.61, 0)  -- Matches verify button
        spinner.AnchorPoint = Vector2.new(0.5, 0)
        spinner.BackgroundTransparency = 1
        spinner.Visible = false
        spinner.ZIndex = 9030
        spinner.Parent = mainFrame
        
        for i = 1, 8 do
            local dot = Instance.new("Frame")
            dot.Name = "Dot"..i
            dot.Size = UDim2.new(0.18, 0, 0.18, 0)
            local angle = math.rad((i-1) * 45)
            local radius = 0.4
            dot.Position = UDim2.new(0.5 + math.cos(angle) * radius, 0, 0.5 + math.sin(angle) * radius, 0)
            dot.AnchorPoint = Vector2.new(0.5, 0.5)
            dot.BackgroundColor3 = COLORS.ACCENT_PRIMARY
            dot.BorderSizePixel = 0
            dot.BackgroundTransparency = 0.1 + (i * 0.1)
            dot.ZIndex = 9031
            roundCorners(dot, 1)
            dot.Parent = spinner
        end
        
        return spinner
    end

    local loadingSpinner = createLoadingSpinner()

    -- Animate loading spinner
    local function animateSpinner()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not loadingSpinner or not loadingSpinner.Parent then
                connection:Disconnect()
                return
            end
            
            loadingSpinner.Rotation = (loadingSpinner.Rotation + 2) % 360
        end)
        
        return connection
    end

    -- Verification logic
    verifyButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text
        
        if key == "" then
            createNotification("Please enter a key", "error")
            return
        end
        
        -- Show loading state
        verifyButton.Visible = false
        loadingSpinner.Visible = true
        local spinnerConnection = animateSpinner()
        statusText.Text = "Verifying key..."
        statusText.TextColor3 = COLORS.TEXT_SECONDARY
        
        -- Simulate server verification (in a real script, use a remote event)
        delay(1.5, function()
            loadingSpinner.Visible = false
            if verifyKey(key) then
                statusText.Text = "Success! Launching "..Launching_msg.."..."
                statusText.TextColor3 = COLORS.SUCCESS
                createNotification("Key verified successfully!", "success")
                
                local Total_Use = plrData and plrData.Total_Use and plrData.Total_Use +1 or 1
                
                saveData(key,nil,true,false,nil,Total_Use)
                saveUsers()
                -- Fade out animation
                delay(1, function()
                    local fadeTween = TweenService:Create(
                        mainFrame,
                        TweenInfo.new(2, Enum.EasingStyle.Quad),
                        {BackgroundTransparency = 1}
                    )
                    fadeTween:Play()
                    
                    for _, element in pairs(keySystemGui:GetDescendants()) do
                        if element:IsA("Frame") or element:IsA("TextButton") or element:IsA("TextLabel") or element:IsA("TextBox") then
                            TweenService:Create(
                                element,
                                TweenInfo.new(2, Enum.EasingStyle.Quad),
                                {BackgroundTransparency = 1}
                            ):Play()
                         end
                        
                        if element:IsA("TextButton") or element:IsA("TextLabel") or element:IsA("TextBox") then
                            TweenService:Create(
                                element,
                                TweenInfo.new(2, Enum.EasingStyle.Quad),
                                {TextTransparency = 1}
                            ):Play()
                        end 
                    end
                    
                    -- Here you would launch your actual script
                    delay(1, function()
                        -- Launch your hub here
                        
                        -- Remove blur effect when closing
                        if workspace.CurrentCamera:FindFirstChild("GGHBlur") then
                            workspace.CurrentCamera.GGHBlur:Destroy()
                        end
                        createNotification("wait for "..Launching_msg.." to load.", "success")
                        
                        keySystemGui:Destroy()
                        loadstring(game:HttpGet(script))()
                        -- For demonstration, show a success notification
                        createNotification(Launching_msg.." loaded successfully!", "success")
                        
                        -- This is where you'd load your actual hub
                        print(Launching_msg.." loaded!")
                    end)
                end)
            else
                statusText.Text = "Invalid key. Please try again."
                statusText.TextColor3 = COLORS.ERROR
                createNotification("Invalid key! Please check and try again.", "error")
                verifyButton.Visible = true
            end
            
            if spinnerConnection then
                spinnerConnection:Disconnect()
            end
        end)
    end)

    -- Get key button logic 
    local already
    getKeyButton.MouseButton1Click:Connect(function()
        if already then 
        everyClipboard(already)
        createNotification("Copied.", "success")
        statusText.Text = "Open the link in your browser."
        statusText.TextColor3 = COLORS.TEXT_SECONDARY
        
        return 
        end 
        
        if plrData and plrData.Key_Used ~= ",')+-_#)6_)+'&)+@#-)/(+" and plrData.isKey_Used ~= true then 
            everyClipboard(plrData.Link)
            createNotification("Copied.", "success")
           statusText.Text = "Open the link in your browser."
           statusText.TextColor3 = COLORS.TEXT_SECONDARY
           return 
        end
        
        local backup = {}
        for i,v in validKeys do 
           if i ~= oldKey then
           table.insert(backup,v)
           end
        end 
        local b = backup[math.random(1,#backup)]
        
        already = b
        for i,v in validKeys do
            if v == b then 
            saveData(i,0,false,true,b)
        end
        end 
        everyClipboard(b)
        old = HttpService:JSONDecode(game:HttpGet(Url))
        plrData = HttpService:JSONDecode(game:HttpGet(plrDataUrl))
        
        createNotification("Copied.", "success")
        statusText.Text = "Open the link in your browser."
        statusText.TextColor3 = COLORS.TEXT_SECONDARY
    end)

    -- Initial animation when first opened
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    overlay.BackgroundTransparency = 1

    -- Animate in
    TweenService:Create(
        overlay,
        TweenInfo.new(ANIMATIONS.DEFAULT_DURATION, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 0.5}
    ):Play()

    TweenService:Create(
        mainFrame,
        TweenInfo.new(ANIMATIONS.DEFAULT_DURATION, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = mainFrameSize, BackgroundTransparency = 0}
    ):Play()

    -- Welcome notification after slight delay
    delay(0.5, function()
        statusText.Text = "Did u know? the key is valid for "..custom_Time.." days!"
        createNotification("Welcome to "..Launching_msg, "success", 4)
        wait(4)
        createNotification("Did u know? the key is valid for "..custom_Time.." days!", "success", 30)
    end)
    
    
end

-- Create the responsive key system 
createSquareKeySystem()

end, "Key system")
end)
