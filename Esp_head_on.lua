-- ESP HEAD - ATIVAR (MESMO CÓDIGO DO MENU ORIGINAL)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espHeadHigh then _G.espHeadHigh = {} end
if not _G.espHeadAdded then _G.espHeadAdded = {} end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        local function addHeadHighlight()
            if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                if _G.espHeadHigh[plr] then _G.espHeadHigh[plr]:Destroy() end
                local high = Instance.new("Highlight")
                high.FillColor = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
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
        _G.espHeadAdded[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.2)
            if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                if _G.espHeadHigh[plr] then _G.espHeadHigh[plr]:Destroy() end
                local high = Instance.new("Highlight")
                high.FillColor = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
                high.OutlineTransparency = 1
                high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                high.Parent = plr.Character.Head
                high.Adornee = plr.Character.Head
                _G.espHeadHigh[plr] = high
            end
        end)
    end)
end
