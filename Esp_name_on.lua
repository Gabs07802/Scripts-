-- ESP NAME - ATIVAR (50% menor)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espNameBillboards then _G.espNameBillboards = {} end
if not _G.espNameConnections then _G.espNameConnections = {} end
if not _G.espNameAddedConnections then _G.espNameAddedConnections = {} end
if not _G.espNameRenderStepped then _G.espNameRenderStepped = nil end

local function addEsp(plr)
    if plr == player then return end
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    if _G.espNameBillboards[plr] then _G.espNameBillboards[plr]:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESPName"
    bb.Adornee = plr.Character.Head
    bb.Size = UDim2.new(0,50,0,15)
    bb.StudsOffset = Vector3.new(0,1,0)
    bb.AlwaysOnTop = true
    bb.Parent = plr.Character.Head

    local txt = Instance.new("TextLabel")
    txt.Name = "NameLabel"
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1,0,1,0)
    txt.Font = Enum.Font.GothamBold
    txt.TextStrokeTransparency = 0.7
    txt.TextScaled = true
    txt.Text = plr.Name
    txt.Parent = bb

    -- Função para atualizar a cor conforme o time
    local function updateColor()
        if plr.Team and plr.Team.TeamColor then
            txt.TextColor3 = plr.Team.TeamColor.Color
        else
            txt.TextColor3 = Color3.new(1,1,1)
        end
    end

    updateColor()
    if _G.espNameConnections[plr] then _G.espNameConnections[plr]:Disconnect() end
    _G.espNameConnections[plr] = plr:GetPropertyChangedSignal("Team"):Connect(updateColor)
    _G.espNameBillboards[plr] = bb
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        addEsp(plr)
        -- Atualiza ESP se o personagem for respawnado
        if _G.espNameAddedConnections[plr] then _G.espNameAddedConnections[plr]:Disconnect() end
        _G.espNameAddedConnections[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.3)
            addEsp(plr)
        end)
    end
end

-- Para novos jogadores que entrarem
if not _G.espNameAddedConnections["_playerAdded"] then
    _G.espNameAddedConnections["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        _G.espNameAddedConnections[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.3)
            addEsp(plr)
        end)
    end)
end

-- RenderStepped para ajustar o tamanho do texto conforme distância (50% menor)
if not _G.espNameRenderStepped then
    _G.espNameRenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        for plr, bb in pairs(_G.espNameBillboards) do
            if bb and bb.Parent and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local dist = (cam.CFrame.Position - head.Position).Magnitude
                -- Parâmetros de escala 50% menores
                local minDist, maxDist = 15, 150
                local minSize, maxSize = 6, 14
                local size = math.clamp(maxSize - ((dist - minDist) * ((maxSize-minSize)/(maxDist-minDist))), minSize, maxSize)
                local txt = bb:FindFirstChild("NameLabel")
                if txt then
                    txt.TextSize = size
                end
            end
        end
    end)
end
