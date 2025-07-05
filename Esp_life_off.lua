-- Desativa ESP LIFE Simples

_G.EspLife_Simple_Enabled = false
local Players = game:GetService("Players")
if _G.EspLifeSimpleConn then
    for k,conn in pairs(_G.EspLifeSimpleConn) do
        pcall(function() if typeof(conn)=="RBXScriptConnection" then conn:Disconnect() end end)
    end
end
for _,plr in ipairs(Players:GetPlayers()) do
    if plr.Character and plr.Character:FindFirstChild("Head") then
        local bb = plr.Character.Head:FindFirstChild("EspLifeSimple")
        if bb then pcall(function() bb:Destroy() end) end
    end
end
_G.EspLifeSimpleConn = {}
