-- Desliga o ANT-STAFF: Para monitoramento e impede kick/desconexão automática

if _G._AntStaffCon then
    pcall(function() _G._AntStaffCon:Disconnect() end)
    _G._AntStaffCon = nil
end
