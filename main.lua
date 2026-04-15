--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#=::=*%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@#..:=*%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#-         .-*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@=      :=*@@@@@@@@@@@@@@@@@@@@@@@@#:              .*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@%.          :*%@@@@@@@@@@@@@@@@@@*-       BY         #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@:         .==-..:=*%@@@@@@@@@@@+.        FRITE       =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@+          #@@@@@#=:  :+#@@@@@@@@#=:                  =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@.         *@@@@@@@@@@#+=: .-+*%@@@*.               -=#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                                                                                   
@+         =@@@@@@@@@@@@@@@@%#+-..:-:               -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
@         .@@@@@@@@@@@@@@@@@@@@@@@#+:       .    .=%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+         %@@@@@@@@@@@@@@@@@@@@@@@@@%*--:=:       :=*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
.        +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.          .-=+#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.           ++-:  .:=+*#@%@%@@@@@@@@@@@@@@@@@@@@
        :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.            :%@@@@%*+-:.     .-=#@@@@@@@@@@@@@@@
        +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%               #@@@@@@@@@@:        .:=+*#%@@@@@@@
        *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.               .@@@@@@@@%*.     *%#+=:      .-=+*
        #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#    .            .@#*=-:.       =@@@@@@@@%#*=-.    
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-   +*                      .-=#@@@@@@@@@@@@@@@@@%*+
.       %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%:                     :=+#@@@@@@@@@@@@@@@@@@@@@@@@@
=       *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#-            .@#*#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%       -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+          :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@*       %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#           :#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@-      :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=             +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@%.      +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*.               #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@%       %@@@@@@@@@@@@@@@@@@@@@@@@@@*:                  =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@+      =@@@@@@@@@@@@@@@@@@@@@@@#=.                     :%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@.     .@@@@@@@@@@@@@@@@@@@@%=.                         .%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@:     +@@@@@@@@@@@@@@@@@%+.                           -##@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@.    =@@@@@@@@@@@@@@@@*-                               %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@%    =@@@@@@@@@@@@@@@+.                                 +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@%    @@@@@@@@@@@@@@+.                                   :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--


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

local LPH_RealLvl = LP.leaderstats.Level.Value
local LPH_LvlGod = false

LP.leaderstats.Level:GetPropertyChangedSignal("Value"):Connect(function()
    if not LPH_LvlGod then
        LPH_RealLvl = LP.leaderstats.Level.Value
    end
end)

local LPH_AreaReq = {
    ["area1"]=0,["area2"]=50,["area3"]=200,["area4"]=450,["area5"]=750,
    ["area6"]=1100,["area7"]=1500,["area8"]=1500,["area9"]=1500,
}

local LPH_AreaNPC = {
    ["area1"]="Lvl1",["area2"]="Rock",["area3"]="Grass",["area4"]="Water",
    ["area5"]="Ice",["area6"]="Lightning",["area7"]="Void",["area8"]="Fire",["area9"]="Worm",
}

local function LPH_AreaLvl(a)
    if a == "area1" then return 0 end
    local ok, n = pcall(function()
        local t = workspace.Areas[a].Blocker.Text.SurfaceGui.TextLabel.Text
        return tonumber(t:match("Level%s+(%d+)"))
    end)
    return (ok and n) or LPH_AreaReq[a] or math.huge
end

local function LPH_BestNPC(a)
    local cap = a:gsub("^%l", string.upper)
    local ok, n = pcall(function()
        return workspace.NPCs[cap]:GetChildren()[1].Name
    end)
    return (ok and n) or LPH_AreaNPC[a]
end

local function LPH_Best()
    local best, req = "area1", 0
    for i = 1, 9 do
        local a = "area" .. i
        local r = LPH_AreaLvl(a)
        if LPH_RealLvl >= r and r >= req then best = a req = r end
    end
    return best, LPH_BestNPC(best)
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
local TMisc = W:CreateTab("Misc", 4483362458)
local Tab = W:CreateTab("Spawner", 4483362458)
local TScript = W:CreateTab("Script", 4483362458)
local TCredits = W:CreateTab("Credits", nil)

local LPH_FARM_SKILLS = {
    "Blackhole","Fireball","GreenSun","LaserBeam","Leafball",
    "LightningStrike","Lightningball","Meteor","Rock","Snowball",
    "Voidball","Waterball","Windball","YellowBeam"
}

