local mod = get_mod("RanaldsGiftLoadout")
local pprint = dofile("scripts/mods/RanaldsGiftLoadout/pprint")
local InventorySettings = InventorySettings
local SPProfiles = SPProfiles


--[[ URL PARSING
HEROMAP: https://github.com/ranaldsgift/ranalds.gift/blob/master/src/data/HeroesDataMap.js
TRAITMAP: https://github.com/ranaldsgift/ranalds.gift/blob/master/src/data/TraitsDataMap.js
    (split into melee, ranged etc)
WEAPONMAP: https://github.com/ranaldsgift/ranalds.gift/blob/master/src/data/WeaponsDataMap.js
PROPMAP: https://github.com/ranaldsgift/ranalds.gift/blob/master/src/data/Properties.js
    (split into melee, ranged etc)

Example
https://www.ranalds.gift/heroes/15/012221/2-1-2-1/47-1-2-1/5-2-1/1-2-3/2-3-1

https://www.ranalds.gift/heroes/HERO_ID/TALENTSTRING/MELEE/RANGED/NECKLACE/CHARM/TRINKET

URL path segments after /heroes/ in order
------------------------------------------
HERO_ID: indexes HEROMAP, gives career name

TALENTSTRING: 6 digits, one for each talent row (top to bottom)
    0 = None
    1 = Left col
    2 = Middle col 
    3 = Right col

MELEE: 
    WID - PROP1 - PROP2 - TRAIT
    where WID indexes WEAPONMAP, PROP1 and PROP2 index PROPMAP, TRAIT indexes TRAITMAP 

RANGED:
    see MELEE; identical.

NECKLACE:
    TRAIT - PROP1 - PROP2 
    where PROP1 and PROP2 index PROPMAP, TRAIT indexes TRAITMAP 

CHARM:
    see NECKLACE

TRINKET:
    see NECKLACE

--]]



-- Workaround for deletion (in patch 1.5) of a function required by SimpleUI.
-- UIResolutionScale = UIResolutionScale or UIResolutionScale_pow2

-- mod.simple_ui = nil --get_mod("SimpleUI")

-- mod.loadouts_data = nil
-- mod.fatshark_view = nil
-- mod.is_in_hero_select_popup = false
-- mod.loadouts_window = nil
-- mod.loadout_details_window = nil
-- mod.equipment_queue = {}
-- mod.is_loading = false

local function test_data()  
    return {
        career = "wh_captain",
        talents = {1, 2, 3, 3, 3, 3},


    }
end

-- Perform initial setup.
mod.on_all_mods_loaded = function()
    -- this just loaded and initialised simple UI
end

mod:command("foo", "debug", function () 
    mod:get_hero_and_career()
    
end)

local function list_contains(list, item)
    for _, i in ipairs(list) do
        if i == item then 
            return true
        end
    end
    return false
end

local function find_template_item(items, item_type)
    for _, item in pairs(items) do
        if item.data and item.data.item_type == item_type and item.rarity == 'default' then
            return item
        end
    end
    mod:error("can't find template for %s", item_type)
end

local function weapon_is_candidate(item, item_type, trait, prop1, prop2) 
    if not (item.data and item.data.item_type == item_type ) or item.power_level == nil then
        return false
    end

    if trait then
        if not (item.traits and list_contains(item.traits, trait)) then
            return false
        end
    end

    if prop1 or prop2 then
        if not item.properties then 
            return false
        end
        if prop1 and item.properties[prop1] == nil then
            return false
        end
        if prop2 and item.properties[prop2] == nil then
            return false
        end
    end
    
    return true
end

-- For two items, returns the better one.  prop1 and prop2 are optional.
-- If prop1 either or prop2 are non-nil, a AND b must have .properties tables 
local function best_item(a, b, prop1, prop2)
    if a.power_level < b.power_level then
        return b -- base power Trumps all, most of the time this will be 300 anyway
    end

    local d1 = 0;
    local d2 = 0;

    if prop1 then
        local va = a.properties[prop1] or 0
        local vb = b.properties[prop1] or 0
        d1 = va - vb
    end

    if prop1 then
        local va = a.properties[prop2] or 0
        local vb = b.properties[prop2] or 0
        d2 = va - vb
    end

    if d1 < 0 and d2 < 0 then
        -- b is better both ways
        return b
    elseif d1 > 0 and d2 > 0 then
        -- a is better both ways
        return a
    elseif d1 < 0 and -d1 < d2 then
        -- b is better for prop1, but a is more better in prop2
        return a
    else
        -- vice versa
        return b
    end
