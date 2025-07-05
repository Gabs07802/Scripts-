-- Aimlock para armas: faz toda tool com nome "arma", "gun", "fall" etc mirar no inimigo mais próximo
_G.AimLockToolEnabled = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Função para achar o inimigo mais próximo
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

-- Função para identificar se é arma/tool relevante
local function isWeapon(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = tool.Name:lower()
    return n:find("arma") or n:find("gun") or n:find("fall")
end

-- Função para alinhar a arma para o inimigo
local function alignTool(tool, targetPosition)
    -- O método depende do modelo da arma, mas geralmente: 
    -- Se a arma tem um "Handle", alinhe o Handle.
    local handle = tool:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then
        handle.CFrame = CFrame.new(handle.Position, targetPosition)
    else
        -- Se não tiver Handle, tenta alinhar todos os BaseParts filhos dela
        for _,part in ipairs(tool:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CFrame = CFrame.new(part.Position, targetPosition)
            end
        end
    end
end

-- Remove bind anterior para evitar duplicidade
if _G.AimLockToolRenderConn then _G.AimLockToolRenderConn:Disconnect() end

_G.AimLockToolRenderConn = RunService.RenderStepped:Connect(function()
    if not _G.AimLockToolEnabled then return end
    local char = player.Character
    if not char then return end
    local backpack = player:FindFirstChildOfClass("Backpack")
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    -- Ferramenta equipada
    local tool = humanoid and humanoid:FindFirstChildOfClass("Tool")
    if not tool and char then
        -- Também tenta achar diretamente no Character, caso a arma não esteja Parent como Tool
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") and isWeapon(child) then
                tool = child
                break
            end
        end
    end

    if tool and isWeapon(tool) then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            alignTool(tool, targetPos)
        end
    end
end)
