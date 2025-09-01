-- ANT-STAFF: Kicka o usuário se detectar STAFF/BIB STAFF e exibe mensagem personalizada

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Cleanup anterior
if _G._AntStaffCon then pcall(function() _G._AntStaffCon:Disconnect() end) end

-- Função para identificar staff
local function isStaff(player)
    if not player.Team or not player.Team.Name then return false end
    local t = player.Team.Name
    return t == "STAFF" or t == "BIB | STAFF"
end

-- Função para pegar staff do servidor
local function getStaffPlayers()
    local list = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isStaff(plr) then
            table.insert(list, plr)
        end
    end
    return list
end

-- Função para kickar usuário com mensagem
local function antStaffKick(staffName)
    LocalPlayer:Kick('By ANT-STAFF: STAFF "' .. staffName .. '" Localizado')
end

-- Monitorar staff em tempo real
_G._AntStaffCon = RunService.RenderStepped:Connect(function()
    local staffList = getStaffPlayers()
    if #staffList > 0 then
        local firstStaff = staffList[1]
        antStaffKick(firstStaff.Name)
        if _G._AntStaffCon then _G._AntStaffCon:Disconnect() end
        _G._AntStaffCon = nil
    end
end)

-- Também detecta novos staffs entrando
Players.PlayerAdded:Connect(function(plr)
    if isStaff(plr) then
        antStaffKick(plr.Name)
        if _G._AntStaffCon then _G._AntStaffCon:Disconnect() end
        _G._AntStaffCon = nil
    end
end)
