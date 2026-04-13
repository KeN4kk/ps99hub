local plr = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

return function(Tab)
    Tab:AddToggle({Name = "ESP (подсветка всего)", Default = false, Callback = function(v)
        getgenv().ESP = v
        if v then
            task.spawn(function()
                while getgenv().ESP do task.wait(1)
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
                if obj:FindFirstChild("KeN4kk_ESP") then obj.KeN4kk_ESP:Destroy() end
            end
        end
    end})

    Tab:AddToggle({Name = "Режим полёта", Default = false, Callback = function(v)
        getgenv().Fly = v
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
                    while getgenv().Fly and char and char:FindFirstChild("HumanoidRootPart") do task.wait()
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
    end})
end