end



-- Returns the hero name, career name, and career index of the career whose loadouts
-- should be displayed.
mod.get_hero_and_career = function(self)
    local local_player = Managers.player:local_player()

	local career_index = local_player:career_index() -- 1-4, for each character
	local profile_index = local_player:profile_index()
	
    local current_profile = SPProfiles[profile_index]
	local career = current_profile.careers[career_index]
    local career_name = career.name

    -- mod:echo(career.name) -- 
    -- mod:echo("%d", career_index)

    -- for example:
    --  we_maidenguard, 2 (for Handmaiden) 
    
    -- Backend IDs refer to the INSTANCE of the item you have.  You can have identical items, but 
    -- they will have different backend IDs    
	-- for _, slot in ipairs(InventorySettings.slots_by_ui_slot_index) do
	-- 	local item_backend_id = BackendUtils.get_loadout_item_id(career.name, slot.name)
    --     mod:echo(item_backend_id)
    --     mod:echo(slot.name)
	-- end


    local item_ifc = Managers.backend:get_interface("items")
    local items = item_ifc:get_all_backend_items()
    
    -- for _, item in pairs(items) do
    --     -- if weapon_is_candidate(item, 'wh_captain', 'wh_brace_of_pistols', 'ranged_replenish_ammo_headshot', 'crit_chance', 'power_vs_large') then
    --     -- if weapon_is_candidate(item, 'wh_captain', 'wh_brace_of_pistols', nil, 'crit_chance', nil) then
    --     --     self:echo(pprint.pformat(item))
    --     -- end
    --     -- self:echo(item.ItemId, item.key)
    --     if item.data and item.data.item_type == 'trinket' then
    --         -- self:echo("key=%s power=%d", item.key or "", item.power_level or 0)
    --         self:echo(pprint.pformat(item))
    --     end
    -- end

	local talents_backend = Managers.backend:get_interface("talents")
	local talents_loadout = table.clone(talents_backend:get_talents(career_name))

    self:echo("talents = %s", pprint.pformat(talents_loadout))
    -- talents_backend:set_talents(career_name)
	-- local fatshark_view = self.fatshark_view
	-- if self.is_in_hero_select_popup then
	-- 	return fatshark_view._selected_hero_name, fatshark_view._selected_career_name, fatshark_view._selected_career_index
	-- else
	-- 	local profile_index = FindProfileIndex(fatshark_view.hero_name)
	-- 	local profile = SPProfiles[profile_index]
	-- 	local career_index = fatshark_view.career_index
	-- 	local career_name = profile.careers[career_index].name
	-- 	return fatshark_view.hero_name, career_name, career_index
	-- end

    talents_backend:set_talents(career_name, {0, 1, 1, 1, 1, 1})
    local unit = Managers.player:local_player().player_unit
    if unit and Unit.alive(unit) and is_active_career then
        ScriptUnit.extension(unit, "talent_system"):talents_changed()
        ScriptUnit.extension(unit, "inventory_system"):apply_buffs_to_ammo()
    end
    
    return career_name, career_index
end

-- These should fallback to the template item if nothing can be found?

-- Kind is necklace, trinket or charm
-- Returns backend item ID
mod.find_jewellry = function (kind, trait, property1, property2)

end

-- Returns backend item ID
mod.find_melee_weapon = function (career, trait, property1, property2)

end

-- Returns backend item ID
mod.find_ranged_weapon = function (career, trait, property1, property2) 

end

-- Returns backend item ID
mod.equip_talents = function (career, talent_list)

