local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local exec = identifyexecutor()

script_key = key

local ff3 = 9908641400
local blocked = { Xeno = true, Solara = true }
local ff3Alt = { Xeno = true, Solara = true, Seliware = true, Velocity = true }

if blocked[exec] and game.GameId ~= ff3 then
    plr:Kick("Nova | Unsupported Executor!")
    return
end

local games = {
    [ff3] = function()
        local url = ff3Alt[exec]
            and "https://cdn.snc.dev/699a6a716315fba25b2e51cc/c5jhvhjlafq"
            or "https://cdn.snc.dev/699a6a716315fba25b2e51cc/2nhqc7kru9k"
        loadstring(game:HttpGet(url))()
    end,
    [6505338302] = function()
        loadstring(game:HttpGet("https://cdn.snc.dev/699a6a716315fba25b2e51cc/t9cm7klxb2"))()
    end,
    [184199275] = function()
        loadstring(game:HttpGet("https://cdn.snc.dev/699a6a716315fba25b2e51cc/g0mie4ouq4"))()
    end,
    [5113572498] = function()
        loadstring(game:HttpGet("https://cdn.snc.dev/699a6a716315fba25b2e51cc/je1pjrb4mhg"))()
    end,
    [3032132418] = function()
        plr:Kick("Nova | HCBB is Offline!")
    end,
}

local run = games[game.GameId]
if run then
    run()
else
    loadstring(game:HttpGet("https://cdn.snc.dev/699a6a716315fba25b2e51cc/fay21lfcd2n"))()
end
