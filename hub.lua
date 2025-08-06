loadstring([===[
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local RS = game:GetService("RunService")

local ball
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
        ball = obj
        break
    end
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CqwaHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.4, 0, 0.45, 0)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "Cqwa Hub"
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.new(0,0,0)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0.1, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextScaled = true

local openBtn = Instance.new("TextButton", gui)
openBtn.Text = "✓"
openBtn.Size = UDim2.new(0.05, 0, 0.05, 0)
openBtn.Position = UDim2.new(0.02, 0, 0.9, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
openBtn.TextScaled = true
openBtn.Visible = false

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

local tabs = Instance.new("Frame", frame)
tabs.Size = UDim2.new(1, 0, 0.1, 0)
tabs.Position = UDim2.new(0, 0, 0.1, 0)
tabs.BackgroundTransparency = 1

local scriptTabBtn = Instance.new("TextButton", tabs)
scriptTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
scriptTabBtn.Text = "Scripts"
scriptTabBtn.Font = Enum.Font.SourceSans
scriptTabBtn.TextScaled = true
scriptTabBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)

local levelTabBtn = Instance.new("TextButton", tabs)
levelTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
levelTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
levelTabBtn.Text = "Level"
levelTabBtn.Font = Enum.Font.SourceSans
levelTabBtn.TextScaled = true
levelTabBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)

local scriptTab = Instance.new("Frame", frame)
scriptTab.Size = UDim2.new(1, 0, 0.8, 0)
scriptTab.Position = UDim2.new(0, 0, 0.2, 0)
scriptTab.BackgroundTransparency = 1
scriptTab.Visible = true

local levelTab = Instance.new("Frame", frame)
levelTab.Size = UDim2.new(1, 0, 0.8, 0)
levelTab.Position = UDim2.new(0, 0, 0.2, 0)
levelTab.BackgroundTransparency = 1
levelTab.Visible = false

scriptTabBtn.MouseButton1Click:Connect(function()
	scriptTab.Visible = true
	levelTab.Visible = false
end)
levelTabBtn.MouseButton1Click:Connect(function()
	scriptTab.Visible = false
	levelTab.Visible = true
end)

local sliderLabel = Instance.new("TextLabel", scriptTab)
sliderLabel.Text = "Reach: 15"
sliderLabel.Size = UDim2.new(1, 0, 0.1, 0)
sliderLabel.TextScaled = true
sliderLabel.BackgroundTransparency = 1
sliderLabel.Position = UDim2.new(0, 0, 0.05, 0)

local slider = Instance.new("TextButton", scriptTab)
slider.Size = UDim2.new(0.8, 0, 0.05, 0)
slider.Position = UDim2.new(0.1, 0, 0.15, 0)
slider.BackgroundColor3 = Color3.fromRGB(200,200,200)
slider.Text = ""

local knob = Instance.new("Frame", slider)
knob.Size = UDim2.new(0.05, 0, 1, 0)
knob.BackgroundColor3 = Color3.fromRGB(100,100,100)
knob.Position = UDim2.new(0.5, 0, 0, 0)
knob.BorderSizePixel = 0

local dragging = false
local reach = 15

local function updateSlider(input)
	local relX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
	knob.Position = UDim2.new(relX, 0, 0, 0)
	reach = math.floor(1 + relX * 24)
	sliderLabel.Text = "Reach: "..reach
end

slider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		updateSlider(input)
	end
end)
slider.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
slider.InputChanged:Connect(function(input)
	if dragging then
		updateSlider(input)
	end
end)

local hitbox = Instance.new("Part")
hitbox.Anchored = true
hitbox.CanCollide = false
hitbox.Transparency = 1
hitbox.Size = Vector3.new(4,4,4)
hitbox.Parent = workspace

RS.RenderStepped:Connect(function()
	if not ball or not hrp then return end
	local dir = hrp.CFrame.LookVector
	local pos = hrp.Position + dir * reach
	hitbox.Position = pos
	local dist = (ball.Position - hitbox.Position).Magnitude
	if dist < 5 then
		local force = Vector3.new(dir.X + 0.1, dir.Y + 0.1, dir.Z + 0.2).Unit * 60
		ball.AssemblyLinearVelocity = force
		task.spawn(function()
			for i = 1, 50 do
				if ball then
					ball.AssemblyLinearVelocity *= 0.94
				end
				task.wait(0.05)
			end
		end)
	end
end)
]===])()
