
if (identifyexecutor() == "Xeno" or identifyexecutor() == "Solara") and game.GameId ~= 9908641400 then
    game:GetService("Players").LocalPlayer:Kick('Nova | Unsupported Executor!')
    return
end
if not script_key then
    game:GetService("Players").LocalPlayer:Kick("Nova | Please make sure you include the script_key part ABOVE the loadstring, otherwise Luarmor will not be able to recognize that you bought.")
    return
end
if game.GameId == 9908641400 then
    if identifyexecutor() ~= "Xeno" and identifyexecutor() ~= "Solara" and identifyexecutor() ~= "Seliware" and identifyexecutor() ~= "Volt" and identifyexecutor() ~= "Wave" then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ad427b543b86b73fbc2a007ece7b358d.lua"))() -- Football Fusion 3
    else
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ebf35a3f64beaa6be88055993bb074fc.lua"))() -- Football Fusion 3 (B-Side Script)
    end
elseif game.GameId == 6505338302 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/c0b57bb9a7378ad6dc21e2f43587a18f.lua"))() -- Football Legends
elseif game.GameId == 184199275 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ceb81d950c4857a7a1a04b8c84d80dd9.lua"))() -- Universe Football
elseif game.GameId == 5113572498 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/73482993c40862f621e0df5249a6260c.lua"))() -- College Football
elseif game.GameId == 3032132418 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/23fc12cda6515f241e7a3c0f863a2bb4.lua"))() -- HCBB
else
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2259faaddfcaa0d5acb74e84b2cd96b5.lua"))() -- Main
end
