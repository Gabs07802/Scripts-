-- STAFF NAME ON: Nome RGB sobre STAFF, tamanho dinâmico de acordo com a distância

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

_G._StaffName_Connections = _G._StaffName_Connections or {}
_G._StaffName_Draws = _G._StaffName_Draws or {}

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
for _,c in ipairs(_G._StaffName_Connections) do pcall(function() c:Disconnect() end) end
_G._StaffName_Connections = {}
for _,d in ipairs(_G._StaffName_Draws) do pcall(function() d:Remove() end) end
_G._StaffName_Draws = {}

local function drawNames()
    -- Remove previous names
    for _,d in ipairs(_G._StaffName_Draws) do pcall(function() d:Remove() end) end
    _G._StaffName_Draws = {}

    for _,plr in ipairs(getStaffPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("Head") then
            local headPos = char.Head.Position + Vector3.new(0, 1.5, 0)
            local vector, onScreen = Camera:WorldToViewportPoint(headPos)
            if onScreen then
                -- Distância para o local player
                local dist = (Camera.CFrame.Position - headPos).Magnitude
                local size = math.clamp(25 * (45/dist), 12, 32)
                local text = Drawing.new("Text")
                text.Text = plr.DisplayName or plr.Name
                text.Position = Vector2.new(vector.X, vector.Y)
                text.Center = true
                text.Outline = true
                text.Size = size
                text.Color = getRGBColor(vector.Y)
                text.Transparency = 1
                table.insert(_G._StaffName_Draws, text)
            end
        end
    end
end

local con = RunService.RenderStepped:Connect(drawNames)
table.insert(_G._StaffName_Connections, con)
