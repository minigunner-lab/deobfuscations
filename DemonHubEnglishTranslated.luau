local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- Main container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 500, 0, 300)
mainContainer.Position = UDim2.new(0.5, -250, 0.5, -150) -- Center of screen
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = false
mainContainer.Parent = gui

-- Top bar (drag bar)
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 35)
dragBar.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
dragBar.BorderSizePixel = 2
dragBar.BorderColor3 = Color3.new(0, 0, 0)
dragBar.Parent = mainContainer

-- Close button X
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = dragBar

closeButton.MouseButton1Click:Connect(function()
	mainContainer.Visible = false
end)

-- Sections menu on the left
local sectionsFrame = Instance.new("ScrollingFrame")
sectionsFrame.Size = UDim2.new(0, 120, 1, -35)
sectionsFrame.Position = UDim2.new(0, 0, 0, 35)
sectionsFrame.ScrollBarThickness = 6
sectionsFrame.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
sectionsFrame.BorderSizePixel = 2
sectionsFrame.BorderColor3 = Color3.new(0, 0, 0)
sectionsFrame.Parent = mainContainer

-- Section content
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -120, 1, -35)
contentFrame.Position = UDim2.new(0, 120, 0, 35)
contentFrame.ScrollBarThickness = 6
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 2
contentFrame.BorderColor3 = Color3.new(0, 0, 0)
contentFrame.Parent = mainContainer

-- Background image inside content
local bgImage = Instance.new("ImageLabel")
bgImage.Name = "ContentBackground"
bgImage.Size = contentFrame.Size
bgImage.Position = contentFrame.Position
bgImage.Image = "rbxassetid://127999374636975"
bgImage.BackgroundTransparency = 0
bgImage.ZIndex = contentFrame.ZIndex - 1
bgImage.Parent = mainContainer

-- Toggle button (open/close interface)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0.5, -20)
toggleButton.Image = "rbxassetid://109596885589960"
toggleButton.BackgroundTransparency = 1
toggleButton.ZIndex = 999999
toggleButton.Parent = gui

-- Drag toggle button
local dragging = false
local dragStart, startPos

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = toggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		toggleButton.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
	end
end)

-- Open/close interface with button
local open = false
local openTween = TweenService:Create(mainContainer, TweenInfo.new(0.4), {Position = UDim2.new(0.5, -250, 0.5, -150)})
local closeTween = TweenService:Create(mainContainer, TweenInfo.new(0.4), {Position = UDim2.new(-1, 0, 0.5, -150)})

toggleButton.MouseButton1Click:Connect(function()
	open = not open
	if open then
		mainContainer.Visible = true
		openTween:Play()
	else
		closeTween:Play()
		closeTween.Completed:Wait()
		mainContainer.Visible = false
	end
end)

-- Drag interface from top bar
local draggingFrame = false
local dragStartF, startPosF

local function startDragging(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingFrame = true
		dragStartF = input.Position
		startPosF = mainContainer.Position

		local moveConn
		moveConn = UserInputService.InputChanged:Connect(function(moveInput)
			if moveInput.UserInputType == Enum.UserInputType.MouseMovement and draggingFrame then
				local delta = moveInput.Position - dragStartF
				mainContainer.Position = UDim2.new(
					startPosF.X.Scale, startPosF.X.Offset + delta.X,
					startPosF.Y.Scale, startPosF.Y.Offset + delta.Y
				)
				bgImage.Position = contentFrame.Position -- Keep image in place
			end
		end)

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingFrame = false
				if moveConn then moveConn:Disconnect() end
			end
		end)
	end
end

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not closeButton:IsDescendantOf(input.Target) then
			startDragging(input)
		end
	end
end)

-- Section names
local sectionNames = {"Main Menu", "Scripts", "Player", "Trolling", "Skin", "Protection", "Cars", "Server", "Names"}
-- Store toggle state for each feature to maintain state when navigating
local playerSettings = {
	jumpOn = false,
	speedOn = false,
	noClipOn = false
}

local protectionFeatures = {
	antiAir = false,
	antiVoid = false,
	antiBan = false
}

-- Section contents
local sectionContents = {}

-- Section: Main Menu
sectionContents["Main Menu"] = function()
	contentFrame:ClearAllChildren()

	local texts = {
		"Ev_Rami",
		"My Roblox: Sajwaad",
		"DemonHubV0.5 Script"
	}

	for i, text in ipairs(texts) do
		local label = Instance.new("TextLabel")
		label.Text = text
		label.Size = UDim2.new(0, 300, 0, 40)
		label.Position = UDim2.new(0, 10, 0, (i-1)*45 + 10)
		label.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		label.TextColor3 = Color3.new(0, 0, 0)
		label.Font = Enum.Font.SourceSansBold
		label.TextSize = 22
		label.Parent = contentFrame
	end
