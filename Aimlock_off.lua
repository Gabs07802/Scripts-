-- Desativa Aimlock corpo inteiro
_G.AimLockEnabled = false
if _G.AimLockRenderConn then _G.AimLockRenderConn:Disconnect() end
_G.AimLockRenderConn = nil
