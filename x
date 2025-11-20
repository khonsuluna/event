--// SIMPLE TP LOOP GUI (MINIMIZE FIX + CUSTOM LOOP)
local GUI_NAME = "TpLoopGui"
if game.CoreGui:FindFirstChild(GUI_NAME) then
    game.CoreGui[GUI_NAME]:Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- =====================================================
-- CREATE GUI
-- =====================================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = GUI_NAME
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0.5, -130, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "TP Loop"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 40, 0, 30)
minimize.Position = UDim2.new(1, -40, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.Text = "-"
minimize.TextSize = 20
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.SourceSansBold

local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1

local labelA = Instance.new("TextLabel", content)
labelA.Size = UDim2.new(1, 0, 0, 25)
labelA.Position = UDim2.new(0, 0, 0, 0)
labelA.BackgroundTransparency = 1
labelA.Text = "Posisi A (X Y Z):"
labelA.TextColor3 = Color3.fromRGB(255,255,255)

local inputA = Instance.new("TextBox", content)
inputA.Size = UDim2.new(1, -10, 0, 25)
inputA.Position = UDim2.new(0, 5, 0, 25)
inputA.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputA.TextColor3 = Color3.fromRGB(255,255,255)
inputA.PlaceholderText = "contoh: 10 5 7"

local labelB = labelA:Clone()
labelB.Parent = content
labelB.Position = UDim2.new(0, 0, 0, 55)
labelB.Text = "Posisi B (X Y Z):"

local inputB = inputA:Clone()
inputB.Parent = content
inputB.Position = UDim2.new(0, 5, 0, 80)

local inputUserMinutes = Instance.new("TextBox", content)
inputUserMinutes.Size = UDim2.new(1, -10, 0, 25)
inputUserMinutes.Position = UDim2.new(0, 5, 0, 110)
inputUserMinutes.BackgroundColor3 = Color3.fromRGB(50,50,50)
inputUserMinutes.TextColor3 = Color3.fromRGB(255,255,255)
inputUserMinutes.PlaceholderText = "Waktu awal ke B (menit)"

local inputLoopDelay = Instance.new("TextBox", content)
inputLoopDelay.Size = UDim2.new(1, -10, 0, 25)
inputLoopDelay.Position = UDim2.new(0, 5, 0, 140)
inputLoopDelay.BackgroundColor3 = Color3.fromRGB(50,50,50)
inputLoopDelay.TextColor3 = Color3.fromRGB(255,255,255)
inputLoopDelay.PlaceholderText = "Delay loop berikutnya (menit/jam)"

local startBtn = Instance.new("TextButton", content)
startBtn.Size = UDim2.new(1, -10, 0, 30)
startBtn.Position = UDim2.new(0, 5, 0, 170)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.fromRGB(255,255,255)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 18

-- =====================================================
-- MINIMIZE FIX
-- =====================================================
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minimize.Text = minimized and "+" or "-"
    frame.Size = minimized and UDim2.new(0, 260, 0, 30) or UDim2.new(0, 260, 0, 180)
end)

-- =====================================================
-- TELEPORT FUNCTION
-- =====================================================
local function parseVector(str)
    local x,y,z = str:match("([^%s]+)%s+([^%s]+)%s+([^%s]+)")
    return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
end

local running = false

local function tpTo(vec)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(vec)
    end
end

-- =====================================================
-- LOOP LOGIC
-- =====================================================
startBtn.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    startBtn.Text = "RUNNING..."

    local posA = parseVector(inputA.Text)
    local posB = parseVector(inputB.Text)

    local firstDelay = tonumber(inputUserMinutes.Text) or 1
    local loopDelay = tonumber(inputLoopDelay.Text) or 60 -- default 1 jam

    task.spawn(function()
        while true do
            -- Ke B setelah input user
            task.wait(firstDelay * 60)
            tpTo(posB)

            -- Balik ke A setelah 11 menit
            task.wait(11 * 60)
            tpTo(posA)

            -- Loop delay custom
            task.wait(loopDelay * 60)
        end
    end)
end)
