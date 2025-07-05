--[[
  NOCLIP FiveM Style v1 (Ativar pelo menu)
  - Câmera livre, personagem parado.
  - Botão "TP": teleporta personagem para posição da câmera (com física normal).
  - Ao desativar, câmera volta pro personagem.
  - PC e Mobile.
  - Use loadstring para ligar/desligar pelo menu!
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
local camera = Workspace.CurrentCamera

-- Evita múltiplas execuções
if _G.noclipConn then _G.noclipConn:Disconnect() end
if _G.noclipStep then _G.noclipStep:Disconnect() end
_G.noclipping = true

local moveDir = Vector3.new()
local noclipSpeed, maxSpeed, minSpeed = 60, 300, 10
local up, down = false, false
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- Freecam
local freecamCF = camera.CFrame

-- Remove GUI antiga
pcall(function() if plr.PlayerGui:FindFirstChild("NOCLIPGUI") then plr.PlayerGui.NOCLIPGUI:Destroy() end end)
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "NOCLIPGUI"
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
txt.Text = "NOCLIP: "..tostring(noclipSpeed).." | TP para teleportar | Z/X ou +/- = Velocidade"

-- Botão TP
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

-- Mobile botões
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
        noclipSpeed = math.min(maxSpeed, noclipSpeed+10)
        txt.Text = "NOCLIP: "..tostring(noclipSpeed).." | TP para teleportar | +/- = Velocidade"
    end)
    mobileBtns.minus.MouseButton1Click:Connect(function()
        noclipSpeed = math.max(minSpeed, noclipSpeed-10)
        txt.Text = "NOCLIP: "..tostring(noclipSpeed).." | TP para teleportar | +/- = Velocidade"
    end)
    mobileBtns.up.MouseButton1Down:Connect(function() up=true end)
    mobileBtns.up.MouseButton1Up:Connect(function() up=false end)
    mobileBtns.down.MouseButton1Down:Connect(function() down=true end)
    mobileBtns.down.MouseButton1Up:Connect(function() down=false end)
end

-- Trava personagem
hrp.Anchored = true
if hum then hum.PlatformStand = true end

-- INPUT PC
_G.noclipConn = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Z then
        noclipSpeed = math.max(minSpeed, noclipSpeed-10)
        txt.Text = "NOCLIP: "..tostring(noclipSpeed).." | TP para teleportar | Z/X = Velocidade"
    elseif input.KeyCode == Enum.KeyCode.X then
        noclipSpeed = math.min(maxSpeed, noclipSpeed+10)
        txt.Text = "NOCLIP: "..tostring(noclipSpeed).." | TP para teleportar | Z/X = Velocidade"
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

-- FREECAM LOOP
_G.noclipStep = Run.RenderStepped:Connect(function(dt)
    if not _G.noclipping then return end

    local camCF = freecamCF
    moveDir = Vector3.new()
    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
    if up then moveDir = moveDir + Vector3.new(0,1,0) end
    if down then moveDir = moveDir - Vector3.new(0,1,0) end
    if isMobile and hum.MoveDirection.Magnitude > 0 then
        moveDir = moveDir + (camCF.Rotation:VectorToWorldSpace(hum.MoveDirection))
    end
    if moveDir.Magnitude > 0 then
        freecamCF = freecamCF + (moveDir.Unit * noclipSpeed * dt)
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
end)

-- Botão TP
tpBtn.MouseButton1Click:Connect(function()
    local pos = camera.CFrame.Position
    hrp.CFrame = CFrame.new(pos + Vector3.new(0,2,0))
    hrp.Anchored = false
    if hum then hum.PlatformStand = false end
end)

-- Desativar tudo (para usar no menu)
_G.noclip_cleanup = function()
    _G.noclipping = false
    if _G.noclipConn then _G.noclipConn:Disconnect() _G.noclipConn = nil end
    if _G.noclipStep then _G.noclipStep:Disconnect() _G.noclipStep = nil end
    pcall(function() gui:Destroy() end)
    camera.CameraSubject = hum or hrp
    camera.CameraType = Enum.CameraType.Custom
    hrp.Anchored = false
    if hum then hum.PlatformStand = false end
    if not isMobile then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
end

char.AncestryChanged:Connect(function()
    if not char:IsDescendantOf(Workspace) then
        _G.noclip_cleanup()
    end
end)
