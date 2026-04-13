local plr = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

return function(Tab)
    Tab:AddToggle({Name = "Автосбор всего (монеты, алмазы, сундуки)", Default = false, Callback = function(v)
        getgenv().AutoFarm = v
        while getgenv().AutoFarm do task.wait(0.1)
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                local closest, dist = nil, 50
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name == "Diamond" or obj.Name == "Chest" or obj.Name == "Gift" or obj.Name == "Present") then
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
    end})

    Tab:AddToggle({Name = "Авто-Ребёрт", Default = false, Callback = function(v)
        getgenv().AutoRebirth = v
        while getgenv().AutoRebirth do task.wait(5)
            pcall(function()
                local args = { [1] = "Rebirth" }
                game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
            end)
        end
    end})

    Tab:AddToggle({Name = "Автопокупка зон", Default = false, Callback = function(v)
        getgenv().AutoBuyZones = v
        while getgenv().AutoBuyZones do task.wait(2)
            pcall(function()
                local args = { [1] = "BuyZone" }
                game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
            end)
        end
    end})
end
