--# Aimlock Upper Body Only (Tronco para cima)
if getgenv()._AIMLOCK_UPPER_ONLY then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local AIM_PART = "Head"         -- Parte do inimigo para mirar
local AIM_FOV = 400             -- Pixels de raio para procurar alvo
local UPPER_PARTS = {"UpperTorso", "Head"} -- R15. Se for R6, use {"Torso", "Head"}

getgenv()._AIMLOCK_UPPER_ONLY = true
getgenv()._AIMLOCK_UPPER_CONN = nil

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

local function aimUpperBody(targetPos)
    local char = LocalPlayer.Character
    if not char then return end

    -- Aponta Head e UpperTorso/Torso para o alvo, respeitando altura original
    for _, partName in ipairs(UPPER_PARTS) do
        local part = char:FindFirstChild(partName)
        if part then
            local pos = part.Position
            local look = Vector3.new(targetPos.X, pos.Y, targetPos.Z)
            part.CFrame = CFrame.new(pos, look)
        end
    end

    -- Aponta arma, se equipada
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        pcall(function()
            tool.Handle.CFrame = CFrame.new(tool.Handle.Position, targetPos)
        end)
    end
end

getgenv()._AIMLOCK_UPPER_CONN = RunService.RenderStepped:Connect(function()
    if not getgenv()._AIMLOCK_UPPER_ONLY then return end
    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(AIM_PART) then
        local targetPos = target.Character[AIM_PART].Position
        -- Câmera
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        -- Upper body
        aimUpperBody(targetPos)
    end
end)