TFarm:CreateSection("Best Farm")

local LPH_BFarm = false
local LPH_BFarmLbl = TFarm:CreateLabel("NPC : --", 4483362458, Color3.fromRGB(180,180,180), false)

TFarm:CreateToggle({
    Name = "Best Farm ⭐",
    CurrentValue = false,
    Flag = "LPH_BFarmToggle",
    Callback = function(v)
        LPH_BFarm = v
        if v then
            task.spawn(function()
                while LPH_BFarm do
                    local _, npc = LPH_Best()
                    pcall(function() LPH_BFarmLbl:Set("NPC : " .. npc) end)
                    dmg(npc)
                    for _, sk in ipairs(LPH_FARM_SKILLS) do
                        if not LPH_BFarm then break end
                        skill(npc, sk)
                    end
                    wait()
                end
                pcall(function() LPH_BFarmLbl:Set("NPC : --") end)
            end)
        end
    end
})

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

TOther:CreateSection("Best Coins")

local LPH_BCoin = false
local LPH_BCoinLbl = TOther:CreateLabel("NPC : --", 4483362458, Color3.fromRGB(180,180,180), false)

TOther:CreateToggle({
    Name = "Best Coins ⭐",
    CurrentValue = false,
    Flag = "LPH_BCoinToggle",
    Callback = function(v)
        LPH_BCoin = v
        if v then
            task.spawn(function()
                while LPH_BCoin do
                    local _, npc = LPH_Best()
                    pcall(function() LPH_BCoinLbl:Set("NPC : " .. npc) end)
                    coin(npc)
                    wait()
                end
                pcall(function() LPH_BCoinLbl:Set("NPC : --") end)
            end)
        end
    end
})

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

TPVP:CreateSection("Instant Kill")

local LPH_IK = false
local LPH_IKT = false
local LPH_Targets = {}
local LPH_CarryEv = Ev.CarryEvent
local LPH_NpcDmgEv = Ev.NPCDamageEvent
local LPH_SpawnEv = RS.Events.SpawnEvent

local function LPH_KillPlayer(p)
    if not p or not p.Character then return end
    local root = p.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    pcall(function() LP.Character:SetPrimaryPartCFrame(root.CFrame) end)
    task.wait(0.3)
    pcall(function() fire(LPH_CarryEv, p, "request_accepted") end)
    task.wait(0.2)
    pcall(function() fire(LPH_NpcDmgEv, math.huge) end)
    task.wait(0.2)
    pcall(function() LPH_SpawnEv:FireServer("Human","human_gamepass1","Human") end)
    task.wait(0.6)
end

local function ikAll()
    while LPH_IK do
        for _, p in ipairs(Players:GetPlayers()) do
            if not LPH_IK then break end
            if p ~= LP then LPH_KillPlayer(p) end
        end
        task.wait(0.6)
    end
end

TPVP:CreateToggle({
    Name = "Instant Kill All Players",
    CurrentValue = false,
    Flag = "LPH_IKToggle",
    Callback = function(v)
        LPH_IK = v
        if v then task.spawn(ikAll) end
    end
})

TPVP:CreateSection("Instant Kill Target")

local function LPH_PlayerList()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(t, p.Name) end
    end
    return t
end

local function ikTarget()
    while LPH_IKT do
        for _, tn in ipairs(LPH_Targets) do
            if not LPH_IKT then break end
            LPH_KillPlayer(Players:FindFirstChild(tn))
        end
        task.wait(0.6)
    end
end

_G.LPH_pList = LPH_PlayerList()

local LPH_IKDrop = TPVP:CreateDropdown({
    Name = "Select Target Players",
    Options = _G.LPH_pList,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "LPH_IKTargets",
    Callback = function(v) LPH_Targets = v end,
})

Players.PlayerAdded:Connect(function(p)
    if p ~= LP then
        table.insert(_G.LPH_pList, p.Name)
        LPH_IKDrop:Refresh(_G.LPH_pList, 1)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    for i, n in ipairs(LPH_Targets) do
        if n == p.Name then table.remove(LPH_Targets, i) break end
    end
    for i, n in ipairs(_G.LPH_pList) do
        if n == p.Name then table.remove(_G.LPH_pList, i) break end
    end
    LPH_IKDrop:Refresh(_G.LPH_pList, 1)
end)

