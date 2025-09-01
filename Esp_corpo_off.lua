-- Desativa ESP Skeleton (linhas) e ESP Head Highlight (vermelho na cabeça)

if _G.espSkeletonRender then
    _G.espSkeletonRender:Disconnect()
    _G.espSkeletonRender = nil
end
if _G.espSkeletonDrawing then
    for _,lines in pairs(_G.espSkeletonDrawing) do
        for _,line in pairs(lines) do
            pcall(function() line:Remove() end)
        end
    end
    _G.espSkeletonDrawing = {}
end
if _G.espSkeletonAdded then
    for _,conn in pairs(_G.espSkeletonAdded) do
        pcall(function() conn:Disconnect() end)
    end
    _G.espSkeletonAdded = {}
end

if _G.espHeadHigh then
    for _,high in pairs(_G.espHeadHigh) do
        pcall(function() high:Destroy() end)
    end
    _G.espHeadHigh = {}
end
if _G.espHeadAdded then
    for _,conn in pairs(_G.espHeadAdded) do
        pcall(function() conn:Disconnect() end)
    end
    _G.espHeadAdded = {}
end
