local function uwu(t)
    game.StarterGui:SetCore("SendNotification", {
    Title = "Missing functionality",
    Text = "Executor not supported `"..tostring(identifyexecutor())"`",
    Duration = 10
})
    return print("💔💔💔")
end

if not (setmetatable and getmetatable) then
    uwu()
elseif not (newcclosure and hookmetamethod) then
    uwu()
end 

local ErrorReporter = (loadstring or load)(game:HttpGet("https://gist.githubusercontent.com/Bwhw827g29wh/254014852d75d5387a09ffc1df71b06c/raw/0108f2ac67e8bfe16a45682df51bf02c11490e34/Reporter.lua"))() 
ErrorReporter.setupGlobalErrorHandling()
ErrorReporter.SCRIPT_NAME = "Fruit Vision"

local function secureSpawn(func)
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

local service = setmetatable({}, {
	__index = function(self, key)
		return (cloneref or function(service) return service end)(game.GetService(game, key))
	end
})

local CollectionService = service.CollectionService
local UserInputService = service.UserInputService
local RunService = service.RunService
local TweenService = service.TweenService

local a,b = pcall(function()
    return require(service.ReplicatedStorage.Modules.MutationHandler)
end)

if not a then 
   service.StarterGui:SetCore("SendNotification", {
    Title = "Error",
    Text = tostring(identifyexecutor())..", 'require' not supported",
    Duration = 10
})
ErrorReporter.reportError(tostring(identifyexecutor())..", 'require' not supported","Grow a Garden","Unknown line")
return print("💔💔💔")
end 

local GGH = {
    ["Version"] = "1.4"
}
local ReplicatedStorage = service.ReplicatedStorage
local Players = service.Players
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CoreGui = service.CoreGui
local Workspace = service.Workspace
local Camera = Workspace.CurrentCamera
local Parent = PlayerGui
local mouse = LocalPlayer:GetMouse()
local Backpack = LocalPlayer.Backpack
local Farm = require(ReplicatedStorage.Modules.GetFarmAsync)(LocalPlayer)
local Remotes = require(ReplicatedStorage.Modules.Remotes)
local Connection_Cache = {}
local Old = {}

local OldIndex 
OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, property)
    if property == "CanQuery" and Old[self] then
        return Old[self] == "true" and true or false
    end
    return OldIndex(self, property)
end))

local NewIndex 
NewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, property, value)
    if property == "CanQuery" and Old[self] then
        value = true
    end
    
    return NewIndex(self,property,value)
end)) 

secureSpawn(function()
for i, Fruits in pairs(CollectionService:GetTagged("Harvestable")) do
    if Fruits then
        for _, ClickAble in pairs(Fruits:GetDescendants()) do
            if ClickAble and Old[ClickAble] == nil and (ClickAble:IsA("BasePart") or ClickAble:IsA("MeshPart")) then
                Old[ClickAble] = ClickAble.CanQuery == true and "true" or "false"
                ClickAble.CanQuery = true
            end
        end
    end
end
end)

