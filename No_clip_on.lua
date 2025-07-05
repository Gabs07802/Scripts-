--[[ FREECAM puro estilo FiveM/Roblox (olhar/mover livre, sem TP, movimento sempre para direção da câmera) ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
local camera = Workspace.CurrentCamera

if _G.freecamConn then pcall(function() _G.freecamConn:Disconnect() end) end
if _G.freecamStep then pcall(function() _G.freecamStep:Disconnect() end) end
if _G.freecamTouch then pcall(function() _G.freecamTouch:Disconnect() end) end
_G.freecaming = true

-- Salva valores originais para restaurar depois
local oldWalkSpeed = hum.WalkSpeed
local oldJumpPower = hum.JumpPower
hum.WalkSpeed = 0
hum.JumpPower = 0

-- GUI simples
pcall(function() if plr.PlayerGui:FindFirstChild("FREECAMGUI") then plr.PlayerGui.FREECAMGUI:Destroy() end end)
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "FREECAMGUI"
gui.ResetOnSpawn = false

local txt = Instance.new("TextLabel", gui)
txt.AnchorPoint = Vector2.new(0.5,1)
txt.Position = UDim2.new(0.5,0,1,-40)
txt.Size = UDim2.new(0,390,0,34)
txt.BackgroundTransparency = 0.35
txt.BackgroundColor3 = Color3.fromRGB(30,30,30)
txt.TextColor3 = Color3.fromRGB(180,85,85)
txt.TextStrokeTransparency = 0.6
txt.Font = Enum.Font.GothamBold
txt.TextSize = 22
txt.Text = "FREECAM: WASD/mouse ou analógico/touch | Z/X +/- velocidade"

-- Mobile controls
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local freecamSpeed, maxSpeed, minSpeed = 60, 300, 10
local up, down = false, false
local moveDir = Vector3.new()

local mobileBtns = {}
if isMobile then
    local function makeBtn(txtLabel, pos, size)
        local b = Instance.new("TextButton", gui)
        b.Text = txtLabel
        b.Font = Enum.Font.GothamBold
        b.TextSize = 28
        b.Size = UDim2.new(0,size,0,size)
        b.Position = pos
        b.BackgroundColor3 = Color3.fromRGB(30,30,30)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.BackgroundTransparency = 0.18
        b.AutoButtonColor = true
        b.ZIndex = 5
        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(1,0)
        return b
    end
    mobileBtns.plus = makeBtn("+", UDim2.new(1,-70,1,-120), 50)
    mobileBtns.minus = makeBtn("-", UDim2.new(1,-130,1,-120), 50)
    mobileBtns.up = makeBtn("↑", UDim2.new(1,-100,1,-185), 40)
    mobileBtns.down = makeBtn("↓", UDim2.new(1,-100,1,-65), 40)

    mobileBtns.plus.MouseButton1Click:Connect(function()
        freecamSpeed = math.min(maxSpeed, freecamSpeed+10)
        txt.Text = "FREECAM: WASD/mouse ou analógico/touch | Z/X +/- velocidade ("..freecamSpeed..")"
    end)
    mobileBtns.minus.MouseButton1Click:Connect(function()
        freecamSpeed = math.max(minSpeed, freecamSpeed-10)
        txt.Text = "FREECAM: WASD/mouse ou analógico/touch | Z/X +/- velocidade ("..freecamSpeed..")"
    end)
    mobileBtns.up.MouseButton1Down:Connect(function() up=true end)
    mobileBtns.up.MouseButton1Up:Connect(function() up=false end)
    mobileBtns.down.MouseButton1Down:Connect(function() down=true end)
    mobileBtns.down.MouseButton1Up:Connect(function() down=false end)
end

-- Inicializa rotação freecam
local freecamPos = camera.CFrame.Position
local function getYawPitch(cf)
    local look = cf.LookVector
    local yaw = math.atan2(-look.X, -look.Z)
    local pitch = math.asin(look.Y)
    return yaw, pitch
end
local yaw, pitch = getYawPitch(camera.CFrame)

-- Mobile drag vars
local dragging = false
local lastTouchPos = nil
local touchSensitivity = 0.018 -- Ajuste para sensibilidade do drag

-- Deixa personagem imóvel (além do WalkSpeed=0)
hrp.Anchored = true
if hum then hum.PlatformStand = true end

-- INPUT PC para velocidade, subir/descer câmera, mouse look
_G.freecamConn = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Z then
        freecamSpeed = math.max(minSpeed, freecamSpeed-10)
        txt.Text = "FREECAM: WASD/mouse ou analógico/touch | Z/X +/- velocidade ("..freecamSpeed..")"
    elseif input.KeyCode == Enum.KeyCode.X then
        freecamSpeed = math.min(maxSpeed, freecamSpeed+10)
        txt.Text = "FREECAM: WASD/mouse ou analógico/touch | Z/X +/- velocidade ("..freecamSpeed..")"
    elseif input.KeyCode == Enum.KeyCode.Space then
        up = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        down = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        up = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        down = false
    end
end)

-- TOUCH para olhar (mobile)
if isMobile then
    _G.freecamTouch = UIS.TouchStarted:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Touch and input.Position.X > Workspace.CurrentCamera.ViewportSize.X*0.2 then
            dragging = true
            lastTouchPos = input.Position
        end
    end)
    UIS.TouchMoved:Connect(function(input, gpe)
        if dragging and input.UserInputType == Enum.UserInputType.Touch and lastTouchPos then
            local delta = input.Position - lastTouchPos
            yaw = yaw - delta.X * touchSensitivity
            pitch = math.clamp(pitch - delta.Y * touchSensitivity, -math.rad(89), math.rad(89))
            lastTouchPos = input.Position
        end
    end)
    UIS.TouchEnded:Connect(function(input, gpe)
        dragging = false
        lastTouchPos = nil
    end)
