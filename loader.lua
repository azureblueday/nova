local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local genv = (getgenv and getgenv()) or _G
if genv.__nova_loader_active then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Nova",
            Text = "Already loaded. Press your menu key to open it.",
            Duration = 5,
        })
    end)
    return
end
genv.__nova_loader_active = true

local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Nova", Text = text, Duration = 8 })
    end)
end

local function stop(reason)
    genv.__nova_loader_active = nil
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

if game.GameId == 3032132418 then
    stop("HCBB is offline")
    return
end

local loaders = {
    [9908641400] = "0530b1fddfc5c9d6e64dec3820802840",
    [6505338302] = "528ed318de01e4d36977743ad3c78d8e",
    [184199275]  = "36df1bb6c0fd5035f9206e229c76f010",
    [5113572498] = "a4ec574c31e02d5bc051c5f4b879ec9b",
    [73885730]   = "f1e884f9203bf01df7741218b2973238",
    [7633926880] = "ae8ea6dbf229231a3b4ddc503cdd3052",
}

local scriptId = loaders[game.GameId] or "53e855696b112994c13a029e3f511876"
local function run()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. scriptId .. ".lua"))()
end

local function fetchUi()
    for attempt = 1, 2 do
        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/azureblueday/nova/main/nova-ui.lua"))()
        end)
        if ok and type(result) == "table" and type(result.KeySystem) == "function" then
            return result
        end
        if attempt == 1 then
            task.wait(1.5)
        end
    end
    return nil
end

local ui = fetchUi()
local release

if ui then
    local status, _, hold = ui:KeySystem({ Title = "Nova", Preload = true })
    if not status then
        genv.__nova_loader_active = nil
        return
    end
    release = hold
elseif not script_key then
    stop("Could not reach the key server. Check your connection and try again")
    return
end

local ok, problem = pcall(run)

if release then
    release(ok, problem)
elseif not ok then
    genv.__nova_loader_active = nil
    stop("Script failed to start: " .. tostring(problem))
end