TPVP:CreateToggle({
    Name = "Instant Kill Selected Players",
    CurrentValue = false,
    Flag = "LPH_IKTToggle",
    Callback = function(v)
        LPH_IKT = v
        if v then
            if #LPH_Targets == 0 then LPH_IKT = false return end
            task.spawn(ikTarget)
        end
    end
})

TMisc:CreateSection("Player")

local LPH_OrigLvl = LP.leaderstats.Level.Value
local LPH_LvlLoop = nil

TMisc:CreateToggle({
    Name = "Level God Mode ⚡",
    CurrentValue = false,
    Flag = "LPH_LvlGodToggle",
    Callback = function(v)
        LPH_LvlGod = v
        if v then
            LPH_OrigLvl = LPH_RealLvl
            LPH_LvlLoop = game:GetService("RunService").Heartbeat:Connect(function()
                local lvl = LP.leaderstats.Level
                if lvl.Value ~= 4000000000000000000 then
                    lvl.Value = 4000000000000000000
                end
            end)
        else
            if LPH_LvlLoop then LPH_LvlLoop:Disconnect() LPH_LvlLoop = nil end
            LP.leaderstats.Level.Value = LPH_OrigLvl
        end
    end
})

TMisc:CreateSection("NPC")

local LPH_OrigDmg = {}
local LPH_DmgLoop = nil

local function LPH_SaveDmg()
    for _, area in ipairs(workspace.NPCs:GetChildren()) do
        LPH_OrigDmg[area.Name] = {}
        for _, npc in ipairs(area:GetChildren()) do
            local cfg = npc:FindFirstChild("Configuration")
            if cfg then
                local d = cfg:FindFirstChild("Damage")
                if d then LPH_OrigDmg[area.Name][npc.Name] = d.Value end
            end
        end
    end
end

local function LPH_ZeroDmg()
    for _, area in ipairs(workspace.NPCs:GetChildren()) do
        if not LPH_OrigDmg[area.Name] then LPH_OrigDmg[area.Name] = {} end
        for _, npc in ipairs(area:GetChildren()) do
            local cfg = npc:FindFirstChild("Configuration")
            if cfg then
                local d = cfg:FindFirstChild("Damage")
                if d and d.Value ~= 0 then
                    if not LPH_OrigDmg[area.Name][npc.Name] then
                        LPH_OrigDmg[area.Name][npc.Name] = d.Value
                    end
                    d.Value = 0
                end
            end
        end
    end
end

local function LPH_RestoreDmg()
    for _, area in ipairs(workspace.NPCs:GetChildren()) do
        for _, npc in ipairs(area:GetChildren()) do
            local cfg = npc:FindFirstChild("Configuration")
            if cfg then
                local d = cfg:FindFirstChild("Damage")
                if d and LPH_OrigDmg[area.Name] and LPH_OrigDmg[area.Name][npc.Name] then
                    d.Value = LPH_OrigDmg[area.Name][npc.Name]
                end
            end
        end
    end
end

