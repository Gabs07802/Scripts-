local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService, Camera = game:GetService("RunService"), workspace.CurrentCamera
local ovosFolder = workspace:WaitForChild("LocalOvos")

if not _G.espPecaDrawing then _G.espPecaDrawing = {} end
if not _G.espPecaRender then _G.espPecaRender = nil end

-- RGB brilhante
local function getRGB()
    local t = tick()
    return Color3.fromHSV((t % 5) / 5, 1, 1)
end

-- Salve o tamanho padrão ao estar próximo (ex: 20 para Evento, 18 para peça)
local eventoTextSize = 20
local pecaTextSize = 18

local function addPecaESP(part)
    if _G.espPecaDrawing[part] then
        for _,v in pairs(_G.espPecaDrawing[part]) do
            v:Remove()
        end
    end
    _G.espPecaDrawing[part] = {}

    -- "Evento" RGB
    local eventoText = Drawing.new("Text")
    eventoText.Center = true
    eventoText.Outline = true
    eventoText.Size = eventoTextSize
    eventoText.Text = "Evento"
    eventoText.Visible = true
    eventoText.Font = 2
    table.insert(_G.espPecaDrawing[part], eventoText)

    -- "peça" azul
    local pecaText = Drawing.new("Text")
    pecaText.Center = true
    pecaText.Outline = true
    pecaText.Size = pecaTextSize
    pecaText.Text = "peça"
    pecaText.Color = Color3.fromRGB(30,150,255)
    pecaText.Visible = true
    pecaText.Font = 2
    table.insert(_G.espPecaDrawing[part], pecaText)
end

if not _G.espPecaRender then
    _G.espPecaRender = RunService.RenderStepped:Connect(function()
        for _,v in pairs(_G.espPecaDrawing) do
            for _,draw in pairs(v) do
                draw.Visible = false
            end
        end
        for _,localObj in pairs(ovosFolder:GetChildren()) do
            local item = localObj:FindFirstChild("Item3")
            if item and item:FindFirstChild("proxypart") then
                local part = item.proxypart
                local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt and prompt.Enabled then
                    if not _G.espPecaDrawing[part] then
                        addPecaESP(part)
                    end
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos, onscreen = Camera:WorldToViewportPoint(part.Position)
                        local eventoText = _G.espPecaDrawing[part][1]
                        local pecaText = _G.espPecaDrawing[part][2]
                        if onscreen then
                            eventoText.Position = Vector2.new(pos.X, pos.Y - 32)
                            eventoText.Size = eventoTextSize
                            eventoText.Text = "Evento"
                            eventoText.Color = getRGB()
                            eventoText.Visible = true

                            pecaText.Position = Vector2.new(pos.X, pos.Y - 12)
                            pecaText.Size = pecaTextSize
                            pecaText.Text = "peça"
                            pecaText.Visible = true
                        else
                            eventoText.Visible = false
                            pecaText.Visible = false
                        end
                    end
                elseif _G.espPecaDrawing[part] then
                    for _,draw in pairs(_G.espPecaDrawing[part]) do
                        draw.Visible = false
                    end
                end
            end
        end
    end)
end
