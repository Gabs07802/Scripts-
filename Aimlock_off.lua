-- Desativa aimlock de armas/tools
_G.AimLockToolEnabled = false
if _G.AimLockToolRenderConn then _G.AimLockToolRenderConn:Disconnect() end
_G.AimLockToolRenderConn = nil
