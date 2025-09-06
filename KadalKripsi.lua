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

-- Tempat simpan lokasi custom
local savedLocations = {}

-- Tombol Save Lokasi
Tab:AddButton({
    Name = "Save Lokasi Saat Ini",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            table.insert(savedLocations, pos)

            -- Bikin tombol teleport ke lokasi yang disimpan
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

-- GUI Teleport ke Teman
local FriendTab = Window:MakeTab({
    Name = "Teleport ke Teman",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local function updateFriendList()
    FriendTab:ClearAllChildren()
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player then
            FriendTab:AddButton({
                Name = "Teleport ke "..target.Name,
                Callback = function()
                    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + CFrame.new(2,0,2)
                        end
                    end
                end
            })
        end
    end
end

Players.PlayerAdded:Connect(updateFriendList)
Players.PlayerRemoving:Connect(updateFriendList)
updateFriendList()

-- Chat Command /tp NamaTemen
local function onChatted(msg)
    local args = msg:split(" ")
    if args[1]:lower() == "/tp" and args[2] then
        local targetName = args[2]
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + CFrame.new(2,0,2)
                print("Teleport ke "..targetName)
            end
        else
            print("Player tidak ditemukan atau sedang respawn")
        end
    end
end

player.Chatted:Connect(onChatted)

OrionLib:Init()
