--[[
    ╔══════════════════════════════════════════════╗
    ║           PS99 Hub: KeN4kk_n1                ║
    ║          Version: 1.0 | By: Colin            ║
    ╚══════════════════════════════════════════════╝
]]

-- 1. Инициализация и настройка производительности
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiLeNSwOrD/Rayfield/main/source.lua'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local plr = Players.LocalPlayer

-- Флаги состояния (для оптимизации)
getgenv().AutoFarm = false
getgenv().AutoHatch = false
getgenv().PetSpeed = 16
getgenv().AntiAFK = true
getgenv().ESP = false
getgenv().AntiSteal = true
getgenv().AutoRebirth = false
getgenv().AutoQuest = false
getgenv().FlyEnabled = false
getgenv().InfiniteJump = false

-- 2. Защита от воровства (Анти-Стилер)
local function setupAntiSteal()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "InvokeServer" or method == "FireServer" then
            if tostring(self):find("Mailbox") or tostring(self):find("Trade") then
                if getgenv().AntiSteal then
                    return nil
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end
setupAntiSteal()

-- 3. Основное окно с анимациями
local Window = Rayfield:CreateWindow({
    Name = "KeN4kk_n1 | PS99",
    Icon = 0,
    LoadingTitle = "Загружаем АХУЕННЫЙ ХАБ...",
    LoadingSubtitle = "by Colin (Survival Edition)",
    ShowText = "Нажми кнопку UI в меню Delta!",
    ConfigurationSaving = { Enabled = true, FolderName = "KeN4kk_n1", FileName = "config" }
})

Rayfield:Notify({ Title = "Хаб загружен", Content = "KeN4kk_n1 готов к работе. Не благодари.", Duration = 5, Image = 4483362458 })

-- 4. Вкладка Автофарм
local FarmTab = Window:CreateTab("🤖 Автофарм", 4483362458)
FarmTab:CreateSection("Сбор ресурсов")

