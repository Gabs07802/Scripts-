-- Aimlock: gira o corpo inteiro (todas as partes principais) para o inimigo mais próximo, usando CFrame
_G.AimLockEnabled = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local headPos = plr.Character.Head.Position
            local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.zero
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
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    local head = char:FindFirstChild("Head")
    local lowerTorso = char:FindFirstChild("LowerTorso")

    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("Head") and root then
        local targetPos = target.Character.Head.Position
        local myPos = root.Position
        local lookAt = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)

        -- Aponta o RootPart
        root.CFrame = CFrame.new(myPos, lookAt)

        -- Aponta o torso
        if torso then
            torso.CFrame = CFrame.new(torso.Position, lookAt)
        end
        -- Aponta o LowerTorso (R15)
        if lowerTorso then
            lowerTorso.CFrame = CFrame.new(lowerTorso.Position, lookAt)
        end
        -- Aponta a cabeça
        if head then
            head.CFrame = CFrame.new(head.Position, target.Character.Head.Position)
        end

        -- Opcional: Se quiser a câmera junto, descomente:
        -- local camera = workspace.CurrentCamera
        -- camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
    end
end)
