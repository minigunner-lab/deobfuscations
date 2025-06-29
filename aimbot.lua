
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bwhw827g29wh/47448/refs/heads/main/SonicxShadow%20UI%20Library.lua",true))()
local Window = library:Window("🎯 GGH Aimbot", getgenv().Gtheme or "Sonic")
local ESPWindow = library:Window("👁️ ESP System", getgenv().Gtheme or "Sonic")
local more = library:Window("More", getgenv().Gtheme or "Sonic")

-- 🎮 SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = workspace
local UserInputService = game:GetService("UserInputService")

-- 👤 PLAYER REFERENCES
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ⚙️ SETTINGS
local Settings = {
    Enabled = false,
    Mode = "enemies",
    AimPart = "Head", 
    MaxDistance = 700,
    WallCheck = true,
    SmoothAiming = true,
    SmoothSpeed = 5, -- 1-20 range
    ShowFOV = false,
    FOVSize = 50,
    TargetPriority = "highest_threat",
    ShowHighlight = true,
    ScreenOnlyMode = false,
    MovementPrediction = true,
    
    -- ESP SETTINGS
    ESPEnabled = false,
    AlwaysOnTop = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
}

-- 📊 STATE
local Connection = nil
local CurrentTarget = nil
local FOVCircle = nil
local TargetHighlight = nil
local ESPHighlights = {}
local Position = "position 2"

-- 🎯 UTILITY FUNCTIONS
local function getDistance(part1, part2)
    if not part1 or not part2 then return 999999 end
    return (part1.Position - part2.Position).Magnitude
end

local function isEnemy(player)
    if not player or player == LocalPlayer then return false end
    if not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    if Settings.Mode == "enemies" then
        local hasTeams = false
        pcall(function()
            hasTeams = game:GetService("Teams"):FindFirstChildOfClass("Team") ~= nil
        end)
        
        if hasTeams then
            return player.Team ~= LocalPlayer.Team
        else
            return true
        end
    else
        return true
    end
end

local function canSeeTarget(targetPlayer, targetPart)
    if not Settings.WallCheck then return true end
    if not LocalPlayer.Character then return false end
    
    local success, result = pcall(function()
        local myHead = LocalPlayer.Character:FindFirstChild("Head")
        if not myHead then return false end
        
        local startPos = myHead.Position
        local endPos = targetPart.Position
        local direction = endPos - startPos
        
        -- 🆕 MULTIPLE RAYCAST APPROACH (ignores fake walls)
        local currentPos = startPos
        local remainingDistance = direction.magnitude
        local maxAttempts = 5 -- Prevent infinite loops
        local attempts = 0
        
        while remainingDistance > 0.5 and attempts < maxAttempts do
            attempts = attempts + 1
            
            local rayDirection = direction.Unit * math.min(remainingDistance, direction.magnitude)
            local rayResult = Workspace:Raycast(currentPos, rayDirection)
            
            if not rayResult then
                -- No obstacles, clear path
                return true
            end
            
            local hitPart = rayResult.Instance
            
            -- 🎯 Check if we hit the target player
            if hitPart.Parent == targetPlayer.Character or hitPart:IsDescendantOf(targetPlayer.Character) then
                return true -- Hit target = can see
            end
            
            -- 🌿 CHECK IF THIS IS A FAKE WALL (plants, decorations, etc.)
            local isFakeWall = false
            
            -- 1. ✅ Transparency check (glass, invisible parts)
            if hitPart.Transparency > 0.3 then
                isFakeWall = true
            end
            
            -- 2. ✅ CanCollide check (decorative parts)
            if not hitPart.CanCollide then
                isFakeWall = true
            end
            
            -- 🛑 If this is a REAL WALL, stop here
            if not isFakeWall then
                return false -- Real wall blocking
            end
            
            -- 🌿 If it's a fake wall, continue raycast from hit point
            currentPos = rayResult.Position + direction.Unit * 0.1 -- Move slightly past the fake wall
            remainingDistance = (endPos - currentPos).magnitude
        end
        
        -- If we went through all attempts and didn't hit anything solid
        return attempts < maxAttempts
    end)
    
    return success and result
end

-- 🎯 MOVEMENT PREDICTION
local function isCharacterStable(targetPlayer)
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then return false end
    
    local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not humanoid or not humanoidRootPart then return false end

    local velocity = humanoidRootPart.Velocity.magnitude
    local stabilityThreshold = humanoid.WalkSpeed
    
    return velocity < stabilityThreshold
