local Exploit = identifyexecutor()
local Player = game:GetService("Players").LocalPlayer

local poop = { "Solara", "Xeno" }

if table.find(poop, Exploit) then
    return Player:Kick("Nova | Executor is not supported by Nova.")
end

warn("thank you so much for using the script! - nova (@xm5l)")

-- special games + defauly
local gameid = game.GameId

if gameid == 9908641400 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/ad427b543b86b73fbc2a007ece7b358d.lua"))() -- ff3
elseif gameid == 184199275 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c0b57bb9a7378ad6dc21e2f43587a18f.lua"))() -- football legends
elseif gameid == 6505338302 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/ceb81d950c4857a7a1a04b8c84d80dd9.lua"))() -- uf
else
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/2259faaddfcaa0d5acb74e84b2cd96b5.lua"))() -- defaulr
end
