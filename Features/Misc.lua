local plr = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

return function(Tab)
    Tab:AddToggle({Name = "Анти-АФК", Default = true, Callback = function(v)
        getgenv().AntiAFK = v
        while getgenv().AntiAFK do task.wait(120)
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end})

    Tab:AddButton({Name = "Респавн", Callback = function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character:BreakJoints()
        end
    end})

    Tab:AddButton({Name = "Сервер-хоп", Callback = function()
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
    end})
end
