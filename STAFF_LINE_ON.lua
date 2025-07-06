-- STAFF LINE ON: Desenha linhas RGB para jogadores do time STAFF ou BIB | STAFF

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

_G._StaffLine_Connections = _G._StaffLine_Connections or {}
_G._StaffLine_Draws = _G._StaffLine_Draws or {}

local function isStaff(player)
    if not player.Team or not player.Team.Name then return false end
    local t = player.Team.Name
    return t == "STAFF" or t == "BIB | STAFF"
end

local function getStaffPlayers()
    local list = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isStaff(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, plr)
        end
    end
    return list
end

local function getRGBColor(timeOffset)
    local t = tick() + (timeOffset or 0)
    return Color3.fromHSV((t%5)/5, 1, 1)
end

-- Clean up previous
for _,c in ipairs(_G._StaffLine_Connections) do pcall(function() c:Disconnect() end) end
_G._StaffLine_Connections = {}
for _,d in ipairs(_G._StaffLine_Draws) do pcall(function() d:Remove() end) end
_G._StaffLine_Draws = {}

local function drawLines()
    -- Remove previous lines
    for _,d in ipairs(_G._StaffLine_Draws) do pcall(function() d:Remove() end) end
    _G._StaffLine_Draws = {}

    for _,plr in ipairs(getStaffPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            local vector, onScreen = Camera:WorldToViewportPoint(pos)
            if onScreen then
                local line = Drawing.new("Line")
                line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) -- Do fundo da tela
                line.To = Vector2.new(vector.X, vector.Y)
                line.Color = getRGBColor(vector.X + vector.Y)
                line.Thickness = 2
                line.Transparency = 1
                table.insert(_G._StaffLine_Draws, line)
            end
        end
    end
end

local con = RunService.RenderStepped:Connect(drawLines)
table.insert(_G._StaffLine_Connections, con)
