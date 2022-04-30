local mod = get_mod("mastergriller")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de

local hat_path = "units/chief_hat"
local wand_path = "units/gold_pan"

local hat_replace = "units/beings/player/bright_wizard_adept/headpiece/bw_a_hat_01"
local wep_replace = "units/weapons/player/wpn_brw_crowbill_01/wpn_brw_crowbill_01"

local wep_replace2 = "units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_sword_01_t2"

Managers.package:load("units/beings/player/bright_wizard_scholar/third_person_base/chr_third_person_mesh", "global")
Managers.package:load("units/beings/player/bright_wizard_adept/third_person_base/chr_third_person_mesh", "global")
Managers.package:load("units/beings/player/bright_wizard_unchained/skins/black_and_gold/chr_bright_wizard_unchained_black_and_gold", "global")
Wwise.load_bank("wwise/pan_hits")

mod.tisch = {
	{
		name = "crowbill",
		path = wand_path,
		path_3p = wand_path.."_3p",
		swap_skin = "bw_1h_crowbill_skin_01",
		swap_hand = "right_hand_unit",
		wpn_path = wep_replace,
		wpn_path_3p = wep_replace.."_3p"
	},
	{
		name = "sword",
		path = wand_path,
		path_3p = wand_path.."_3p",
		swap_skin = "bw_1h_sword_skin_02",
		swap_hand = "right_hand_unit",
		wpn_path = wep_replace2,
		wpn_path_3p = wep_replace2.."_3p"
	}
}

for i=1, #mod.tisch do 		
	NetworkLookup.inventory_packages[mod.tisch[i].path_3p] = NetworkLookup.inventory_packages[mod.tisch[i].wpn_path_3p]
	NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.tisch[i].wpn_path_3p]] = mod.tisch[i].path_3p
	NetworkLookup.inventory_packages[mod.tisch[i].path] = NetworkLookup.inventory_packages[mod.tisch[i].wpn_path]
	NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.tisch[i].wpn_path]] = mod.tisch[i].path
    WeaponSkins.skins[mod.tisch[i].swap_skin][mod.tisch[i].swap_hand] = mod.tisch[i].path
end

NetworkLookup.inventory_packages[hat_path] = NetworkLookup.inventory_packages[hat_replace]
NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[hat_replace]] = hat_path


ItemMasterList.adept_hat_0000.unit = hat_path
ItemMasterList.adept_hat_0000.template = "dr_helmets"
-- WeaponSkins.skins.bw_1h_crowbill_skin_01["right_hand_unit"] = wand_path
-- WeaponSkins.skins.bw_1h_sword_skin_02["right_hand_unit"] = wand_path



mod:hook(PackageManager, "load",
         function(func, self, package_name, reference_name, callback,
                  asynchronous, prioritize)
    if package_name ~= hat_path and package_name ~= wand_path .. "_3p" and package_name ~= wand_path then
        func(self, package_name, reference_name, callback, asynchronous,
             prioritize)
    end
	
end)

mod:hook(PackageManager, "unload",
         function(func, self, package_name, reference_name)
    if package_name ~= hat_path and package_name ~= wand_path .. "_3p" and package_name ~= wand_path then
        func(self, package_name, reference_name)
    end
	
end)

mod:hook(PackageManager, "has_loaded",
         function(func, self, package, reference_name)
    if package == hat_path or (package == wand_path .. "_3p" or package == wand_path) then
        return true
    end
	
    return func(self, package, reference_name)
end)

