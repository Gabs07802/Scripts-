--# Aimlock Completo Ativado (Câmera, Corpo e Arma)
if getgenv()._AIMLOCK_FULL_CONNECTIONS then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local AIM_PART = "Head" -- Head ou UpperTorso
local AIM_FOV = 400     -- raio em pixels para procurar alvo

getgenv()._AIMLOCK_FULL_ACTIVE = true
getgenv()._AIMLOCK_FULL_CONNECTIONS = {}

local function getClosestTarget()
    local closest, shortest = nil, AIM_FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AIM_PART) and v.Team ~= LocalPlayer.Team then
            local pos, onscreen = Camera:WorldToViewportPoint(v.Character[AIM_PART].Position)
            if onscreen and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = v
                end
            end
        end
    end
    return closest
end

local function faceTargetCF(part, targetPos)
    -- Gera um CFrame para olhar para targetPos, mas mantém altura do personagem
    local pos = part.Position
    local look = Vector3.new(targetPos.X, pos.Y, targetPos.Z)
    return CFrame.new(pos, look)
end

local function toolPointTo(part, targetPos)
    -- Aponta qualquer Tool equipada para targetPos
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        -- Move/rotaciona Handle para mirar (pode depender do tipo de arma)
        local handle = tool.Handle
        pcall(function()
            handle.CFrame = CFrame.new(handle.Position, targetPos)
        end)
    end
end

-- RenderStepped: Câmera e corpo
getgenv()._AIMLOCK_FULL_CONNECTIONS.render = RunService.RenderStepped:Connect(function()
    if not getgenv()._AIMLOCK_FULL_ACTIVE then return end
    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(AIM_PART) then
        local targetPos = target.Character[AIM_PART].Position

        -- Câmera
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)

        -- Corpo todo (HumanoidRootPart)
        local chr = LocalPlayer.Character
        if chr and chr:FindFirstChild("HumanoidRootPart") then
            chr.HumanoidRootPart.CFrame = faceTargetCF(chr.HumanoidRootPart, targetPos)
        end

        -- (Opcional) Rotaciona UpperTorso e Head para olhar também
        if chr:FindFirstChild("UpperTorso") then
            chr.UpperTorso.CFrame = faceTargetCF(chr.UpperTorso, targetPos)
        end
        if chr:FindFirstChild("Head") then
            chr.Head.CFrame = faceTargetCF(chr.Head, targetPos)
        end

        -- Arma/item equipado
        toolPointTo(chr, targetPos)
    end
end)

-- Também faz o mesmo ao usar qualquer Tool
getgenv()._AIMLOCK_FULL_CONNECTIONS.tool = LocalPlayer.Character.ChildAdded:Connect(function(obj)
    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(AIM_PART) then
            local targetPos = target.Character[AIM_PART].Position
            pcall(function()
                obj.Handle.CFrame = CFrame.new(obj.Handle.Position, targetPos)
            end)
        end
    end
end)
