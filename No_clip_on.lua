-- Noclip paredes (NÃO atravessa chão). Ative executando este script.
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

getgenv().noclipConn = getgenv().noclipConn or nil

local nomesDeChao = {
    ["Baseplate"] = true,
    ["Ground"] = true,
    ["Floor"] = true,
    ["Chao"] = true
}

if not getgenv().noclipConn then
    getgenv().noclipConn = game:GetService("RunService").Stepped:Connect(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Mantém colisão do chão, noclip no restante
                if not nomesDeChao[part.Name] then
                    part.CanCollide = false
                else
                    part.CanCollide = true
                end
            end
        end
    end)
end
