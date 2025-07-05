--# Desativa Aimlock Upper Body Only
getgenv()._AIMLOCK_UPPER_ONLY = false
if getgenv()._AIMLOCK_UPPER_CONN then
    getgenv()._AIMLOCK_UPPER_CONN:Disconnect()
    getgenv()._AIMLOCK_UPPER_CONN = nil
end
