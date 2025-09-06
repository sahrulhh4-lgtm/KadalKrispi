-- Library Orion
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "Teleport & Tools",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "ToolsHub"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
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

-- Dropdown pilih player + bring
local selectedPlayer = nil
local function getPlayerNames()
    local names = {}
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end

local playerDropdown = TeleportTab:AddDropdown({
    Name = "Pilih Player",
    Default = "",
    Options = getPlayerNames(),
    Callback = function(val)
        selectedPlayer = val
    end
})

Players.PlayerAdded:Connect(function()
    playerDropdown:Refresh(getPlayerNames(), true)
end)
Players.PlayerRemoving:Connect(function()
    playerDropdown:Refresh(getPlayerNames(), true)
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

ToolsTab:AddLabel("Koordinat Player:")
local coordLabel = ToolsTab:AddLabel("X=0 | Y=0 | Z=0")
RS.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        coordLabel:Set("X="..math.floor(pos.X).." | Y="..math.floor(pos.Y).." | Z="..math.floor(pos.Z))
    end
end)

-- =========================================
-- FLY SYSTEM
-- =========================================
local UIS = game:GetService("UserInputService")
local flying = false
local speed = 50
local bv, bg

getgenv().FlyToggle = function(state)
    if state and not flying then
        flying = true
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart

            -- BodyVelocity
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp

            -- BodyGyro biar gak kaku
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 1e4
            bg.CFrame = hrp.CFrame
            bg.Parent = hrp
        end

        -- Gerakan
        RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value, function()
            if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and bv and bg then
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

                bg.CFrame = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)

                -- NoClip otomatis
                for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    elseif not state and flying then
        flying = false
        RS:UnbindFromRenderStep("FlyMovement")
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
end

getgenv().SetFlySpeed = function(val)
    speed = val
end

-- Toggle & Slider di Orion
ToolsTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        getgenv().FlyToggle(state)
    end
})

ToolsTab:AddSlider({
    Name = "Kecepatan Fly",
    Min = 10,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 5,
    ValueName = "Speed",
    Callback = function(val)
        getgenv().SetFlySpeed(val)
    end
})

-- =========================================
-- INIT ORION
-- =========================================
OrionLib:Init()
