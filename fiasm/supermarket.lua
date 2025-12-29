local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "RiceHub",
    Author = "Fight in a Supermarket",
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
local AutofarmTab = Window:Tab({
    Title = "Autofarm",
    Icon = "wallet",
    Locked = false,
})
MainTab:Select()

WindUI:Popup({
    Title = "RiceHub",
    Icon = "info",
    Content = "Do not move while autofarm is enabled",
    Buttons = {
        {
            Title = "Continue",
            Icon = "arrow-right",
            Callback = function() end,
            Variant = "Primary",
        }
    }
})

local moneyFarmEnabled = false
local moneyFarmWalkEnabled = false
local moneyFarmDelay = 1
local reachDistance = 120
local atmFarmEnabled = false
local clickDelay = 0.05
local killAuraEnabled = false
local killAuraRange = 15
local attackDelay = 0.1
local speedEnabled = false
local speedMultiplier = 1.5

local VirtualUser = game:GetService("VirtualUser")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

local Toggle = AutofarmTab:Toggle({
    Title = "Money farm TP",
    Desc = "Teleport around to pick up cash",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        moneyFarmEnabled = state
    end
})
local Toggle = AutofarmTab:Toggle({
    Title = "Money farm WLK",
    Desc = "Walk around to pick up cash",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        moneyFarmWalkEnabled = state
    end
})
local Toggle = AutofarmTab:Toggle({
    Title = "ATM farm WLK",
    Desc = "Walk around to break machines",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        atmFarmEnabled = state
    end
})

local Slider = MainTab:Slider({
    Title = "Speed Modifier",
    Desc = "Enter desired walkspeed",
    Step = .1,
    Value = {
        Min = 1.0,
        Max = 1.8,
        Default = 1.0,
    },
    Callback = function(value)
        speedMultiplier = value
    end
})
local Toggle = MainTab:Toggle({
    Title = "Set Speed",
    Desc = "Change your walkspeed",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        speedEnabled = state
    end
})
MainTab:Divider()
local Slider = MainTab:Slider({
    Title = "KillAura Range",
    Desc = "(in studs)",
    Step = 1,
    Value = {
        Min = 5,
        Max = 30,
        Default = killAuraRange,
    },
    Callback = function(value)
        killAuraRange = value
    end
})
local Toggle = MainTab:Toggle({
    Title = "KillAura",
    Desc = "Automatically lock and hit at players near",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        killAuraEnabled = state
    end
})



