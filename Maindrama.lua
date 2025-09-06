-- OrionLib Loader
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Window
local Window = OrionLib:MakeWindow({
    Name = "KadalKrispi",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "KadalKrispiConfig"
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tab utama
local Tab = Window:MakeTab({
    Name = "Gunung Mt Atin",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- =========================
-- Checkpoint Teleport
-- =========================
Tab:AddButton({
    Name = "Teleport ke Checkpoint 26",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(624.6, 1800.7, 3432.4)
        end
    end
})

Tab:AddButton({
    Name = "Teleport ke Checkpoint 27",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(791.9, 2171.7, 3935.4)
        end
    end
})

-- =========================
-- Save Lokasi
-- =========================
local savedLocations = {}

Tab:AddButton({
    Name = "Save Lokasi Saat Ini",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            table.insert(savedLocations, pos)

            Tab:AddButton({
                Name = "Teleport ke Lokasi ("..#savedLocations..")",
                Callback = function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                    end
                end
            })
        end
    end
})

-- =========================
-- Teleport ke Pemain
-- =========================
Tab:AddTextbox({
    Name = "Teleport ke Pemain",
    Default = "",
    TextDisappear = true,
    Callback = function(targetName)
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,2)
        end
    end
})

-- =========================
-- Teleport Random
-- =========================
Tab:AddButton({
    Name = "Teleport ke Pemain Random",
    Callback = function()
        local allPlayers = Players:GetPlayers()
        if #allPlayers > 1 then
            local target
            repeat
                target = allPlayers[math.random(1, #allPlayers)]
            until target ~= player
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart")
