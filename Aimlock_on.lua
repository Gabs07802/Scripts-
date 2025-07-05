-- Script de Aimlock para Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Config: Defina como ativar o Aimlock
local aimlockAtivado = false -- Você pode ligar/desligar pelo menu

-- Função para encontrar o inimigo mais próximo (exemplo simples)
local function EncontrarInimigo()
    local inimigoMaisProximo = nil
    local menorDistancia = math.huge

    for _, jogador in pairs(Players:GetPlayers()) do
        if jogador ~= LocalPlayer and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") and jogador.Team ~= LocalPlayer.Team then
            local distancia = (LocalPlayer.Character.HumanoidRootPart.Position - jogador.Character.HumanoidRootPart.Position).Magnitude
            if distancia < menorDistancia then
                menorDistancia = distancia
                inimigoMaisProximo = jogador
            end
        end
    end
    return inimigoMaisProximo
end

local function ApontarParaInimigo(inimigo)
    if not inimigo or not inimigo.Character or not inimigo.Character:FindFirstChild("HumanoidRootPart") then return end
    local inimigoPos = inimigo.Character.HumanoidRootPart.Position
    local personagem = LocalPlayer.Character

    -- Rotacionar corpo inteiro
    if personagem and personagem:FindFirstChild("HumanoidRootPart") then
        personagem.HumanoidRootPart.CFrame = CFrame.new(personagem.HumanoidRootPart.Position, inimigoPos)
    end

    -- Rotacionar membros (braços, pernas, cabeça)
    for _, parte in ipairs(personagem:GetChildren()) do
        if parte:IsA("BasePart") and parte.Name ~= "HumanoidRootPart" then
            parte.CFrame = CFrame.new(parte.Position, inimigoPos)
        end
    end

    -- Apontar itens equipados
    local tool = personagem:FindFirstChildOfClass("Tool")
    if tool then
        for _, item in ipairs(tool:GetDescendants()) do
            if item:IsA("BasePart") then
                item.CFrame = CFrame.new(item.Position, inimigoPos)
            end
        end
    end

    -- Apontar câmera/tela
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, inimigoPos)
end

-- Loop principal
RunService.RenderStepped:Connect(function()
    if aimlockAtivado then
        local alvo = EncontrarInimigo()
        if alvo then
            ApontarParaInimigo(alvo)
        end
    end
end)

-- Exemplo de ativação/desativação via menu (troque por seu código de menu)
-- aimlockAtivado = true -- Para ligar
-- aimlockAtivado = false -- Para desligar
