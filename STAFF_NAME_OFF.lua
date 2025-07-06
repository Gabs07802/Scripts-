if _G._StaffName_Con then _G._StaffName_Con:Disconnect(); _G._StaffName_Con = nil end
if _G._StaffName_Draws then for _,d in pairs(_G._StaffName_Draws) do pcall(function() d:Remove() end) end _G._StaffName_Draws = nil end
