-- HITBOX LEGIT OFF (restaura padrão)

local Players = game:GetService("Players")

for _,v in pairs(Players:GetPlayers()) do
    if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        local part = v.Character.HumanoidRootPart
        part.Size = Vector3.new(2,2,1) -- padrão Roblox
        part.Transparency = 1
        part.CanCollide = true

        -- Restaura a cor padrão (cinza)
        part.Color = Color3.fromRGB(163, 162, 165)
    end
end

Players.PlayerAdded:Connect(function(v)
    v.CharacterAdded:Connect(function(char)
        local part = char:WaitForChild("HumanoidRootPart")
        part.Size = Vector3.new(2,2,1)
        part.Transparency = 1
        part.CanCollide = true
        part.Color = Color3.fromRGB(163, 162, 165)
    end)
end)
