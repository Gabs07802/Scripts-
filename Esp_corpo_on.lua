-- ESP CORPO - ATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espBodyHigh then _G.espBodyHigh = {} end
if not _G.espBodyAdded then _G.espBodyAdded = {} end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        local function addHighlight()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                if _G.espBodyHigh[plr] then _G.espBodyHigh[plr]:Destroy() end
                local high = Instance.new("Highlight")
                high.FillColor = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
                high.OutlineTransparency = 1
                high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                high.Parent = plr.Character
                high.Adornee = plr.Character
                _G.espBodyHigh[plr] = high
            end
        end
        addHighlight()
        if _G.espBodyAdded[plr] then _G.espBodyAdded[plr]:Disconnect() end
        _G.espBodyAdded[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            addHighlight()
        end)
    end
end
if not _G.espBodyAdded["_playerAdded"] then
    _G.espBodyAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        _G.espBodyAdded[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                if _G.espBodyHigh[plr] then _G.espBodyHigh[plr]:Destroy() end
                local high = Instance.new("Highlight")
                high.FillColor = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
                high.OutlineTransparency = 1
                high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                high.Parent = plr.Character
                high.Adornee = plr.Character
                _G.espBodyHigh[plr] = high
            end
        end)
    end)
end
