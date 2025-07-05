-- HITBOX LEGIT ON (com cor conforme time)

local Players = game:GetService("Players")

for _,v in pairs(Players:GetPlayers()) do
    if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        local part = v.Character.HumanoidRootPart
        part.Size = Vector3.new(3,3,2)
        part.Transparency = 0.5
        part.CanCollide = false

        -- Define a cor conforme o TeamColor
        if v.Team and v.Team.TeamColor then
            part.Color = v.Team.TeamColor.Color
        else
            part.Color = Color3.fromRGB(255,255,255) -- cor padrão se não tiver time
        end
    end
end

Players.PlayerAdded:Connect(function(v)
    v.CharacterAdded:Connect(function(char)
        local part = char:WaitForChild("HumanoidRootPart")
        part.Size = Vector3.new(3,3,2)
        part.Transparency = 0.5
        part.CanCollide = false

        if v.Team and v.Team.TeamColor then
            part.Color = v.Team.TeamColor.Color
        else
            part.Color = Color3.fromRGB(255,255,255)
        end
    end)
end)
