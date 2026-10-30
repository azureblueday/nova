local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local genv = (getgenv and getgenv()) or _G
if genv.NovaLoaded then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Nova",
            Text = "Already loaded. Press your menu key to open it.",
            Duration = 5,
        })
    end)
    return
end
genv.NovaLoaded = true

local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Nova", Text = text, Duration = 8 })
    end)
end

local function stop(reason)
    genv.NovaLoaded = nil
    notify(reason)
    plr:Kick("Nova | " .. reason)
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local exec = type(identifyexecutor) == "function" and select(1, identifyexecutor()) or nil

local blocked = { Xeno = true, Solara = true }
if exec and blocked[exec] then
    stop("Unsupported executor: " .. exec)
    return
end

if exec == "Wave" and game.GameId == 9908641400 then
    stop("Do not use Wave for FF3")
    return
end

-- Per-script identifiers from the Luaprot dashboard (Script settings).
local loaders = {
    [9908641400] = "89048271267758538540",
    [6505338302] = "57169447094118387962",
    [184199275]  = "55093479707859976447",
    [5113572498] = "17133985253246002057",
    [73885730]   = "95176784829569159990",
    [7633926880] = "84059311235232050610",
    [3032132418] = "05146109569431460352",
    [6035872082] = "58472705167128262935",
    [5595353122] = "11890381396920401119",
    [7326934954] = "59038223352436917912",
    [7884563721] = "64401754467196387871",
    [111958650]  = "54732693064156474966",
    [4931927012] = "00018918314620731535",
    [1281592938] = "39951436050373842551",
    [3647333358] = "33727261307634141103",
    [8558141897] = "89670125580692075936",
    [1160789089] = "38667871809371224066",
    [8795154789] = "04353207396204900259",
    [6331902150] = "70828060946652882384",
    [9199655655] = "36970982730650324135",
    [5012222382] = "56256348050371011455",
    [2287245386] = "11546571706167591028",
    [10155360168] = "40754115565878658027",
    [66654135]   = "22461448066746468650",
    [8307114974] = "19800711613904870168",
    [9893475671] = "56162697190658584195",
    [6858584271] = "11642727740419402797",
    [7128251171] = "70908709128150230095",
    [5674379281] = "78195646218178162698",
    [10737656087] = "78195646218178162698",
    [2251388500] = "51062804516489960874",
    [9112256336] = "88600230119671825219",
    [6739698191] = "63021192150429225109",
    [6931042565] = "14964990094438521849",
    [10124403207] = "09358189646316459970",
    [9753494457] = "11437576592499409623",
}

local scriptId = loaders[game.GameId] or "35286829668613166203"

-- Some executors (Delta on Android) fail the TLS handshake in game:HttpGet on hosts their own
-- request() reaches fine, so every fetch here tries both.
local function fetchText(url)
    local ok, body = pcall(game.HttpGet, game, url)
    if ok and type(body) == "string" then
        return body
    end
    local send = (syn and syn.request) or (http and http.request) or http_request or request
    if type(send) == "function" then
        local sent, response = pcall(send, { Url = url, Method = "GET" })
        if sent and type(response) == "table" and response.StatusCode == 200 and type(response.Body) == "string" then
            return response.Body
        end
    end
    error(string.format("could not reach %s (%s)", string.match(url, "^https?://([^/]+)") or url, tostring(body)), 0)
end

local function run()
    local sdk = loadstring(fetchText("https://sdk.luaprot.net/"))()
    sdk.scriptId = scriptId
    sdk:loadScript()
end

local ok, problem = pcall(run)

if not ok then
    stop("Script failed to start: " .. tostring(problem))
end
