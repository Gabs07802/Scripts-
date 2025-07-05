-- Aimlock "realista" ON: personagem e câmera sempre viram juntos para o inimigo mais próximo
_G.AimLockEnabled = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Função para achar o player mais próximo
local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local headPos = plr.Character.Head.Position
            local myPos = camera.CFrame.Position
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
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local myPos = camera.CFrame.Position
        local targetPos = target.Character.Head.Position

        -- Mira a câmera
        camera.CFrame = CFrame.new(myPos, targetPos)

        -- Mira o personagem (com suavização opcional)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local lookAt = CFrame.new(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
            -- Suavização: pode deixar sem Lerp se preferir instantâneo
            root.CFrame = root.CFrame:Lerp(lookAt, 0.35)
        end
    end
end)
