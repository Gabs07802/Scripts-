--[[
    FLY UNIVERSAL v3 (PC & MOBILE) - DESLIGAR
    Desativa o modo voo, limpa animação, eventos, gui e devolve o personagem ao normal.
--]]

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:FindFirstChildOfClass("Humanoid")

_G.flying = false

if _G.flyConn then pcall(function() _G.flyConn:Disconnect() end) _G.flyConn = nil end
if _G.flyAnimTrack then pcall(function() _G.flyAnimTrack:Stop() end) _G.flyAnimTrack = nil end
if _G.flyStep then pcall(function() _G.flyStep:Disconnect() end) _G.flyStep = nil end

pcall(function() if plr.PlayerGui:FindFirstChild("FLYGUI") then plr.PlayerGui.FLYGUI:Destroy() end end)
if hum then hum.PlatformStand = false end
