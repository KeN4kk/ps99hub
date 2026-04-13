local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

return function(Tab)
    Tab:AddToggle({Name = "Автооткрытие яиц", Default = false, Callback = function(v)
        getgenv().AutoHatch = v
        while getgenv().AutoHatch do task.wait(0.5)
            pcall(function()
                local args = { [1] = "HatchEgg" }
                game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
            end)
        end
    end})

    Tab:AddSlider({Name = "Скорость питомцев", Min = 16, Max = 500, Default = 16, Increment = 1, Callback = function(v)
        getgenv().PetSpeed = v
        while getgenv().PetSpeed do task.wait(0.5)
            for _, pet in pairs(workspace:GetDescendants()) do
                if pet.Name == "Pet" and pet:FindFirstChild("Humanoid") then
                    pet.Humanoid.WalkSpeed = getgenv().PetSpeed
                end
            end
        end
    end})

    Tab:AddButton({Name = "Телепорт питомцев ко мне", Callback = function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, pet in pairs(workspace:GetDescendants()) do
                if pet.Name == "Pet" and pet:FindFirstChild("HumanoidRootPart") then
                    pet.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end
        end
    end})

    Tab:AddToggle({Name = "Автопрокачка питомцев", Default = false, Callback = function(v)
        getgenv().AutoUpgrade = v
        while getgenv().AutoUpgrade do task.wait(2)
            pcall(function()
                local args = { [1] = "UpgradePet" }
                game:GetService("ReplicatedStorage"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
            end)
        end
    end})
end
