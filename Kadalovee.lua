-- OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Window
local Window = OrionLib:MakeWindow({
    Name = "Summit 26",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Summit26Config"
})

-- Tab utama
local Tab = Window:MakeTab({
    Name = "Gunung Mt Atin",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Checkpoint 26
Tab:AddButton({
    Name = "Teleport ke Checkpoint 26",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(624.6, 1800.7, 3432.4)
        end
    end
})

-- Checkpoint 27
Tab:AddButton({
    Name = "Teleport ke Checkpoint 27",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(791.9, 2171.7, 3935.4)
        end
    end
})

-- Simpan lokasi custom
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

-- ====== Teleport ke teman via GUI ======
local function teleportToPlayer(target)
    if player.Character and target.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp and targetHrp then
            hrp.CFrame = targetHrp.CFrame + Vector3.new(2, 0, 2)
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Berhasil teleport ke " .. target.Name,
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end

-- Subtab untuk teleport ke player
local TeleportTab = Window:MakeTab({
    Name = "Teleport Teman",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Update tombol daftar player
local function updatePlayerList()
    TeleportTab:ClearButtons()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            TeleportTab:AddButton({
                Name = "Teleport ke " .. plr.Name,
                Callback = function()
                    teleportToPlayer(plr)
                end
            })
        end
    end
end

-- Auto refresh daftar player tiap 5 detik
task.spawn(function()
    while task.wait(5) do
        updatePlayerList()
    end
end)

-- ====== Teleport via chat command ======
local function onChatted(msg)
    if msg:sub(1, 3):lower() == "/tp" then
        local targetName = msg:sub(5)
        local target = Players:FindFirstChild(targetName)
        if target then
            teleportToPlayer(target)
        else
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Player '" .. targetName .. "' tidak ditemukan!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end

player.Chatted:Connect(onChatted)

-- Init Orion
OrionLib:Init()
