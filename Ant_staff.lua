-- Script ANT STAFF para Roblox
-- Quando ativado, verifica a cada 1 segundo se há alguém do time/cargo "BIB | STAFF" ou " STAFF"
-- Se houver, o player sai do servidor imediatamente

_G.antstaff_ativo = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer

spawn(function()
    while _G.antstaff_ativo do
        for _, p in ipairs(Players:GetPlayers()) do
            -- Verifica Team e Name para maior segurança
            local teamString = ""
            if p.Team and p.Team.Name then
                teamString = p.Team.Name
            end
            local nameString = (p.Name or "")

            -- Checa se há alguém do time/cargo proibido
            if teamString == "BIB | STAFF" or teamString == " STAFF" or nameString == "BIB | STAFF" or nameString == " STAFF" then
                -- Sair do servidor
                pcall(function()
                    game:GetService("TeleportService"):Teleport(0, player)
                end)
                return -- Para o loop após sair
            end
        end
        wait(1)
    end
end)

-- Para desativar:
-- _G.antstaff_ativo = false
