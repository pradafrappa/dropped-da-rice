local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Rice Hub 🍚",
   Icon = 0,
   LoadingTitle = "RiceHub - Loading...",
   LoadingSubtitle = "🎉 @" .. game.Players.LocalPlayer.Name,
   ShowText = "RiceHub",
   Theme = "DarkBlue",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "RiceHub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true 
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})
local MainTab = Window:CreateTab("Main", "pointer")
local PlayerTab = Window:CreateTab("Player", "user")
local CombatTab = Window:CreateTab("Combat", "crosshair")
local TeleportsTab = Window:CreateTab("Teleports", "map-pin")

local RunService = game:GetService("RunService")
local UserSettings = UserSettings()
local GameSettings = UserSettings:GetService("UserGameSettings")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local PlayerSpeed = false
local PlayerFov = false
local PlayerCurrentFov = game.Workspace.CurrentCamera.FieldOfView
local PlayerCurrentSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
local resolutionName = "1920x1080"
local InfStamina = false

local StretchResolutions = {
    ["1080x1080"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.35, 0, 0, 0, 1), 
    ["1920x1080"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.65, 0, 0, 0, 1), 
    ["2560x1440"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8895, 0, 0, 0, 1)
}

local function goTo(location)
	local player = game.Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	hrp.CFrame = CFrame.new(location)
end


local Toggle = MainTab:CreateToggle({
   Name = "Walkspeed",
   CurrentValue = PlayerSpeed,
   Flag = "walkspeedtoggle",
   Callback = function(Value)
    PlayerSpeed = Value
   end,
})
local Slider = MainTab:CreateSlider({
   Name = "Speed",
   Range = {8, 40},
   Increment = 1,
   Suffix = "%",
   CurrentValue = PlayerCurrentSpeed,
   Flag = "speedslider",
   Callback = function(Value)
    PlayerCurrentSpeed = Value
   end,
})
local Divider = MainTab:CreateDivider()
local Toggle = MainTab:CreateToggle({
   Name = "Player FOV",
   CurrentValue = PlayerSpeed,
   Flag = "fovtoggle",
   Callback = function(Value)
    PlayerFov = Value
   end,
})
local Slider = MainTab:CreateSlider({
   Name = "FOV",
   Range = {1, 120},
   Increment = 1,
   Suffix = "%",
   CurrentValue = PlayerCurrentFov,
   Flag = "fovslider",
   Callback = function(Value)
    PlayerCurrentFov = Value
   end,
})
local Dropdown = MainTab:CreateDropdown({
   Name = "Stretch Resolution",
   Options = {"1080x1080","1920x1080","2560x1440"},
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "stretchresdropdown",
   Callback = function(Options)
    local resolution = StretchResolutions[Options[1]]
    game:GetService("RunService").RenderStepped:Connect(function()
        Camera.CFrame = Camera.CFrame * resolution
    end)
   end,
})
local Section = MainTab:CreateSection("Must rejoin to reset strech-res")
local Divider = MainTab:CreateDivider()
local Section = MainTab:CreateSection("GUI Options")
local Button = MainTab:CreateButton({
   Name = "Show ATM UI",
   Callback = function()
    game.Players.LocalPlayer.PlayerGui.ATM.Holder.Visible = true
   end,
})
local Button = MainTab:CreateButton({
   Name = "Show Chains UI",
   Callback = function()
    game.Players.LocalPlayer.PlayerGui.ChainsUI.Middle.Holder.Visible = true
   end,
})
local Button = MainTab:CreateButton({
   Name = "Show Safe UI",
   Callback = function()
    game.Players.LocalPlayer.PlayerGui.Safe.Frame.Visible = true
   end,
})

local Toggle = PlayerTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = InfStamina,
   Flag = "infstaminatoggle",
   Callback = function(Value)
    InfStamina = Value
   end,
})
local Divider = PlayerTab:CreateDivider()
local Button = PlayerTab:CreateButton({
   Name = "Remove Jump Cooldown",
   Callback = function()
    game.Players.LocalPlayer.PlayerGui.JumpCooldown:Destroy()
    Rayfield:Notify({
        Title = "Rice Hub",
        Content = "Removed jump cooldown",
        Duration = 3,
        Image = 0,
    })
   end,
})
local Button = PlayerTab:CreateButton({
   Name = "Remove Camera Sway",
   Callback = function()
    game.Players.LocalPlayer.PlayerGui.CameraSway:Destroy()
    Rayfield:Notify({
        Title = "Rice Hub",
        Content = "Removed camera sway",
        Duration = 3,
        Image = 0,
    })
   end,
})

local Button = TeleportsTab:CreateButton({
   Name = "Gun Store #1",
   Callback = function()
    goTo(Vector3.new(-2520.58, -15.07, 273.73))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Gun Store #2",
   Callback = function()
    goTo(Vector3.new(-1709.97, -14.81, 378.43))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Ice Blox",
   Callback = function()
    goTo(Vector3.new(-1981.75, -287.45, 444.28))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Royal Clothing",
   Callback = function()
    goTo(Vector3.new(-2087.10, -14.31, 386.36))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Masks",
   Callback = function()
    goTo(Vector3.new(-2334.02, -14.72, 475.40))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Robbery Houses",
   Callback = function()
    goTo(Vector3.new(-2318.16, -12.99, 544.35))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Dunna Wear",
   Callback = function()
    goTo(Vector3.new(-2499.13, -14.83, 401.73))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Sams Store",
   Callback = function()
    goTo(Vector3.new(-2496.96, -14.83, 427.50))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Urban Star",
   Callback = function()
    goTo(Vector3.new(-3027.93, -13.78, 341.72))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "John Cuts",
   Callback = function()
    goTo(Vector3.new(-3021.70, -14.43, 374.24))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Chocolate Job",
   Callback = function()
    goTo(Vector3.new(-3019.86, -15.11, 495.21))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Bakery Job",
   Callback = function()
    goTo(Vector3.new(-3023.67, -13.94, 115.38))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Studio",
   Callback = function()
    goTo(Vector3.new(-2779.64, -14.50, -349.08))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Dealership",
   Callback = function()
    goTo(Vector3.new(-2415.68, -343.36, -97.06))
   end,
})
local Button = TeleportsTab:CreateButton({
   Name = "Bank",
   Callback = function()
    goTo(Vector3.new(-2913.78, -14.91, 288.75))
   end,
})



task.spawn(function()
	while true do
		RunService.Heartbeat:Wait()

		if PlayerSpeed then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = PlayerCurrentSpeed
		end
        if PlayerFov then
            game.Workspace.CurrentCamera.FieldOfView = PlayerCurrentFov
        end
        if InfStamina then
            game:GetService("Players").LocalPlayer.Valuestats.Stamina.Value = 1
        end
	end
end)
