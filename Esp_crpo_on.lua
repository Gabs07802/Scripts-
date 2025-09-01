--[[
Esse script mistura ESP Skeleton (linhas conectando partes do corpo) + ESP Head Highlight (cabeça fica vermelha, exceto STAFF/BIB).

- Desenha esqueleto para todos jogadores (exceto você).
- Destaca a cabeça em vermelho (Highlight) para quem NÃO for STAFF/BIB.
- Otimizado para não duplicar highlights ou linhas.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Skeleton config
if not _G.espSkeletonDrawing then _G.espSkeletonDrawing = {} end
if not _G.espSkeletonRender then _G.espSkeletonRender = nil end
if not _G.espSkeletonAdded then _G.espSkeletonAdded = {} end

-- Head highlight config
if not _G.espHeadHigh then _G.espHeadHigh = {} end
if not _G.espHeadAdded then _G.espHeadAdded = {} end

local function getTeamColor(plr)
    return (plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color) or Color3.new(1,1,1)
end

local function isStaff(plr)
    return plr.Team and (
        plr.Team.Name == "STAFF" or plr.Team.Name == "BIB | STAFF" or plr.Team.Name == "STAFF/BIB"
    )
end

-- Skeleton line connections
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
        line.Thickness = 1
        table.insert(_G.espSkeletonDrawing[plr], line)
    end
end

local function addHeadHighlight(plr)
    if plr == LocalPlayer or isStaff(plr) then return end
    if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
        if _G.espHeadHigh[plr] then _G.espHeadHigh[plr]:Destroy() end
        local high = Instance.new("Highlight")
        high.FillColor = Color3.fromRGB(255,0,0) -- VERMELHO
        high.OutlineTransparency = 1
        high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        high.Parent = plr.Character.Head
        high.Adornee = plr.Character.Head
        _G.espHeadHigh[plr] = high
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        addSkeleton(plr)
        if _G.espSkeletonAdded[plr] then _G.espSkeletonAdded[plr]:Disconnect() end
        _G.espSkeletonAdded[plr] = plr.CharacterAdded:Connect(function() addSkeleton(plr) end)
        
        -- Head highlight
        addHeadHighlight(plr)
        if _G.espHeadAdded[plr] then _G.espHeadAdded[plr]:Disconnect() end
        _G.espHeadAdded[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            addHeadHighlight(plr)
        end)
    end
end

if not _G.espSkeletonAdded["_playerAdded"] then
    _G.espSkeletonAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == LocalPlayer then return end
        _G.espSkeletonAdded[plr] = plr.CharacterAdded:Connect(function() addSkeleton(plr) end)
    end)
end

if not _G.espHeadAdded["_playerAdded"] then
    _G.espHeadAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == LocalPlayer or isStaff(plr) then return end
        _G.espHeadAdded[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            addHeadHighlight(plr)
        end)
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