end

_G.freecamStep = Run.RenderStepped:Connect(function(dt)
    if not _G.freecaming then return end

    -- Mouse Look (PC)
    if not isMobile then
        if UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
        local delta = UIS:GetMouseDelta()
        if delta.Magnitude ~= 0 then
            local sens = 0.18
            yaw = yaw - delta.X * sens * dt
            pitch = math.clamp(pitch - delta.Y * sens * dt, -math.rad(89), math.rad(89))
        end
    end

    -- Calcula CFrame da câmera com pitch/yaw livre (ordem correta: YAW depois PITCH)
    local camCF = CFrame.new(freecamPos)
        * CFrame.Angles(0, yaw, 0)
        * CFrame.Angles(pitch, 0, 0)

    -- MOVIMENTO: WASD/touch/analógico sempre para onde a câmera ESTÁ OLHANDO
    moveDir = Vector3.new()
    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
    if up then moveDir = moveDir + Vector3.new(0,1,0) end
    if down then moveDir = moveDir - Vector3.new(0,1,0) end
    if isMobile and hum.MoveDirection.Magnitude > 0 then
        moveDir = moveDir + camCF.Rotation:VectorToWorldSpace(hum.MoveDirection)
    end

    if moveDir.Magnitude > 0 then
        freecamPos = freecamPos + (moveDir.Unit * freecamSpeed * dt)
        -- não atualiza rotação, só posição!
        camCF = CFrame.new(freecamPos)
            * CFrame.Angles(0, yaw, 0)
            * CFrame.Angles(pitch, 0, 0)
    end

    camera.CFrame = camCF
end)

_G.freecam_cleanup = function()
    _G.freecaming = false
    if _G.freecamConn then pcall(function() _G.freecamConn:Disconnect() end) _G.freecamConn = nil end
    if _G.freecamStep then pcall(function() _G.freecamStep:Disconnect() end) _G.freecamStep = nil end
    if _G.freecamTouch then pcall(function() _G.freecamTouch:Disconnect() end) _G.freecamTouch = nil end
    pcall(function() gui:Destroy() end)
    camera.CameraSubject = hum or hrp
    camera.CameraType = Enum.CameraType.Custom
    hrp.Anchored = false
    if hum then hum.PlatformStand = false end
    hum.WalkSpeed = oldWalkSpeed
    hum.JumpPower = oldJumpPower
    if not isMobile then UIS.MouseBehavior = Enum.MouseBehavior.Default end
end

char.AncestryChanged:Connect(function()
    if not char:IsDescendantOf(Workspace) then
        _G.freecam_cleanup()
    end
end)
