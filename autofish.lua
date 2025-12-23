local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "dropped da rice",
   Icon = 0,
   LoadingTitle = "shiit there go the riice",
   LoadingSubtitle = "loadingz!!!",
   ShowText = "DDR",
   Theme = "Serenity",
   ToggleUIKeybind = Enum.KeyCode.RightShift,
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
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

local autoFishMode = false

local Tab = Window:CreateTab("Fishing", 4483362458)

Tab:CreateToggle({
   Name = "Auto Fish",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      autoFishMode = Value
   end,
})

local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local wasInside = false

local function centerInside(mover, frame)
    local mPos, mSize = mover.AbsolutePosition, mover.AbsoluteSize
    local fPos, fSize = frame.AbsolutePosition, frame.AbsoluteSize

    local centerX = mPos.X + (mSize.X / 2)
    local centerY = mPos.Y + (mSize.Y / 2)

    return (
        centerX >= fPos.X and
        centerX <= fPos.X + fSize.X and
        centerY >= fPos.Y and
        centerY <= fPos.Y + fSize.Y
    )
end

RunService.RenderStepped:Connect(function()
    if not autoFishMode then
        wasInside = false
        return
    end

    local gui = player.PlayerGui:FindFirstChild("GameScreenGui")
    if not gui then return end

    local barTemplate = gui:FindFirstChild("MovingBarTemplate")
    if not barTemplate then return end

    local bar = barTemplate:FindFirstChild("Bar")
    if not bar then return end

    local mover = bar:FindFirstChild("Mover")
    local frame = bar:FindFirstChild("Frame")
    if not mover or not frame then return end

    local inside = centerInside(mover, frame)

    if inside and not wasInside then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end

    wasInside = inside
end)
