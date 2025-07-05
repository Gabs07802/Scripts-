-- ESP BOX - ATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espBoxDrawing then _G.espBoxDrawing = {} end
if not _G.espBoxAdded then _G.espBoxAdded = {} end
if not _G.espBoxRender then _G.espBoxRender = nil end

local RunService, Camera = game:GetService("RunService"), workspace.CurrentCamera
local function addBox(plr)
    if plr == player then return end
    if _G.espBoxDrawing[plr] then pcall(function() _G.espBoxDrawing[plr]:Remove() end) end
    local box = Drawing.new("Quad")
    box.Visible, box.Thickness, box.Transparency, box.Filled = true, 1.2, 1, false
    box.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
    _G.espBoxDrawing[plr] = box
end
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        addBox(plr)
        if _G.espBoxAdded[plr] then _G.espBoxAdded[plr]:Disconnect() end
        _G.espBoxAdded[plr] = plr.CharacterAdded:Connect(function() addBox(plr) end)
    end
end
if not _G.espBoxAdded["_playerAdded"] then
    _G.espBoxAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        _G.espBoxAdded[plr] = plr.CharacterAdded:Connect(function() addBox(plr) end)
    end)
end
if not _G.espBoxRender then
    _G.espBoxRender = RunService.RenderStepped:Connect(function()
        for plr, box in pairs(_G.espBoxDrawing) do
            local char = plr.Character
            if box and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp, head = char.HumanoidRootPart, char.Head
                local size = hrp.Size
                local cam = Camera
                -- Calculate box corners
                local top = (hrp.CFrame * CFrame.new(0, size.Y/2 + (head.Position.Y-hrp.Position.Y), 0)).Position
                local bottom = (hrp.CFrame * CFrame.new(0, -size.Y/2, 0)).Position
                local r = size.X/2
                local front = hrp.CFrame.LookVector * (size.Z/2)
                local right = hrp.CFrame.RightVector * r

                local corners = {
                    cam:WorldToViewportPoint((top + right + front)),
                    cam:WorldToViewportPoint((top - right + front)),
                    cam:WorldToViewportPoint((bottom - right - front)),
                    cam:WorldToViewportPoint((bottom + right - front)),
                }
                if corners[1].Z > 0 and corners[2].Z > 0 and corners[3].Z > 0 and corners[4].Z > 0 then
                    box.Visible = true
                    box.PointA = Vector2.new(corners[1].X, corners[1].Y)
                    box.PointB = Vector2.new(corners[2].X, corners[2].Y)
                    box.PointC = Vector2.new(corners[3].X, corners[3].Y)
                    box.PointD = Vector2.new(corners[4].X, corners[4].Y)
                    box.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
                else
                    box.Visible = false
                end
            elseif box then
                box.Visible = false
            end
        end
    end)
end
