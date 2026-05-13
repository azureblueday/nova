if game.GameId == 9908641400 then
    if getconnections then
        for i,v in next, getconnections(game:GetService("ScriptContext").Error) do
            if v.Function then
                v:Disable()
            end
        end
    end

    if hookfunction then
        local Old; Old = hookfunction(game:GetService("LogService").GetLogHistory, function(...)
            local Results = Old(...);

            if #Results > 3 then
                for i = 4, #Results do
                    if type(Results[i]) == "table" and Results[i].messageType == Enum.MessageType.MessageError then
                        table.remove(Results, i);
                    end
                end
            end

            return Results
        end)
    end
end

if (identifyexecutor() == "Xeno" or identifyexecutor() == "Solara") and game.GameId ~= 9908641400 then
    game:GetService("Players").LocalPlayer:Kick('Nova | Unsupported Executor!')
    return
end

if not script_key then
    game:GetService("Players").LocalPlayer:Kick("Nova | Please make sure you include the script_key part ABOVE the loadstring, otherwise Luarmor will not be able to recognize that you bought.")
    return
end

if game.GameId == 9908641400 then
    if identifyexecutor() ~= "Xeno" and identifyexecutor() ~= "Solara" then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ad427b543b86b73fbc2a007ece7b358d.lua"))()
    else
        game:GetService("Players").LocalPlayer:Kick("dont use shitty 30% sUNC executors and expect it to work")
    end
elseif game.GameId == 6505338302 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/c0b57bb9a7378ad6dc21e2f43587a18f.lua"))() -- Football Legends
elseif game.GameId == 184199275 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ceb81d950c4857a7a1a04b8c84d80dd9.lua"))() -- Universe Football
else
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2259faaddfcaa0d5acb74e84b2cd96b5.lua"))() -- Main
end
