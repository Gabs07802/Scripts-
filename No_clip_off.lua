-- DESLIGAR noclip paredes. Execute este script para restaurar colisão normal.
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

if getgenv().noclipConn then
    pcall(function() getgenv().noclipConn:Disconnect() end)
    getgenv().noclipConn = nil
end

-- Restaura colisão em todas as partes do personagem
for _, part in ipairs(char:GetDescendants()) do
    if part:IsA("BasePart") then
        part.CanCollide = true
    end
end
