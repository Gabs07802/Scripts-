-- DESATIVAR FREECAM UNIVERSAL
local camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer

if getgenv().freecamAtivo then getgenv().freecamAtivo = false end

-- Desconectar conexões e restaurar personagem
if getgenv().mouseConn1 then pcall(function() getgenv().mouseConn1:Disconnect() end) getgenv().mouseConn1 = nil end
if getgenv().mouseConn2 then pcall(function() getgenv().mouseConn2:Disconnect() end) getgenv().mouseConn2 = nil end
if getgenv().inputEndConn then pcall(function() getgenv().inputEndConn:Disconnect() end) getgenv().inputEndConn = nil end
if getgenv().touchStartedConn then pcall(function() getgenv().touchStartedConn:Disconnect() end) getgenv().touchStartedConn = nil end
if getgenv().touchMovedConn then pcall(function() getgenv().touchMovedConn:Disconnect() end) getgenv().touchMovedConn = nil end
if getgenv().touchEndedConn then pcall(function() getgenv().touchEndedConn:Disconnect() end) getgenv().touchEndedConn = nil end
if getgenv().camLoopConn then pcall(function() getgenv().camLoopConn:Disconnect() end) getgenv().camLoopConn = nil end

camera.CameraType = Enum.CameraType.Custom
StarterGui:SetCore("ResetButtonCallback", true)

-- Restaura movimentação do personagem
local char = player.Character
if char and char:FindFirstChildOfClass("Humanoid") then
    char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    char:FindFirstChildOfClass("Humanoid").JumpPower = 50
end
