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
local Tab = W:CreateTab("Spawner", 4483362458)
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

TPVP:CreateSection("Instant Kill")

local LPH_IK = false

local function ikAll()
    local carryEv = Ev.CarryEvent
    local npcDmgEv = Ev.NPCDamageEvent

    while LPH_IK do
        for _, p in ipairs(Players:GetPlayers()) do
            if not LPH_IK then break end
            if p ~= LP and p.Character then
                local c = p.Character
                local root = c:FindFirstChild("HumanoidRootPart")

                if root then
                    pcall(function()
                        LP.Character:SetPrimaryPartCFrame(root.CFrame)
                    end)

                    wait(0.3)

                    pcall(function()
                        fire(carryEv, p, "request_accepted")
                    end)

                    wait(0.2)

                    pcall(function()
                        fire(npcDmgEv, math.huge)
                    end)

                    wait(0.2)
                    
                    pcall(function()
                        local args = {
                            [1] = "Human",
                            [2] = "human_gamepass4",
                            [3] = "Human"
                        }
                        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer(unpack(args))
                    end)

                    wait(0.6)
                end
            end
        end
        wait(0.6)
    end
end

TPVP:CreateToggle({
    Name = "Instant Kill All Players",
    CurrentValue = false,
    Flag = "LPH_IKToggle",
    Callback = function(v)
        LPH_IK = v
        if v then
            coroutine.wrap(ikAll)()
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

local AnimalsGUI = game:GetService("Players").LocalPlayer.PlayerGui.AnimalsGUI
local Animals = AnimalsGUI.windowFrame.bodyFrame.body2Frame.Animals

local function ExtractAssetId(imageStr)
    if not imageStr or imageStr == "" then return 4483362458 end
    local id = imageStr:match("rbxassetid://(%d+)")
    if id then return tonumber(id) end
    id = imageStr:match("id=(%d+)")
    if id then return tonumber(id) end
    id = imageStr:match("^(%d+)$")
    if id then return tonumber(id) end
    return 4483362458
end

local function GetSkinImage(animalFolder, skinName)
    local success, result = pcall(function()
        return Animals[animalFolder][skinName].Button.ImageLabel.Image
    end)
    if success then
        return ExtractAssetId(result)
    end
    return 4483362458
end

local function NotifySpawn(animalFolder, skinName)
    local imgId = GetSkinImage(animalFolder, skinName)
    Rayfield:Notify({
        Title = "Skin sélectionné",
        Content = skinName,
        Duration = 4,
        Image = imgId,
    })
end

-- ==================== HUMAN ====================
local HumanLabel = Tab:CreateLabel("HUMAN SPAWNER", 4483362458, Color3.fromRGB(255, 255, 255), false)

local SelectedHuman = "human_none"

local HumanDropdown = Tab:CreateDropdown({
    Name = "Human Skin",
    Options = {
        "human_blade", "human_electric", "human_fire",
        "human_gamepass1", "human_gamepass2", "human_gamepass3", "human_gamepass4",
        "human_grass", "human_ice", "human_none",
        "human_rock", "human_s1", "human_s2",
        "human_void", "human_water"
    },
    CurrentOption = {"human_none"},
    MultipleOptions = false,
    Flag = "HumanDropdown",
    Callback = function(Options)
        SelectedHuman = Options[1]
        NotifySpawn("Human", SelectedHuman)
    end,
})

local HumanButton = Tab:CreateButton({
    Name = "Spawn Human",
    Callback = function()
        local args = { [1] = "Human", [2] = SelectedHuman, [3] = "Human" }
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer(unpack(args))
    end,
})

-- ==================== BEAR ====================
local BearLabel = Tab:CreateLabel("BEAR SPAWNER", 4483362458, Color3.fromRGB(255, 255, 255), false)

local SelectedBear = "bear1"

local BearDropdown = Tab:CreateDropdown({
    Name = "Bear Skin",
    Options = {
        "babybear1", "babybear2", "babybear3",
        "bear1", "bear2", "bear3",
        "bearelectric", "bearfire", "beargrass",
        "bearice", "bearrock", "bears1", "bears2",
        "bearvoid", "bearwater"
    },
    CurrentOption = {"bear1"},
    MultipleOptions = false,
    Flag = "BearDropdown",
    Callback = function(Options)
        SelectedBear = Options[1]
        NotifySpawn("Bear", SelectedBear)
    end,
})

local BearButton = Tab:CreateButton({
    Name = "Spawn Bear",
    Callback = function()
        local args = { [1] = "Bear", [2] = SelectedBear, [3] = "Bear" }
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer(unpack(args))
    end,
})

-- ==================== RABBIT ====================
local RabbitLabel = Tab:CreateLabel("RABBIT SPAWNER", 4483362458, Color3.fromRGB(255, 255, 255), false)

local SelectedRabbit = "rabbit1"

local RabbitDropdown = Tab:CreateDropdown({
    Name = "Rabbit Skin",
    Options = {
        "babyrabbit1", "babyrabbit2", "babyrabbit3",
        "rabbit1", "rabbit2", "rabbit3",
        "rabbitelectric", "rabbitfire", "rabbitgrass",
        "rabbitice", "rabbitrock", "rabbits1", "rabbits2",
        "rabbitvoid", "rabbitwater"
    },
    CurrentOption = {"rabbit1"},
    MultipleOptions = false,
    Flag = "RabbitDropdown",
    Callback = function(Options)
        SelectedRabbit = Options[1]
        NotifySpawn("Rabbit", SelectedRabbit)
    end,
})

local RabbitButton = Tab:CreateButton({
    Name = "Spawn Rabbit",
    Callback = function()
        local args = { [1] = "Rabbit", [2] = SelectedRabbit, [3] = "Rabbit" }
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer(unpack(args))
    end,
})

-- ==================== DOG ====================
local DogLabel = Tab:CreateLabel("DOG SPAWNER", 4483362458, Color3.fromRGB(255, 255, 255), false)

local SelectedDog = "dog1"

local DogDropdown = Tab:CreateDropdown({
    Name = "Dog Skin",
    Options = {
        "dog1", "dog2", "dog3",
        "dogelectric", "dogfire", "doggrass",
        "dogice", "dogrock", "dogs1", "dogs2",
        "dogvoid", "dogwater",
        "puppy1", "puppy2", "puppy3"
    },
    CurrentOption = {"dog1"},
    MultipleOptions = false,
    Flag = "DogDropdown",
    Callback = function(Options)
        SelectedDog = Options[1]
        NotifySpawn("Dog", SelectedDog)
    end,
})

local DogButton = Tab:CreateButton({
    Name = "Spawn Dog",
    Callback = function()
        local args = { [1] = "Dog", [2] = SelectedDog, [3] = "Dog" }
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer(unpack(args))
    end,
})

-- ==================== CAT ====================
local CatLabel = Tab:CreateLabel("CAT SPAWNER", 4483362458, Color3.fromRGB(255, 255, 255), false)

local SelectedCat = "cat1"

local CatDropdown = Tab:CreateDropdown({
    Name = "Cat Skin",
    Options = {
        "cat1", "cat2", "cat3",
        "catelectric", "catfire", "catgrass",
        "catice", "catrock", "cats1", "cats2",
        "catvoid", "catwater",
        "kitten1", "kitten2", "kitten3"
    },
    CurrentOption = {"cat1"},
    MultipleOptions = false,
    Flag = "CatDropdown",
    Callback = function(Options)
        SelectedCat = Options[1]
        NotifySpawn("Cat", SelectedCat)
    end,
})

local CatButton = Tab:CreateButton({
    Name = "Spawn Cat",
    Callback = function()
        local args = { [1] = "Cat", [2] = SelectedCat, [3] = "Cat" }
        game:GetService("ReplicatedStorage").Events.SpawnEvent:FireServer(unpack(args))
    end,
})

TCredits:CreateSection("Credits")
TCredits:CreateParagraph({Title = "Scripting", Content = "frite (C.N) [frite.exe_v1]"})
TCredits:CreateParagraph({Title = "Management", Content = "frite (C.N) [frite.exe_v1]"})
TCredits:CreateParagraph({Title = "UI Library", Content = "Rayfield"})

Rayfield:LoadConfiguration()
