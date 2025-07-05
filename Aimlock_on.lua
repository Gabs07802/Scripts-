-- AIMLOCK UNIVERSAL (BETA)
-- Mira sempre centralizada, corpo do player e arma apontam juntos para o inimigo.
-- Suporte para ferramentas com nome: "arma", "Gun", "fall", "letal", "g17", "pistola", "pistolas" (independente de maiúsculas/minúsculas)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimlockActive = true
_G.AimlockConn = nil

-- Lista de nomes de armas (case-insensitive, parte do nome já funciona)
local WEAPON_NAMES = {"arma", "gun", "fall", "letal", "g17", "pistola", "pistolas"}

local function isWeapon(tool)
    local name = tool.Name:lower()
    for _,w in ipairs(WEAPON_NAMES) do
        if name:find(w) then
            return true
        end
    end
    return false
end

local function getClosestTarget()
    local closestDist = math.huge
    local target = nil
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local screenPos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    target = plr
                end
            end
        end
    end
    return target
end

local function getWeapon()
    if not LocalPlayer.Character then return nil end
    for _,tool in ipairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and isWeapon(tool) then
            if tool:FindFirstChild("Handle") then
                return tool.Handle
            else
                -- Se não tem Handle, tenta pegar a primeira BasePart
                for _,part in ipairs(tool:GetChildren()) do
                    if part:IsA("BasePart") then
                        return part
                    end
                end
            end
        end
    end
    return nil
end

-- Loop principal Aimlock
_G.AimlockConn = RunService.RenderStepped:Connect(function()
    if not _G.AimlockActive then if _G.AimlockConn then _G.AimlockConn:Disconnect() end return end
    local aimTarget = getClosestTarget()
    if aimTarget and aimTarget.Character and aimTarget.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = aimTarget.Character.HumanoidRootPart.Position + Vector3.new(0,1.5,0)
        -- 1. Camera mira no alvo (centro da tela)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        -- 2. Player olha para o alvo
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(targetPos.X, LocalPlayer.Character.HumanoidRootPart.Position.Y, targetPos.Z))
        end
        -- 3. Arma aponta para o alvo
        local gun = getWeapon()
        if gun then
            gun.CFrame = CFrame.new(gun.Position, targetPos)
        end
    end
end)