local lastTp = 0
local cashIndex = 1
task.spawn(function()
	while true do
		if not moneyFarmEnabled then
			cashIndex = 1
			task.wait(0.1)
			continue
		end

		local character = localPlayer.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if not hrp then
			task.wait(0.1)
			continue
		end

		local spawnedCash = workspace:FindFirstChild("SpawnedCash")
		if not spawnedCash then
			task.wait(0.1)
			continue
		end

		local cashChildren = spawnedCash:GetChildren()
		if #cashChildren == 0 then
			cashIndex = 1
			task.wait(0.1)
			continue
		end

		if tick() - lastTp < moneyFarmDelay then
			task.wait(0.05)
			continue
		end
		lastTp = tick()

		if cashIndex > #cashChildren then
			cashIndex = 1
		end

		local cash = cashChildren[cashIndex]
		cashIndex += 1

		if cash and cash.Name == "Money" then
			local hitbox = cash:FindFirstChild("MoneyHitbox")
			if hitbox then
				hrp.CFrame = hitbox.CFrame + Vector3.new(0, 2, 0)
			end
		end

		task.wait(0.05)
	end
end)
task.spawn(function()
	while true do
		if not moneyFarmWalkEnabled then
			task.wait(0.2)
			continue
		end

		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChild("Humanoid")
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp then
			task.wait(0.2)
			continue
		end

		local spawnedCash = workspace:FindFirstChild("SpawnedCash")
		if not spawnedCash then
			task.wait(0.2)
			continue
		end

		local moneyTargets = {}
		for _, obj in ipairs(spawnedCash:GetChildren()) do
			if obj.Name == "Money" then
				local hitbox = obj:FindFirstChild("MoneyHitbox")
				if hitbox then
					table.insert(moneyTargets, hitbox)
				end
			end
		end

		if #moneyTargets == 0 then
			task.wait(0.2)
			continue
		end

		table.sort(moneyTargets, function(a, b)
			return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
		end)

		local target = moneyTargets[1]
		if not target or not target.Parent then
			task.wait(0.1)
			continue
		end

		local path = PathfindingService:CreatePath({
			AgentRadius = 2,
			AgentHeight = 5,
			AgentCanJump = true,
		})

		path:ComputeAsync(hrp.Position, target.Position)

		if path.Status ~= Enum.PathStatus.Success then
			task.wait(0.1)
			continue
		end

		local waypoints = path:GetWaypoints()

		for _, waypoint in ipairs(waypoints) do
			if not moneyFarmWalkEnabled then break end
			if not target.Parent then break end

			if humanoid.MoveDirection.Magnitude > 0 then
				break
			end

			if waypoint.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end

			humanoid:MoveTo(waypoint.Position)

			local reached = humanoid.MoveToFinished:Wait(2)
			if not reached then
				break
			end
		end

		task.wait(0.1)
	end
end)
task.spawn(function()
	while true do
		if not atmFarmEnabled then
			task.wait(0.2)
			continue
		end

		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChild("Humanoid")
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp then
			task.wait(0.2)
			continue
		end

		local spawners = workspace:FindFirstChild("Spawners")
		if not spawners then
			task.wait(0.2)
			continue
		end

		local targets = {}

		for _, spawn in ipairs(spawners:GetChildren()) do
			if spawn.Name == "HittableSpawn" then
				local hittable = spawn:FindFirstChild("Hittable")
				if hittable then
					table.insert(targets, {
						spawn = spawn,
						hittable = hittable
					})
				end
			end
		end

		if #targets == 0 then
			task.wait(0.3)
			continue
		end

		table.sort(targets, function(a, b)
			return (a.spawn.Position - hrp.Position).Magnitude <
			       (b.spawn.Position - hrp.Position).Magnitude
		end)

		local targetData = targets[1]
		local spawn = targetData.spawn
		local hittable = targetData.hittable

		if not spawn or not spawn.Parent or not hittable or not hittable.Parent then
			task.wait(0.1)
			continue
		end

		local path = PathfindingService:CreatePath({
			AgentRadius = 2,
			AgentHeight = 5,
			AgentCanJump = true
		})

		path:ComputeAsync(hrp.Position, spawn.Position)

		if path.Status ~= Enum.PathStatus.Success then
			task.wait(0.2)
			continue
		end

		for _, waypoint in ipairs(path:GetWaypoints()) do
			if not atmFarmEnabled then break end
			if not hittable.Parent then break end

			if humanoid.MoveDirection.Magnitude > 0 then
				break
			end

			if waypoint.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end

			humanoid:MoveTo(waypoint.Position)
			local reached = humanoid.MoveToFinished:Wait(2)
			if not reached then break end
		end

		while atmFarmEnabled and hittable.Parent do
			local lookPos = Vector3.new(
				spawn.Position.X,
				hrp.Position.Y,
				spawn.Position.Z
			)

			hrp.CFrame = CFrame.new(hrp.Position, lookPos)

			VirtualUser:Button1Down(Vector2.new(0, 0))
			VirtualUser:Button1Up(Vector2.new(0, 0))

			task.wait(clickDelay)
		end

		task.wait(0.1)
	end
end)
local lastAttack = 0
task.spawn(function()
	while true do
		if not killAuraEnabled then
			task.wait(0.1)
			continue
		end

		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChild("Humanoid")
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp or humanoid.Health <= 0 then
			task.wait(0.1)
			continue
		end

		local closestTarget
		local closestDist = killAuraRange

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= localPlayer then
				local char = plr.Character
				local hum = char and char:FindFirstChild("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")

				if hum and root and hum.Health > 0 then
					local dist = (root.Position - hrp.Position).Magnitude
					if dist <= closestDist then
						closestDist = dist
						closestTarget = root
					end
				end
			end
		end

		if closestTarget then
			local lookPos = Vector3.new(
				closestTarget.Position.X,
				hrp.Position.Y,
				closestTarget.Position.Z
			)
			hrp.CFrame = CFrame.new(hrp.Position, lookPos)

			if tick() - lastAttack >= attackDelay then
				lastAttack = tick()
				VirtualUser:Button1Down(Vector2.new(0, 0))
				VirtualUser:Button1Up(Vector2.new(0, 0))
			end
		end

		task.wait(0.05)
	end
end)
RunService.Stepped:Connect(function(_, dt)
	if not speedEnabled then return end

	local char = localPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	local moveDir = hum.MoveDirection
	if moveDir.Magnitude > 0 then
		hrp.CFrame = hrp.CFrame + (moveDir * speedMultiplier * dt * 16)
	end
end)
