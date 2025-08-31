if _G.espLifeBarRender then
    _G.espLifeBarRender:Disconnect()
    _G.espLifeBarRender = nil
end
if _G.espLifeBarDrawing then
    for _,draws in pairs(_G.espLifeBarDrawing) do
        for _,draw in pairs(draws) do
            pcall(function() draw:Remove() end)
        end
    end
    _G.espLifeBarDrawing = {}
end
if _G.espLifeBarAdded then
    for _,conn in pairs(_G.espLifeBarAdded) do
        pcall(function() conn:Disconnect() end)
    end
    _G.espLifeBarAdded = {}
end
