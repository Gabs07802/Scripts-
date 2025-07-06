-- STAFF NAME OFF: Remove todos os textos e desconecta

if _G._StaffName_Connections then
    for _,c in ipairs(_G._StaffName_Connections) do pcall(function() c:Disconnect() end) end
    _G._StaffName_Connections = nil
end
if _G._StaffName_Draws then
    for _,d in ipairs(_G._StaffName_Draws) do pcall(function() d:Remove() end) end
    _G._StaffName_Draws = nil
end
