-- STAFF LIST OFF: Remove a lista e desconecta atualização

if _G._StaffList_Con then pcall(function() _G._StaffList_Con:Disconnect() end) _G._StaffList_Con = nil end
if _G._StaffListGui then pcall(function() _G._StaffListGui:Destroy() end) _G._StaffListGui = nil end
