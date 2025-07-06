-- NIGHTVISION: Deixa o jogo com brilho máximo

if _G._NightVisionRestore then pcall(_G._NightVisionRestore) end
_G._NightVisionRestore = nil

local Lighting = game:GetService("Lighting")
local oldBrightness = Lighting.Brightness
local oldExposure = (Lighting:FindFirstChildOfClass("ColorCorrectionEffect") and Lighting:FindFirstChildOfClass("ColorCorrectionEffect").ExposureCompensation) or nil

Lighting.Brightness = 10
local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
if not cc then
    cc = Instance.new("ColorCorrectionEffect", Lighting)
end
cc.ExposureCompensation = 2.5

_G._NightVisionRestore = function()
    Lighting.Brightness = oldBrightness
    if oldExposure then cc.ExposureCompensation = oldExposure else cc.ExposureCompensation = 0 end
end
