-- STAFF LIST ON: Exibe uma lista com STAFF: Nome em RGB [distância em RGB], apenas para times STAFF e BIB | STAFF

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Cleanup anterior
if _G._StaffListGui then pcall(function() _G._StaffListGui:Destroy() end) end
if _G._StaffList_Con then pcall(function() _G._StaffList_Con:Disconnect() end) end

-- Função para RGB animado
local function getRGBColor(offset)
    local t = tick() + (offset or 0)
    return Color3.fromHSV((t%5)/5, 1, 1)
end

local function isStaff(player)
    if not player.Team or not player.Team.Name then return false end
    local t = player.Team.Name
    return t == "STAFF" or t == "BIB | STAFF"
end

local function getStaffPlayers()
    local list = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isStaff(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, plr)
        end
    end
    return list
end

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "StaffListGUI"
gui.Parent = game.CoreGui
_G._StaffListGui = gui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 220)
mainFrame.Position = UDim2.new(0.5, -250, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 0
mainFrame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0,40)
uicorner.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(128, 65, 65)
titleBar.BackgroundTransparency = 0
titleBar.Parent = mainFrame

local titleUICorner = Instance.new("UICorner")
titleUICorner.CornerRadius = UDim.new(0,40)
titleUICorner.Parent = titleBar

local titleLbl = Instance.new("TextLabel")
titleLbl.Name = "StaffTitle"
titleLbl.Text = "STAFF LIST"
titleLbl.Size = UDim2.new(1, 0, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 54
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
titleLbl.TextXAlignment = Enum.TextXAlignment.Center
titleLbl.TextYAlignment = Enum.TextYAlignment.Center
titleLbl.Parent = titleBar

-- Staff list
local listStartY = 70
local lineHeight = 45
local maxLines = 3
local staffLines = {}

for i = 1, maxLines do
    local label = Instance.new("TextLabel")
    label.Name = "StaffLine" .. i
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 20, 0, listStartY + (i-1)*lineHeight)
    label.Size = UDim2.new(1, -40, 0, lineHeight)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = ""
    label.Parent = mainFrame
    staffLines[i] = label
end

-- Atualização dinâmica da lista e RGB
_G._StaffList_Con = RunService.RenderStepped:Connect(function()
    -- Atualiza cor do título
    titleLbl.TextColor3 = getRGBColor(0)

    local staffList = getStaffPlayers()
    for i = 1, maxLines do
        local line = staffLines[i]
        local plr = staffList[i]
        if plr then
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local dist = hrp and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or "?"
            -- RGB para nome e distância
            local rgbName = getRGBColor(i*0.25)
            local rgbDist = getRGBColor(i*0.5)
            line.Text = ("STAFF: <font color=\"rgb(%d,%d,%d)\">%s</font> [ <font color=\"rgb(%d,%d,%d)\">%s metros</font> ]")
                :format(
                    math.floor(rgbName.R*255), math.floor(rgbName.G*255), math.floor(rgbName.B*255), plr.Name,
                    math.floor(rgbDist.R*255), math.floor(rgbDist.G*255), math.floor(rgbDist.B*255), dist
                )
            line.RichText = true
            line.Visible = true
        else
            line.Text = ""
            line.Visible = false
        end
    end
end)
