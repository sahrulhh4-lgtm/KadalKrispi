-- Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Teleport & Tools", HidePremium = false, SaveConfig = false, ConfigFolder = "ToolsHub"})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")

-- =========================================
-- TAB TELEPORT
-- =========================================
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- CP Teleport
TeleportTab:AddButton({
    Name = "Checkpoint 26",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(624.6, 1800.7, 3432.4)
        end
    end
})

TeleportTab:AddButton({
    Name = "Checkpoint 27",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(791.9, 2171.7, 3935.4)
        end
    end
})

TeleportTab:AddButton({
    Name = "Teleport Random Player",
    Callback = function()
        local plist = Players:GetPlayers()
        if #plist > 1 then
            local target = plist[math.random(1, #plist)]
            if target and target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,2)
            end
        end
    end
})

-- Dropdown + Bring Player
local selectedPlayer = nil
local playerNames = {}
for _,p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playerNames, p.Name) end
end

local playerDropdown = TeleportTab:AddDropdown({
    Name = "Pilih Player",
    Default = "",
    Options = playerNames,
    Callback = function(val)
        selectedPlayer = val
    end
})

Players.PlayerAdded:Connect(function(p)
    table.insert(playerNames, p.Name)
    playerDropdown:Refresh(playerNames, true)
end)

Players.PlayerRemoving:Connect(function(p)
    for i,n in ipairs(playerNames) do
        if n == p.Name then
            table.remove(playerNames, i)
            break
        end
    end
    playerDropdown:Refresh(playerNames, true)
end)

TeleportTab:AddButton({
    Name = "Bring Player",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0)
            end
        end
    end
})

-- =========================================
-- TAB TOOLS
-- =========================================
local ToolsTab = Window:MakeTab({Name = "Tools", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Lihat koordinat
ToolsTab:AddLabel("Koordinat Player:")
local coordLabel = ToolsTab:AddLabel("X=0 | Y=0 | Z=0")
RS.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        coordLabel:Set("X="..math.floor(pos.X).." | Y="..math.floor(pos.Y).." | Z="..math.floor(pos.Z))
    end
end)

-- Init Orion
OrionLib:Init()

-- =========================================
-- FLY EXTERNAL (script kamu)
-- =========================================
loadstring(game:HttpGet("https://raw.githubusercontent.com/noirexe/GYkHTrZSc5W/refs/heads/main/sc-free-ko-dijual-awoakowk.lua"))()
