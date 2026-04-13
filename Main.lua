--[[
    ╔══════════════════════════════════════════════╗
    ║      PS99 Hub: KeN4kk_n1 v3.0                ║
    ║    ULTIMATE EDITION - Полный Комбайн          ║
    ╚══════════════════════════════════════════════╝
    Автор сборки: Colin (Выживший)
]]

-- 1. Защита от воровства (Анти-Стилер)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "InvokeServer" or method == "FireServer" then
        if tostring(self):find("Mailbox") or tostring(self):find("Trade") then
            return nil
        end
    end
    return oldNamecall(self, ...)
end)

-- 2. Загрузка библиотеки Orion
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/KeN4kk/ps99hub/main/Libs/OrionLib.lua"))()

-- 3. Создание окна
local Window = OrionLib:MakeWindow({
    Name = "KeN4kk_n1 | PS99 Ultimate",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "KeN4kkConfig",
    IntroText = "by Colin (Survival Edition)",
    IntroIcon = "rbxassetid://4483345998"
})

-- 4. Создаём вкладки
local FarmTab = Window:MakeTab({Name = "🤖 Автофарм", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local PetsTab = Window:MakeTab({Name = "🐾 Питомцы", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local VisualTab = Window:MakeTab({Name = "👁️ Визуал", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TeleportTab = Window:MakeTab({Name = "🌍 Телепорты", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "⚙️ Разное", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- 5. Загружаем фичи из других файлов
loadstring(game:HttpGet("https://raw.githubusercontent.com/KeN4kk/ps99hub/main/Features/AutoFarm.lua"))(FarmTab)
loadstring(game:HttpGet("https://raw.githubusercontent.com/KeN4kk/ps99hub/main/Features/Pets.lua"))(PetsTab)
loadstring(game:HttpGet("https://raw.githubusercontent.com/KeN4kk/ps99hub/main/Features/Visuals.lua"))(VisualTab)
loadstring(game:HttpGet("https://raw.githubusercontent.com/KeN4kk/ps99hub/main/Features/Teleports.lua"))(TeleportTab)
loadstring(game:HttpGet("https://raw.githubusercontent.com/KeN4kk/ps99hub/main/Features/Misc.lua"))(MiscTab)

-- 6. Финализация интерфейса
OrionLib:Init()

-- 7. Приветствие
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "KeN4kk_n1 v3.0",
    Text = "Хаб загружен! Удачи, выживший.",
    Duration = 5
})
print("KeN4kk_n1 v3.0 успешно загружен!")
