local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local RS = game:GetService("RunService")
local reach = 25

local ball
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
        ball = obj
        break
    end
end

if not ball then
    warn("Top bulunamadı")
    return
end

local fakePart = Instance.new("Part", workspace)
fakePart.Anchored = true
fakePart.Transparency = 1
fakePart.CanCollide = false
fakePart.Size = Vector3.new(4,4,4)

RS.RenderStepped:Connect(function()
    local dir = hrp.CFrame.LookVector
    local pos = hrp.Position + dir * reach
    fakePart.Position = pos

    if (ball.Position - pos).Magnitude <= 5 then
        local power = dir.Unit * 60
        ball.AssemblyLinearVelocity = power
        task.spawn(function()
            for i = 1, 40 do
                if ball then
                    ball.AssemblyLinearVelocity *= 0.92
                end
                task.wait(0.03)
            end
        end)
    end
end)
