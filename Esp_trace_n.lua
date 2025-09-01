-- ESP TRACE - ATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espTraceDrawing then _G.espTraceDrawing = {} end
if not _G.espTraceAdded then _G.espTraceAdded = {} end
if not _G.espTraceRender then _G.espTraceRender = nil end

local RunService, Camera = game:GetService("RunService"), workspace.CurrentCamera
local function addTracer(plr)
    if plr == player then return end
    if _G.espTraceDrawing[plr] then pcall(function() _G.espTraceDrawing[plr]:Remove() end) end
    local tracer = Drawing.new("Line")
    tracer.Visible, tracer.Thickness, tracer.Transparency, tracer.ZIndex = true, 1.2, 1, 2
    tracer.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
    _G.espTraceDrawing[plr] = tracer
end
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        addTracer(plr)
        if _G.espTraceAdded[plr] then _G.espTraceAdded[plr]:Disconnect() end
        _G.espTraceAdded[plr] = plr.CharacterAdded:Connect(function() addTracer(plr) end)
    end
end
if not _G.espTraceAdded["_playerAdded"] then
    _G.espTraceAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        _G.espTraceAdded[plr] = plr.CharacterAdded:Connect(function() addTracer(plr) end)
    end)
end
if not _G.espTraceRender then
    _G.espTraceRender = RunService.RenderStepped:Connect(function()
        local cam = Camera
        for plr, tracer in pairs(_G.espTraceDrawing) do
            local char = plr.Character
            if tracer and char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local head = char.Head
                local screenPos, onScreen = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                if onScreen then
                    tracer.Visible = true
                    tracer.From = Vector2.new(cam.ViewportSize.X/2, 0)
                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    tracer.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
                else
                    tracer.Visible = false
                end
            elseif tracer then
                tracer.Visible = false
            end
        end
    end)
end
