local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "RiceHub",
    Author = "Steal Time Simulator",
})
Window:EditOpenButton({
    Title = "Open RiceHub",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})
Window:Tag({
    Title = "Undetected",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 8,
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "brick-wall",
    Locked = false,
})
local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "swords",
    Locked = false,
})
MainTab:Select()

local speedToSet = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed
local spinbotEnabled = false
local bodyLockEnabled = false
local spinbotSpeed = 70
local autoSafeTpEnabled = false
local safePosition = Vector3.new(-30.72, 4.50, -62.95)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Slider = MainTab:Slider({
    Title = "Speed Modifier",
    Desc = "Change walkspeed",
    Step = 1,
    Value = {
        Min = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed - 3,
        Max = 80,
        Default = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed,
    },
    Callback = function(value)
        speedToSet = value
    end
})
local Button = MainTab:Button({
    Title = "Set Speed",
    Desc = "Apply above changes",
    Locked = false,
    Callback = function()
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = speedToSet
    end
})
MainTab:Divider()
local Slider = MainTab:Slider({
    Title = "Spinbot Modifier",
    Desc = "Change spinbot speed",
    Step = 1,
    Value = {
        Min = 5,
        Max = 120,
        Default = spinbotSpeed,
    },
    Callback = function(value)
        spinbotSpeed = value
    end
})
local Toggle = MainTab:Toggle({
    Title = "Toggle On/Off",
    Desc = "Enable/Disable spinbot",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        spinbotEnabled = state
    end
})

local Toggle = CombatTab:Toggle({
    Title = "Bodylock",
    Desc = "Lock body facing closest player",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        bodyLockEnabled = state
    end
})
local Toggle = CombatTab:Toggle({
    Title = "Safety Teleport",
    Desc = "Teleport to safety at low health",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        autoSafeTpEnabled = state
    end
})



local function getClosestPlayer()
	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local closestPlayer
	local closestDist = math.huge

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local char = plr.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChild("Humanoid")
			if root and hum and hum.Health > 0 then
				local dist = (root.Position - hrp.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestPlayer = root
				end
			end
		end
	end

	return closestPlayer
end

RunService.Heartbeat:Connect(function()
	if not autoSafeTpEnabled then return end

	local character = player.Character
	local humanoid = character and character:FindFirstChild("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then return end

	if humanoid.Health > 0 and humanoid.Health < 50 then
		hrp.CFrame = CFrame.new(safePosition)
        task.wait(4)
	end
end)

RunService.Heartbeat:Connect(function()
	local character = player.Character
	local humanoid = character and character:FindFirstChild("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then return end

	if not bodyLockEnabled then
		humanoid.AutoRotate = true
		return
	end

	humanoid.AutoRotate = false

	local targetRoot = getClosestPlayer()
	if not targetRoot then return end

	local lookPos = Vector3.new(
		targetRoot.Position.X,
		hrp.Position.Y,
		targetRoot.Position.Z
	)

	hrp.CFrame = CFrame.new(hrp.Position, lookPos)
end)

RunService.Heartbeat:Connect(function(dt)
	if not spinbotEnabled then return end

	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.CFrame = hrp.CFrame * CFrame.Angles(
		0,
		math.rad(spinbotSpeed * 360) * dt,
		0
	)
end)
