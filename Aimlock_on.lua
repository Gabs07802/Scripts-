-- Aimlock: corpo gira para o inimigo mais próximo e a câmera também mira (CFrame)
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
            local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
            local mag = (myPos - headPos).Magnitude
            if mag < dist then
                dist = mag
                closest = plr
            end
        end
    end
    return closest
end

if _G.AimLockRenderConn then _G.AimLockRenderConn:Disconnect() end

_G.AimLockRenderConn = RunService.RenderStepped:Connect(function()
    if not _G.AimLockEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("Head") and root then
        local targetPos = target.Character.Head.Position
        local myPos = root.Position
        local lookAt = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
        root.CFrame = CFrame.new(myPos, lookAt)
        -- Faz a câmera mirar exatamente para a cabeça do inimigo
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
    end
end)
