-- ESP CORPO - DESATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
if _G.espBodyAdded then
    for plr,conn in pairs(_G.espBodyAdded) do if conn then pcall(function() conn:Disconnect() end) end end
    _G.espBodyAdded = {}
end
if _G.espBodyHigh then
    for plr,high in pairs(_G.espBodyHigh) do if high then pcall(function() high:Destroy() end) end end
    _G.espBodyHigh = {}
end
