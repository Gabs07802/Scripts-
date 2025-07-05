-- Aimlock: faz o corpo (HumanoidRootPart) apontar para o inimigo mais próximo
_G.AimLockEnabled = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local headPos = plr.Character.Head.Position
            local myPos
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                myPos = player.Character.HumanoidRootPart.Position
            else
                myPos = camera.CFrame.Position
            end
            local mag = (myPos - headPos).Magnitude
            if mag < dist then
                dist = mag
                closest = plr
            end
        end
    end
    return closest
end

-- Remove bind anterior para evitar duplicidade
if _G.AimLockRenderConn then _G.AimLockRenderConn:Disconnect() end

_G.AimLockRenderConn = RunService.RenderStepped:Connect(function()
    if not _G.AimLockEnabled then return end
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("Head") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local targetPos = target.Character.Head.Position
        local myPos = root.Position
        -- Mantém a altura do corpo (não inclina para cima/baixo)
        local lookAt = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
        root.CFrame = CFrame.new(myPos, lookAt)
        -- Opcional: também fazer a câmera mirar junto
        -- camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
    end
end)
