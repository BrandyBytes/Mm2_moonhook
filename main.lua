-- Moonhook MM2 Main Script
-- Professional GUI with requested features

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Helper functions
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonhookGui"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 600)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui
createUICorner(mainFrame, 15)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
createUICorner(titleBar, 15)

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Moonhook"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 30
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Parent = titleBar

-- Drag functionality
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Scroll frame for buttons/sliders
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 12)
listLayout.Parent = scrollFrame

-- Create Toggle UI element
local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    createUICorner(frame, 10)

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 70, 0, 30)
    toggleBtn.Position = UDim2.new(1, -80, 0.5, -15)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 18
    toggleBtn.Parent = frame

    local enabled = default

    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
        toggleBtn.Text = enabled and "ON" or "OFF"
        callback(enabled)
    end)

    return frame
end

-- Create Slider UI element
local function createSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    createUICorner(frame, 10)

    local label = Instance.new("TextLabel")
    label.Text = text .. ": " .. tostring(default)
    label.Size = UDim2.new(1, -30, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -30, 0, 20)
    slider.Position = UDim2.new(0, 15, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    createUICorner(slider, 8)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    fill.Parent = slider

    local dragging = false

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - slider.AbsolutePosition.X
            local sizeX = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(sizeX, 0, 1, 0)
            local value = math.floor(min + sizeX * (max - min))
            label.Text = text .. ": " .. tostring(value)
            callback(value)
        end
    end)

    return frame
end

-- Helper to find player by name
local function findPlayer(name)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) then
            return player
        end
    end
    return nil
end

-- WalkSpeed slider
createSlider("WalkSpeed", 16, 250, 16, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)

-- JumpPower slider
createSlider("JumpPower", 50, 250, 50, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
    end
end)

-- Btools toggle
createToggle("Btools", false, function(enabled)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    if enabled then
        if not backpack:FindFirstChild("Btools") then
            local btools = Instance.new("HopperBin")
            btools.Name = "Btools"
            btools.BinType = Enum.BinType.Spawn
            btools.Parent = backpack
        end
    else
        for _, tool in pairs(backpack:GetChildren()) do
            if tool.Name == "Btools" then tool:Destroy() end
        end
    end
end)

-- Godmode toggle (simple infinite health)
local godmodeEnabled = false
createToggle("Godmode", false, function(enabled)
    godmodeEnabled = enabled
    if enabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end)

-- ESP (Sheriff, Murderer, All)
local espEnabled = {
    Sheriff = false,
    Murderer = false,
    All = false,
}

local espFolder = Instance.new("Folder", Workspace)
espFolder.Name = "MoonhookESP"

local function createBoxAdornee(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = player.Character.HumanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 5, 1)
    box.Transparency = 0.5
    box.Parent = espFolder
    return box
end

local espBoxes = {}

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local role = player:GetAttribute("Role") or "" -- MM2 role attribute or change to your game role logic
            local shouldShow = false
            if espEnabled.All then
                shouldShow = true
            elseif espEnabled.Sheriff and role == "Sheriff" then
                shouldShow = true
            elseif espEnabled.Murderer and role == "Murderer" then
                shouldShow = true
            end

            if shouldShow then
                if not espBoxes[player] then
                    espBoxes[player] = createBoxAdornee(player)
                end
                if espBoxes[player] then espBoxes[player].Enabled = true end
            else
                if espBoxes[player] then espBoxes[player].Enabled = false end
            end
        end
    end
end

RunService.Heartbeat:Connect(updateESP)

-- ESP toggles
createToggle("ESP Sheriff", false, function(enabled)
    espEnabled.Sheriff = enabled
end)

createToggle("ESP Murderer", false, function(enabled)
    espEnabled.Murderer = enabled
end)

createToggle("ESP All", false, function(enabled)
    espEnabled.All = enabled
end)

-- Silent Aim (Sheriff only) toggle - placeholder logic (you must add your own aim code)
local silentAimEnabled = false
createToggle("Silent Aim (Sheriff)", false, function(enabled)
    silentAimEnabled = enabled
    -- Add your silent aim implementation here
end)

-- Kill Aura (Murderer) with whitelist toggle - placeholder
local killAuraEnabled = false
local killAuraWhitelist = {}
createToggle("Kill Aura (Murderer)", false, function(enabled)
    killAuraEnabled = enabled
    -- Implement kill aura logic here with whitelist filtering
end)

-- Kill All (Murderer) with whitelist button - placeholder
local killAllButton = Instance.new("TextButton")
killAllButton.Size = UDim2.new(1, 0, 0, 45)
killAllButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
killAllButton.BorderSizePixel = 0
killAllButton.Text = "Kill All as Murderer"
killAllButton.TextColor3 = Color3.fromRGB(230, 230, 230)
killAllButton.Font = Enum.Font.GothamBold
killAllButton.TextSize = 22
killAllButton.Parent = scrollFrame
createUICorner(killAllButton, 10)

killAllButton.MouseButton1Click:Connect(function()
    -- Your kill all logic here with whitelist
    print("Kill All activated")
end)

-- Gun ESP toggle (simple highlighting guns)
local gunESPEnabled = false
createToggle("Gun ESP", false, function(enabled)
    gunESPEnabled = enabled
    -- Add Gun ESP logic here
end)

-- Grab Gun toggle (placeholder)
local grabGunEnabled = false
createToggle("Grab Gun", false, function(enabled)
    grabGunEnabled = enabled
    -- Implement grab gun logic here
end)

-- Xray toggle (toggle transparency of walls)
local xrayEnabled = false
createToggle("Xray", false, function(enabled)
    xrayEnabled = enabled
    -- Implement Xray logic here
end)

-- XP and Coin Autofarm toggle (placeholder)
local xpAutoFarmEnabled = false
local coinAutoFarmEnabled = false

createToggle("XP Autofarm", false, function(enabled)
    xpAutoFarmEnabled = enabled
    -- Your XP autofarm logic here
end)

createToggle("Coin Autofarm", false, function(enabled)
    coinAutoFarmEnabled = enabled
    -- Your coin autofarm logic here
end)

-- Update ScrollFrame canvas size dynamically
local uiListLayout = scrollFrame.UIListLayout or listLayout
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
