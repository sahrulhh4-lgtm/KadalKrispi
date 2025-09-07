-- LocalScript di StarterGui > AutoRunGui
-- GUI Toggle untuk Auto Run + Auto Jump

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local button = script.Parent:WaitForChild("ToggleButton")

-- State Auto Run
local autoRunEnabled = false
local autoJumpEnabled = true -- biar tetap lompat saat ada obstacle

-- Untuk simpan humanoid / HRP saat character ada
local humanoid, hrp

-- Fungsi toggle
local function updateButton()
	if autoRunEnabled then
		button.Text = "Auto Run: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- hijau
	else
		button.Text = "Auto Run: OFF"
		button.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- merah
	end
end
updateButton()

button.MouseButton1Click:Connect(function()
	autoRunEnabled = not autoRunEnabled
	updateButton()
end)

-- Setup Auto Run + Auto Jump
local function setup(char)
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")

	local RAY_DISTANCE = 4
	local RAY_HEIGHT = 2
	local JUMP_COOLDOWN = 0.35
	local lastJump = 0

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {char}

	RunService.RenderStepped:Connect(function()
		if not humanoid or humanoid.Health <= 0 then return end

		-- Auto Run
		if autoRunEnabled then
			local forward = hrp.CFrame.LookVector
			humanoid:Move(forward, false)
		end

		-- Auto Jump
		if autoRunEnabled and autoJumpEnabled then
			local origin = hrp.Position + Vector3.new(0, RAY_HEIGHT, 0)
			local direction = hrp.CFrame.LookVector * RAY_DISTANCE
			local hit = workspace:Raycast(origin, direction, params)

			if hit and time() - lastJump > JUMP_COOLDOWN then
				humanoid.Jump = true
				lastJump = time()
			end
		end
	end)
end

-- Pasang ke karakter player
player.CharacterAdded:Connect(setup)
if player.Character then
	setup(player.Character)
end