end

-- 🎯 FIXED MOVEMENT PREDICTION (Better Calibrated)
local function predictPosition(targetPlayer)
    if not Settings.MovementPrediction then 
        return targetPlayer.Character and targetPlayer.Character:FindFirstChild(Settings.AimPart) and targetPlayer.Character[Settings.AimPart].Position
    end
    
    local myPosition = LocalPlayer.Character and LocalPlayer.Character.Head and LocalPlayer.Character.Head.Position
    local targetCharacter = targetPlayer.Character
    if not myPosition or not targetCharacter then return nil end
    
    local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
    local targetHead = targetCharacter:FindFirstChild(Settings.AimPart)

    if humanoid and humanoidRootPart and targetHead then
        local currentPosition = targetHead.Position
        local velocity = humanoidRootPart.AssemblyLinearVelocity
        local moveDirection = humanoid.MoveDirection

        local distanceToTarget = (currentPosition - myPosition).magnitude

        -- If target is not moving, aim directly
        if velocity.magnitude < 1 then -- 🆕 Increased threshold slightly
            return currentPosition
        end

        -- 🆕 MUCH LESS AGGRESSIVE PREDICTION
        -- Reduced lead factors significantly
        local baseLeadFactor = math.clamp(distanceToTarget / 400, 0.1, 0.4) -- 🆕 Much smaller range (was 0.3-1.2)
        
        -- 🆕 Reduce prediction for close targets (where you need precision)
        if distanceToTarget < 50 then
            baseLeadFactor = baseLeadFactor * 0.3 -- Very minimal prediction for close range
        elseif distanceToTarget < 100 then
            baseLeadFactor = baseLeadFactor * 0.6 -- Moderate reduction for medium range
        end
        
        -- Counter rapid direction changes (keep this part)
        local suddenDirectionChange = velocity.magnitude > 8 and moveDirection.magnitude < 0.1
        local stabilityFactor = suddenDirectionChange and 0.4 or 1 -- 🆕 Reduced from 0.6

        local adjustedLeadFactor = baseLeadFactor * stabilityFactor

        -- 🆕 FINAL PREDICTION (much more conservative)
        local predictedPosition = currentPosition + (velocity * adjustedLeadFactor * 0.5) -- 🆕 Added 0.5 multiplier
        
        -- 🆕 SAFETY CHECK - Don't predict too far from actual position
        local predictionDistance = (predictedPosition - currentPosition).magnitude
        if predictionDistance > 5 then -- Max 5 studs prediction
            local direction = (predictedPosition - currentPosition).Unit
            predictedPosition = currentPosition + (direction * 5)
        end

        return predictedPosition
    end
    
    return nil
end

-- 🆕 FOV CIRCLE DETECTION (Using Drawing API)
local function isInFOV(targetPart)
    if not Settings.ScreenOnlyMode then return true end
    
    local success, result = pcall(function()
        local screenPoint, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
        
        if not onScreen then return false end
        
        -- Check if within FOV circle
        if Settings.ShowFOV then
            local screenCenter = Camera.ViewportSize / 2
            local distance = (Vector2.new(screenPoint.x, screenPoint.y) - screenCenter).Magnitude
            return distance <= (Settings.FOVSize + 25)
        end
        
        return true
    end)
    
    return success and result
end

-- 🎯 PRIORITY TARGETING
local function getTargetPriority(player, targetPart)
    local priority = 0
    
    if Settings.TargetPriority == "closest" then
        local distance = LocalPlayer:DistanceFromCharacter(targetPart.Position)
        priority = Settings.MaxDistance - distance
    elseif Settings.TargetPriority == "lowest_health" then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            priority = 100 - (humanoid.Health - 10)
        end
    elseif Settings.TargetPriority == "highest_threat" then
        local distance = LocalPlayer:DistanceFromCharacter(targetPart.Position)
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local health = humanoid and humanoid.Health or 100
        
        priority = (Settings.MaxDistance - distance) + (100 - health) * 0.5
    end
    
    return priority
end

