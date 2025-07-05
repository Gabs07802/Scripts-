--# Aimlock para jogos com animação de arma (só braço/arma aponta)
if getgenv()._AIMLOCK_ANIM then return end
getgenv()._AIMLOCK_ANIM = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local AIM_PART = "Head" -- parte do inimigo
local AIM_FOV = 400

-- Função para encontrar alvo
local function getClosestTarget()
    local closest, shortest = nil, AIM_FOV
    for _, v in ipairs(Players:GetPlayers()) do
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

-- Função para apontar o braço/arma
local function pointArmAndTool(targetPos)
    local char = LocalPlayer.Character
    if not char then return end

    -- Procura Motor6D do braço direito
    local rShoulder = nil
    if char:FindFirstChild("RightUpperArm") then
        -- R15
        for _,v in pairs(char.RightUpperArm:GetChildren()) do
            if v:IsA("Motor6D") and v.Name:lower():find("shoulder") then
                rShoulder = v
            end
        end
    elseif char:FindFirstChild("Right Arm") then
        -- R6
        for _,v in pairs(char["Right Arm"]:GetChildren()) do
            if v:IsA("Motor6D") and v.Name:lower():find("shoulder") then
                rShoulder = v
            end
        end
    end

    -- Aponta braço para o alvo
    if rShoulder then
        local armPos = rShoulder.Part0.Position
        local look = (targetPos - armPos).Unit
        -- Calcula rotação local
        local right = look:Cross(Vector3.new(0,1,0)).Unit
        local up = right:Cross(look).Unit
        local cf = CFrame.fromMatrix(armPos, right, up, -look)
        rShoulder.C0 = char.HumanoidRootPart.CFrame:toObjectSpace(cf)
    end

    -- Aponta Tool (arma) se equipada
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        pcall(function()
            tool.Handle.CFrame = CFrame.new(tool.Handle.Position, targetPos)
        end)
    end
end

-- Acompanha alvo a cada frame
getgenv()._AIMLOCK_ANIM_CONN = RunService.RenderStepped:Connect(function()
    if not getgenv()._AIMLOCK_ANIM then return end
    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(AIM_PART) then
        local targetPos = target.Character[AIM_PART].Position
        -- NÃO rotaciona tronco/corpo! Só braço/arma:
        pointArmAndTool(targetPos)
        -- Opcional: Câmera também aponta (remova se preferir)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end
end)
