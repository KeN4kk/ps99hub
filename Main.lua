--[[
    Pet Simulator 99 Hub - Mobile Edition
    Автор: Colin (Выживший)
    Версия: Delta Android Fix
]]

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiLeNSwOrD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "PS99 Hub | Colin",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by Colin",
    ShowText = "Нажми кнопку UI в меню Delta!",
    ConfigurationSaving = { Enabled = false }
})

Rayfield:Notify({
    Title = "Хаб загружен",
    Content = "Выживание продолжается.",
    Duration = 3,
    Image = 4483362458
})

local FarmTab = Window:CreateTab("🤖 Автофарм")
FarmTab:CreateSection("Сбор")

local AutoFarm = false
FarmTab:CreateToggle({
    Name = "Автосбор монет/алмазов",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(v)
        AutoFarm = v
        if v then
            task.spawn(function()
                while AutoFarm do
                    task.wait(0.1)
                    local plr = game.Players.LocalPlayer
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name == "Diamond" or obj.Name == "Chest") then
                                root.CFrame = obj.CFrame
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local PetsTab = Window:CreateTab("🐾 Питомцы")
PetsTab:CreateSection("Управление")

PetsTab:CreateToggle({
    Name = "Автооткрытие яиц",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(v)
        getgenv().AutoHatch = v
        if v then
            task.spawn(function()
                while getgenv().AutoHatch do
                    task.wait(0.5)
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
                task.wait(1)
                for _, pet in pairs(workspace:GetDescendants()) do
                    if pet.Name == "Pet" and pet:FindFirstChild("Humanoid") then
                        pet.Humanoid.WalkSpeed = getgenv().PetSpeed
                    end
                end
            end
        end)
    end,
})

local TeleportTab = Window:CreateTab("🌍 Телепорты")
TeleportTab:CreateSection("Локации")

TeleportTab:CreateButton({
    Name = "VIP зона",
    Callback = function()
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(-120, 20, 350)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Торговец",
    Callback = function()
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(50, 15, -80)
        end
    end,
})

local MiscTab = Window:CreateTab("⚙️ Разное")
MiscTab:CreateSection("Полезное")

MiscTab:CreateToggle({
    Name = "Анти-АФК",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(v)
        getgenv().AntiAFK = v
        if v then
            local vu = game:GetService("VirtualUser")
            task.spawn(function()
                while getgenv().AntiAFK do
                    task.wait(120)
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end,
})

MiscTab:CreateButton({
    Name = "Респавн",
    Callback = function()
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character:BreakJoints()
        end
    end,
})
