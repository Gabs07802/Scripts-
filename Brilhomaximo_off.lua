-- NIGHTVISION OFF: Restaura o brilho

if _G._NightVisionRestore then
    pcall(_G._NightVisionRestore)
    _G._NightVisionRestore = nil
end
