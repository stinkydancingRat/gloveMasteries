pcall(function()
	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

	local MyWindow = Library:NewWindow("HAR3NZ HUB")
	
	local MyCheats = MyWindow:NewSection("Annoyer")

	local autoSpamBrickEnabled = false
	local brickTeleportEnabled = false

	MyCheats:CreateToggle("Auto Spam Brick",function(value)
		function _G.onPlayerDeath3()
			value = false
		end
		autoSpamBrickEnabled = value
		if autoSpamBrickEnabled then
			task.spawn(function()
				while autoSpamBrickEnabled do
					local VirtualInputManager = game:GetService("VirtualInputManager")
					VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
					wait(0.1)
					VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
					wait(5.05)
				end
			end)
		end
	end)

	MyCheats:CreateTextbox("Exclude this person", function(text)
		local Players = game:GetService("Players")
		local inputLower = string.lower(text)
		for _, player in ipairs(Players:GetPlayers()) do
			local displayName = player.DisplayName
			local username = player.Name
			if string.find(string.lower(displayName), inputLower) or string.find(string.lower(username), inputLower) then
				print("Excluding player:", player.Name)
				_G.excludePlayer = player
				return
			end
		end
	end)

	MyCheats:CreateToggle("Brick Teleport", function(value)
		function _G.onPlayerDeath2()
			value = false
		end
		brickTeleportEnabled = value
		if brickTeleportEnabled then
			task.spawn(function()
				local Players = game:GetService("Players")
				local workspace = game:GetService("Workspace")
				local Forces = {}
	
				local function applyForceToPart(part, targetPosition)
					if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(Players.LocalPlayer.Character) then
						
						for _, c in pairs(part:GetChildren()) do
							if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
								c:Destroy()
							end
						end

						local force = Instance.new("BodyPosition")
						force.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- Maximum force
						force.P = 50000
						force.D = 60
						force.Position = targetPosition
						force.Parent = part
	
						part.CanCollide = false
						table.insert(Forces, force)
					end
				end

				local allPlayers = {}
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= Players.LocalPlayer and player ~= _G.excludePlayer then
						table.insert(allPlayers, player)
					end
				end

				if #allPlayers == 0 then
					print("No other players found.")
					return
				end
	
				local playerIndex = 1
				while brickTeleportEnabled do
					for _, part in ipairs(workspace:GetDescendants()) do
						if part:IsA("BasePart") and not part:IsDescendantOf(Players.LocalPlayer.Character) then
							local targetPlayer = allPlayers[playerIndex]
							if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
								local targetPosition = targetPlayer.Character.Torso.Position
								applyForceToPart(part, targetPosition)
							end
	
							playerIndex = playerIndex + 1
							if playerIndex > #allPlayers then
								playerIndex = 1
							end
						end
					end
	
					wait(0.5)

					for _, force in ipairs(Forces) do
						force:Destroy()
					end
					Forces = {}
				end
			end)
		end
	end)

	MyCheats:CreateToggle("SafeSpot",function(value)
			function _G.onPlayerDeath1()
				value = false
			end
			local camera = workspace.CurrentCamera
			local Players = game:GetService("Players")
			local LocalPlayer = Players.LocalPlayer
			local oldCFrame = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame or nil
			local safeSpotPosition = Vector3.new(10000, -50, 10000)

			if value then

				if oldCFrame then
					LocalPlayer:SetAttribute("OldCFrame", oldCFrame)
				end

				camera.CameraType = Enum.CameraType.Scriptable
				local pos = Vector3.new(190.241409, 40.4071045, -129.361908)
				local lookAtPos = Vector3.new(-8.56204139e-08, 0.962727666, 0.270472676)
				camera.CFrame = CFrame.lookAt(pos, lookAtPos)

				if not workspace:FindFirstChild("Safespot") then
					local Safespot = Instance.new("Part")
					Safespot.Name = "Safespot"
					Safespot.Position = safeSpotPosition
					Safespot.Size = Vector3.new(500, 10, 500)
					Safespot.Anchored = true
					Safespot.CanCollide = true
					Safespot.Transparency = 0.5
					Safespot.Parent = workspace
				end

				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(safeSpotPosition) + Vector3.new(0, 5, 0)
				end
			else
				camera.CameraType = Enum.CameraType.Custom

				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local storedCFrame = LocalPlayer:GetAttribute("OldCFrame")
					if storedCFrame then
						LocalPlayer.Character.HumanoidRootPart.CFrame = storedCFrame
					else
						print("Original position not found, skipping teleport.")
					end
				end
			end
	end)

	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local function onPlayerDeath()
		onPlayerDeath1()
		onPlayerDeath2()
		onPlayerDeath3()
	end
	local function trackPlayerDeath()
		LocalPlayer.CharacterAdded:Connect(function(character)
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.Died:Connect(onPlayerDeath)
		end)

		if LocalPlayer.Character then
			local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.Died:Connect(onPlayerDeath)
			end
		end
	end
	trackPlayerDeath()
end)
