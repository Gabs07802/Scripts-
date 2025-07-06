-- FPS BOOST: Remove árvores, partículas, latas, lixo, e tudo que é desnecessário para melhorar o FPS

local debrisNames = {"Arvore", "Árvore", "Tree", "Lata", "Lixo", "Trash", "Can", "Bin"} -- personalize conforme o mapa
local debrisClasses = {
    "ParticleEmitter", "Smoke", "Fire", "Sparkles", "Trail"
}

-- Remove objetos do workspace
local function clearUnwanted()
    for _,desc in ipairs(workspace:GetDescendants()) do
        -- Remove objetos por nome
        for _,n in ipairs(debrisNames) do
            if desc.Name:lower():find(n:lower()) then
                pcall(function() desc:Destroy() end)
            end
        end
        -- Remove objetos por classe
        for _,c in ipairs(debrisClasses) do
            if desc:IsA(c) then
                pcall(function() desc:Destroy() end)
            end
        end
        -- Remove Decals de solo e objetos pequenos
        if desc:IsA("Decal") or desc:IsA("Texture") then
            pcall(function() desc:Destroy() end)
        end
        -- Remove MeshParts de lixo
        if desc:IsA("MeshPart") and desc.Name:lower():find("lixo") then
            pcall(function() desc:Destroy() end)
        end
    end
end

-- Diminui qualidade de Terrain & Lighting
pcall(function()
    workspace.Terrain.WaterTransparency = 1
    workspace.Terrain.Decoration = false
end)
if game.Lighting then
    pcall(function()
        game.Lighting.FogEnd = 1e10
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = false
        game.Lighting.EnvironmentDiffuseScale = 0
        game.Lighting.EnvironmentSpecularScale = 0
    end)
end

-- Remove efeitos em Players
for _,plr in pairs(game.Players:GetPlayers()) do
    local char = plr.Character
    if char then
        for _,desc in ipairs(char:GetDescendants()) do
            for _,c in ipairs(debrisClasses) do
                if desc:IsA(c) then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
    end
end

-- Limpa tudo repetidamente por 10 segundos (pega respawns/loops)
for i=1,20 do
    clearUnwanted()
    task.wait(0.5)
end
clearUnwanted()

-- Remove efeitos de tela
if game.Lighting then
    for _,v in pairs(game.Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
            pcall(function() v:Destroy() end)
        end
    end
end

print("FPS BOOST ativado! Para reverter, reinicie o jogo.")
