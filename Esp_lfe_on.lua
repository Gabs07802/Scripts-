local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local BAR_WIDTH = 6
local BAR_PAD_PIXELS = 10

  -- 4 pixel ao lado do braço esquerdo (na tela)
local PERCENT_SIZE = 13

if not _G.espLifeBarDrawing then _G.espLifeBarDrawing = {} end
if not _G.espLifeBarRender then _G.espLifeBarRender = nil end

local function lerp(a, b, t) return a + (b - a) * t end

local function addLifeBar(plr)
    if plr == LocalPlayer then return end
    if _G.espLifeBarDrawing[plr] then
        for _,v in pairs(_G.espLifeBarDrawing[plr]) do pcall(function() v:Remove() end) end
    end
    _G.espLifeBarDrawing[plr] = {}

    local percentText = Drawing.new("Text")
    percentText.Center = true
    percentText.Outline = true
    percentText.Size = PERCENT_SIZE
    percentText.Font = 2
    percentText.Visible = true
    table.insert(_G.espLifeBarDrawing[plr], percentText)

    local barBack = Drawing.new("Square")
    barBack.Visible = true
    barBack.Thickness = 0
    barBack.Filled = true
    barBack.Color = Color3.fromRGB(15,15,15)
    table.insert(_G.espLifeBarDrawing[plr], barBack)

    local barGreen = Drawing.new("Square")
    barGreen.Visible = true
    barGreen.Thickness = 0
    barGreen.Filled = true
    barGreen.Color = Color3.fromRGB(30,255,30)
    table.insert(_G.espLifeBarDrawing[plr], barGreen)
end

-- Adiciona para todos já presentes
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        addLifeBar(plr)
        if _G.espLifeBarDrawing[plr] then
            if _G.espLifeBarAdded and _G.espLifeBarAdded[plr] then _G.espLifeBarAdded[plr]:Disconnect() end
            _G.espLifeBarAdded = _G.espLifeBarAdded or {}
            _G.espLifeBarAdded[plr] = plr.CharacterAdded:Connect(function() addLifeBar(plr) end)
        end
    end
end
if not _G.espLifeBarAdded or not _G.espLifeBarAdded["_playerAdded"] then
    _G.espLifeBarAdded = _G.espLifeBarAdded or {}
    _G.espLifeBarAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == LocalPlayer then return end
        _G.espLifeBarAdded[plr] = plr.CharacterAdded:Connect(function() addLifeBar(plr) end)
    end)
end

if not _G.espLifeBarRender then
    _G.espLifeBarRender = RunService.RenderStepped:Connect(function()
        for plr,draws in pairs(_G.espLifeBarDrawing) do
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChild("LeftUpperArm") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local head = char.Head
                local arm = char.LeftUpperArm
                local humanoid = char.Humanoid

                local footPos = hrp.Position - Vector3.new(0, hrp.Size.Y/2, 0)
                local headPos = head.Position + Vector3.new(0, head.Size.Y/2, 0)
                local armPos = arm.Position

                -- Converte as posições para tela (2D)
                local foot2d, fvis = Camera:WorldToViewportPoint(footPos)
                local head2d, hvis = Camera:WorldToViewportPoint(headPos)
                local arm2d, avis = Camera:WorldToViewportPoint(armPos)

                if fvis and hvis and avis and foot2d.Z > 0 and head2d.Z > 0 and arm2d.Z > 0 then
                    -- FIXA a barra sempre a 4 pixels ao lado do braço esquerdo (independente de distância)
                    local barY1 = head2d.Y
                    local barY2 = foot2d.Y
                    local barX = arm2d.X + BAR_PAD_PIXELS

                    local percent = math.clamp(humanoid.Health/humanoid.MaxHealth, 0, 1)
                    local percentNum = math.floor(percent*100)

                    local percentText = draws[1]
                    percentText.Text = percentNum.."%"
                    percentText.Position = Vector2.new(barX + BAR_WIDTH/2, barY1 - 18)
                    percentText.Size = PERCENT_SIZE
                    percentText.Color = Color3.fromRGB(0,0,0)
                    percentText.Visible = true

                    local barBack = draws[2]
                    barBack.Position = Vector2.new(barX, barY1)
                    barBack.Size = Vector2.new(BAR_WIDTH, barY2-barY1)
                    barBack.Visible = true

                    local barGreen = draws[3]
                    barGreen.Position = Vector2.new(barX+2, lerp(barY2, barY1, percent))
                    barGreen.Size = Vector2.new(BAR_WIDTH-4, (barY2-barY1-4)*percent)
                    barGreen.Visible = true
                else
                    for _,v in pairs(draws) do v.Visible = false end
                end
            else
                for _,v in pairs(draws) do v.Visible = false end
            end
        end
    end)
end
