--[[ FLY UNIVERSAL (PC e MOBILE) - Anda para frente do personagem ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")

if _G.flyConn then _G.flyConn:Disconnect() end
if _G.flyStep then _G.flyStep:Disconnect() end
_G.flying = true

local flySpeed, maxSpeed, minSpeed = 50, 200, 10
local moveDir = Vector3.new()
local flyUp, flyDown = false, false
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

pcall(function() if plr.PlayerGui:FindFirstChild("FLYGUI") then plr.PlayerGui.FLYGUI:Destroy() end end)
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "FLYGUI"
gui.ResetOnSpawn = false

local txt = Instance.new("TextLabel", gui)
txt.AnchorPoint = Vector2.new(0.5,1)
txt.Position = UDim2.new(0.5,0,1,-80)
txt.Size = UDim2.new(0,260,0,36)
txt.BackgroundTransparency = 0.35
txt.BackgroundColor3 = Color3.fromRGB(30,30,30)
txt.TextColor3 = Color3.fromRGB(180,85,85)
txt.TextStrokeTransparency = 0.6
txt.Font = Enum.Font.GothamBold
txt.TextSize = 22
txt.Text = "FLY: "..tostring(flySpeed).." | Z/X = Velocidade"

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
    mobileBtns.close = makeBtn("✖", UDim2.new(1,-50,1,-50), 36)

    mobileBtns.plus.MouseButton1Click:Connect(function()
        flySpeed = math.min(maxSpeed, flySpeed+10)
        txt.Text = "FLY: "..tostring(flySpeed).." | +/- = Velocidade"
    end)
    mobileBtns.minus.MouseButton1Click:Connect(function()
        flySpeed = math.max(minSpeed, flySpeed-10)
        txt.Text = "FLY: "..tostring(flySpeed).." | +/- = Velocidade"
    end)
    mobileBtns.up.MouseButton1Down:Connect(function() flyUp=true end)
    mobileBtns.up.MouseButton1Up:Connect(function() flyUp=false end)
    mobileBtns.down.MouseButton1Down:Connect(function() flyDown=true end)
    mobileBtns.down.MouseButton1Up:Connect(function() flyDown=false end)
    mobileBtns.close.MouseButton1Click:Connect(function()
        _G.flying = false
        gui:Destroy()
        if hum then hum.PlatformStand = false end
        if _G.flyConn then _G.flyConn:Disconnect() end
        if _G.flyStep then _G.flyStep:Disconnect() end
    end)
end

-- ANIMAÇÃO NATURAL
if hum and hum:FindFirstChildOfClass("Animator") then
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://913402848"
    local track = hum:FindFirstChildOfClass("Animator"):LoadAnimation(anim)
    track:Play()
    track.Looped = true
    _G.flyAnimTrack = track
end

_G.flyConn = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Z then
        flySpeed = math.max(minSpeed, flySpeed-10)
        txt.Text = "FLY: "..tostring(flySpeed).." | Z/X = Velocidade"
    elseif input.KeyCode == Enum.KeyCode.X then
        flySpeed = math.min(maxSpeed, flySpeed+10)
        txt.Text = "FLY: "..tostring(flySpeed).." | Z/X = Velocidade"
    elseif input.KeyCode == Enum.KeyCode.Space then
        flyUp = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        flyDown = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        flyUp = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        flyDown = false
    end
end)

_G.flyStep = Run.RenderStepped:Connect(function()
    if not _G.flying or not char or not hrp or not hum then return end

    local charCF = hrp.CFrame
    moveDir = Vector3.new()
    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + charCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - charCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + charCF.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - charCF.RightVector end
    if flyUp then moveDir = moveDir + Vector3.new(0,1,0) end
    if flyDown then moveDir = moveDir - Vector3.new(0,1,0) end

    -- MOBILE: MoveDirection já é no espaço do personagem!
    if isMobile and hum.MoveDirection.Magnitude > 0 then
        moveDir = moveDir + hum.MoveDirection
    end

    if moveDir.Magnitude > 0 then
        hrp.Velocity = moveDir.Unit * flySpeed
    else
        hrp.Velocity = Vector3.new(0,0,0)
    end

    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + charCF.LookVector)
    hum.PlatformStand = true
end)

char.AncestryChanged:Connect(function()
    if not char:IsDescendantOf(workspace) then
        _G.flying = false
        if _G.flyConn then _G.flyConn:Disconnect() end
        if _G.flyAnimTrack then _G.flyAnimTrack:Stop() end
        if _G.flyStep then _G.flyStep:Disconnect() end
        pcall(function() gui:Destroy() end)
        if hum then hum.PlatformStand = false end
    end
end)
