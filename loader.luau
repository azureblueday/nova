if (identifyexecutor() == "Xeno" or identifyexecutor() == "Solara") and game.GameId ~= 9908641400 then
    game:GetService("Players").LocalPlayer:Kick('Nova | Unsupported Executor!')
    return
end
if not script_key then
    game:GetService("Players").LocalPlayer:Kick("Nova | Please make sure you include the script_key part ABOVE the loadstring, otherwise Luarmor will not be able to recognize that you bought.")
    return
end

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

if game.GameId == 9908641400 then -- ff3
  loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/4c36b60cae5eb0e09500192338bd6ec3.lua"))()
end
