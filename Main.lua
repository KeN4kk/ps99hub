--[[
    Pet Simulator 99 Hub
    Автор: Colin (с кэша памяти)
    Версия: 1.0
]]

-- Загружаем UI библиотеку
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/PS99Hub/main/Libs/UI.lua"))()

-- Создаём главное окно
local Window = UI:CreateWindow("Pet Sim 99 Hub", "by Colin")

-- Вкладка Автофарм
local FarmTab = Window:CreateTab("Автофарм")

FarmTab:CreateToggle("Автосбор монет", false, function(state)
    getgenv().AutoFarmCoins = state
end)

FarmTab:CreateToggle("Автосбор алмазов", false, function(state)
    getgenv().AutoFarmDiamonds = state
end)

FarmTab:CreateToggle("Автооткрытие яиц", false, function(state)
    getgenv().AutoHatch = state
end)

FarmTab:CreateButton("Телепорт в VIP зону", function()
    -- Координаты VIP зоны (World 1, VIP Area)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-120, 20, 350)
end)

-- Вкладка Питомцы
local PetsTab = Window:CreateTab("Питомцы")

PetsTab:CreateSlider("Скорость питомцев", 16, 500, 16, function(value)
    for _, pet in pairs(game.Workspace:GetChildren()) do
        if pet.Name == "Pet" and pet:FindFirstChild("Humanoid") then
            pet.Humanoid.WalkSpeed = value
        end
    end
    getgenv().PetSpeed = value
end)

PetsTab:CreateButton("Собрать всех питомцев к игроку", function()
    local plr = game.Players.LocalPlayer
    for _, pet in pairs(game.Workspace:GetChildren()) do
        if pet.Name == "Pet" and pet:FindFirstChild("HumanoidRootPart") then
            pet.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

-- Вкладка Разное
local MiscTab = Window:CreateTab("Разное")

MiscTab:CreateButton("Телепорт к торговцу", function()
    -- Координаты торговца (Merchant)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(50, 15, -80)
end)

MiscTab:CreateButton("Телепорт в мир 2", function()
    -- Телепорт к порталу в World 2
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(200, 20, -300)
end)

MiscTab:CreateToggle("Бесконечный прыжок", false, function(state)
    local plr = game.Players.LocalPlayer
    if state then
        plr.Character.Humanoid.JumpPower = 1000
        plr.Character.Humanoid.Jump = true
        getgenv().InfJump = true
        while getgenv().InfJump do
            task.wait()
            plr.Character.Humanoid.Jump = true
        end
    else
        plr.Character.Humanoid.JumpPower = 50
        getgenv().InfJump = false
    end
end)

-- Запускаем основной цикл для автофарма
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoFarmCoins then
            for _, coin in pairs(game.Workspace:GetChildren()) do
                if coin.Name == "Coin" and coin:IsA("BasePart") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, coin, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, coin, 1)
                end
            end
        end
        if getgenv().AutoFarmDiamonds then
            for _, diamond in pairs(game.Workspace:GetChildren()) do
                if diamond.Name == "Diamond" and diamond:IsA("BasePart") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, diamond, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, diamond, 1)
                end
            end
        end
        if getgenv().AutoHatch then
            local args = {
                [1] = "HatchEgg",
                [2] = "Basic" -- или "Golden", "Diamond" в зависимости от яйца
            }
            game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
        end
    end
end)

-- Применяем скорость питомцев постоянно
task.spawn(function()
    while task.wait(1) do
        if getgenv().PetSpeed then
            for _, pet in pairs(game.Workspace:GetChildren()) do
                if pet.Name == "Pet" and pet:FindFirstChild("Humanoid") then
                    pet.Humanoid.WalkSpeed = getgenv().PetSpeed
                end
            end
        end
    end
end)
