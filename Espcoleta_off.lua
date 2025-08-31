if _G.espPecaRender then
    _G.espPecaRender:Disconnect()
    _G.espPecaRender = nil
end
if _G.espPecaDrawing then
    for _,draws in pairs(_G.espPecaDrawing) do
        for _,draw in pairs(draws) do
            pcall(function() draw:Remove() end)
        end
    end
    _G.espPecaDrawing = {}
end
