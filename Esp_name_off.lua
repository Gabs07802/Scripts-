-- ESP NAME - DESATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
if _G.espNameConnections then
    for plr,conn in pairs(_G.espNameConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    _G.espNameConnections = {}
end

if _G.espNameAddedConnections then
    for plr,conn in pairs(_G.espNameAddedConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    _G.espNameAddedConnections = {}
end

if _G.espNameBillboards then
    for plr,bb in pairs(_G.espNameBillboards) do
        if bb and typeof(bb)=="Instance" and bb.Parent then pcall(function() bb:Destroy() end) end
    end
    _G.espNameBillboards = {}
end

if _G.espNameRenderStepped then
    _G.espNameRenderStepped:Disconnect()
    _G.espNameRenderStepped = nil
end
