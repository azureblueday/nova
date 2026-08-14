local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local exec = identifyexecutor()

local ff3 = 9908641400
local blocked = { Xeno = true, Solara = true }

if blocked[exec] and game.GameId ~= ff3 then
    plr:Kick("Nova | Unsupported Executor!")
    return
end

local games = {
    [ff3] = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/0530b1fddfc5c9d6e64dec3820802840.lua"))()
    end,
    [6505338302] = function() -- fbl
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/528ed318de01e4d36977743ad3c78d8e.lua"))()
    end,
    [184199275] = function() -- uf
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/36df1bb6c0fd5035f9206e229c76f010.lua"))()
    end,
    [5113572498] = function() -- cfb
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/a4ec574c31e02d5bc051c5f4b879ec9b.lua"))()
    end,
    [3032132418] = function() -- hcbb
        plr:Kick("Nova | HCBB is Offline!")
    end,
}

local run = games[game.GameId]
if run then
    run()
else -- main
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/0530b1fddfc5c9d6e64dec3820802840.lua"))()
end
