local Exploit = identifyexecutor()
local Player = game:GetService("Players").LocalPlayer

if Exploit == "Xeno" and game.GameId ~= 9908641400 then
    Player:Kick("Nova | Unsupported Executor")
elseif Exploit == "Xeno" and game.GameId == 9908641400 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/e8a512ea02aa7f12332fd74066499f05.lua"))() -- ff3 xeno
end
if Exploit == "Solara" and game.GameId ~= 9908641400 then
    Player:Kick("Nova | Unsupported Executor")
elseif Exploit == "Solara" and game.GameId == 9908641400 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/e8a512ea02aa7f12332fd74066499f05.lua"))() -- ff3 xeno
end
warn("tysm for using the script! - nova")

if game.GameId == 9908641400 then
    if getconnections then
        for _, v in next, getconnections(game:GetService("ScriptContext").Error) do
            if v.Function then
                v:Disable()
            end
        end
    end

    if hookfunction then
        local Old; Old = hookfunction(game:GetService("LogService").GetLogHistory, function(...)
            local Results = Old(...)
            if #Results > 3 then
                for i = #Results, 4, -1 do
                    if type(Results[i]) == "table" and Results[i].messageType == Enum.MessageType.MessageError then
                        table.remove(Results, i)
                    end
                end
            end
            return Results
        end)

        local function findUpvalue(func, value)
            for _, upval in debug.getupvalues(func) do
                if upval == value then
                    return true
                end
            end
            return false
        end

        local heartbeat = game:GetService("RunService").Heartbeat
        local dummy = Instance.new("BindableEvent")

        for _, func in getgc() do
            if typeof(func) == "function" and islclosure(func) then
                if findUpvalue(func, heartbeat) then
                    for i, v in getupvalues(func) do
                        if v == heartbeat then
                            setupvalue(func, i, dummy.Event)
                        elseif v == heartbeat.Connect then
                            setupvalue(func, i, dummy.Event.Wait)
                        end
                    end
                end
            end
        end
    end
end
-- special games + defauly
local gameid = game.GameId

if gameid == 9908641400 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/ad427b543b86b73fbc2a007ece7b358d.lua"))() -- ff3
elseif gameid == 184199275 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/ceb81d950c4857a7a1a04b8c84d80dd9.lua"))() -- uf
elseif gameid == 6505338302 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c0b57bb9a7378ad6dc21e2f43587a18f.lua"))() -- fbl
else
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/2259faaddfcaa0d5acb74e84b2cd96b5.lua"))() -- defaulr
end
