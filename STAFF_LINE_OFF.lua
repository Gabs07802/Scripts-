-- STAFF LINE OFF: Remove todas as linhas e desconecta

if _G._StaffLine_Connections then
    for _,c in ipairs(_G._StaffLine_Connections) do pcall(function() c:Disconnect() end) end
    _G._StaffLine_Connections = nil
end
if _G._StaffLine_Draws then
    for _,d in ipairs(_G._StaffLine_Draws) do pcall(function() d:Remove() end) end
    _G._StaffLine_Draws = nil
end
