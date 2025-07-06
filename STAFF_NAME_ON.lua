-- STAFF NAME: ESP name RGB para STAFF/BIB | STAFF, nome maior quando perto, menor quando longe, sem limite de distância

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

if _G._StaffName_Con then _G._StaffName_Con:Disconnect() end
if _G._StaffName_Draws then for _,d in pairs(_G._StaffName_Draws) do pcall(function() d:Remove() end) end end
_G._StaffName_Draws = {}

local function isStaff(plr)
    return plr.Team and (plr.Team.Name == "STAFF" or plr.Team.Name == "BIB | STAFF")
end

_G._StaffName_Con = RunService.RenderStepped:Connect(function()
    for _,d in pairs(_G._StaffName_Draws) do pcall(function() d:Remove() end) end
    _G._StaffName_Draws = {}

    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isStaff(plr) then
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")
            if head then
                local dist = (myHRP.Position - head.Position).Magnitude
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.6, 0))
                if onScreen then
                    -- Tamanho dinâmico (quanto mais perto, maior; quanto mais longe, menor)
                    local size = math.clamp(32 * (35 / dist), 12, 32)
                    local txt = Drawing.new("Text")
                    txt.Text = plr.DisplayName or plr.Name
                    txt.Position = Vector2.new(pos.X, pos.Y)
                    txt.Center = true
                    txt.Outline = true
                    txt.Size = size
                    txt.Font = 2 -- UI
                    txt.Color = Color3.fromHSV((tick()%5)/5,1,1)
                    txt.Transparency = 1
                    table.insert(_G._StaffName_Draws, txt)
                end
            end
        end
    end
end)
