-- Load Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Teleport & Fly Menu", HidePremium = false, SaveConfig = true, ConfigFolder = "TeleGunung"})

-- Tab Teleport
local TeleTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Section
TeleTab:AddSection({
    Name = "Gunung / Checkpoint"
})

-- Tombol Teleport Gunung Atin (Checkpoint 26)
TeleTab:AddButton({
    Name = "Teleport ke Gunung Atin (Checkpoint 26)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        char:MoveTo(Vector3.new(624.6, 1800.7, 3432.4))
    end    
})

-- Tombol Teleport Checkpoint 27
TeleTab:AddButton({
    Name = "Teleport ke Checkpoint 27",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        char:MoveTo(Vector3.new(791.9, 2171.7, 3935.4))
    end    
})

-- Section tambahan
TeleTab:AddSection({
    Name = "Player"
})

-- Tombol Teleport ke Random Player
TeleTab:AddButton({
    Name = "Teleport ke Random Player",
    Callback = function()
        local Players = game.Players
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

        -- pilih random player selain diri sendiri
        local others = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(others, p)
            end
        end

        if #others > 0 then
            local target = others[math.random(1, #others)]
            local targetPos = target.Character.HumanoidRootPart.Position
            char:MoveTo(targetPos + Vector3.new(2,0,2)) -- spawn agak samping biar ga nabrak
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Berhasil teleport ke "..target.Name,
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Ga ada player lain buat teleport.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end    
})

-- Tab Fly
local FlyTab = Window:MakeTab({
    Name = "Terbang",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Konfigurasi terbang
local FlySpeed = 50
local IsFlying = false
local ToggleKey = Enum.KeyCode.F

-- UI untuk mengatur kecepatan terbang
FlyTab:AddSlider({
    Name = "Kecepatan Terbang",
    Min = 10,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        FlySpeed = Value
    end    
})

-- Tombol untuk mengaktifkan/menonaktifkan terbang
FlyTab:AddButton({
    Name = "Toggle Terbang (F)",
    Callback = function()
        ToggleFlight()
    end    
})

-- Fungsi untuk mengaktifkan/menonaktifkan terbang
local function ToggleFlight()
    IsFlying = not IsFlying
    
    if IsFlying then
        local Character = game.Players.LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.PlatformStand = true
            end
        end
        OrionLib:MakeNotification({
            Name = "Terbang",
            Content = "Terbang diaktifkan! Gunakan WASD untuk bergerak, SPACE untuk naik, CTRL untuk turun.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        local Character = game.Players.LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.PlatformStand = false
            end
            local RootPart = Character:FindFirstChild("HumanoidRootPart")
            if RootPart then
                local bodyVelocity = RootPart:FindFirstChild("FlyBV")
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
        end
        OrionLib:MakeNotification({
            Name = "Terbang",
            Content = "Terbang dinonaktifkan.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end

-- Input handling
local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == ToggleKey then
        ToggleFlight()
    end
end

-- Koneksikan input event
game:GetService("UserInputService").InputBegan:Connect(onInputBegan)

-- Loop utama untuk mengontrol terbang
local flyConnection
flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
    if IsFlying then
        local player = game.Players.LocalPlayer
        local Character = player.Character
        if not Character then return end
        
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")
        
        if RootPart and Humanoid then
            local UserInputService = game:GetService("UserInputService")
            local Camera = workspace.CurrentCamera
            
            -- Hapus BodyVelocity lama jika ada
            local bodyVelocity = RootPart:FindFirstChild("FlyBV")
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Name = "FlyBV"
                bodyVelocity.Parent = RootPart
                bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            -- Dapatkan input arah
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - Camera
