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

-- Checkpoint 26
Tab:AddButton({
    Name = "Teleport ke Checkpoint 26",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(624.6, 1800.7, 3432.4)
        end
    end    
})

-- Checkpoint 27
Tab:AddButton({
    Name = "Teleport ke Checkpoint 27",
    Callback = function()
        local player = game.Players.LocalPlayer
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
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            table.insert(savedLocations, pos)

            -- Bikin tombol baru buat teleport ke lokasi yg disave
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

OrionLib:Init()
