--# Fly universal (PC e Mobile) - Ativado
if getgenv()._FLY_CONN then return end
getgenv()._FLY_ACTIVE = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

-- Caso morra, desativa o fly
if getgenv()._FLY_CHAR_DIED then getgenv()._FLY_CHAR_DIED:Disconnect() end
getgenv()._FLY_CHAR_DIED = Humanoid.Died:Connect(function()
    getgenv()._FLY_ACTIVE = false
    if getgenv()._FLY_CONN then getgenv()._FLY_CONN:Disconnect() end
    if getgenv()._FLY_BTN then getgenv()._FLY_BTN:Destroy() end
end)

local speed = 50 -- Velocidade do fly
local flying = true
local moveDirection = Vector3.new()
local jump = false
local descend = false

-- PC: registra teclas
local keys = {W = false, A = false, S = false, D = false, Q = false, E = false}

local function keyDown(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then jump = true end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.LeftShift then descend = true end
    if input.KeyCode == Enum.KeyCode.E then keys.E = true end
    if input.KeyCode == Enum.KeyCode.Q then keys.Q = true end
end
local function keyUp(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then jump = false end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.LeftShift then descend = false end
    if input.KeyCode == Enum.KeyCode.E then keys.E = false end
    if input.KeyCode == Enum.KeyCode.Q then keys.Q = false end
end

UserInputService.InputBegan:Connect(keyDown)
UserInputService.InputEnded:Connect(keyUp)

-- MOBILE: cria botão para subir/descer
if UserInputService.TouchEnabled then
    -- Botão para subir
    local btn = Instance.new("ScreenGui", game:GetService("CoreGui"))
    btn.Name = "_FlyTouchGui"
    getgenv()._FLY_BTN = btn

    local up = Instance.new("TextButton", btn)
    up.Size = UDim2.new(0,80,0,80)
    up.Position = UDim2.new(1,-180,1,-220)
    up.Text = "⬆️"
    up.BackgroundColor3 = Color3.fromRGB(70,170,70)
    up.TextSize = 38
    up.TextColor3 = Color3.fromRGB(255,255,255)
    up.BackgroundTransparency = 0.2

    local dn = Instance.new("TextButton", btn)
    dn.Size = UDim2.new(0,80,0,80)
    dn.Position = UDim2.new(1,-90,1,-130)
    dn.Text = "⬇️"
    dn.BackgroundColor3 = Color3.fromRGB(170,70,70)
    dn.TextSize = 38
    dn.TextColor3 = Color3.fromRGB(255,255,255)
    dn.BackgroundTransparency = 0.2

    up.MouseButton1Down:Connect(function() jump = true end)
    up.MouseButton1Up:Connect(function() jump = false end)
    dn.MouseButton1Down:Connect(function() descend = true end)
    dn.MouseButton1Up:Connect(function() descend = false end)
end

-- Loop principal
getgenv()._FLY_CONN = RunService.RenderStepped:Connect(function()
    if not getgenv()._FLY_ACTIVE or not Character or not HumanoidRootPart or Humanoid.Health <= 0 then return end

    -- Direção do movimento via câmera (universal)
    local cam = workspace.CurrentCamera
    local move = Vector3.new()
    if UserInputService.TouchEnabled then
        -- Mobile: usa MoveDirection do Humanoid (joystick)
        move = Humanoid.MoveDirection
    else
        -- PC: teclas
        if keys.W then move = move + cam.CFrame.LookVector end
        if keys.S then move = move - cam.CFrame.LookVector end
        if keys.A then move = move - cam.CFrame.RightVector end
        if keys.D then move = move + cam.CFrame.RightVector end
    end
    if move.Magnitude > 0 then
        move = move.Unit
    end

    -- Subir/descer
    local vert = 0
    if jump then vert = vert + 1 end
    if descend then vert = vert - 1 end

    local velocity = (move * speed) + Vector3.new(0, vert*speed, 0)
    HumanoidRootPart.Velocity = velocity
    Humanoid.PlatformStand = true
end)

print("[MOD MENU] Fly ativado universal! PC: WASD/Q/E para mover. Mobile: Joystick anda, botões ⬆️⬇️ sobem/descem.")