end

-- Section: Scripts
sectionContents["Scripts"] = function()
	contentFrame:ClearAllChildren()

	local scripts = {
		{Title = "vr7", Script = 'loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-VR7-35232"))()'},
		{Title = "Martin", Script = 'loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-MARTIN-IRAQ-31476"))()'},
		{Title = "Sander X", Script = 'loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Sander-x-22769"))()'},
		{Title = "Anti Sit", Script = 'loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Anti-sit-script-38345"))()'},
		{Title = "Doors Script", Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/main/DemonXpart"))()'},
		{Title = "Developer Tool", Script = 'loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Dex-Fixed-Bugs-42099"))()'},
		{Title = "FPS Boost", Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/main/Fps"))()'}
	}

	for i, data in ipairs(scripts) do
		local btn = Instance.new("TextButton")
		btn.Text = data.Title
		btn.Size = UDim2.new(0, 260, 0, 35)
		btn.Position = UDim2.new(0, 10, 0, (i-1)*40 + 10)
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 20
		btn.Parent = contentFrame

		btn.MouseButton1Click:Connect(function()
			loadstring(data.Script)()
		end)
	end
end

-- Section: Player
sectionContents["Player"] = function()
	contentFrame:ClearAllChildren()

	local player = LocalPlayer

	-- Fly button
	local flyBtn = Instance.new("TextButton")
	flyBtn.Text = "Fly"
	flyBtn.Size = UDim2.new(0, 260, 0, 35)
	flyBtn.Position = UDim2.new(0, 10, 0, 10)
	flyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	flyBtn.TextColor3 = Color3.new(1, 1, 1)
	flyBtn.Font = Enum.Font.SourceSansBold
	flyBtn.TextSize = 20
	flyBtn.Parent = contentFrame
	flyBtn.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/main/Fly"))()
	end)

	-- Jump power
	local jumpInput = Instance.new("TextBox")
	jumpInput.PlaceholderText = "50"
	jumpInput.Text = "50"
	jumpInput.Size = UDim2.new(0, 60, 0, 25)
	jumpInput.Position = UDim2.new(0, 10, 0, 55)
	jumpInput.BackgroundColor3 = Color3.new(1, 1, 1)
	jumpInput.TextColor3 = Color3.new(0, 0, 0)
	jumpInput.ClearTextOnFocus = false
	jumpInput.Parent = contentFrame

	local jumpToggle = Instance.new("TextButton")
	jumpToggle.Text = playerSettings.jumpOn and "Jump ON" or "Jump OFF"
	jumpToggle.Size = UDim2.new(0, 180, 0, 25)
	jumpToggle.Position = UDim2.new(0, 80, 0, 55)
	jumpToggle.BackgroundColor3 = playerSettings.jumpOn and Color3.fromRGB(0,170,0) or Color3.new(0, 0, 0)
	jumpToggle.TextColor3 = Color3.new(1, 1, 1)
	jumpToggle.Font = Enum.Font.SourceSansBold
	jumpToggle.TextSize = 18
	jumpToggle.Parent = contentFrame

	jumpToggle.MouseButton1Click:Connect(function()
		local char = player.Character
		if char then
			local humanoid = char:FindFirstChild("Humanoid")
			if humanoid then
				playerSettings.jumpOn = not playerSettings.jumpOn
				jumpToggle.Text = playerSettings.jumpOn and "Jump ON" or "Jump OFF"
				jumpToggle.BackgroundColor3 = playerSettings.jumpOn and Color3.fromRGB(0,170,0) or Color3.new(0,0,0)
				if playerSettings.jumpOn then
					local val = tonumber(jumpInput.Text) or 50
					humanoid.JumpPower = val
				else
					humanoid.JumpPower = 50
				end
			end
		end
	end)

	-- Walk speed
	local speedInput = Instance.new("TextBox")
	speedInput.PlaceholderText = "16"
	speedInput.Text = "16"
	speedInput.Size = UDim2.new(0, 60, 0, 25)
	speedInput.Position = UDim2.new(0, 10, 0, 95)
	speedInput.BackgroundColor3 = Color3.new(1, 1, 1)
	speedInput.TextColor3 = Color3.new(0, 0, 0)
	speedInput.ClearTextOnFocus = false
	speedInput.Parent = contentFrame

	local speedToggle = Instance.new("TextButton")
	speedToggle.Text = playerSettings.speedOn and "Speed ON" or "Speed OFF"
	speedToggle.Size = UDim2.new(0, 180, 0, 25)
	speedToggle.Position = UDim2.new(0, 80, 0, 95)
	speedToggle.BackgroundColor3 = playerSettings.speedOn and Color3.fromRGB(0,170,0) or Color3.new(0, 0, 0)
	speedToggle.TextColor3 = Color3.new(1, 1, 1)
	speedToggle.Font = Enum.Font.SourceSansBold
	speedToggle.TextSize = 18
	speedToggle.Parent = contentFrame

	speedToggle.MouseButton1Click:Connect(function()
		local char = player.Character
		if char then
			local humanoid = char:FindFirstChild("Humanoid")
			if humanoid then
				playerSettings.speedOn = not playerSettings.speedOn
				speedToggle.Text = playerSettings.speedOn and "Speed ON" or "Speed OFF"
				speedToggle.BackgroundColor3 = playerSettings.speedOn and Color3.fromRGB(0,170,0) or Color3.new(0,0,0)
				if playerSettings.speedOn then
					local val = tonumber(speedInput.Text) or 16
					humanoid.WalkSpeed = val
				else
					humanoid.WalkSpeed = 16
				end
			end
		end
	end)

	-- NoClip button 🔥
	local noclipToggle = Instance.new("TextButton")
	noclipToggle.Text = playerSettings.noClipOn and "NoClip ON" or "NoClip OFF"
	noclipToggle.Size = UDim2.new(0, 260, 0, 35)
	noclipToggle.Position = UDim2.new(0, 10, 0, 135)
	noclipToggle.BackgroundColor3 = playerSettings.noClipOn and Color3.fromRGB(0, 170, 0) or Color3.new(0, 0, 0)
	noclipToggle.TextColor3 = Color3.new(1, 1, 1)
	noclipToggle.Font = Enum.Font.SourceSansBold
	noclipToggle.TextSize = 20
	noclipToggle.Parent = contentFrame

	local connection
	noclipToggle.MouseButton1Click:Connect(function()
		local char = player.Character
		if char then
			playerSettings.noClipOn = not playerSettings.noClipOn
			noclipToggle.Text = playerSettings.noClipOn and "NoClip ON" or "NoClip OFF"
			noclipToggle.BackgroundColor3 = playerSettings.noClipOn and Color3.fromRGB(0, 170, 0) or Color3.new(0, 0, 0)

			if playerSettings.noClipOn then
				connection = game:GetService("RunService").Stepped:Connect(function()
					for _, part in pairs(char:GetChildren()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end)
			else
				if connection then
					connection:Disconnect()
					connection = nil
				end
				for _, part in pairs(char:GetChildren()) do
					if part:IsA("BasePart") then
						part.CanCollide = true
					end
				end
			end
		end
	end)
end

-- Section: Trolling
sectionContents["Trolling"] = function()
	contentFrame:ClearAllChildren()

	local player = game.Players.LocalPlayer
	local runService = game:GetService("RunService")

	local targetName = ""
	local frontFollowConnection = nil
	local backFollowConnection = nil
	local watchConnection = nil
	local toggles = {followFront = false, followBack = false, watching = false}

	-- Function to find player by first 3 letters
	local function findPlayerByPartialName(part)
		if #part < 3 then return nil end
		for _, p in ipairs(game.Players:GetPlayers()) do
			if p.Name:lower():sub(1, #part) == part:lower() then
				return p
			end
		end
		return nil
	end

	-- Player name textbox
	local targetBox = Instance.new("TextBox")
	targetBox.PlaceholderText = "Enter player name (3 letters)"
	targetBox.Size = UDim2.new(0, 280, 0, 35)
	targetBox.Position = UDim2.new(0, 10, 0, 10)
	targetBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	targetBox.TextColor3 = Color3.new(1, 1, 1)
	targetBox.Font = Enum.Font.SourceSansBold
	targetBox.TextSize = 18
	targetBox.Parent = contentFrame

	-- Watch button
	local watchBtn = Instance.new("TextButton")
	watchBtn.Text = "Watch (OFF)"
	watchBtn.Size = UDim2.new(0, 280, 0, 35)
	watchBtn.Position = UDim2.new(0, 10, 0, 55)
	watchBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	watchBtn.TextColor3 = Color3.new(1, 1, 1)
	watchBtn.Font = Enum.Font.SourceSansBold
	watchBtn.TextSize = 18
	watchBtn.Parent = contentFrame

	watchBtn.MouseButton1Click:Connect(function()
		toggles.watching = not toggles.watching
		watchBtn.Text = toggles.watching and "Watch (ON)" or "Watch (OFF)"
		watchBtn.BackgroundColor3 = toggles.watching and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(0, 0, 0)

		if toggles.watching then
			local target = findPlayerByPartialName(targetBox.Text)
			if not target then warn("Player not found") return end
			watchConnection = runService.Heartbeat:Connect(function()
				if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					game.Workspace.CurrentCamera.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 10)
				end
			end)
		else
			if watchConnection then watchConnection:Disconnect() watchConnection = nil end
		end
	end)

	-- Front follow button
	local frontBtn = Instance.new("TextButton")
	frontBtn.Text = "Front Follow (OFF)"
	frontBtn.Size = UDim2.new(0, 280, 0, 35)
	frontBtn.Position = UDim2.new(0, 10, 0, 100)
	frontBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frontBtn.TextColor3 = Color3.new(1, 1, 1)
	frontBtn.Font = Enum.Font.SourceSansBold
	frontBtn.TextSize = 18
	frontBtn.Parent = contentFrame

	frontBtn.MouseButton1Click:Connect(function()
		toggles.followFront = not toggles.followFront
		frontBtn.Text = toggles.followFront and "Front Follow (ON)" or "Front Follow (OFF)"
		frontBtn.BackgroundColor3 = toggles.followFront and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(0, 0, 0)

		if toggles.followFront then
			local target = findPlayerByPartialName(targetBox.Text)
			if not target then warn("Player not found") return end
			frontFollowConnection = runService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character.HumanoidRootPart
					local targetHRP = target.Character.HumanoidRootPart
					hrp.CFrame = CFrame.new(targetHRP.Position + (targetHRP.CFrame.LookVector * 2)) * CFrame.Angles(0, math.rad(targetHRP.Orientation.Y + 180), 0)
					task.wait(0.01)
				end
			end)
		else
			if frontFollowConnection then frontFollowConnection:Disconnect() frontFollowConnection = nil end
		end
	end)

	-- Back follow button
	local backBtn = Instance.new("TextButton")
	backBtn.Text = "Back Follow (OFF)"
	backBtn.Size = UDim2.new(0, 280, 0, 35)
	backBtn.Position = UDim2.new(0, 10, 0, 145)
	backBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	backBtn.TextColor3 = Color3.new(1, 1, 1)
	backBtn.Font = Enum.Font.SourceSansBold
	backBtn.TextSize = 18
	backBtn.Parent = contentFrame

	backBtn.MouseButton1Click:Connect(function()
		toggles.followBack = not toggles.followBack
		backBtn.Text = toggles.followBack and "Back Follow (ON)" or "Back Follow (OFF)"
		backBtn.BackgroundColor3 = toggles.followBack and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(0, 0, 0)

		if toggles.followBack then
			local target = findPlayerByPartialName(targetBox.Text)
			if not target then warn("Player not found") return end
			backFollowConnection = runService.Heartbeat:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character.HumanoidRootPart
					local targetHRP = target.Character.HumanoidRootPart
					hrp.CFrame = targetHRP.CFrame
					task.wait(0.01)
					hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
					task.wait(0.01)
				end
			end)
		else
			if backFollowConnection then backFollowConnection:Disconnect() backFollowConnection = nil end
		end
	end)

	-- Teleport button
	local tpBtn = Instance.new("TextButton")
	tpBtn.Text = "Teleport"
	tpBtn.Size = UDim2.new(0, 280, 0, 35)
	tpBtn.Position = UDim2.new(0, 10, 0, 190)
	tpBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	tpBtn.TextColor3 = Color3.new(1, 1, 1)
	tpBtn.Font = Enum.Font.SourceSansBold
	tpBtn.TextSize = 18
	tpBtn.Parent = contentFrame

	tpBtn.MouseButton1Click:Connect(function()
		local target = findPlayerByPartialName(targetBox.Text)
		if not target then warn("Player not found") return end
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
		end
	end)
