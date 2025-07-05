-- ESP BOX - DESATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
if _G.espBoxAdded then
    for plr,conn in pairs(_G.espBoxAdded) do if conn then pcall(function() conn:Disconnect() end) end end
    _G.espBoxAdded = {}
end
if _G.espBoxDrawing then
    for plr,box in pairs(_G.espBoxDrawing) do if box then pcall(function() box:Remove() end) end end
    _G.espBoxDrawing = {}
end
if _G.espBoxRender then _G.espBoxRender:Disconnect() _G.espBoxRender = nil end
