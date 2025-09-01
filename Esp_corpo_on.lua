local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

if not _G.espSkeletonDrawing then _G.espSkeletonDrawing = {} end
if not _G.espSkeletonRender then _G.espSkeletonRender = nil end

local function getTeamColor(plr)
    return (plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color) or Color3.new(1,1,1)
end

-- Cria linhas para o esqueleto: 13 linhas para cabeça, ombros, tronco, mãos, pernas, pés
local SKELETON_LINEMAP = {
    {"Head", "UpperTorso"},     -- cabeça ao torso superior
    {"UpperTorso", "LeftUpperArm"},  -- torso ao ombro esquerdo
    {"UpperTorso", "RightUpperArm"}, -- torso ao ombro direito
    {"LeftUpperArm", "LeftLowerArm"},-- ombro esq ao cotovelo esq
    {"LeftLowerArm", "LeftHand"},    -- cotovelo esq à mão esq
    {"RightUpperArm", "RightLowerArm"},-- ombro dir ao cotovelo dir
    {"RightLowerArm", "RightHand"},    -- cotovelo dir à mão dir
    {"UpperTorso", "LowerTorso"},     -- torso superior ao inferior
    {"LowerTorso", "LeftUpperLeg"},   -- torso inf à coxa esq
    {"LeftUpperLeg", "LeftLowerLeg"}, -- coxa esq ao joelho esq
    {"LeftLowerLeg", "LeftFoot"},     -- joelho esq ao pé esq
    {"LowerTorso", "RightUpperLeg"},  -- torso inf à coxa dir
    {"RightUpperLeg", "RightLowerLeg"},-- coxa dir ao joelho dir
    {"RightLowerLeg", "RightFoot"},   -- joelho dir ao pé dir
    {"LeftUpperLeg", "RightUpperLeg"},-- entre as duas coxas
}

local PARTS = {
    "Head","UpperTorso","LowerTorso",
    "LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperArm","RightLowerArm","RightHand",
    "LeftUpperLeg","LeftLowerLeg","LeftFoot",
    "RightUpperLeg","RightLowerLeg","RightFoot"
}

local function addSkeleton(plr)
    if plr == LocalPlayer then return end
    if _G.espSkeletonDrawing[plr] then
        for _,v in pairs(_G.espSkeletonDrawing[plr]) do pcall(function() v:Remove() end) end
    end
    _G.espSkeletonDrawing[plr] = {}
    for i=1,#SKELETON_LINEMAP do
        local line = Drawing.new("Line")
        line.Visible = true
        line.Thickness = 2
        table.insert(_G.espSkeletonDrawing[plr], line)
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        addSkeleton(plr)
        if _G.espSkeletonDrawing[plr] then
            if _G.espSkeletonAdded and _G.espSkeletonAdded[plr] then _G.espSkeletonAdded[plr]:Disconnect() end
            _G.espSkeletonAdded = _G.espSkeletonAdded or {}
            _G.espSkeletonAdded[plr] = plr.CharacterAdded:Connect(function() addSkeleton(plr) end)
        end
    end
end
if not _G.espSkeletonAdded or not _G.espSkeletonAdded["_playerAdded"] then
    _G.espSkeletonAdded = _G.espSkeletonAdded or {}
    _G.espSkeletonAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == LocalPlayer then return end
        _G.espSkeletonAdded[plr] = plr.CharacterAdded:Connect(function() addSkeleton(plr) end)
    end)
end

if not _G.espSkeletonRender then
    _G.espSkeletonRender = RunService.RenderStepped:Connect(function()
        for plr,lines in pairs(_G.espSkeletonDrawing) do
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local parts2d = {}
                for _,partName in ipairs(PARTS) do
                    local part = char:FindFirstChild(partName)
                    if part then
                        local pos2d, vis = Camera:WorldToViewportPoint(part.Position)
                        parts2d[partName] = vis and pos2d.Z > 0 and Vector2.new(pos2d.X, pos2d.Y) or nil
                    end
                end
                local color = getTeamColor(plr)
                for i,map in ipairs(SKELETON_LINEMAP) do
                    local from = parts2d[map[1]]
                    local to = parts2d[map[2]]
                    if from and to then
                        local line = lines[i]
                        line.From = from
                        line.To = to
                        line.Color = color
                        line.Visible = true
                    else
                        lines[i].Visible = false
                    end
                end
            else
                for _,line in pairs(lines) do line.Visible = false end
            end
        end
    end)
end
