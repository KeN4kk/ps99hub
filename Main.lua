--[[
    ╔══════════════════════════════════════════════╗
    ║      PS99 Hub: KeN4kk_n1 FINAL              ║
    ║      Проверено на Delta Android             ║
    ╚══════════════════════════════════════════════╝
    Автор: Colin (Выживший)
    Собрано из лучших кусков: 6FootScripts, Zer0 Hub и др.
--]]

-- 1. Библиотека Orion (проверена на мобилках)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "KeN4kk_n1 | PS99",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "KeN4kkConfig"
})

-- 2. Основные переменные
local plr = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

_G.AutoFarm = false
_G.AutoHatch = false
_G.AutoRebirth = false
_G.PetSpeed = 16
_G.AntiAFK = true

-- 3. Вкладка Автофарм
local FarmTab = Window:MakeTab({Name = "🤖 Автофарм", Icon = "rbxassetid://4483345998", PremiumOnly = false})
FarmTab:AddToggle({
    Name = "Автосбор всего (монеты, алмазы, сундуки)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        while _G.AutoFarm do
            task.wait(0.1)
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                local closest, dist = nil, 50
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name == "Diamond" or obj.Name == "Chest") then
                        local d = (root.Position - obj.Position).Magnitude
                        if d < dist then dist = d; closest = obj end
                    end
                end
                if closest then
                    local tween = TweenService:Create(root, TweenInfo.new(0.1), {CFrame = closest.CFrame})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end
        end
    end
})

FarmTab:AddToggle({
    Name = "Авто-Ребёрт",
    Default = false,
    Callback = function(Value)
        _G.AutoRebirth = Value
        while _G.AutoRebirth do
            task.wait(5)
            pcall(function()
                local args = { [1] = "Rebirth" }
                game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
            end)
        end
    end
})

-- 4. Вкладка Питомцы
local PetsTab = Window:MakeTab({Name = "🐾 Питомцы", Icon = "rbxassetid://4483345998", PremiumOnly = false})
PetsTab:AddToggle({
    Name = "Автооткрытие яиц",
    Default = false,
    Callback = function(Value)
        _G.AutoHatch = Value
        while _G.AutoHatch do
            task.wait(0.5)
            pcall(function()
                local args = { [1] = "HatchEgg" }
                game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
            end)
        end
    end
})

PetsTab:AddSlider({
    Name = "Скорость питомцев",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(Value)
        _G.PetSpeed = Value
        while _G.PetSpeed do
            task.wait(0.5)
            for _, pet in pairs(workspace:GetDescendants()) do
                if pet.Name == "Pet" and pet:FindFirstChild("Humanoid") then
                    pet.Humanoid.WalkSpeed = _G.PetSpeed
                end
            end
        end
    end
})

-- 5. Вкладка Телепорты
local TeleportTab = Window:MakeTab({Name = "🌍 Телепорты", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local teleports = {
    ["VIP зона"] = CFrame.new(-120, 20, 350),
    ["Торговец"] = CFrame.new(50, 15, -80),
    ["Мир 2"] = CFrame.new(200, 20, -300)
}
for name, pos in pairs(teleports) do
    TeleportTab:AddButton({Name = name, Callback = function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local tween = TweenService:Create(plr.Character.HumanoidRootPart, TweenInfo.new(0.5), {CFrame = pos})
            tween:Play()
        end
    end})
end

-- 6. Вкладка Разное
local MiscTab = Window:MakeTab({Name = "⚙️ Разное", Icon = "rbxassetid://4483345998", PremiumOnly = false})
MiscTab:AddToggle({
    Name = "Анти-АФК",
    Default = true,
    Callback = function(Value)
        _G.AntiAFK = Value
        while _G.AntiAFK do
            task.wait(120)
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end
})
MiscTab:AddButton({Name = "Респавн", Callback = function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character:BreakJoints()
    end
end})
MiscTab:AddButton({Name = "Сервер-хоп", Callback = function()
    local req = request({ Url = "https://games.roblox.com/v1/games/8737602449/servers/Public?limit=100" })
    local body = HttpService:JSONDecode(req.Body)
    local servers = {}
    for _, v in pairs(body.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(servers, v.id)
        end
    end
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(8737602449, servers[math.random(1, #servers)], plr)
    end
end})

-- 7. Защита от воровства
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "InvokeServer" or method == "FireServer" then
        if tostring(self):find("Mailbox") or tostring(self):find("Trade") then
            return nil
        end
    end
    return oldNamecall(self, ...)
end)

-- 8. Финализация
OrionLib:Init()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "KeN4kk_n1",
    Text = "Хаб загружен!",
    Duration = 5
})
