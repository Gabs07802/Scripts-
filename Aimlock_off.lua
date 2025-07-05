--# Aimlock Completo Desativado
getgenv()._AIMLOCK_FULL_ACTIVE = false
if getgenv()._AIMLOCK_FULL_CONNECTIONS then
    for _,conn in pairs(getgenv()._AIMLOCK_FULL_CONNECTIONS) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    getgenv()._AIMLOCK_FULL_CONNECTIONS = nil
end
