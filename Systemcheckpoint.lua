-- LocalScript di StarterGui > CheckpointGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local label = script.Parent:WaitForChild("CheckpointLabel")

-- Sembunyikan dulu
label.Visible = false

-- Fungsi tampilkan teks sementara
local function showCheckpointText(text)
	label.Text = text
	label.Visible = true
	label.TextTransparency = 0

	-- Fade out setelah 2 detik
	task.delay(2, function()
		for i = 0, 1, 0.05 do
			label.TextTransparency = i
			label.TextStrokeTransparency = i
			task.wait(0.05)
		end
		label.Visible = false
	end)
end

-- Tunggu leaderstats (checkpoint value) dari server
local function setup()
	local stats = player:WaitForChild("leaderstats")
	local cpValue = stats:WaitForChild("Checkpoint")

	cpValue:GetPropertyChangedSignal("Value"):Connect(function()
		local newVal = cpValue.Value
		if newVal > 0 then
			showCheckpointText("Checkpoint " .. newVal .. "!")
		end
	end)
end

setup()
