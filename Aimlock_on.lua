local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local AIM_PART = "Head"
local AIM_FOV = 300

local function getClosestTarget()
    local closest, shortest = nil, AIM_FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AIM_PART) and v.Team ~= LocalPlayer.Team then
            local pos, onscreen = Camera:WorldToViewportPoint(v.Character[AIM_PART].Position)
            if onscreen and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = v
                end
            end
        end
    end
    return closest
end

getgenv().AIMLOCK_MOBILE = true

getgenv().AIMLOCK_MOBILE_CONN = RunService.RenderStepped:Connect(function()
    if not getgenv().AIMLOCK_MOBILE then return end
    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(AIM_PART) then
        local targetPos = target.Character[AIM_PART].Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end
end)
