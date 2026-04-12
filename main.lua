local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local Ev = RS.Events
local SkillEv = Ev.Skills.SkillEvent
local DmgEv = Ev.DamageEvent
local CoinEv = Ev.coinsEvent
local BuyEv = Ev.Skills.BuySkillEvent
local NPCDmgEv = Ev.NPCDamageEvent

local function fire(ev, ...) ev:FireServer(...) end

local function dmg(npc)
    fire(DmgEv, {["isLocalNPC"]=true, ["npcName"]=npc})
end

local function skill(npc, sk)
    fire(SkillEv, "damage", {["isLocalNPC"]=true, ["npcName"]=npc, ["SelectedSkill"]=sk})
end

local function coin(npc)
    fire(CoinEv, {["action"]="npc_died", ["npcName"]=npc})
end

local function pdmg(char)
    fire(DmgEv, {["isPlayer"]=true, ["enemyChar"]=char})
end

local function pskill(char, sk)
    fire(SkillEv, "damage", {["isPlayer"]=true, ["enemyChar"]=char, ["SelectedSkill"]=sk})
end

local function closest()
    local lc = LP.Character
    if not lc or not lc:FindFirstChild("HumanoidRootPart") then return nil end
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChild("Humanoid")
            if r and h and h.Health > 0 then
                local d = (lc.HumanoidRootPart.Position - r.Position).Magnitude
                if d < dist then dist = d best = p end
            end
        end
    end
    return best
end

local W = Rayfield:CreateWindow({
    Name = "FRITE HUB | Animal Adventures",
    LoadingTitle = "FRITE HUB",
    LoadingSubtitle = "Power of FRITE ",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})


Rayfield:Notify({
    Title = "FRITE HUB",
    Content = "Script loaded successfully!",
    Duration = 4,
    Actions = {Ignore = {Name = "OK!", Callback = function() end}}
})

local TFarm = W:CreateTab("Farm", 4483362458)
local TOther = W:CreateTab("Coins", 4483362458)
local TPVP = W:CreateTab("PVP", 4483362458)
local TScript = W:CreateTab("Script", 4483362458)
local TCredits = W:CreateTab("Credits", nil)

TFarm:CreateSection("NPC Farm")

local LPH_NPCS = {
    {name="Lvl1",      icon="🌱"},
    {name="Rock",      icon="🪨"},
    {name="Grass",     icon="🌿"},
    {name="Water",     icon="🌊"},
    {name="Ice",       icon="❄️"},
    {name="Lightning", icon="⚡"},
    {name="Void",      icon="🌌"},
    {name="Fire",      icon="🔥"},
    {name="Worm",      icon="🪱"},
}

local LPH_FARM_SKILLS = {
    "Blackhole","Fireball","GreenSun","LaserBeam","Leafball",
    "LightningStrike","Lightningball","Meteor","Rock","Snowball",
    "Voidball","Waterball","Windball","YellowBeam"
}

for _, n in ipairs(LPH_NPCS) do
    local gk = "LPH_Farm_" .. n.name
    TFarm:CreateToggle({
        Name = "Farm " .. n.name .. " " .. n.icon,
        CurrentValue = false,
        Flag = "LPH_FarmToggle_" .. n.name,
        Callback = function(v)
            _G[gk] = v
            if v then
                while _G[gk] do
                    wait()
                    dmg(n.name)
                    for _, sk in ipairs(LPH_FARM_SKILLS) do
                        if not _G[gk] then break end
                        skill(n.name, sk)
                    end
                end
            end
        end
    })
end

TOther:CreateSection("Coins Collection")

local LPH_COIN_NPCS = {
    {name="Lvl1",      label="Lvl 1",      icon="💰"},
    {name="Rock",      label="Lvl 50",     icon="💰"},
    {name="Grass",     label="Lvl 200",    icon="💰"},
    {name="Water",     label="Lvl 450",    icon="💰"},
    {name="Ice",       label="Lvl 750",    icon="💰"},
    {name="Lightning", label="Lvl 1100",   icon="💰"},
    {name="Void",      label="Lvl 1500",   icon="💰"},
    {name="Fire",      label="Lvl 1500+",  icon="💰"},
    {name="Worm",      label="Lvl 1500++", icon="💰"},
}

for _, n in ipairs(LPH_COIN_NPCS) do
    local gk = "LPH_Coin_" .. n.name
    TOther:CreateToggle({
        Name = "Coins " .. n.icon .. " (" .. n.label .. ")",
        CurrentValue = false,
        Flag = "LPH_CoinToggle_" .. n.name,
        Callback = function(v)
            _G[gk] = v
            if v then
                while _G[gk] do
                    wait()
                    coin(n.name)
                end
            end
        end
    })
end

TOther:CreateSection("Skills")

local LPH_BuySkill = false
TOther:CreateToggle({
    Name = "Auto Buy Skill 🎓",
    CurrentValue = false,
    Flag = "LPH_BuySkillToggle",
    Callback = function(v)
        LPH_BuySkill = v
        if v then
            while LPH_BuySkill do
                wait()
                fire(BuyEv)
            end
        end
    end
})

TPVP:CreateSection("Kill Aura")

local LPH_SKILLS = {
    "Blackhole","Fireball","GreenSun","LaserBeam","Leafball",
    "LightningStrike","Lightningball","Meteor","Rock","Snowball",
    "Voidball","Waterball","Windball","YellowBeam"
}

local LPH_AllPVP = false
TPVP:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "LPH_AllPVPToggle",
    Callback = function(v)
        LPH_AllPVP = v
        if v then
            while LPH_AllPVP do
                wait()
                local t = closest()
                if t and t.Character then
                    local c = t.Character
                    pdmg(c)
                    for _, sk in ipairs(LPH_SKILLS) do
                        if not LPH_AllPVP then break end
                        pskill(c, sk)
                    end
                end
            end
        end
    end
})

TScript:CreateSection("Utilities")

local LPH_InfHP = false
TScript:CreateToggle({
    Name = "Infinite Health ♾️",
    CurrentValue = false,
    Flag = "LPH_InfHPToggle",
    Callback = function(v)
        LPH_InfHP = v
        if v then
            while LPH_InfHP do
                wait()
                fire(NPCDmgEv, -math.huge)
            end
        end
    end
})

TScript:CreateButton({
    Name = "Anti AFK",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xpzrmodzz/anti-afk/main/Anti%20afk"))()
    end
})

TScript:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

TCredits:CreateSection("Credits")
TCredits:CreateParagraph({Title = "Scripting", Content = "frite (C.N) [frite.exe_v1]"})
TCredits:CreateParagraph({Title = "Management", Content = "frite (C.N) [frite.exe_v1]"})
TCredits:CreateParagraph({Title = "UI Library", Content = "Rayfield"})

Rayfield:LoadConfiguration()
