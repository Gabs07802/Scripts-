if _G.espBoxRender then
    _G.espBoxRender:Disconnect()
    _G.espBoxRender = nil
end
if _G.espBoxDrawing then
    for _,box in pairs(_G.espBoxDrawing) do
        pcall(function() box:Remove() end)
    end
    _G.espBoxDrawing = {}
end
if _G.espBoxAdded then
    for _,conn in pairs(_G.espBoxAdded) do
        pcall(function() conn:Disconnect() end)
    end
    _G.espBoxAdded = {}
end