end 

-- Section: Skin
sectionContents["Skin"] = function()
	contentFrame:ClearAllChildren()

	local skinBtn = Instance.new("TextButton")
	skinBtn.Text = "Activate Copy Skin"
	skinBtn.Size = UDim2.new(0, 260, 0, 40)
	skinBtn.Position = UDim2.new(0, 10, 0, 10)
	skinBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	skinBtn.TextColor3 = Color3.new(1, 1, 1)
	skinBtn.Font = Enum.Font.SourceSansBold
	skinBtn.TextSize = 20
	skinBtn.Parent = contentFrame

	skinBtn.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Luarmor123/YHUB-Community/refs/heads/main/BrookhavenCopyAvatar.lua"))()
	end)
end
local protectionStates = {
    teleportOn = false,
    antiVoidOn = false,
    antiBanOn = false,
}

sectionContents["Protection"] = function()
	contentFrame:ClearAllChildren()

	local playerSection = Instance.new("Frame")
	playerSection.Size = UDim2.new(0, 280, 0, 270)
	playerSection.Position = UDim2.new(0, 10, 0, 10)
	playerSection.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
	playerSection.BorderSizePixel = 2
	playerSection.BorderColor3 = Color3.new(0, 0, 0)
	playerSection.Parent = contentFrame

	-- Anti Air button  
	local teleportBtn = Instance.new("TextButton")
	teleportBtn.Size = UDim2.new(0, 260, 0, 35)
	teleportBtn.Position = UDim2.new(0, 10, 0, 10)
	teleportBtn.BackgroundColor3 = protectionStates.teleportOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,0,0)
	teleportBtn.TextColor3 = Color3.new(1, 1, 1)
	teleportBtn.Font = Enum.Font.SourceSansBold
	teleportBtn.TextSize = 20
	teleportBtn.Text = "Anti Air (" .. (protectionStates.teleportOn and "ON" or "OFF") .. ")"
	teleportBtn.Parent = playerSection

	local running = false
	local originalPosition = nil

	teleportBtn.MouseButton1Click:Connect(function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			if not protectionStates.teleportOn then
				protectionStates.teleportOn = true
				running = true
				originalPosition = humanoidRootPart.CFrame
				teleportBtn.Text = "Anti Air (ON)"
				teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

				task.spawn(function()
					while running do
						humanoidRootPart.CFrame = originalPosition * CFrame.new(12^12, 10^12, 0)
						task.wait(0.01)
						humanoidRootPart.CFrame = originalPosition * CFrame.new(-12^12, 10^12, 0)
						task.wait(0.01)
						humanoidRootPart.CFrame = originalPosition * CFrame.new(0, 10^12, -12^12)
						task.wait(0.01)
						humanoidRootPart.CFrame = originalPosition * CFrame.new(0, 10^12, 12^12)
						task.wait(0.01)
						humanoidRootPart.CFrame = originalPosition
						task.wait(0.01)
					end
				end)
			else
				protectionStates.teleportOn = false
				running = false
				if originalPosition then
					humanoidRootPart.CFrame = originalPosition
				end
				teleportBtn.Text = "Anti Air (OFF)"
				teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			end
		end
	end)

	-- Anti Rami button (executes script when clicked only)
	local antiRamiBtn = Instance.new("TextButton")
	antiRamiBtn.Size = UDim2.new(0, 260, 0, 35)
	antiRamiBtn.Position = UDim2.new(0, 10, 0, 55)
	antiRamiBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	antiRamiBtn.TextColor3 = Color3.new(1, 1, 1)
	antiRamiBtn.Font = Enum.Font.SourceSansBold
	antiRamiBtn.TextSize = 20
	antiRamiBtn.Text = "Anti Rami"
	antiRamiBtn.Parent = playerSection

	antiRamiBtn.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/44c52f1d3f259f70840a406b1476c25830bddb1b/AntiRami"))()
	end)

	-- Anti Void button  
	local antiVoidBtn = Instance.new("TextButton")
	antiVoidBtn.Size = UDim2.new(0, 260, 0, 35)
	antiVoidBtn.Position = UDim2.new(0, 10, 0, 100)
	antiVoidBtn.BackgroundColor3 = protectionStates.antiVoidOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,0,0)
	antiVoidBtn.TextColor3 = Color3.new(1, 1, 1)
	antiVoidBtn.Font = Enum.Font.SourceSansBold
	antiVoidBtn.TextSize = 20
	antiVoidBtn.Text = "Anti Void (" .. (protectionStates.antiVoidOn and "ON" or "OFF") .. ")"
	antiVoidBtn.Parent = playerSection

	local antiVoidRunning = false

	antiVoidBtn.MouseButton1Click:Connect(function()
		protectionStates.antiVoidOn = not protectionStates.antiVoidOn
		if protectionStates.antiVoidOn then
			antiVoidBtn.Text = "Anti Void (ON)"
			antiVoidBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
			antiVoidRunning = true

			task.spawn(function()
				while antiVoidRunning and protectionStates.antiVoidOn do
					local player = game.Players.LocalPlayer
					local character = player.Character or player.CharacterAdded:Wait()
					local hrp = character:FindFirstChild("HumanoidRootPart")
					if hrp and hrp.Position.Y < -10 then
						hrp.CFrame = CFrame.new(0, 50, 0)
					end
					task.wait(0.5)
				end
			end)
		else
			antiVoidBtn.Text = "Anti Void (OFF)"
			antiVoidBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			antiVoidRunning = false
		end
	end)

	-- Strong Anti Ban button  
	local antiBanBtn = Instance.new("TextButton")
	antiBanBtn.Size = UDim2.new(0, 260, 0, 35)
	antiBanBtn.Position = UDim2.new(0, 10, 0, 145)
	antiBanBtn.BackgroundColor3 = protectionStates.antiBanOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,0,0)
	antiBanBtn.TextColor3 = Color3.new(1, 1, 1)
	antiBanBtn.Font = Enum.Font.SourceSansBold
	antiBanBtn.TextSize = 20
	antiBanBtn.Text = "Anti Ban (" .. (protectionStates.antiBanOn and "ON" or "OFF") .. ")"
	antiBanBtn.Parent = playerSection

	antiBanBtn.MouseButton1Click:Connect(function()
		protectionStates.antiBanOn = not protectionStates.antiBanOn
		if protectionStates.antiBanOn then
			antiBanBtn.Text = "Anti Ban (ON)"
			antiBanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

			game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
				if protectionStates.antiBanOn then
					while wait() do end -- Freeze report
				end
			end)

			game:GetService("Players").LocalPlayer.Kick = function() end
			setreadonly(getrawmetatable(game), false)
			local mt = getrawmetatable(game)
			local oldNamecall = mt.__namecall
			mt.__namecall = newcclosure(function(self, ...)
				local args = {...}
				if getnamecallmethod() == "Kick" or getnamecallmethod() == "Ban" then
					return nil
				end
				return oldNamecall(self, unpack(args))
			end)
			setreadonly(mt, true)
		else
			antiBanBtn.Text = "Anti Ban (OFF)"
			antiBanBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		end
	end)
