if (identifyexecutor() == "Xeno" or identifyexecutor() == "Solara") and game.GameId ~= 9908641400 then
    game:GetService("Players").LocalPlayer:Kick('Nova | Unsupported Executor!')
    return
end
if not script_key then
    game:GetService("Players").LocalPlayer:Kick("Nova | Please make sure you include the script_key part ABOVE the loadstring, otherwise Luarmor will not be able to recognize that you bought.")
    return
end

if game.GameId == 9908641400 then -- ff3
  loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/a906b9de9de16fae6b347dd7868b8f0d.lua"))()
end
