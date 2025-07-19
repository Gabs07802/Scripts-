-- DESATIVAR SPEEDCAR: volta todos os carros ao padrão (ex: 180 km/h e aceleração pela metade)
local carrosFolder = workspace:FindFirstChild("CarrosSpawnados")
if carrosFolder then
    for _, carro in ipairs(carrosFolder:GetChildren()) do
        local vMax = carro:FindFirstChild("VelocidadeMaxima")
        if vMax and vMax:IsA("NumberValue") then
            vMax.Value = 180  -- Coloque aqui o valor original padrão se souber
        end
        for _, obj in ipairs(carro:GetChildren()) do
            if obj:IsA("NumberValue") then
                local nome = string.lower(obj.Name)
                if nome:find("acelera") or nome:find("accel") then
                    obj.Value = obj.Value / 2 -- volta ao valor original se antes foi dobrado
                end
            end
        end
    end
    print("SpeedCar DESATIVADO: Todos os carros voltaram ao padrão de velocidade e aceleração.")
else
    warn("Pasta 'CarrosSpawnados' não encontrada!")
end
