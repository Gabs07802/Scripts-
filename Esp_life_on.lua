-- ESP LIFE ON: Barra de vida vertical ao lado do inimigo com porcentagem
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

_G.EspLifeBar = _G.EspLifeBar or {}
_G.EspLifeConn = _G.EspLifeConn or {}

local function clearEspLife()
    for _,v in pairs(_G.EspLifeBar) do
        if v and v.Parent then v:Destroy() end
    end
    for _,conn in pairs(_G.EspLifeConn) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    _G.EspLifeBar = {}
    _G.EspLifeConn = {}
end

local function createEspBar(plr)
    if plr == LocalPlayer then return end
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    if _G.EspLifeBar[plr] then _G.EspLifeBar[plr]:Destroy() end

    local head = plr.Character.Head
    local gui = Instance.new("BillboardGui")
    gui.Name = "ESPLifeBar"
    gui.Adornee = head
    gui.Size = UDim2.new(0, 54, 0, 180)
    gui.StudsOffset = Vector3.new(2.2, 0.5, 0)
    gui.AlwaysOnTop = true
    gui.Parent = head

    local barBack = Instance.new("Frame")
    barBack.Size = UDim2.new(0, 40, 0, 160)
    barBack.Position = UDim2.new(0, 7, 0, 20)
    barBack.BackgroundColor3 = Color3.new(0,0,0)
    barBack.BorderSizePixel = 0
    barBack.Parent = gui

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBack

    local barFill = Instance.new("Frame")
    barFill.Name = "BarFill"
    barFill.Size = UDim2.new(1, -8, 1, -8)
    barFill.Position = UDim2.new(0, 4, 1, -4)
    barFill.BackgroundColor3 = Color3.fromRGB(0,255,40)
    barFill.BorderSizePixel = 0
    barFill.AnchorPoint = Vector2.new(0,1)
    barFill.Parent = barBack
    barFill.ClipsDescendants = true

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1,0)
    barFillCorner.Parent = barFill

    local percent = Instance.new("TextLabel")
    percent.Name = "Percentage"
    percent.Size = UDim2.new(1, 0, 0, 32)
    percent.Position = UDim2.new(0, 0, 0, -38)
    percent.BackgroundTransparency = 1
    percent.TextColor3 = Color3.new(0,0,0)
    percent.TextStrokeTransparency = 0.2
    percent.TextStrokeColor3 = Color3.new(1,1,1)
    percent.Font = Enum.Font.GothamBlack
    percent.TextSize = 32
    percent.Text = "100%"
    percent.Parent = gui

    _G.EspLifeBar[plr] = gui

    local function update()
        if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then return end
        local hum = plr.Character.Humanoid
        local hp = math.max(0, math.min(hum.Health, hum.MaxHealth))
        local percentValue = hum.MaxHealth > 0 and math.floor((hp/hum.MaxHealth)*100) or 0
        percent.Text = percentValue .. "%"
        barFill.Size = UDim2.new(1, -8, hp/hum.MaxHealth, -8)
        barFill.Position = UDim2.new(0, 4, 1, -4)
        if percentValue <= 25 then
            barFill.BackgroundColor3 = Color3.fromRGB(255,60,40)
        elseif percentValue <= 50 then
            barFill.BackgroundColor3 = Color3.fromRGB(255,220,40)
        else
            barFill.BackgroundColor3 = Color3.fromRGB(0,255,40)
        end
    end

    local hum = plr.Character:FindFirstChild("Humanoid")
    if hum then
        _G.EspLifeConn[plr] = hum.HealthChanged:Connect(update)
        update()
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    createEspBar(plr)
    _G.EspLifeConn[plr.."Char"] = plr.CharacterAdded:Connect(function()
        task.wait(0.4)
        createEspBar(plr)
    end)
end

_G.EspLifeConn["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
    _G.EspLifeConn[plr.."Char"] = plr.CharacterAdded:Connect(function()
        task.wait(0.4)
        createEspBar(plr)
    end)
end)
