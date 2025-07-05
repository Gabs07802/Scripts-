-- ESP LIFE Simples: Mostra "VIDA: xx%" acima da cabeça

if _G.EspLifeSimpleConn == nil then _G.EspLifeSimpleConn = {} end
_G.EspLife_Simple_Enabled = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function addEspLife(plr)
    if plr == player then return end
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    if plr.Character.Head:FindFirstChild("EspLifeSimple") then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "EspLifeSimple"
    bb.Adornee = plr.Character.Head
    bb.Size = UDim2.new(0,70,0,15)
    bb.StudsOffset = Vector3.new(0,2.5,0)
    bb.AlwaysOnTop = true
    bb.Parent = plr.Character.Head
    local txt = Instance.new("TextLabel")
    txt.Name = "LifeLabel"
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1,0,1,0)
    txt.Font = Enum.Font.GothamBold
    txt.TextStrokeTransparency = 0.7
    txt.TextScaled = true
    txt.TextColor3 = Color3.new(1,1,1)
    txt.Text = "VIDA: 100%"
    txt.Parent = bb
    -- Atualizar vida sempre
    if not _G.EspLifeSimpleConn[plr] then
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            _G.EspLifeSimpleConn[plr] = humanoid.HealthChanged:Connect(function(hp)
                if txt and humanoid then
                    local max = humanoid.MaxHealth or 100
                    txt.Text = "VIDA: "..math.floor((hp/max)*100).."%"
                end
            end)
        end
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        addEspLife(plr)
        if not _G.EspLifeSimpleConn[plr] then
            _G.EspLifeSimpleConn[plr] = plr.CharacterAdded:Connect(function()
                task.wait(0.2)
                addEspLife(plr)
            end)
        end
    end
end

if not _G.EspLifeSimpleConn["_playerAdded"] then
    _G.EspLifeSimpleConn["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        _G.EspLifeSimpleConn[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            addEspLife(plr)
        end)
    end)
end
