if _G._StaffLine_Con then _G._StaffLine_Con:Disconnect(); _G._StaffLine_Con = nil end
if _G._StaffLine_Draws then for _,d in pairs(_G._StaffLine_Draws) do pcall(function() d:Remove() end) end _G._StaffLine_Draws = nil end
