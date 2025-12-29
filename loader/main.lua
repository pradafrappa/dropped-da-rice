if game.PlaceId == 18450282790 then -- STEAL TIME SIMULATOR
  loadstring(game:HttpGet("https://raw.githubusercontent.com/pradafrappa/dropped-da-rice/refs/heads/main/steal_time_sim/index.lua"))()
elseif game.PlaceId == 17306807164 then -- NO MERCY
  loadstring(game:HttpGet("https://raw.githubusercontent.com/pradafrappa/dropped-da-rice/refs/heads/main/no_mercy/ricehub.lua"))()
elseif game.PlaceId == 73703959264496 then -- FIGHT IN A SUPERMARKET
  loadstring(game:HttpGet("https://raw.githubusercontent.com/pradafrappa/dropped-da-rice/refs/heads/main/fiasm/supermarket.lua"))()
else
  game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = "Rice Hub",
      Text = "Game not supported",
      Duration = 5
  })
end
