-- ESP HEAD: Só aparece (vermelho) em quem NÃO for STAFF/BIB nem STAFF

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espHeadHigh then _G.espHeadHigh = {} end
if not _G.espHeadAdded then _G.espHeadAdded = {} end

local function isStaff(plr)
    return plr.Team and (
        plr.Team.Name == "STAFF" or plr.Team.Name == "BIB | STAFF" or plr.Team.Name == "STAFF/BIB"
    )
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player and not isStaff(plr) then
        local function addHeadHighlight()
            if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                if _G.espHeadHigh[plr] then _G.espHeadHigh[plr]:Destroy() end
                local high = Instance.new("Highlight")
                high.FillColor = Color3.fromRGB(255,0,0) -- VERMELHO
                high.OutlineTransparency = 1
                high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                high.Parent = plr.Character.Head
                high.Adornee = plr.Character.Head
                _G.espHeadHigh[plr] = high
            end
        end
        addHeadHighlight()
        if _G.espHeadAdded[plr] then _G.espHeadAdded[plr]:Disconnect() end
        _G.espHeadAdded[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            addHeadHighlight()
        end)
    end
end
if not _G.espHeadAdded["_playerAdded"] then
    _G.espHeadAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        if isStaff(plr) then return end
        _G.espHeadAdded[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                if _G.espHeadHigh[plr] then _G.espHeadHigh[plr]:Destroy() end
                local high = Instance.new("Highlight")
                high.FillColor = Color3.fromRGB(255,0,0) -- VERMELHO
                high.OutlineTransparency = 1
                high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                high.Parent = plr.Character.Head
                high.Adornee = plr.Character.Head
                _G.espHeadHigh[plr] = high
            end
        end)
    end)
end