end	
-- Global variable to save button states
local carToggles = {}

sectionContents["Cars"] = function()
	contentFrame:ClearAllChildren()

	local cars = {
		{Title = "Truck", Script = function()
			local args = {"PickingCar","TowTruck"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Ship", Script = function()
			local args = {"PickingBoat","PirateFree"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Bus", Script = function()
			local args = {"PickingCar","Bus"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "School Bus", Script = function()
			local args = {"PickingCar","SchoolBus"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Lamborghini", Script = function()
			local args = {"PickingCar","Lamborgini"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Escalade", Script = function()
			local args = {"PickingCar","Escalade"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Garbage Truck", Script = function()
			local args = {"PickingCar","GarbageTruck"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Harley Davidson", Script = function()
			local args = {"PickingCar","NPHarleyDavison"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Food Truck", Script = function()
			local args = {"PickingCar","FoodTruck"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},

		{Title = "Fire Truck", Script = function()
			local args = {"PickingCar","FireTruck"}
			game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
		end},
	}

	for i, car in ipairs(cars) do
		local btn = Instance.new("TextButton")
		btn.Text = car.Title
		btn.Size = UDim2.new(0, 200, 0, 35)
		btn.Position = UDim2.new(0, 10, 0, (i-1)*40 + 10)
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 20
		btn.Parent = contentFrame

		local toggleBtn = Instance.new("TextButton")
		toggleBtn.Size = UDim2.new(0, 50, 0, 35)
		toggleBtn.Position = UDim2.new(0, 220, 0, (i-1)*40 + 10)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		toggleBtn.TextColor3 = Color3.new(1, 1, 1)
		toggleBtn.Font = Enum.Font.SourceSansBold
		toggleBtn.TextSize = 18
		toggleBtn.Parent = contentFrame

		-- Restore button state
		if carToggles[i] then
			toggleBtn.Text = "ON"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		else
			toggleBtn.Text = "OFF"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		end

		toggleBtn.MouseButton1Click:Connect(function()
			carToggles[i] = not carToggles[i]
			toggleBtn.Text = carToggles[i] and "ON" or "OFF"
			toggleBtn.BackgroundColor3 = carToggles[i] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(0, 0, 0)

			if carToggles[i] then
				task.spawn(function()
					while carToggles[i] do
						car.Script()
						task.wait(0.6)
					end
				end)
			end
		end)
	end
end

sectionContents["Server"] = function()
	contentFrame:ClearAllChildren()

	local TeleportService = game:GetService("TeleportService")
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local placeId = game.PlaceId

	-- Rejoin same server button
	local rejoinBtn = Instance.new("TextButton")
	rejoinBtn.Text = "Rejoin"
	rejoinBtn.Size = UDim2.new(0, 260, 0, 40)
	rejoinBtn.Position = UDim2.new(0, 10, 0, 10)
	rejoinBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	rejoinBtn.TextColor3 = Color3.new(1,1,1)
	rejoinBtn.Font = Enum.Font.SourceSansBold
	rejoinBtn.TextSize = 20
	rejoinBtn.Parent = contentFrame

	rejoinBtn.MouseButton1Click:Connect(function()
		TeleportService:Teleport(placeId)
	end)

	-- Join new server button
	local newServerBtn = Instance.new("TextButton")
	newServerBtn.Text = "Random Server"
	newServerBtn.Size = UDim2.new(0, 260, 0, 40)
	newServerBtn.Position = UDim2.new(0, 10, 0, 60)
	newServerBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	newServerBtn.TextColor3 = Color3.new(1,1,1)
	newServerBtn.Font = Enum.Font.SourceSansBold
	newServerBtn.TextSize = 20
	newServerBtn.Parent = contentFrame

	newServerBtn.MouseButton1Click:Connect(function()
		TeleportService:Teleport(placeId, player)
	end)

	-- Copy current server code button
	local copyCodeBtn = Instance.new("TextButton")
	copyCodeBtn.Text = "Copy Server Code"
	copyCodeBtn.Size = UDim2.new(0, 260, 0, 40)
	copyCodeBtn.Position = UDim2.new(0, 10, 0, 110)
	copyCodeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	copyCodeBtn.TextColor3 = Color3.new(1,1,1)
	copyCodeBtn.Font = Enum.Font.SourceSansBold
	copyCodeBtn.TextSize = 20
	copyCodeBtn.Parent = contentFrame

	copyCodeBtn.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(game.JobId)
		end
	end)

	-- TextBox for server code
	local serverCodeInput = Instance.new("TextBox")
	serverCodeInput.PlaceholderText = "Server Code"
	serverCodeInput.Text = ""
	serverCodeInput.Size = UDim2.new(0, 260, 0, 35)
	serverCodeInput.Position = UDim2.new(0, 10, 0, 160)
	serverCodeInput.BackgroundColor3 = Color3.new(1,1,1)
	serverCodeInput.TextColor3 = Color3.new(0,0,0)
	serverCodeInput.Font = Enum.Font.SourceSans
	serverCodeInput.TextSize = 18
	serverCodeInput.ClearTextOnFocus = false
	serverCodeInput.Parent = contentFrame

	-- Join server by code button
	local joinByCodeBtn = Instance.new("TextButton")
	joinByCodeBtn.Text = "Join by Code"
	joinByCodeBtn.Size = UDim2.new(0, 260, 0, 40)
	joinByCodeBtn.Position = UDim2.new(0, 10, 0, 205)
	joinByCodeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	joinByCodeBtn.TextColor3 = Color3.new(1,1,1)
	joinByCodeBtn.Font = Enum.Font.SourceSansBold
	joinByCodeBtn.TextSize = 20
	joinByCodeBtn.Parent = contentFrame

	joinByCodeBtn.MouseButton1Click:Connect(function()
		local code = serverCodeInput.Text
		if code ~= "" then
			TeleportService:TeleportToPlaceInstance(placeId, code)
		end
	end)
end
sectionContents["Names"] = function()
	contentFrame:ClearAllChildren()

	local toggles = {}
	local spamToggles = {}
	local spamSpeeds = {}

	-- Colored name
	local colorToggle = false
	local colorBtn = Instance.new("TextButton")
	colorBtn.Text = "Colored Name (OFF)"
	colorBtn.Size = UDim2.new(0, 260, 0, 35)
	colorBtn.Position = UDim2.new(0, 10, 0, 10)
	colorBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	colorBtn.TextColor3 = Color3.new(1, 1, 1)
	colorBtn.Font = Enum.Font.SourceSansBold
	colorBtn.TextSize = 18
	colorBtn.Parent = contentFrame

	colorBtn.MouseButton1Click:Connect(function()
		colorToggle = not colorToggle
		colorBtn.Text = colorToggle and "Colored Name (ON)" or "Colored Name (OFF)"
		colorBtn.BackgroundColor3 = colorToggle and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,0,0)

		if colorToggle then
			task.spawn(function()
				while colorToggle do
					local color = Color3.fromHSV(tick()%5/5,1,1)
					local args = {"PickingRPNameColor", color}
					game.ReplicatedStorage.RE["1RPNam1eColo1r"]:FireServer(unpack(args))
					task.wait(0.5)
				end
			end)
		end
	end)

	-- Colored bio
	local bioToggle = false
	local bioBtn = Instance.new("TextButton")
	bioBtn.Text = "Colored Bio (OFF)"
	bioBtn.Size = UDim2.new(0, 260, 0, 35)
	bioBtn.Position = UDim2.new(0, 10, 0, 55)
	bioBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bioBtn.TextColor3 = Color3.new(1, 1, 1)
	bioBtn.Font = Enum.Font.SourceSansBold
	bioBtn.TextSize = 18
	bioBtn.Parent = contentFrame

	bioBtn.MouseButton1Click:Connect(function()
		bioToggle = not bioToggle
		bioBtn.Text = bioToggle and "Colored Bio (ON)" or "Colored Bio (OFF)"
		bioBtn.BackgroundColor3 = bioToggle and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,0,0)

		if bioToggle then
			task.spawn(function()
				while bioToggle do
					local color = Color3.fromHSV(tick()%5/5,1,1)
					local args = {"PickingRPBioColor", color}
					game.ReplicatedStorage.RE["1RPNam1eColo1r"]:FireServer(unpack(args))
					task.wait(0.5)
				end
			end)
		end
	end)

	-- Name spam (3)
	for i=1,3 do
		local textBox = Instance.new("TextBox")
		textBox.PlaceholderText = "Spam Name "..i
		textBox.Size = UDim2.new(0, 150, 0, 30)
		textBox.Position = UDim2.new(0, 10, 0, 100+(i-1)*40)
		textBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
		textBox.TextColor3 = Color3.new(1,1,1)
		textBox.Font = Enum.Font.SourceSansBold
		textBox.TextSize = 16
		textBox.Parent = contentFrame

		local toggle = Instance.new("TextButton")
		toggle.Text = "OFF"
		toggle.Size = UDim2.new(0, 50, 0, 30)
		toggle.Position = UDim2.new(0, 170, 0, 100+(i-1)*40)
		toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
		toggle.TextColor3 = Color3.new(1,1,1)
		toggle.Font = Enum.Font.SourceSansBold
		toggle.TextSize = 16
		toggle.Parent = contentFrame

		local speedBox = Instance.new("TextBox")
		speedBox.Text = "0.4"
		speedBox.Size = UDim2.new(0, 40, 0, 30)
		speedBox.Position = UDim2.new(0, 230, 0, 100+(i-1)*40)
		speedBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
		speedBox.TextColor3 = Color3.new(1,1,1)
		speedBox.Font = Enum.Font.SourceSansBold
		speedBox.TextSize = 14
		speedBox.Parent = contentFrame

		toggles[i] = false

		toggle.MouseButton1Click:Connect(function()
			toggles[i] = not toggles[i]
			toggle.Text = toggles[i] and "ON" or "OFF"
			toggle.BackgroundColor3 = toggles[i] and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,0,0)

			if toggles[i] then
				task.spawn(function()
					while toggles[i] do
						local nameText = textBox.Text
						local speed = tonumber(speedBox.Text) or 0.4
						if nameText and nameText~="" then
							local args = {"RolePlayName", nameText}
							game.ReplicatedStorage.RE["1RPNam1eTex1t"]:FireServer(unpack(args))
						end
						task.wait(speed)
					end
				end)
			end
		end)
	end

	-- Boys name buttons
	local boys = {"DemonHub", "Rami", "Hassan", "Ali", "Jassim", "Mohammed", "Eν̃̾ịĿ", "ADMIN", "Khaled", "Omar"}
	for i, name in ipairs(boys) do
		local btn = Instance.new("TextButton")
		btn.Text = name
		btn.Size = UDim2.new(0, 125, 0, 25)
		btn.Position = UDim2.new(0, 10, 0, 250+(i-1)*28)
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 14
		btn.Parent = contentFrame

		btn.MouseButton1Click:Connect(function()
			local args = {"RolePlayName", name}
			game.ReplicatedStorage.RE["1RPNam1eTex1t"]:FireServer(unpack(args))
		end)
	end

	-- Girls names title
	local label = Instance.new("TextLabel")
	label.Text = "Girls Names"
	label.Size = UDim2.new(0, 260, 0, 25)
	label.Position = UDim2.new(0, 10, 0, 540)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 18
	label.Parent = contentFrame

	-- Girls name buttons
	local girls = {"Maryam", "Hawraa", "Yasmin", "Sara", "Mayar", "Noor", "Shaimaa", "Zahraa", "Fatima", "Huda"}
	for i, name in ipairs(girls) do
		local btn = Instance.new("TextButton")
		btn.Text = name
		btn.Size = UDim2.new(0, 125, 0, 25)
		btn.Position = UDim2.new(0, 10, 0, 570+(i-1)*28)
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 14
		btn.Parent = contentFrame

		btn.MouseButton1Click:Connect(function()
			local args = {"RolePlayName", name}
			game.ReplicatedStorage.RE["1RPNam1eTex1t"]:FireServer(unpack(args))
		end)
	end
end

-- Create section buttons
for i, name in ipairs(sectionNames) do
	local button = Instance.new("TextButton")
	button.Text = name
	button.Size = UDim2.new(1, -8, 0, 40)
	button.Position = UDim2.new(0, 4, 0, (i-1)*45)
	button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Parent = sectionsFrame

	button.MouseButton1Click:Connect(function()
		contentFrame:ClearAllChildren()
		bgImage.Position = contentFrame.Position
		if sectionContents[name] then
			sectionContents[name]()
		end
	end)
end
