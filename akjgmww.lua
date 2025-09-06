-- Load Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===================
-- 🔹 Fly Variables
-- ===================
local flying = false
local flySpeed = 50
local flyConnection

local function startFly()
    if flying then return end
    flying = true
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    flyConnection = RunService.RenderStepped:Connect(function()
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            move = move - Vector3.new(0,1,0)
        end

        if move.Magnitude > 0 then
            root.Velocity = move.Unit * flySpeed
        else
            root.Velocity = Vector3.new(0,0,0)
        end
    end)
end

local function stopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end

-- ===================
-- 🔹 NoClip Variables
-- ===================
local noclip = false
local noclipConnection

local function startNoClip()
    if noclip then return end
    noclip = true
    noclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoClip()
    noclip = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ===================
-- 🔹 Orion UI
-- ===================
local Window = OrionLib:MakeWindow({
    Name = "Teleport & Tools",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "TeleGunung"
})

-- Tab Teleport
local TeleTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TeleTab:AddSection({ Name = "Gunung / Checkpoint" })

TeleTab:AddButton({
    Name = "Teleport ke Gunung Atin (Checkpoint 26)",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        char:MoveTo(Vector3.new(624.6, 1800.7, 3432.4))
    end    
})

TeleTab:AddButton({
    Name = "Teleport ke Checkpoint 27",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        char:MoveTo(Vector3.new(791.9, 2171.7, 3935.4))
    end    
})

TeleTab:AddSection({ Name = "Koordinat" })
local coordLabel = TeleTab:AddLabel("Posisi: X=0, Y=0, Z=0")

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        coordLabel:Set("Posisi: X="..math.floor(pos.X).." Y="..math.floor(pos.Y).." Z="..math.floor(pos.Z))
    end
end)

-- Tab Fly
local FlyTab = Window:MakeTab({
    Name = "Fly & NoClip",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FlyTab:AddToggle({
    Name = "Aktifkan Fly",
    Default = false,
    Callback = function(Value)
        if Value then
            startFly()
        else
            stopFly()
        end
    end    
})

FlyTab:AddSlider({
    Name = "Kecepatan Fly",
    Min = 10,
    Max = 200,
    Default = 50,
    Increment = 5,
    ValueName = "Speed",
    Callback = function(Value)
        flySpeed = Value
    end    
})

FlyTab:AddToggle({
    Name = "Aktifkan NoClip",
    Default = false,
    Callback = function(Value)
        if Value then
            startNoClip()
        else
            stopNoClip()
        end
    end    
})

OrionLib:Init()
