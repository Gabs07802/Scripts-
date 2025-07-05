-- ESP HEAD - DESATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
if _G.espHeadAdded then
    for plr,conn in pairs(_G.espHeadAdded) do if conn then pcall(function() conn:Disconnect() end) end end
    _G.espHeadAdded = {}
end
if _G.espHeadHigh then
    for plr,high in pairs(_G.espHeadHigh) do if high then pcall(function() high:Destroy() end) end end
    _G.espHeadHigh = {}
end
