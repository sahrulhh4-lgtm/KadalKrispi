-- Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Teleport & Tools", HidePremium = false, SaveConfig = false, ConfigFolder = "ToolsHub"})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // TELEPORT TAB
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

TeleportTab:AddButton({
    Name = "Checkpoint 26",
    Callback = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(624.6, 1800.7, 3432.4)
    end
})

TeleportTab:AddButton({
    Name = "Checkpoint 27",
    Callback = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(791.9, 2171.7, 3935.4)
    end
})

TeleportTab:AddButton({
    Name = "Teleport Random Player",
    Callback = function()
        local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
        if randomPlayer and randomPlayer.Character and randomPlayer ~= LocalPlayer then
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,2)
        end
    end
})

-- // TOOLS TAB
local ToolsTab = Window:MakeTab({Name = "Tools", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Lihat Koordinat
ToolsTab:AddLabel("Koordinat Player:")

local coordLabel = ToolsTab:AddLabel("X=0 | Y=0 | Z=0")
game:GetService("RunService").RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        coordLabel:Set("X="..math.floor(pos.X).." | Y="..math.floor(pos.Y).." | Z="..math.floor(pos.Z))
    end
end)

-- Fly + NoClip
local flying = false
local noclip = false
local speed = 50

ToolsTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 5,
    ValueName = "Speed",
    Callback = function(val)
        speed = val
    end    
})

ToolsTab:AddToggle({
    Name = "Fly + NoClip",
    Default = false,
    Callback = function(val)
        flying = val
        noclip = val
    end    
})

-- Fly & NoClip Logic
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

RS.RenderStepped:Connect(function()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        local camCF = workspace.CurrentCamera.CFrame
        local moveDir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0,-1,0) end

        if moveDir.Magnitude > 0 then
            HRP.Velocity = moveDir.Unit * speed
        else
            HRP.Velocity = Vector3.zero
        end

        if noclip then
            for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)

OrionLib:Init()
