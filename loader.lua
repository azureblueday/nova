local GameID = game.GameId
local Exploit = identifyexecutor()
local Player = game:GetService("Players").LocalPlayer

local poop = { "Solara", "Xeno" }

if table.find(poop, Exploit) then
    return Player:Kick("Nova | Executor is not supported by Nova.")
end

if game.GameId == 8558141897 then -- flag
    Player:Kick("Nova | Flag Football is temporarily disabled due to technical errors.")
end

if game.GameId ~= 8558141897 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/2259faaddfcaa0d5acb74e84b2cd96b5.lua"))()
end