--[[
CollectionService:GetInstanceAddedSignal("Harvestable"):Connect(function(v)
    while wait(1) do
    for i,b in pairs(v:GetDescendants()) do
        if b:IsA("ProximityPrompt") then
            break
        end
    end
    end
    for i,b in pairs(v:GetDescendants()) do
        if b:IsA("BasePart") or b:IsA("MeshPart") then
            Old[b] = b.CanQuery == true and "true" or "false"
        --[[ elseif b:IsA("MeshPart") then
            Old[b] = b.CanQuery == true and "true" or "false" 
        end
    end
end) ]]

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
else
    Main.Parent = CoreGui
    Parent = Main.Parent
end
end)
end 

local function formatWithCommas(number)
    local formatted = tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:gsub("^,", "")
end

local function removeFormatting(value)
    if not value then return nil end
    local cleaned = value:gsub(",", ""):gsub("¢", "")
    return tonumber(cleaned)
end

-- Game-style raycast function
local function RaycastToPosition(mouseLocation)
    local viewportRay = Camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    -- Only include objects tagged as "Harvestable"
    raycastParams.FilterDescendantsInstances = CollectionService:GetTagged("Harvestable")
    
    local raycastResult = Workspace:Raycast(viewportRay.Origin, viewportRay.Direction * 500, raycastParams)
    if raycastResult and raycastResult.Instance then
        return raycastResult
    end
    return nil
end

-- Enhanced target validation using GetAncestors()
local function isValidTarget(raycastResult)
    if not raycastResult then return false, nil, nil end

    local instance = raycastResult.Instance
    local plant 
    local Fruits = instance:FindFirstAncestorWhichIsA("Folder")
    
    if Fruits and (Fruits.Name == "Fruits" or Fruits.Name == "Plants_Physical") then
        for i,v in pairs(Fruits:GetChildren()) do
            if instance:IsDescendantOf(v) then
                plant = v
            end
        end
    end
    
     if plant and plant:FindFirstChild("Variant") then
            
            local parentName = plant.Parent.Name
            local type = parentName == "Fruits" and "fruit" or parentName == "Plants_Physical" and "plant"
            
            return true, plant, type, instance
           
        end 
    
    return false, nil, nil, nil
end

-- Function to manually calculate fruit values
local function CalculateFruitValue(fruitModel, coma)
    local itemString = fruitModel.Name
    if fruitModel:IsA("Tool") then
        wait(.1)
        itemString = fruitModel.Item_String.Value
    end
    
    local variant = fruitModel:WaitForChild("Variant")
    if not variant then
        -- warn("CalculateFruitValue | Missing Variant")
        return 0
    end
    
    local weight = fruitModel:WaitForChild("Weight")
    if not weight then
        -- warn("CalculateFruitValue | Missing Weight")
        return 0
    end
    
    local itemData
    for _, item in pairs(require(ReplicatedStorage.Item_Module).Return_All_Data()) do
        if item[1] == itemString then
            itemData = item
            break
        end
    end
    
    if not itemData or #itemData < 3 then
        -- warn("CalculateFruitValue | ItemData is invalid for: " .. itemString)
        return 0
    end
    
    local baseValue = itemData[3]
    local expectedWeight = itemData[2]
    
    local variantMultiplier = 1
    if variant.Value == "Gold" then
        variantMultiplier = 20
    elseif variant.Value == "Rainbow" then
        variantMultiplier = 50
    end
    
    local mutationMultiplier = 1
    local mutationHandler = require(ReplicatedStorage.Modules.MutationHandler)
    
    for mutationName, mutationData in pairs(mutationHandler:GetMutations()) do
        if fruitModel:GetAttribute(mutationName) then
            mutationMultiplier = mutationMultiplier + (mutationData.ValueMulti - 1)
        end
    end
    
    local baseValueWithMultipliers = baseValue * mutationMultiplier * variantMultiplier
    local weightRatio = weight.Value / expectedWeight
    local clampedWeightRatio = math.clamp(weightRatio, 0.95, 100000000)
    local finalValue = baseValueWithMultipliers * (clampedWeightRatio * clampedWeightRatio)
    
    local done = math.round(finalValue)
    local a = formatWithCommas(done)
    if not coma then
        return a
    else
        return done
    end
end 

local function Collect(cropsTable)
    if not cropsTable or #cropsTable == 0 then
        print("No crops provided to collect!")
        return 0
    end
    
    -- Mark all crops as collected for visual feedback
    for _, crop in pairs(cropsTable) do
        if crop and crop.Parent then
            crop:SetAttribute("Collected", true)
            
            -- Reset collected attribute after 1 second
            task.delay(1, function()
                if crop and crop.Parent then
                    crop:SetAttribute("Collected", nil)
                end
            end)
        end
    end
    
    -- Send collect request
    -- print("Collecting", #cropsTable, "crops...")
    Remotes.Crops.Collect.send(cropsTable)
    return #cropsTable
end

local Mutations = require(ReplicatedStorage.Modules.MutationHandler)

local targetplant 
local mutationList = {}

local highlight = Camera:FindFirstChild("Highlight") or Instance.new("Highlight", Camera)
highlight.FillTransparency = 0.65
highlight.FillColor = Color3.fromRGB(0,155,255)
highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
highlight.OutlineTransparency = 0

local visionUIcontroller = (loadstring or load)(game:HttpGet("https://gist.githubusercontent.com/Bwhw827g29wh/b1e011c08ae1723f7c51e6c862446966/raw/88c1581a993a9a6d44a0ee431422be99a0ae714c/Mutations.lua"))()

visionUIcontroller.CollectButton.MouseButton1Click:Connect(function()
     if targetplant and targetplant.Parent then
     Collect({targetplant})
     end
end) 

-- Game-style continuous highlighting
local highlightConnection
local function startHighlighting()
    if highlightConnection then
        highlightConnection:Disconnect()
    end
    
    highlightConnection = RunService.RenderStepped:Connect(function()
        local mouseLocation = UserInputService:GetMouseLocation()
        local raycastResult = RaycastToPosition(mouseLocation)
        
        if not raycastResult then
            highlight.Adornee = nil

            return
        end
        
        local isValid, validTarget, targetType, hitPart = isValidTarget(raycastResult)
        
        if isValid and validTarget then
            if highlight.Adornee ~= validTarget then
                -- Smooth transition like the game
                highlight.FillTransparency = 1
                local tween = TweenService:Create(highlight, TweenInfo.new(0.25), {
                    FillTransparency = 0.5
                })
                tween:Play()
            end
            highlight.Adornee = validTarget
        else
            highlight.Adornee = targetplant and targetplant or nil
        end
    end)
end

function GGH:stopHighlighting()
    if highlightConnection then
        highlightConnection:Disconnect()
        highlightConnection = nil
    end
    highlight.Adornee = nil
end

-- Game-style click handler
local function handleClickInput(mouseLocation, processed)
    if processed then return end
    
    local raycastResult = RaycastToPosition(mouseLocation)
    local isValid, validTarget, targetType, hitPart = isValidTarget(raycastResult)
    
    if not isValid then return end
    
    mutationList = {}
    
    -- Process mutations
    for mutation,_ in pairs(Mutations:GetMutations()) do
        if validTarget:GetAttribute(mutation) then
            table.insert(mutationList, mutation)
        end
    end
    
    targetplant = validTarget
    highlight.Adornee = validTarget
    
        if validTarget:WaitForChild("Variant") and validTarget:WaitForChild("Variant").Value ~= "Normal" then
            table.insert(mutationList,validTarget:WaitForChild("Variant").Value)
        end
    
    visionUIcontroller.UpdateData(
        validTarget.Name.." ¢"..tostring(CalculateFruitValue(validTarget)),
        #mutationList > 0 and mutationList or {"Normal"}
    )
end

local Lop = false
function GGH:OpenVisionUI(toggleState)
    Lop = toggleState
    if toggleState then
        visionUIcontroller.Open("left")
        
        
        secureSpawn(function()
while Lop do
if not Lop then break end
for i, Fruits in pairs(CollectionService:GetTagged("Harvestable")) do
    if Fruits then
        for _, ClickAble in pairs(Fruits:GetDescendants()) do
            if ClickAble and Old[ClickAble] == nil and (ClickAble:IsA("BasePart") or ClickAble:IsA("MeshPart")) then
                Old[ClickAble] = ClickAble.CanQuery == true and "true" or "false"
                ClickAble.CanQuery = true
            end
        end
    end
end
task.wait(60)
end
        end) 
        
        -- Start game-style highlighting
        startHighlighting()
        
        Connection_Cache.c1 = mouse.Button1Down:Connect(function()
                handleClickInput(UserInputService:GetMouseLocation(), false)
            end)
        
        -- Handle clicks based on input type (like the game)
        --[[ if UserInputService.TouchEnabled then
            Connection_Cache.c1 = UserInputService.TouchTapInWorld:Connect(handleClickInput)
        else
            Connection_Cache.c1 = mouse.Button1Down:Connect(function()
                handleClickInput(UserInputService:GetMouseLocation(), false)
            end)
        end ]]
        
    elseif not toggleState then
        GGH:stopHighlighting()
        
        if Connection_Cache.c1 then
            Connection_Cache.c1:Disconnect()
        end
        
        visionUIcontroller.Close()
        highlight.Adornee = nil
    end
end

if not getgenv().igit then
function removeNaiqiqy(h)
    for i,v in h:GetChildren() do
        if v:IsA("ImageButton") and v.Name ~= "Shop" then
            v:Destroy()
        elseif v.Name ~= "Shop" and v.Name ~= "UIAspectRatioConstraint" and v.Name ~= ("UIListLayout") then
            v:Destroy()
        end
    end
end 

local SeedShop = LocalPlayer.PlayerGui.Hud_UI:Clone()
SeedShop.SideBtns.Position = UDim2.new(0.005,0,0.42,0)
SeedShop.SideBtns.Shop.Label.Text = "Tubol"
SeedShop.Name = "tubol"
hide(SeedShop)

local a = false
SeedShop.SideBtns.Shop.Vector.Image = "rbxassetid://14260097894"
SeedShop.SideBtns.Shop.MouseButton1Click:Connect(function()
    a = not a
    GGH:OpenVisionUI(a)
end)

removeNaiqiqy(SeedShop.SideBtns)
local Notification_upvr = require(ReplicatedStorage.Modules.Notification)
Notification_upvr:CreateNotification("<font color=\"#87CEEB\"><b>Made by GGH:)</b></font>")
Notification_upvr:CreateNotification("<font color=\"#87CEEB\"><b>Version: 1.3</b></font>")
Notification_upvr:CreateNotification("<font color=\"#87CEEB\"><b>Name: Fruit Vision</b></font>")
local a = loadstring(game:HttpGet("https://gist.githubusercontent.com/Bwhw827g29wh/003d3458acfbf3f52435752cf360b526/raw/1b059b5c24fa865b24902dcac158e135624214c1/Success%2520logger.lua"))()
a.Type = "Fruit Vision"

a.sendSuccess()
wait(10)

Notification_upvr:CreateNotification("<font color=\"#87CEEB\"><b>Made by GGH:)</b></font>")
Notification_upvr:CreateNotification("<font color=\"#87CEEB\"><b>Version: 1.3</b></font>")
Notification_upvr:CreateNotification("<font color=\"#87CEEB\"><b>Name: Fruit Vision</b></font>")

end

GGH.visionUIcontroller = visionUIcontroller

return GGH
