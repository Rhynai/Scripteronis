if game.local_player.champ_name ~= "Udyr" then
    return 
end

do
    local function AutoUpdate()
		local Version = 0.1
		local file_name = "Speed-Demon-Udyr.lua"
		local url = "https://github.com/Rhynai/Scripteronis/blob/main/Speed-Demon-Udyr.lua"
        local web_version = http:get("https://github.com/Rhynai/Scripteronis/blob/main/Udyr-Version.txt")
        console:log("Speed Demon Udyr.lua Vers: "..Version)
		console:log("Speed Demon Udyr.Web Vers: "..tonumber(web_version))
		if tonumber(web_version) == Version then

            console:log("...Speed Demon Udyr Ready to Roll.....")


        else
			http:download_file(url, file_name)
			      console:log("Speed Demon Udyr Update available.....")
						console:log("Please Reload via F5!.....")
						console:log("----------------------------")
						console:log("Please Reload via F5!.....")
						console:log("----------------------------")
						console:log("Please Reload via F5!.....")
        end

    end

    AutoUpdate()
end


-- Locals to pull info from

local myHero = game.local_player
local local_player = game.local_player

local function Ready(spell)
    return spellbook:can_cast(spell)
end
  
local function GetEnemyHeroes()
    local _EnemyHeroes = {}
    players = game.players
    for i, unit in ipairs(players) do
        if unit and unit.is_enemy then
            table.insert(_EnemyHeroes, unit)
        end
    end
      return _EnemyHeroes
end
  
local function GetAllyHeroes()
    local _AllyHeroes = {}
      players = game.players
    for i, unit in ipairs(players) do
        if unit and not unit.is_enemy and unit.object_id ~= myHero.object_id then
            table.insert(_AllyHeroes, unit)
        end
    end
    return _AllyHeroes
end
  
local function IsValid(unit)
    if (unit and unit.is_targetable and unit.is_alive and unit.is_visible and unit.object_id and unit.health > 0) then
        return true
    end
    return false
end

local function HasEStun(unit)
    if unit:has_buff("udyrbearstuncheck") then
        return true
    end
    return false
end



-- Menu

udyr_category = menu:add_category("Udyr")
udyr_enabled = menu:add_checkbox("Enabled", udyr_category, 1)
udyr_combokey = menu:add_keybinder("Combo Mode Key", udyr_category, 32)
menu:add_label("Speed Demon Udyr", udyr_category)

udyr_combo = menu:add_subcategory("[Combo]", udyr_category)
udyr_combo_use_q = menu:add_checkbox("Use [Q]", udyr_combo, 1)
udyr_combo_use_w = menu:add_checkbox("Use [W]", udyr_combo, 1)
udyr_combo_use_e = menu:add_checkbox("Use [E]", udyr_combo, 1)
udyr_combo_use_r = menu:add_checkbox("Use [R]", udyr_combo, 1)

Jungle_ClearM = menu:add_subcategory("Jungle Clear", udyr_category)
Jungle_Clear = menu:add_checkbox("Jungle Clear", Jungle_ClearM, 1)
udyr_jungle_use_q = menu:add_checkbox("Use [Q]", Jungle_ClearM, 1)
udyr_jungle_use_w = menu:add_checkbox("Use [W]", Jungle_ClearM, 1)
udyr_jungle_use_e = menu:add_checkbox("Use [E]", Jungle_ClearM, 1)
udyr_jungle_use_r = menu:add_checkbox("Use [R]", Jungle_ClearM, 1)
Min_ManaJ = menu:add_slider("Minumum mana [%] to Jungle", Jungle_ClearM, 1, 100, 20)

Lane = menu:add_subcategory("Lane Clear", udyr_category)
Jungle_Clear = menu:add_checkbox("Lane Clear", Lane, 1)
udyr_lane_use_q = menu:add_checkbox("Use [Q]", Lane, 1)
udyr_lane_use_w = menu:add_checkbox("Use [W]", Lane, 1)
udyr_lane_use_e = menu:add_checkbox("Use [E]", Lane, 1)
udyr_lane_use_r = menu:add_checkbox("Use [R]", Lane, 1)
Min_ManaL = menu:add_slider("Minumum mana [%] to Lane", Lane, 1, 100, 20)


Choose_StanceQ = menu:add_checkbox("Q build", udyr_category, 1)
Choose_StanceR = menu:add_checkbox("R build", udyr_category, 0)

-- Spell Data
local Q = {Range = 600, Delay = .09}
local W = {Range = 600, Delay = .09}
local E = {Range = 600, Delay = .09}
local R = {Range = 325, Delay = .09}