-- 🎯 TARGET ACQUISITION
local function getBestTarget()
    local bestPlayer = nil
    local highestPriority = -1
    local validTargets = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local character = player.Character
            if character then
                local targetPart = character:FindFirstChild(Settings.AimPart) 
                    or character:FindFirstChild("Head")
                    or character:FindFirstChild("UpperTorso") 
                    or character:FindFirstChild("Torso")
                
                if targetPart and not character:FindFirstChildOfClass("ForceField") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = LocalPlayer:DistanceFromCharacter(targetPart.Position)
                        
                        if distance <= Settings.MaxDistance then
                            if isInFOV(targetPart) then
                                if canSeeTarget(player, targetPart) then
                                    table.insert(validTargets, {
                                        player = player,
                                        part = targetPart,
                                        distance = distance,
                                        priority = getTargetPriority(player, targetPart)
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    for _, target in pairs(validTargets) do
        if target.priority > highestPriority then
            highestPriority = target.priority
            bestPlayer = target.player
        end
    end
    
    return bestPlayer
end

-- ✅ TARGET HIGHLIGHTING (OCCLUDED)
local function createHighlight(targetPlayer)
    if not Settings.ShowHighlight then return end
    if not targetPlayer or not targetPlayer.Character then return end
    
    pcall(function()
        if TargetHighlight then
            TargetHighlight:Destroy()
            TargetHighlight = nil
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "AimbotHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Settings.AlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        highlight.Parent = targetPlayer.Character
        
        TargetHighlight = highlight
    end)
end

-- 🆕 FOV CIRCLE (Drawing API)
local function createFOVCircle()
    if FOVCircle then 
        FOVCircle:Remove()
        FOVCircle = nil
    end
    
    if not Settings.ShowFOV then return end
    
    pcall(function()
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Thickness = 2
        FOVCircle.NumSides = 100
        FOVCircle.Filled = false
        FOVCircle.Color = Color3.fromRGB(255, 0, 0)
        FOVCircle.Transparency = 0.7
        FOVCircle.Visible = true
        
        local p = Position == "position 1" and 2 or 1.83
    
    local centerX, centerY = Camera.ViewportSize.X / p, Camera.ViewportSize.Y / 2
    local radius = Settings.FOVSize / 2
    
    FOVCircle.Position = Vector2.new(centerX, centerY)
    FOVCircle.Radius = radius
    FOVCircle.Visible = Settings.ShowFOV
    end)
end

-- Update FOV circle
local function updateFOVCircle()
    if not FOVCircle then return end
    local p = Position == "position 1" and 2 or 1.83
    local centerX, centerY = Camera.ViewportSize.X / p, Camera.ViewportSize.Y / 2
    local radius = Settings.FOVSize / 2
    
    FOVCircle.Position = Vector2.new(centerX, centerY)
    FOVCircle.Radius = radius
    FOVCircle.Visible = Settings.ShowFOV 
end

-- 🆕 ESP SYSTEM
local function updateESP()
    -- Clear old ESP
    for userId, highlight in pairs(ESPHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    ESPHighlights = {}
    
    if not Settings.ESPEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character then
            pcall(function()
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillTransparency = 1
                highlight.OutlineColor = Settings.ESPColor
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Settings.AlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                highlight.Parent = player.Character
                
                ESPHighlights[player.UserId] = highlight
            end)
        end
    end
end

-- ✅ FIXED SMOOTH AIMING (OLD WORKING METHOD!)
local function aimAt(targetPosition)
    if not targetPosition then return end
    
    pcall(function()
        if Settings.SmoothAiming then
            -- 🆕 OLD WORKING METHOD - Direct CFrame interpolation
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)
            
            -- Convert speed to alpha (1-20 becomes 0.05-1.0)
            local alpha = Settings.SmoothSpeed / 20
            
            -- Smooth interpolation every frame
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, alpha)
        else
            -- Instant aim
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)
        end
    end)
end

-- 🔄 MAIN LOOP
local function aimbot()
    if not Settings.Enabled then return end
    if not LocalPlayer.Character then return end
    
    -- Update FOV circle position
    if FOVCircle and Settings.ShowFOV then
        updateFOVCircle()
    end
    
    local target = getBestTarget()
    CurrentTarget = target
    
    if target and target.Character then
        local aimPosition = predictPosition(target)
        
        if aimPosition then
            aimAt(aimPosition) -- ✅ Now uses working smooth aim method
            createHighlight(target)
        end
    else
        if TargetHighlight then
            TargetHighlight:Destroy()
            TargetHighlight = nil
        end
    end
end

local function startAimbot()
    if Connection then Connection:Disconnect() end
    Connection = RunService.Heartbeat:Connect(aimbot)
    print("🎯 Perfect Aimbot STARTED!")
end

local function stopAimbot()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    if TargetHighlight then
        TargetHighlight:Destroy()
        TargetHighlight = nil
    end
    
    if FOVCircle then
        FOVCircle:Remove()
        FOVCircle = nil
    end
    
    print("⏹️ Aimbot STOPPED!")
