--[[ FREECAM + TP FiveM Style (ativa/desativa pelo menu) ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
local camera = Workspace.CurrentCamera

-- Evita múltiplas execuções antigas
if _G.freecamConn then pcall(function() _G.freecamConn:Disconnect() end) end
if _G.freecamStep then pcall(function() _G.freecamStep:Disconnect() end) end
_G.freecaming = true

-- GUI
pcall(function() if plr.PlayerGui:FindFirstChild("FREECAMGUI") then plr.PlayerGui.FREECAMGUI:Destroy() end end)
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "FREECAMGUI"
gui.ResetOnSpawn = false

local txt = Instance.new("TextLabel", gui)
txt.AnchorPoint = Vector2.new(0.5,1)
txt.Position = UDim2.new(0.5,0,1,-80)
txt.Size = UDim2.new(0,320,0,36)
txt.BackgroundTransparency = 0.35
txt.BackgroundColor3 = Color3.fromRGB(30,30,30)
txt.TextColor3 = Color3.fromRGB(180,85,85)
txt.TextStrokeTransparency = 0.6
txt.Font = Enum.Font.GothamBold
txt.TextSize = 22
txt.Text = "FREECAM: WASD/mouse ou analógico | TP = teleporte"

local tpBtn = Instance.new("TextButton", gui)
tpBtn.Size = UDim2.new(0,120,0,44)
tpBtn.AnchorPoint = Vector2.new(0.5,1)
tpBtn.Position = UDim2.new(0.5,0,1,-35)
tpBtn.Text = "TP"
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 26
tpBtn.BackgroundTransparency = 0.13
tpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpBtn.ZIndex = 10
local tpCorner = Instance.new("UICorner", tpBtn)
tpCorner.CornerRadius = UDim.new(1,0)

-- Mobile controls (opcional)
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local freecamSpeed, maxSpeed, minSpeed = 60, 300, 10
local up, down = false, false
local moveDir = Vector3.new()
local lastCamPos = camera.CFrame.Position

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
    mobileBtns.plus = makeBtn("+", UDim2.new(1,-70,1,-170), 56)
    mobileBtns.minus = makeBtn("-", UDim2.new(1,-140,1,-170), 56)
    mobileBtns.up = makeBtn("↑", UDim2.new(1,-105,1,-235), 44)
    mobileBtns.down = makeBtn("↓", UDim2.new(1,-105,1,-110), 44)

    mobileBtns.plus.MouseButton1Click:Connect(function()
        freecamSpeed = math.min(maxSpeed, freecamSpeed+10)
    end)
    mobileBtns.minus.MouseButton1Click:Connect(function()
        freecamSpeed = math.max(minSpeed, freecamSpeed-10)
    end)
    mobileBtns.up.MouseButton1Down:Connect(function() up=true end)
    mobileBtns.up.MouseButton1Up:Connect(function() up=false end)
    mobileBtns.down.MouseButton1Down:Connect(function() down=true end)
    mobileBtns.down.MouseButton1Up:Connect(function() down=false end)
end

-- Freecam setup
local freecamCF = camera.CFrame

-- Deixa personagem imóvel
hrp.Anchored = true
if hum then hum.PlatformStand = true end

-- INPUT PC para velocidade e subir/descer câmera
_G.freecamConn = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Z then
        freecamSpeed = math.max(minSpeed, freecamSpeed-10)
    elseif input.KeyCode == Enum.KeyCode.X then
        freecamSpeed = math.min(maxSpeed, freecamSpeed+10)
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

-- Freecam loop
_G.freecamStep = Run.RenderStepped:Connect(function(dt)
    if not _G.freecaming then return end

    local camCF = freecamCF
    moveDir = Vector3.new()
    -- PC: WASD movimenta câmera
    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
    if up then moveDir = moveDir + Vector3.new(0,1,0) end
    if down then moveDir = moveDir - Vector3.new(0,1,0) end
    -- Mobile: usa MoveDirection do humanoid
    if isMobile and hum.MoveDirection.Magnitude > 0 then
        moveDir = moveDir + hum.MoveDirection
    end

    if moveDir.Magnitude > 0 then
        freecamCF = freecamCF + (moveDir.Unit * freecamSpeed * dt)
    end

    -- Mouse Look (PC)
    if not isMobile and UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
    if not isMobile then
        local delta = UIS:GetMouseDelta()
        if delta.Magnitude > 0 then
            local sens = 0.25
            freecamCF = freecamCF * CFrame.Angles(0, -delta.X * sens * dt, 0)
            freecamCF = freecamCF * CFrame.Angles(-delta.Y * sens * dt, 0, 0)
        end
    end

    camera.CFrame = freecamCF
    lastCamPos = camera.CFrame.Position
end)

-- Botão TP: teleporta personagem para última posição da câmera e respeita física
tpBtn.MouseButton1Click:Connect(function()
    hrp.CFrame = CFrame.new(lastCamPos + Vector3.new(0,2,0))
    hrp.Anchored = false
    if hum then hum.PlatformStand = false end
end)

-- Clean-up para desligar via menu
_G.freecam_cleanup = function()
    _G.freecaming = false
    if _G.freecamConn then pcall(function() _G.freecamConn:Disconnect() end) _G.freecamConn = nil end
    if _G.freecamStep then pcall(function() _G.freecamStep:Disconnect() end) _G.freecamStep = nil end
    pcall(function() gui:Destroy() end)
    camera.CameraSubject = hum or hrp
    camera.CameraType = Enum.CameraType.Custom
    hrp.Anchored = false
    if hum then hum.PlatformStand = false end
    if not isMobile then UIS.MouseBehavior = Enum.MouseBehavior.Default end
end

char.AncestryChanged:Connect(function()
    if not char:IsDescendantOf(Workspace) then
        _G.freecam_cleanup()
    end
end)