local function spawn_package_to_player (package_name)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
    local unit_spawner = Managers.state.unit_spawner
    local init_data = {}

	if world and player and player.player_unit then
        local player_unit = player.player_unit
    
        local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
        local rotation = Unit.local_rotation(player_unit, 0)
        local unit_template_name = "interaction_unit"
        local extension_init_data  = {}
        
        local unit = World.spawn_unit(world, package_name, position, rotation)

        mod:chat_broadcast(#NetworkLookup.inventory_packages + 1)
        return unit
	end
  
	return nil
end

local function replace_textures(unit)
    if Unit.has_data(unit, "mat_list") then
        local num_mats = Unit.get_data(unit, "num_mats")

        for i=1, num_mats do 
            local mat_slot = Unit.get_data(unit, "mat_slots", "slot"..tostring(i))
            local mat = Unit.get_data(unit, "mat_list", "slot"..tostring(i))
            Unit.set_material(unit, mat_slot, mat)
        end
    end 
end

mod:command("grill", "", function()
    local unit = spawn_package_to_player(hat_path)
    replace_textures(unit)
end)

mod:command("pan", "", function()
    local unit = spawn_package_to_player(wand_path.."_3p")
    replace_textures(unit)
end)

function re_equip()
    local player = Managers.player:local_player()
    local player_unit = player.player_unit    
    local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
    local career_extension = ScriptUnit.extension(player_unit, "career_system")
    local career_name = career_extension:career_name()
    local item_one = BackendUtils.get_loadout_item(career_name, "slot_melee")
    local item_two = BackendUtils.get_loadout_item(career_name, "slot_ranged")
    local item_hat = BackendUtils.get_loadout_item(career_name, "slot_hat")

    local skin_item = BackendUtils.get_loadout_item(career_name, "slot_skin")
    local item_data = skin_item and skin_item.data
    local skin_name = item_data.name
    local skin_data = Cosmetics[skin_name]
    local equip_hat_event = skin_data.equip_hat_event

    -- local hat_index = InventorySettings.slots_by_name.slot_hat.slot_index
    -- local hat_data = equipment_units[hat_index]

    if item_hat and equip_hat_event then
        Unit.flow_event(item_hat, equip_hat_event)
    end


    for k,v in pairs (mod.tisch) do
        if (item_one.skin == v.swap_skin) or (item_two.skin == v.swap_skin) then
            BackendUtils.set_loadout_item(item_two.backend_id, career_name, "slot_ranged")
            inventory_extension:create_equipment_in_slot("slot_ranged", item_two.backend_id)
            BackendUtils.set_loadout_item(item_one.backend_id, career_name, "slot_melee")
            inventory_extension:create_equipment_in_slot("slot_melee", item_one.backend_id)
        end
    end

    local backend_items = Managers.backend:get_interface("items")
    backend_items:set_loadout_item(item_hat.backend_id, career_name, "slot_hat")
    
    -- PlayerUnitCosmeticExtension.trigger_equip_events("slot_hat", unit)
    -- BackendUtils.set_loadout_item(item_hat.backend_id, career_name, "slot_hat")
    -- inventory_extension:create_equipment_in_slot("slot_hat", item_hat.backend_id)
end

function mod.update()
    for i=1, #mod.tisch do
        if mod:get(tostring(i)) then
            if WeaponSkins.skins[mod.tisch[i].swap_skin][mod.tisch[i].swap_hand] ~= mod.tisch[i].path then
                NetworkLookup.inventory_packages[mod.tisch[i].path_3p] = NetworkLookup.inventory_packages[mod.tisch[i].wpn_path_3p]
                NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.tisch[i].wpn_path_3p]] = mod.tisch[i].path_3p
                NetworkLookup.inventory_packages[mod.tisch[i].path] = NetworkLookup.inventory_packages[mod.tisch[i].wpn_path]
                NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.tisch[i].wpn_path]] = mod.tisch[i].path
                WeaponSkins.skins[mod.tisch[i].swap_skin][mod.tisch[i].swap_hand] = mod.tisch[i].path
                re_equip()
            end
        elseif not mod:get(tostring(i)) then
            if WeaponSkins.skins[mod.tisch[i].swap_skin][mod.tisch[i].swap_hand] == mod.tisch[i].path then
                NetworkLookup.inventory_packages[mod.tisch[i].wpn_path_3p] = NetworkLookup.inventory_packages[mod.tisch[i].path_3p]
                NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.tisch[i].path_3p]] = mod.tisch[i].wpn_path_3p
                NetworkLookup.inventory_packages[mod.tisch[i].wpn_path] = NetworkLookup.inventory_packages[mod.tisch[i].path]
                NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[mod.tisch[i].path]] = mod.tisch[i].wpn_path
                WeaponSkins.skins[mod.tisch[i].swap_skin][mod.tisch[i].swap_hand] = mod.tisch[i].wpn_path
                re_equip()
            end
        end
    end

    if mod:get("hat") then
        if ItemMasterList.adept_hat_0000.unit ~= hat_path then 
            NetworkLookup.inventory_packages[hat_path] = NetworkLookup.inventory_packages[hat_replace]
            NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[hat_replace]] = hat_path
            ItemMasterList.adept_hat_0000.unit = hat_path
            ItemMasterList.adept_hat_0000.template = "dr_helmets"
            re_equip()
        end
    elseif not mod:get("hat") then
        if ItemMasterList.adept_hat_0000.unit == hat_path then 
            NetworkLookup.inventory_packages[hat_replace] = NetworkLookup.inventory_packages[hat_path]
            NetworkLookup.inventory_packages[NetworkLookup.inventory_packages[hat_path]] = hat_replace
            ItemMasterList.adept_hat_0000.unit = hat_replace
            ItemMasterList.adept_hat_0000.template = "bw_gates"
            re_equip()
        end
    end

end

mod:hook_safe(ActionSweep,'_play_environmental_effect' ,function (self, weapon_rotation, current_action, hit_unit, hit_position, hit_normal, hit_actor)
    local unit = self.weapon_unit
    if Unit.get_data(unit, 'unit_name') == 'units/gold_pan' then
        local world = Managers.world:world("level_world")
        local wwise_world = Wwise.wwise_world(world)
        local event = "pan_melee_new01"
        local sound = WwiseWorld.trigger_event(wwise_world, event, unit)
    end
end)

mod:hook_safe(ActionSweep,'_play_character_impact' ,function (self, is_server, attacker_unit, hit_unit, breed, hit_position, hit_zone_name, current_action, damage_profile, target_index, power_level, attack_direction, blocking, boost_curve_multiplier, is_critical_strike, backstab_multiplier)
    local unit = self.weapon_unit
    if Unit.get_data(unit, 'unit_name') == 'units/gold_pan' then
        local world = Managers.world:world("level_world")
        local wwise_world = Wwise.wwise_world(world)
        local event = "pan_melee_new01"
        local sound = WwiseWorld.trigger_event(wwise_world, event, unit)
    end
end)