-- STAFF LIST ON: Com movimentação por mouse (PC) e toque (celular/tablet), só pela barra vermelha

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Cleanup anterior
if _G._StaffListGui then pcall(function() _G._StaffListGui:Destroy() end) end
if _G._StaffList_Con then pcall(function() _G._StaffList_Con:Disconnect() end) end
if _G._StaffList_DragCon then pcall(function() _G._StaffList_DragCon:Disconnect() end) end

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

-- GUI Setup reduzido (3x menor)
local gui = Instance.new("ScreenGui")
gui.Name = "StaffListGUI"
gui.Parent = game.CoreGui
_G._StaffListGui = gui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500/3, 0, 220/3)
mainFrame.Position = UDim2.new(0.5, -500/6, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 0
mainFrame.Parent = gui
mainFrame.Active = true

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0,40/3)
uicorner.Parent = mainFrame

-- Title bar (barra vermelha)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60/3)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(128, 65, 65)
titleBar.BackgroundTransparency = 0
titleBar.Parent = mainFrame
titleBar.Active = true

local titleUICorner = Instance.new("UICorner")
titleUICorner.CornerRadius = UDim.new(0,40/3)
titleUICorner.Parent = titleBar

local titleLbl = Instance.new("TextLabel")
titleLbl.Name = "StaffTitle"
titleLbl.Text = "STAFF LIST"
titleLbl.Size = UDim2.new(1, 0, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 54/3
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
titleLbl.TextXAlignment = Enum.TextXAlignment.Center
titleLbl.TextYAlignment = Enum.TextYAlignment.Center
titleLbl.Parent = titleBar

-- Lista dos staffs
local listStartY = 70/3
local lineHeight = 45/3
local maxLines = 3
local staffLines = {}

for i = 1, maxLines do
    local label = Instance.new("TextLabel")
    label.Name = "StaffLine" .. i
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 20/3, 0, listStartY + (i-1)*lineHeight)
    label.Size = UDim2.new(1, -40/3, 0, lineHeight)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28/3
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = ""
    label.Parent = mainFrame
    staffLines[i] = label
end

-- DRAG & DROP MOUSE + TOUCH SOMENTE PELA BARRA VERMELHA
local dragging = false
local dragStart, startPos

local function beginDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

_G._StaffList_DragCon = UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

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
