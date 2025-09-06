-- Library Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Teleport & Tools", HidePremium = false, SaveConfig = false, ConfigFolder = "ToolsHub"})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- =========================================
-- TAB TELEPORT
-- =========================================
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

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

-- =========================================
-- FLY + NOCLIP
-- =========================================
local flying = false
local speed = 50
local bv

ToolsTab:AddSlider({
    Name = "Kecepatan Terbang",
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
    Name = "Toggle Fly (atau tekan F)",
    Default = false,
    Callback = function(val)
        if val then
            flying = true
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            end
        else
            flying = false
            if bv then bv:Destroy() bv = nil end
        end
    end
})

-- Hotkey F buat toggle fly
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            end
        else
            if bv then bv:Destroy() bv = nil end
        end
    end
end)

-- Gerakan fly + noclip
RS.RenderStepped:Connect(function()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and bv then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camCF = workspace.CurrentCamera.CFrame
        local move = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end

        if move.Magnitude > 0 then
            bv.Velocity = move.Unit * speed
        else
            bv.Velocity = Vector3.zero
        end

        -- NoClip aktif
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Init Orion
OrionLib:Init()