end

-- 🎮 MAIN WINDOW GUI

Window:Toggle("🎯 Enable Aimbot", false, function(enabled)
    Settings.Enabled = enabled
    if enabled then
        startAimbot()
    else
        stopAimbot()
    end
end)

Window:Dropdown("Mode", {"enemies", "others"}, function(mode)
    Settings.Mode = mode
end)

Window:Dropdown("Aim Part", {"Head", "Torso", "HumanoidRootPart"}, function(part)
    if part == "Torso" then
        Settings.AimPart = "UpperTorso"
    else
        Settings.AimPart = part
    end
end)

Window:Box("Max Distance", function(text, focuslost)
    if focuslost and tonumber(text) then
        Settings.MaxDistance = math.max(10, tonumber(text))
        print("📏 Distance set to:", Settings.MaxDistance)
    end
end)

Window:Dropdown("Target Priority", {"closest", "lowest_health", "highest_threat"}, function(priority)
    Settings.TargetPriority = priority
end)
more:Toggle("🧱 Wall Check", true, function(enabled)
    Settings.WallCheck = enabled
end)

more:Toggle("🌊 Smooth Aim", true, function(enabled)
    Settings.SmoothAiming = enabled
    print("🌊 Smooth aim:", enabled and "ON" or "OFF")
end)

more:Box("Smooth Speed (1-20)", function(text, focuslost)
    if focuslost and tonumber(text) then
        Settings.SmoothSpeed = math.clamp(tonumber(text), 1, 20)
        print("⚡ Smooth speed:", Settings.SmoothSpeed, "/ 20")
    end
end)

-- FOV CONTROLS
more:Toggle("Screen-Only Mode (FOV)", false, function(enabled)
    Settings.ShowFOV = enabled
    Settings.ScreenOnlyMode = enabled
    
    if enabled then
        createFOVCircle()
        print("👁️ Screen-only targeting enabled")
    else
        if FOVCircle then
            FOVCircle:Remove()
            FOVCircle = nil
        end
        print("🔄 360° targeting enabled")
    end
end)

more:Box("FOV Size", function(text, focuslost)
    if focuslost and tonumber(text) then
        Settings.FOVSize = math.clamp(tonumber(text), 1, 500)
        print(" FOV size:", Settings.FOVSize)
        
        if Settings.ShowFOV then
            createFOVCircle()
        end
    end
end)

Window:Toggle("Movement Prediction", true, function(enabled)
    Settings.MovementPrediction = enabled
    print("🎯 Movement prediction:", enabled and "ON" or "OFF")
end)

Window:Toggle("Highlight Target", true, function(enabled)
    Settings.ShowHighlight = enabled
    if not enabled and TargetHighlight then
        TargetHighlight:Destroy()
        TargetHighlight = nil
    end
end)

-- ESP WINDOW
ESPWindow:Toggle("👁️ Enable ESP", false, function(enabled)
    Settings.ESPEnabled = enabled
    updateESP()
    print("👁️ ESP:", enabled and "ON" or "OFF")
end)

ESPWindow:Toggle("AlwaysOnTop", false, function(enabled)
    Settings.AlwaysOnTop = enabled
    updateESP()
end)

local STC = loadstring(game:HttpGet("https://gist.githubusercontent.com/Bwhw827g29wh/84d4a9c747bfee81ddc9e453e9d144a6/raw/ce28638dabd077dabe0745feaad62b079e3eafc4/Support%2520the%2520creator.lua",true))()

ESPWindow:Button("Support the creator", function()
    STC:Show()
end)

more:Dropdown("Fov position", {"position 1", "position 2"}, function(position)
    Position = position
end)

-- ESP UPDATE EVENTS
Players.PlayerAdded:Connect(function()
    if Settings.ESPEnabled then
        wait(1)
        updateESP()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPHighlights[player.UserId] then
        ESPHighlights[player.UserId]:Destroy()
        ESPHighlights[player.UserId] = nil
    end
end)

-- ESP UPDATE LOOP
spawn(function()
    while wait(2) do
        if Settings.ESPEnabled then
            updateESP()
        end
    end
end)

-- CLEANUP
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        if FOVCircle then FOVCircle:Remove() end
        if TargetHighlight then TargetHighlight:Destroy() end
        for _, highlight in pairs(ESPHighlights) do
            if highlight then highlight:Destroy() end
        end
    end
end)