FarmTab:CreateToggle({
    Name = "Автосбор монет/алмазов/сундуков",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(v)
        getgenv().AutoFarm = v
        if v then
            task.spawn(function()
                while getgenv().AutoFarm do
                    task.wait(0.05)
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local root = plr.Character.HumanoidRootPart
                        local closest, dist = nil, 50
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name == "Diamond" or obj.Name == "Chest" or obj.Name == "Gift" or obj.Name == "Present" or obj.Name == "TreasureChest") then
                                local d = (root.Position - obj.Position).Magnitude
                                if d < dist then
                                    dist = d
                                    closest = obj
                                end
                            end
                        end
                        if closest then
                            local tween = TweenService:Create(root, TweenInfo.new(0.1), {CFrame = closest.CFrame})
                            tween:Play()
                            tween.Completed:Wait()
                        end
                    end
                end
            end)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Автопокупка зон",
    CurrentValue = false,
    Flag = "AutoBuyZones",
    Callback = function(v)
        getgenv().AutoBuyZones = v
        if v then
            task.spawn(function()
                while getgenv().AutoBuyZones do
                    task.wait(1)
                    pcall(function()
                        local args = { [1] = "BuyZone" }
                        game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                end
            end)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Авто-Ребёрт",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(v)
        getgenv().AutoRebirth = v
        if v then
            task.spawn(function()
                while getgenv().AutoRebirth do
                    task.wait(5)
                    pcall(function()
                        local args = { [1] = "Rebirth" }
                        game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                end
            end)
        end
    end,
})

-- 5. Вкладка Питомцы и яйца
local PetsTab = Window:CreateTab("🐾 Питомцы и яйца", 4483362458)
PetsTab:CreateSection("Управление")

PetsTab:CreateToggle({
    Name = "Автооткрытие яиц (мгновенное)",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(v)
        getgenv().AutoHatch = v
        if v then
            task.spawn(function()
                while getgenv().AutoHatch do
                    task.wait(0.1)
                    pcall(function()
                        local args = { [1] = "HatchEgg" }
                        game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                end
            end)
        end
    end,
})

PetsTab:CreateSlider({
    Name = "Скорость питомцев",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Flag = "PetSpeed",
    Callback = function(v)
        getgenv().PetSpeed = v
        task.spawn(function()
            while getgenv().PetSpeed do
                task.wait(0.5)
                for _, pet in pairs(workspace:GetDescendants()) do
                    if pet.Name == "Pet" and pet:FindFirstChild("Humanoid") then
                        pet.Humanoid.WalkSpeed = getgenv().PetSpeed
                    end
                end
            end
        end)
    end,
})

PetsTab:CreateButton({
    Name = "Телепорт питомцев ко мне",
    Callback = function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, pet in pairs(workspace:GetDescendants()) do
                if pet.Name == "Pet" and pet:FindFirstChild("HumanoidRootPart") then
                    pet.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end
        end
    end,
})

PetsTab:CreateToggle({
    Name = "Автопрокачка питомцев",
    CurrentValue = false,
    Flag = "AutoUpgrade",
    Callback = function(v)
        getgenv().AutoUpgrade = v
        if v then
            task.spawn(function()
                while getgenv().AutoUpgrade do
                    task.wait(1)
                    pcall(function()
                        local args = { [1] = "UpgradePet" }
                        game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                end
            end)
        end
    end,
})

-- 6. Вкладка Ивенты и квесты
local EventsTab = Window:CreateTab("🎉 Ивенты и квесты", 4483362458)
EventsTab:CreateSection("Автоматизация")

EventsTab:CreateToggle({
    Name = "Автоквесты",
    CurrentValue = false,
    Flag = "AutoQuest",
    Callback = function(v)
        getgenv().AutoQuest = v
        if v then
            task.spawn(function()
                while getgenv().AutoQuest do
                    task.wait(2)
                    pcall(function()
                        local args = { [1] = "CompleteQuest" }
                        game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                end
            end)
        end
    end,
})

EventsTab:CreateToggle({
    Name = "Автоучастие в ивентах",
    CurrentValue = false,
    Flag = "AutoEvent",
    Callback = function(v)
        getgenv().AutoEvent = v
        if v then
            task.spawn(function()
                while getgenv().AutoEvent do
                    task.wait(10)
                    pcall(function()
                        local args = { [1] = "JoinEvent" }
                        game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                end
            end)
        end
    end,
})

EventsTab:CreateButton({
    Name = "Автосбор подарков",
    Callback = function()
        task.spawn(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name == "Gift" or obj.Name == "Present") then
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        plr.Character.HumanoidRootPart.CFrame = obj.CFrame
                        task.wait(0.5)
                    end
                end
            end
        end)
    end,
})

-- 7. Вкладка Телепорты
local TeleportTab = Window:CreateTab("🌍 Телепорты", 4483362458)
TeleportTab:CreateSection("Локации")

local teleports = {
    ["VIP зона"] = CFrame.new(-120, 20, 350),
    ["Торговец"] = CFrame.new(50, 15, -80),
    ["Золотая шахта"] = CFrame.new(150, 50, -200),
    ["Мир 2"] = CFrame.new(200, 20, -300),
    ["Алмазная пещера"] = CFrame.new(-80, 30, 500),
    ["Рейд босс"] = CFrame.new(300, 100, 400)
}

for name, pos in pairs(teleports) do
    TeleportTab:CreateButton({
        Name = name,
        Callback = function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local tween = TweenService:Create(plr.Character.HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = pos})
                tween:Play()
            end
        end,
    })
end

-- 8. Вкладка Визуал (ESP)
local VisualTab = Window:CreateTab("👁️ Визуал", 4483362458)
VisualTab:CreateSection("Отображение")

VisualTab:CreateToggle({
    Name = "ESP (подсветка предметов)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(v)
        getgenv().ESP = v
        if v then
            task.spawn(function()
                while getgenv().ESP do
                    task.wait(1)
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name == "Diamond" or obj.Name == "Chest" or obj.Name == "Gift") and not obj:FindFirstChild("KeN4kk_ESP") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "KeN4kk_ESP"
                            highlight.FillColor = obj.Name == "Coin" and Color3.fromRGB(255, 215, 0) or obj.Name == "Diamond" and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 0, 0)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = obj
                        end
                    end
                end
            end)
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("KeN4kk_ESP") then
                    obj.KeN4kk_ESP:Destroy()
                end
            end
        end
    end,
})

VisualTab:CreateToggle({
    Name = "Бесконечный прыжок",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(v)
        getgenv().InfiniteJump = v
        if v then
            task.spawn(function()
                while getgenv().InfiniteJump do
                    task.wait()
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        plr.Character.Humanoid.Jump = true
                    end
                end
            end)
        end
    end,
})

VisualTab:CreateToggle({
    Name = "Полёт",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(v)
        getgenv().FlyEnabled = v
        if v then
            task.spawn(function()
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.P = 9e4
                    bodyGyro.Parent = char.HumanoidRootPart
                    local bodyVel = Instance.new("BodyVelocity")
                    bodyVel.Velocity = Vector3.new(0,0,0)
                    bodyVel.MaxForce = Vector3.new(9e4, 9e4, 9e4)
                    bodyVel.Parent = char.HumanoidRootPart
                    while getgenv().FlyEnabled and char and char:FindFirstChild("HumanoidRootPart") do
                        task.wait()
                        local speed = 50
                        local direction = Vector3.new(0,0,0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
                        bodyVel.Velocity = direction * speed
                        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                    end
                    bodyGyro:Destroy()
                    bodyVel:Destroy()
                end
            end)
        end
    end,
})

-- 9. Вкладка Разное
local MiscTab = Window:CreateTab("⚙️ Разное", 4483362458)
MiscTab:CreateSection("Полезности")

MiscTab:CreateToggle({
    Name = "Анти-АФК",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(v)
        getgenv().AntiAFK = v
        if v then
            task.spawn(function()
                while getgenv().AntiAFK do
                    task.wait(120)
                    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end,
})

MiscTab:CreateToggle({
    Name = "Анти-Стилер (защита от воров)",
    CurrentValue = true,
    Flag = "AntiSteal",
    Callback = function(v)
        getgenv().AntiSteal = v
    end,
})

MiscTab:CreateButton({
    Name = "Респавн",
    Callback = function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character:BreakJoints()
        end
    end,
})

MiscTab:CreateButton({
    Name = "Сервер-хоп",
    Callback = function()
        local Http = game:GetService("HttpService")
        local req = request({ Url = "https://games.roblox.com/v1/games/8737602449/servers/Public?limit=100" })
        local body = Http:JSONDecode(req.Body)
        local servers = {}
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(8737602449, servers[math.random(1, #servers)], plr)
        end
    end,
})

MiscTab:CreateButton({
    Name = "Удалить все анимации интерфейса",
    Callback = function()
        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= Window then
                gui:Destroy()
            end
        end
    end,
})

-- 10. Приветственная анимация (последний штрих)
task.spawn(function()
    task.wait(1)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = CoreGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "KeN4kk_n1\nby Colin"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 24
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    local tweenIn = TweenService:Create(label, TweenInfo.new(1), {TextTransparency = 0})
    local tweenOut = TweenService:Create(label, TweenInfo.new(1), {TextTransparency = 1})
    tweenIn:Play()
    tweenIn.Completed:Wait()
    task.wait(2)
    tweenOut:Play()
    tweenOut.Completed:Wait()
    frame:Destroy()
end)

print("KeN4kk_n1 успешно загружен!")