-- Casting 

local function CastQ()
    spellbook:cast_spell(SLOT_Q, Q.Delay)
end

local function CastW()
	spellbook:cast_spell(SLOT_W, W.Delay)
end

local function CastE()
	spellbook:cast_spell(SLOT_E, E.Delay)
end

local function CastR()
	spellbook:cast_spell(SLOT_R, R.Delay)
end

-- Combo

local function Combo()

	target = selector:find_target(600, mode_health)
    if menu:get_value(udyr_combo_use_q) == 1 and Ready(SLOT_Q) then
        if IsValid(target) and HasEStun(target) == true and menu:get_value(Choose_StanceQ) == 1 then
        CastQ()
        end
    end

    if menu:get_value(udyr_combo_use_w) == 1 and Ready(SLOT_W) then
        if IsValid(target) and HasEStun(target) == true  then
            CastW()
        end
    end
    
    if menu:get_value(udyr_combo_use_e) == 1 and Ready(SLOT_E) then
        if IsValid(target) and HasEStun(target) == false then
            CastE()
        end
    end
    
    if menu:get_value(udyr_combo_use_r) == 1 and Ready(SLOT_R) then
        if IsValid(target) and HasEStun(target) == true and menu:get_value(Choose_StanceR) == 1 then
            CastR()
        end
    end
end

local function Dist(unit)
    distance = myHero:distance_to(unit.origin)
    return distance
end


local function Jungle()
    
    local JungleClearMana = myHero.mana/myHero.max_mana >= menu:get_value(Min_ManaJ) / 100

    minions = game.jungle_minions
	for i, target in ipairs(minions) do

        if Ready(SLOT_Q) then
            if menu:get_value(Choose_StanceQ) == 1 and menu:get_value(udyr_jungle_use_q) == 1 and Dist(target) <= 250
             then
                if JungleClearMana then
                CastQ()
                end
            end
        end
        if Ready(SLOT_W) and menu:get_value(udyr_jungle_use_w) == 1 and Dist(target) <= 250
         then
            if JungleClearMana then
                CastW()
            end
        end
        if Ready(SLOT_E) and menu:get_value(udyr_jungle_use_e) == 1 and Dist(target) <= 250
         then
            if JungleClearMana then
                CastE()
            end
        end
        if Ready(SLOT_R) then
            if menu:get_value(Choose_StanceR) == 1 and menu:get_value(udyr_jungle_use_r) == 1 and Dist(target) <= 250
             then
                if JungleClearMana then
                CastR()
                end
            end
        end
    end
end

local function Clear()

    local LaneClearMana = myHero.mana/myHero.max_mana >= menu:get_value(Min_ManaL) / 100

    minions = game.minions
	for i, target in ipairs(minions) do

        if Ready(SLOT_Q) then
            if menu:get_value(Choose_StanceQ) == 1 and menu:get_value(udyr_lane_use_q) == 1 and Dist(target) <= 250 then
                if LaneClearMana then
                CastQ()
                end
            end
        end
        if Ready(SLOT_W) and menu:get_value(udyr_lane_use_w) == 1 and Dist(target) <= 250
         then
            if LaneClearMana then
                CastW()
            end
        end
        if Ready(SLOT_E) and menu:get_value(udyr_lane_use_e) == 1 and Dist(target) <= 250
         then
            if LaneClearMana then
                CastE()
            end
        end
        if Ready(SLOT_R) then
            if menu:get_value(Choose_StanceR) == 1 and menu:get_value(udyr_lane_use_r) == 1 and Dist(target) <= 250
             then
                if LaneClearMana then
                CastR()
                end
            end
        end
    end
end

local function Flee()

    if Ready(SLOT_Q) then
        CastQ()
    end
    if Ready(SLOT_W) then
        CastW()
    end
    if Ready(SLOT_E) then
        CastE()
    end
    if Ready(SLOT_R) then
        CastR()
    end
end




local function on_tick()
    mode = combo:get_mode()
    if menu:get_value(udyr_enabled) == 1 then
        if mode == MODE_COMBO then
            Combo()
        end
    end       
        --MODE_HARASS
    if menu:get_value(udyr_enabled) == 1 then
        if mode == MODE_LANECLEAR then
            Jungle()
            Clear()
        end
    end
        --MODE_LASTHIT
        --MODE_FREEZE
    if menu:get_value(udyr_enabled) == 1 then
        if mode == MODE_FLEE then
            Flee()
        end
    end
        --MODE_ORBWALKER
        --MODE_NONE
end
client:set_event_callback("on_tick", on_tick)

