--[[
FREECAM UNIVERSAL (PC & MOBILE)
- Move com WASD/analógico NA DIREÇÃO DO OLHAR (inclui cima/baixo)
- Olhe para qualquer ângulo com mouse (PC) ou dedo (touch/celular)
- Personagem não anda junto durante o Freecam
- Ativa: F   |   Desativa: G
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local freecamAtivo = false   -- Defina para true para ativar (ou use F para ativar/desativar)
local speed = 1.5           -- Velocidade de movimento da câmera
local sensibilidade = 0.2   -- Sensibilidade mouse/touch

local camRotX, camRotY = 0, 0
local moving = {Forward = 0, Back = 0, Left = 0, Right = 0, Up = 0, Down = 0}

-- Desabilita movimentação do personagem
local function bloquearPersonagem()
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 0
        char:FindFirstChildOfClass("Humanoid").JumpPower = 0
    end
end

local function restaurarPersonagem()
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        char:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end

-- Captura input WASD e analógico
local function atualizarMovimento(input, ativo)
    local code = input.KeyCode
    local type = input.UserInputType

    if code == Enum.KeyCode.W or (type == Enum.UserInputType.Gamepad1 and code == Enum.KeyCode.Thumbstick1) then
        moving.Forward = ativo and 1 or 0
    elseif code == Enum.KeyCode.S then
        moving.Back = ativo and 1 or 0
    elseif code == Enum.KeyCode.A then
        moving.Left = ativo and 1 or 0
    elseif code == Enum.KeyCode.D then
        moving.Right = ativo and 1 or 0
    elseif code == Enum.KeyCode.Space then
        moving.Up = ativo and 1 or 0
    elseif code == Enum.KeyCode.LeftControl or code == Enum.KeyCode.LeftShift then
        moving.Down = ativo and 1 or 0
    end
end

local function atualizarAnalogico(input)
    if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick1 then
        local pos = input.Position
        moving.Forward = pos.Y < -0.2 and 1 or 0
        moving.Back = pos.Y > 0.2 and 1 or 0
        moving.Left = pos.X < -0.2 and 1 or 0
        moving.Right = pos.X > 0.2 and 1 or 0
    end
end

-- Mouse/touch look
local mouseConn1, mouseConn2, inputEndConn, camLoopConn, touchStartedConn, touchMovedConn, touchEndedConn
local mouseDown = false
local lastTouchPosition = nil

local function ativarFreecam()
    if camLoopConn then return end
    freecamAtivo = true

    bloquearPersonagem()
    StarterGui:SetCore("ResetButtonCallback", false)
    camRotX = select(2, camera.CFrame:ToOrientation())
    camRotY = select(3, camera.CFrame:ToOrientation())

    -- Mouse look (PC)
    mouseConn1 = UserInputService.InputChanged:Connect(function(input)
        if freecamAtivo then
            if input.UserInputType == Enum.UserInputType.MouseMovement and mouseDown then
                camRotY = camRotY - input.Delta.x * sensibilidade * 0.01
                camRotX = math.clamp(camRotX - input.Delta.y * sensibilidade * 0.01, -math.pi/2, math.pi/2)
            end
            atualizarAnalogico(input)
        end
    end)
    mouseConn2 = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then mouseDown = true end
        atualizarMovimento(input, true)
    end)
    inputEndConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then mouseDown = false end
        atualizarMovimento(input, false)
    end)

    -- Touch (mobile)
    touchStartedConn = UserInputService.TouchStarted:Connect(function(touch, processed)
        if not processed then
            mouseDown = true
            lastTouchPosition = touch.Position
        end
    end)
    touchMovedConn = UserInputService.TouchMoved:Connect(function(touch, processed)
        if freecamAtivo and mouseDown and lastTouchPosition then
            local delta = touch.Position - lastTouchPosition
            camRotY = camRotY - delta.X * sensibilidade * 0.002
            camRotX = math.clamp(camRotX - delta.Y * sensibilidade * 0.002, -math.pi/2, math.pi/2)
            lastTouchPosition = touch.Position
        end
    end)
    touchEndedConn = UserInputService.TouchEnded:Connect(function()
        mouseDown = false
        lastTouchPosition = nil
    end)

    -- Loop movimentação da câmera
    camLoopConn = RunService.RenderStepped:Connect(function(dt)
        local rot = CFrame.Angles(0, camRotY, 0) * CFrame.Angles(camRotX, 0, 0)
        local camDir = rot.LookVector
        local camRight = rot.RightVector
        local camUp = rot.UpVector

        local moveVec = Vector3.new()
        moveVec = moveVec + camDir * (moving.Forward - moving.Back)
        moveVec = moveVec + camRight * (moving.Right - moving.Left)
        moveVec = moveVec + camUp * (moving.Up - moving.Down)
        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * (speed * dt * 60)
        end

        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(camera.CFrame.Position + moveVec) * CFrame.Angles(camRotX, camRotY, 0)
    end)
end

local function desativarFreecam()
    freecamAtivo = false
    restaurarPersonagem()
    if mouseConn1 then mouseConn1:Disconnect() mouseConn1 = nil end
    if mouseConn2 then mouseConn2:Disconnect() mouseConn2 = nil end
    if inputEndConn then inputEndConn:Disconnect() inputEndConn = nil end
    if touchStartedConn then touchStartedConn:Disconnect() touchStartedConn = nil end
    if touchMovedConn then touchMovedConn:Disconnect() touchMovedConn = nil end
    if touchEndedConn then touchEndedConn:Disconnect() touchEndedConn = nil end
    if camLoopConn then camLoopConn:Disconnect() camLoopConn = nil end
    camera.CameraType = Enum.CameraType.Custom
    StarterGui:SetCore("ResetButtonCallback", true)
end

-- Ativar com F, desativar com G
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        ativarFreecam()
    elseif input.KeyCode == Enum.KeyCode.G then
        desativarFreecam()
    end
end)

print("Pressione F (PC) para ativar o Freecam, G para desativar. No mobile, arraste o dedo na tela para olhar.")
