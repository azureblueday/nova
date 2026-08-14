local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local exec = identifyexecutor()

if not script_key then
    plr:Kick("Nova | Unable to identify key!")
    return
end

local ff3 = 9908641400
local blocked = { Xeno = true, Solara = true }

if blocked[exec] then
    plr:Kick("Nova | Unsupported Executor!")
    return
end

if game.GameId == ff3 and exec == "Wave" then
    plr:Kick("Nova | Do not use Wave for Football Fusion 3!")
    return
end

local parts = {
    "https://api.luarmor.net/files/v4/loaders/8938336a5aef6cdf06ed7dfd068784ae.lua",
    "https://api.luarmor.net/files/v4/loaders/b6b4e42749af632626b277a84cb654d4.lua",
    "https://api.luarmor.net/files/v4/loaders/00490db0c431b26c7adc113326ac4ba4.lua",
    "https://api.luarmor.net/files/v4/loaders/1e07548cebd70c4c9936c70812b2361e.lua",
}

local function load(url)
    loadstring(game:HttpGet(url))()
end

local games = {
    [ff3] = function()
        load("https://api.luarmor.net/files/v4/loaders/0530b1fddfc5c9d6e64dec3820802840.lua")
    end,
    [6505338302] = function() -- fbl
        load("https://api.luarmor.net/files/v4/loaders/528ed318de01e4d36977743ad3c78d8e.lua")
    end,
    [184199275] = function() -- uf
        load("https://api.luarmor.net/files/v4/loaders/36df1bb6c0fd5035f9206e229c76f010.lua")
    end,
    [5113572498] = function() -- cfb
        load("https://api.luarmor.net/files/v4/loaders/a4ec574c31e02d5bc051c5f4b879ec9b.lua")
    end,
    [3032132418] = function() -- hcbb
        plr:Kick("Nova | HCBB is Offline!")
    end,
    [73885730] = function() -- prison life
        load("https://api.luarmor.net/files/v4/loaders/f1e884f9203bf01df7741218b2973238.lua")
    end,
    [7633926880] = function() -- bloxstrike
        load("https://api.luarmor.net/files/v4/loaders/ae8ea6dbf229231a3b4ddc503cdd3052.lua")
    end,
}

local partOf = {
    [1160789089] = 1, -- flag wars
    [111958650] = 1, -- arsenal
    [4931927012] = 1, -- basketball legends
    [9893475671] = 1, -- ot7 football
    [8795154789] = 1,

    [5113572498] = 2, -- flag football
    [7326934954] = 2, -- 99 nights
    [7128251171] = 2, -- superstar baseball
    [6331902150] = 2, -- forsaken
    [6931042565] = 2, -- volleyball legends
    [7884563721] = 2, -- arcade
    [6260656796] = 2, -- playground basketball
    [6061766680] = 2, -- fight in a school

    [2251388500] = 3, -- twisted
    [1008451066] = 3, -- da hood
    [6035872082] = 3, -- rivals
    [4864117649] = 3, -- untitled tag game
    [8558141897] = 3, -- flag fb
    [2583564222] = 3, -- boxing beta
    [533435040] = 3, -- flicker
    [66654135] = 3, -- murder mystery 2
    [3647333358] = 3, -- evade
    [372226183] = 3, -- flee the facility

    [5674379281] = 4, -- the bronx 3
    [5012222382] = 4, -- gun fight arena
    [1281592938] = 4, -- entrenched ww1
    [7931158824] = 4, -- pure soccer
    [7264587281] = 4, -- sniper duels
    [8307114974] = 4, -- operation one
    [6739698191] = 4, -- violence district
    [9199655655] = 4, -- gakuran
    [4348829796] = 4, -- murderers vs sheriffs duels
    [2287245386] = 4, -- hoopz
}

local run = games[game.GameId]
if run then
    run()
else
    load(parts[partOf[game.GameId] or 1])
end
