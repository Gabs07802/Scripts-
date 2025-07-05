-- ESP LIFE OFF: Remove todas as barras de vida do ESP LIFE
if _G.EspLifeBar then
    for _,v in pairs(_G.EspLifeBar) do
        if v and v.Parent then v:Destroy() end
    end
    _G.EspLifeBar = {}
end

if _G.EspLifeConn then
    for _,conn in pairs(_G.EspLifeConn) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    _G.EspLifeConn = {}
end
