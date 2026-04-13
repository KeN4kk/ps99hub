local plr = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

return function(Tab)
    local teleports = {
        ["VIP зона"] = CFrame.new(-120, 20, 350),
        ["Торговец"] = CFrame.new(50, 15, -80),
        ["Золотая шахта"] = CFrame.new(150, 50, -200),
        ["Мир 2"] = CFrame.new(200, 20, -300),
        ["Алмазная пещера"] = CFrame.new(-80, 30, 500),
        ["Рейд босс"] = CFrame.new(300, 100, 400),
        ["Техно мир"] = CFrame.new(500, 20, -500),
        ["Пляж"] = CFrame.new(-300, 20, 200)
    }

    for name, pos in pairs(teleports) do
        Tab:AddButton({Name = name, Callback = function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local tween = TweenService:Create(plr.Character.HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = pos})
                tween:Play()
            end
        end})
    end
end
