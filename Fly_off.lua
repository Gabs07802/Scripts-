--# Fly universal desativado
getgenv()._FLY_ACTIVE = false
if getgenv()._FLY_CONN then getgenv()._FLY_CONN:Disconnect() end
getgenv()._FLY_CONN = nil
if getgenv()._FLY_BTN then getgenv()._FLY_BTN:Destroy() end
-- Libera personagem
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
if Character and Character:FindFirstChildOfClass("Humanoid") then
    Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
end
print("[MOD MENU] Fly desativado.")
