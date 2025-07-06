-- STAFF LINE ON: Linha fina, RGB, só para STAFF/BIB | STAFF entre 1 e 400 metros, agora acompanha a cabeça (Head)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

if _G._StaffLine_Con then _G._StaffLine_Con:Disconnect() end
if _G._StaffLine_Draws then for _,d in pairs(_G._StaffLine_Draws) do pcall(function() d:Remove() end) end end
_G._StaffLine_Draws = {}

local function isStaff(p)
    return p.Team and (p.Team.Name == "STAFF" or p.Team.Name == "BIB | STAFF")
end

_G._StaffLine_Con = RunService.RenderStepped:Connect(function()
    -- Limpa linhas antigas
    for _,d in pairs(_G._StaffLine_Draws) do pcall(function() d:Remove() end) end
    _G._StaffLine_Draws = {}

    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isStaff(plr) then
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")
            if head then
                local dist = (myHRP.Position - head.Position).Magnitude
                if dist >= 1 and dist <= 700 then
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local line = Drawing.new("Line")
                        line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Color = Color3.fromHSV((tick()%5)/5,1,1)
                        line.Thickness = 1.2
                        line.Transparency = 1
                        table.insert(_G._StaffLine_Draws, line)
                    end
                end
            end
        end
    end
end)
