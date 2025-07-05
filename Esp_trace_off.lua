-- ESP TRACE - DESATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
if _G.espTraceAdded then
    for plr,conn in pairs(_G.espTraceAdded) do if conn then pcall(function() conn:Disconnect() end) end end
    _G.espTraceAdded = {}
end
if _G.espTraceDrawing then
    for plr,tracer in pairs(_G.espTraceDrawing) do if tracer then pcall(function() tracer:Remove() end) end end
    _G.espTraceDrawing = {}
end
if _G.espTraceRender then _G.espTraceRender:Disconnect() _G.espTraceRender = nil end