end
--[[

-- Returns the loadout with the given loadout number, for the given career.
mod.get_loadout = function(self, loadout_number, career_name)
	return self.loadouts_data[(career_name .. "/" .. tostring(loadout_number))]
end

-- Modifies and saves the loadout with the given loadout number, for the given
-- career.  The existing loadout is passed to the given function (an empty loadout
-- is created if there isn't one) and then saved after it returns.
mod.modify_loadout = function(self, loadout_number, career_name, modifying_functor)
	local loadout = self:get_loadout(loadout_number, career_name)
	if not loadout then
		loadout = {}
		self.loadouts_data[(career_name .. "/" .. tostring(loadout_number))] = loadout
	end
	modifying_functor(loadout)

	self.cloud_file:cancel()
	self.cloud_file:save(self.loadouts_data)
end


-- Saves the given career's currently equipped gear, talents, and cosmetics to
-- the loadout with the given loadout number.
mod.save_loadout = function(self, loadout_number, career_name)
	local gear_loadout = {}
	local cosmetics_loadout = {}

	-- Add the current gear.
	for _, slot in ipairs(InventorySettings.slots_by_ui_slot_index) do
		local item_backend_id = BackendUtils.get_loadout_item_id(career_name, slot.name)
		if item_backend_id then
			gear_loadout[slot.name] = item_backend_id
		end
	end

	-- Add the current cosmetics.
	for _, slot in ipairs(InventorySettings.slots_by_cosmetic_index) do
		local item_backend_id = BackendUtils.get_loadout_item_id(career_name, slot.name)
		if item_backend_id then
			cosmetics_loadout[slot.name] = item_backend_id
		end
	end

	-- Add the current talents.
	local talents_backend = Managers.backend:get_interface("talents")
	local talents_loadout = table.clone(talents_backend:get_talents(career_name))

	self:modify_loadout(loadout_number, career_name, function(loadout)
		loadout.gear = gear_loadout
		loadout.talents = talents_loadout
		loadout.cosmetics = cosmetics_loadout
	end)
end

-- [[ COMMENTED OUT


-- This check is required to eliminate a couple of exploits that allowed players to equip items on careers
-- for which they weren't intended.  (One exploit relied on quickly switching careers mid-restore, another
-- involved creating loadouts in the modded realm then using them in the official realm.)
local function is_equipment_valid(item, career_name, slot_name)
	-- First check that the current career can wield the item being equipped.
	local item_data = item.data
	local is_valid = table.contains(item_data.can_wield, career_name)
	if not is_valid then
		mod:echo("ERROR: cannot equip item " .. item_data.display_name .. " on career " .. career_name)
	else
		-- Also check that the item is going into an appropriate slot.
		local actual_slot_type = item_data.slot_type
		local expected_slot_type = InventorySettings.slots_by_name[slot_name].type
		if career_name == "dr_slayer" and expected_slot_type == ItemType.RANGED then
			expected_slot_type = ItemType.MELEE
		end

		is_valid = (actual_slot_type == expected_slot_type)
		if not is_valid then
			mod:echo("ERROR: cannot equip item " .. item_data.display_name .. " in this slot type: " .. expected_slot_type)
		end
	end
	return is_valid
end

-- Equips the given career's with the gear, talents, and cosmetics from the
-- loadout with the given loadout number.
mod.restore_loadout = function(self, loadout_number, career_name, exclude_gear, exclude_talents, exclude_cosmetics)
	local name = self:get_name()
	local loadout = self:get_loadout(loadout_number, career_name)
	if not loadout then
		self:echo("Error: loadout #"..tostring(loadout_number).." not found for career "..career_name)
		return
	end
	local is_active_career = not self.is_in_hero_select_popup

	-- Restore talent selection (code based on HeroWindowTalents.on_exit)
	local talents_loadout = (not exclude_talents) and loadout.talents
	if talents_loadout then
		local talents_backend = Managers.backend:get_interface("talents")
		talents_backend:set_talents(career_name, talents_loadout)
		local unit = Managers.player:local_player().player_unit
		if unit and Unit.alive(unit) and is_active_career then
			ScriptUnit.extension(unit, "talent_system"):talents_changed()
			ScriptUnit.extension(unit, "inventory_system"):apply_buffs_to_ammo()
		end
	end

	-- Restore the gear and cosmetics. Part of each equipment change may be done
	-- asynchronously, so we add each item to a queue and perform the next change
	-- only when the current one is finished (in the hook of
	-- HeroViewStateOverview.post_update() below).
	local gear_loadout = (not exclude_gear) and loadout.gear
	local cosmetics_loadout = (not exclude_cosmetics) and loadout.cosmetics
	if gear_loadout or cosmetics_loadout then
		local equipment_queue = self.equipment_queue
		local items_backend = Managers.backend:get_interface("items")

		for _, slot in pairs(InventorySettings.slots_by_slot_index) do
			local item_backend_id = (gear_loadout and gear_loadout[slot.name]) or (cosmetics_loadout and cosmetics_loadout[slot.name])
			local item = item_backend_id and items_backend:get_item_from_id(item_backend_id)
			if item then
				local current_item_id = BackendUtils.get_loadout_item_id(career_name, slot.name)
				if not current_item_id or current_item_id ~= item_backend_id then
					if is_active_career then
						equipment_queue[#equipment_queue + 1] = { slot = slot, item = item }
					elseif is_equipment_valid(item, career_name, slot.name) then
						BackendUtils.set_loadout_item(item_backend_id, career_name, slot.name)
					end
				end
			end
		end
	end

	local completion_message = sprintf("Loadout #%d restored for hero %s", loadout_number, career_name)
	if #self.equipment_queue > 0 then
		self:echo(sprintf("Restoring loadout #%d for hero %s ...", loadout_number, career_name))
		self.completion_message = completion_message
	else
		self:echo(completion_message)
	end
end



local is_hero_preview_hooked = false


-- Checks whether the next item in the equipment queue can be validly equipped
-- in the specified slot by the current career.
local function is_next_equip_valid(next_equip)
	local fatshark_view = mod.fatshark_view
	if not fatshark_view then
		return false
	end

	local _, career_name = mod:get_hero_and_career()
	return is_equipment_valid(next_equip.item, career_name, next_equip.slot.name)
end

-- Hook HeroViewStateOverview.post_update() to perform the actual equipping of
-- items when a loadout is restored, one at a time from the equipment queue.
mod:hook_safe(HeroViewStateOverview, "post_update", function(self, dt, t)
	local equipment_queue = mod.equipment_queue
	local busy = false
	if equipment_queue[1] or mod.completion_message then
		-- Block input while we are processing the queue to prevent the
		-- hero view being closed while we're still equipping stuff.
		if not mod.is_loading then
			mod.is_loading = true
			self:block_input()
		end

		-- Check whether we're ready to equip the next item.
		local unit = Managers.player:local_player().player_unit
		if unit and Unit.alive(unit) then
			local inventory_extn = ScriptUnit.extension(unit, "inventory_system")
			local attachment_extn = ScriptUnit.extension(unit, "attachment_system")
			busy = inventory_extn:resyncing_loadout() or attachment_extn.resync_id or self.ingame_ui._respawning
			if not busy and equipment_queue[1] then
				-- We're good to go.
				local next_equip = equipment_queue[1]
				table.remove(equipment_queue, 1)
				busy = true

				if is_next_equip_valid(next_equip) then
					local slot = next_equip.slot
					self:_set_loadout_item(next_equip.item, slot.name)
					if slot.type == ItemType.SKIN then
						self:update_skin_sync()
					end
				end
			end
		end
	elseif mod.is_loading then
		-- We've finished equipping stuff, unblock input.
		mod.is_loading = false
		self:unblock_input()
	end

	-- Print the completion message once we're no longer busy.
	if mod.completion_message and not busy then
		mod:echo(mod.completion_message)
		mod.completion_message = nil
	end
end)


-- Returns the index corresponding to the career with the given name.
local function get_career_index_from_name(profile, career_name)
	for career_index, career in ipairs(profile.careers) do
		if career.name == career_name then
			return career_index
		end
	end
	return nil
end
--]]