TMisc:CreateToggle({
    Name = "No NPC Damage 🛡️",
    CurrentValue = false,
    Flag = "LPH_NoDmgToggle",
    Callback = function(v)
        if v then
            LPH_SaveDmg()
            LPH_DmgLoop = game:GetService("RunService").Heartbeat:Connect(LPH_ZeroDmg)
        else
            if LPH_DmgLoop then LPH_DmgLoop:Disconnect() LPH_DmgLoop = nil end
            LPH_RestoreDmg()
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

local AnimalsGUI = LP.PlayerGui.AnimalsGUI
local Animals = AnimalsGUI.windowFrame.bodyFrame.body2Frame.Animals

local function LPH_AssetId(s)
    if not s or s == "" then return 4483362458 end
    local id = s:match("rbxassetid://(%d+)") or s:match("id=(%d+)") or s:match("^(%d+)$")
    return id and tonumber(id) or 4483362458
end

local function LPH_SkinImg(folder, skin)
    local ok, r = pcall(function() return Animals[folder][skin].Button.ImageLabel.Image end)
    return ok and LPH_AssetId(r) or 4483362458
end

local function LPH_Notify(folder, skin)
    Rayfield:Notify({Title="Skin sélectionné", Content=skin, Duration=4, Image=LPH_SkinImg(folder, skin)})
end

local LPH_SelHuman = "human_none"
Tab:CreateLabel("HUMAN SPAWNER", 4483362458, Color3.fromRGB(255,255,255), false)
Tab:CreateDropdown({
    Name = "Human Skin",
    Options = {"human_blade","human_electric","human_fire","human_gamepass1","human_gamepass2","human_gamepass3","human_gamepass4","human_grass","human_ice","human_none","human_rock","human_s1","human_s2","human_void","human_water"},
    CurrentOption = {"human_none"}, MultipleOptions = false, Flag = "LPH_HumanDrop",
    Callback = function(v) LPH_SelHuman = v[1] LPH_Notify("Human", LPH_SelHuman) end,
})
Tab:CreateButton({
    Name = "Spawn Human",
    Callback = function()
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer("Human", LPH_SelHuman, "Human")
    end,
})

local LPH_SelBear = "bear1"
Tab:CreateLabel("BEAR SPAWNER", 4483362458, Color3.fromRGB(255,255,255), false)
Tab:CreateDropdown({
    Name = "Bear Skin",
    Options = {"babybear1","babybear2","babybear3","bear1","bear2","bear3","bearelectric","bearfire","beargrass","bearice","bearrock","bears1","bears2","bearvoid","bearwater"},
    CurrentOption = {"bear1"}, MultipleOptions = false, Flag = "LPH_BearDrop",
    Callback = function(v) LPH_SelBear = v[1] LPH_Notify("Bear", LPH_SelBear) end,
})
Tab:CreateButton({
    Name = "Spawn Bear",
    Callback = function()
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer("Bear", LPH_SelBear, "Bear")
    end,
})

local LPH_SelRabbit = "rabbit1"
Tab:CreateLabel("RABBIT SPAWNER", 4483362458, Color3.fromRGB(255,255,255), false)
Tab:CreateDropdown({
    Name = "Rabbit Skin",
    Options = {"babyrabbit1","babyrabbit2","babyrabbit3","rabbit1","rabbit2","rabbit3","rabbitelectric","rabbitfire","rabbitgrass","rabbitice","rabbitrock","rabbits1","rabbits2","rabbitvoid","rabbitwater"},
    CurrentOption = {"rabbit1"}, MultipleOptions = false, Flag = "LPH_RabbitDrop",
    Callback = function(v) LPH_SelRabbit = v[1] LPH_Notify("Rabbit", LPH_SelRabbit) end,
})
Tab:CreateButton({
    Name = "Spawn Rabbit",
    Callback = function()
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer("Rabbit", LPH_SelRabbit, "Rabbit")
    end,
})

local LPH_SelDog = "dog1"
Tab:CreateLabel("DOG SPAWNER", 4483362458, Color3.fromRGB(255,255,255), false)
Tab:CreateDropdown({
    Name = "Dog Skin",
    Options = {"dog1","dog2","dog3","dogelectric","dogfire","doggrass","dogice","dogrock","dogs1","dogs2","dogvoid","dogwater","puppy1","puppy2","puppy3"},
    CurrentOption = {"dog1"}, MultipleOptions = false, Flag = "LPH_DogDrop",
    Callback = function(v) LPH_SelDog = v[1] LPH_Notify("Dog", LPH_SelDog) end,
})
Tab:CreateButton({
    Name = "Spawn Dog",
    Callback = function()
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer("Dog", LPH_SelDog, "Dog")
    end,
})

local LPH_SelCat = "cat1"
Tab:CreateLabel("CAT SPAWNER", 4483362458, Color3.fromRGB(255,255,255), false)
Tab:CreateDropdown({
    Name = "Cat Skin",
    Options = {"cat1","cat2","cat3","catelectric","catfire","catgrass","catice","catrock","cats1","cats2","catvoid","catwater","kitten1","kitten2","kitten3"},
    CurrentOption = {"cat1"}, MultipleOptions = false, Flag = "LPH_CatDrop",
    Callback = function(v) LPH_SelCat = v[1] LPH_Notify("Cat", LPH_SelCat) end,
})
Tab:CreateButton({
    Name = "Spawn Cat",
    Callback = function()
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer("Cat", LPH_SelCat, "Cat")
    end,
})

TCredits:CreateSection("Credits")
TCredits:CreateParagraph({Title="Scripting", Content="frite (C.N) [frite.exe_v1]"})
TCredits:CreateParagraph({Title="Management", Content="frite (C.N) [frite.exe_v1]"})
TCredits:CreateParagraph({Title="UI Library", Content="Rayfield"})

Rayfield:LoadConfiguration()
