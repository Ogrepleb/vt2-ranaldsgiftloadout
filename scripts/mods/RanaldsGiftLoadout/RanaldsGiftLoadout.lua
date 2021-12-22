local mod = get_mod("RanaldsGiftLoadout")

local parse_url = dofile("scripts/mods/RanaldsGiftLoadout/parse_url")

mod.equipment_queue = {}
mod.is_equipping = false
mod.inventory_open = false
mod.talents_window = nil

local SLOT_NAMES = {
    secondary = 'slot_ranged',
    primary = 'slot_melee',
    necklace = 'slot_necklace',
    charm = 'slot_ring',
    trinket = 'slot_trinket_1'
}

mod.echo_localized = function(self, ...)
    mod:echo(mod:localize(...))
end

mod:command("loadout", " " .. mod:localize('cmd_desc'), function(...)
    local nargs = select("#", ...)
    local url = select(1, ...)
    mod:dofile("scripts/mods/RanaldsGiftLoadout/ranalds_gift_lookups")
    if not url or nargs ~= 1 then
        mod:echo_localized('errmsg_bad_args')
        return
    end
    if mod.is_equipping then
        mod:echo_localized('errmsg_busy_equipping')
        return
    end 

    local loadout = parse_url(url)
    if not loadout then
        mod:echo_localized('errmsg_invalid_url')
    end

    if mod.active_career() ~= loadout.career then
        mod:echo_localized('errmsg_switch_career', Managers.localizer:simple_lookup(CareerSettings[loadout.career].display_name))
        return
    end

    mod.set_loadout(loadout)
end)


mod.set_loadout = function(loadout) 
    local unit = Managers.player:local_player().player_unit
    if not (unit and Unit.alive(unit)) then return end

    local item_ifc = Managers.backend:get_interface("items")
    local items = item_ifc:get_all_backend_items()

    local equipment = {}

    equipment.primary = mod.find_item(items, loadout, 'primary')
    -- For careers like Slayer, make sure we don't equip 2 duplicate items
    equipment.secondary = mod.find_item(items, loadout, 'secondary', equipment.primary.backend_id)
    for _, slot in pairs({ 'necklace', 'charm', 'trinket'}) do 
        equipment[slot] = mod.find_item(items, loadout, slot)
    end

    for slot, slot_name in pairs(SLOT_NAMES) do
        if not mod.validate_loadout_item(loadout, equipment[slot], slot_name) then
            return
        end
    end
    
    
    -- Set talents (code based on HeroWindowTalents.on_exit)
    local talents_backend = Managers.backend:get_interface("talents")
    talents_backend:set_talents(loadout.career, loadout.talents)
    ScriptUnit.extension(unit, "talent_system"):talents_changed()
    local inventory_extension = ScriptUnit.extension(unit, "inventory_system")
    inventory_extension:apply_buffs_to_ammo()
        
    -- If the talents window is open, need to update it.  Otherwise, in HeroWindowTalents.on_exit
    -- the talents stored in  HeroWindowTalents will be applied, overriding the loadout
    if mod.talents_window then        
        mod.talents_window._selected_talents = table.clone(loadout.talents)
        mod.talents_window:_update_talent_sync()
    end

    -- Set equipment: There are two paths, depending on whether the equipment window
    -- is open or not
    if mod.inventory_open then
        mod.is_equipping = true
        -- Inventory is open, queue up the items 
        fassert(#mod.equipment_queue == 0, "equipment queue should be empty, check is_equipping")
        for slot, slot_name in pairs(SLOT_NAMES) do
            table.insert(mod.equipment_queue, { slot = slot_name, item = equipment[slot] })
        end
    else
        local attachment_extension = ScriptUnit.extension(unit, "attachment_system")
        for slot, slot_name in pairs(SLOT_NAMES) do
            local item = equipment[slot]
            BackendUtils.set_loadout_item(item.backend_id, loadout.career, slot_name)
            if slot == "primary" or slot == "secondary" then
                inventory_extension:create_equipment_in_slot(slot_name, item.backend_id)
            else
                attachment_extension:create_attachment_in_slot(slot_name, item.backend_id)
            end
        end
        -- Do I need to check if a network sync is happening?
    end
end

mod.validate_loadout_item = function (loadout, item, slot_name)
    if not item then return false end 

    -- Check the item is valid for the career 
    if not (item.data and item.data.can_wield and table.contains(item.data.can_wield, loadout.career)) then
        mod:echo_localized('errmsg_invalid_loadout', mod:localize('errmsg_invalid_loadout_career'))
        return false
    end

    -- Item is in the correct slot for that career
    local valid_slot_types = CareerSettings[loadout.career].item_slot_types_by_slot_name[slot_name];
    if not ( item.data and table.contains(valid_slot_types, item.data.slot_type )) then
        mod:echo_localized('errmsg_invalid_loadout', mod:localize('errmsg_invalid_loadout_slot'))
        return false
    end

    -- Don't need to check trait and properties types because the item comes from the backend
    -- so it must be valid

    return true
end

mod.active_career = function()
    local local_player = Managers.player:local_player()
    if local_player then
        local career_index = local_player:career_index() -- 1-4, for each character
        local profile_index = local_player:profile_index()
        
        local current_profile = SPProfiles[profile_index]
        local career = current_profile.careers[career_index]
        return career.name
    end
end

local function matches_type(item, spec) 
    if spec.type == "necklace" or spec.type == "ring" or spec.type == "trinket" then
        return item.data and item.data.item_type == spec.type
    else
        return item.ItemId == spec.type
    end
end 

local function item_is_candidate(item, spec) 
    if not matches_type(item, spec) or item.power_level == nil then
        return false
    end

    -- mod:echo("match! %s %s", pformat(item.traits),  pformat(spec, {level_width = 120}))

    if spec.trait then
        if not (item.traits and table.contains(item.traits, spec.trait)) then
            return false
        end
    end

    -- mod:echo("match! %s", pformat(spec))

    if spec.prop1 or spec.prop2 then
        if not item.properties then 
            return false
        end
        if spec.prop1 and item.properties[spec.prop1] == nil then
            return false
        end
        if spec.prop2 and item.properties[spec.prop2] == nil then
            return false
        end
    end
    
    return true
end


-- For two items, returns the better one.  prop1 and prop2 are optional.
-- a may be nil, but b may not
-- If prop1 either or prop2 are non-nil, a AND b must have .properties tables 
local function best_item(a, b, spec)
    if not a or a.power_level < b.power_level then
        return b -- base power Trumps all, most of the time this will be 300 anyway
    end

    local score_a = (a.properties[spec.prop1] or 0) + (a.properties[spec.prop2] or 0);
    local score_b = (b.properties[spec.prop1] or 0) + (b.properties[spec.prop2] or 0);
    
    if score_a < score_b then
        return b
    else
        return a
    end
end

-- Fallback for not matching any items, makes it clear that you need to craft something
local function find_template_item(items, spec)
    for _, item in pairs(items) do
        if matches_type(item, spec) and item.rarity == 'default' then
            return item
        end
    end
    mod:error("can't find template for %s", spec.type)
end

-- Fallback for finding a duplicate template item.  For example, if Slayer tries to load a 
-- build with two-pickaxes and has no matching ones, we would otherwise equip 2 template pickaxes.
-- We replace the second pickaxe with an arbitrary template item that matches the slot types
-- and career and is distinct from the pickaxe template (ignore_id)
local function find_any_template_item(items, career, slot, ignore_id)
    local slot_types = CareerSettings[career].item_slot_types_by_slot_name[SLOT_NAMES[slot]]
    for _, item in pairs(items) do
        if (item.backend_id ~= ignore_id and
            item.rarity == 'default' and
            item.data and item.data.can_wield and table.contains(item.data.can_wield, career) and
            table.contains(slot_types, item.data.slot_type)
        ) then
            return item
        end
    end
    mod:error("can't find template for %s, %s", career, slot)
end

mod.find_item = function (items, loadout, slot, ignore_id)
    local best = nil
    local spec = loadout[slot]

    for _, i in pairs(items) do
        if i.backend_id ~= ignore_id and item_is_candidate(i, spec) then
            best = best_item(best, i, spec)
        end
    end
    if best then
        return best
    else
        local item = find_template_item(items, spec)
        if item.backend_id == ignore_id then
            return find_any_template_item(items, loadout.career, slot, ignore_id)     
        else
            return item
        end

    end
end

mod:hook_safe(HeroViewStateOverview, 'on_enter', function()
    mod.inventory_open = true
end)


mod:hook_safe(HeroViewStateOverview, 'on_exit', function()
    mod.inventory_open = false
end)

mod:hook(HeroWindowTalents, 'on_enter', function(func, self, ...)
    mod.talents_window = self
    func(self, ...)
end)


mod:hook_safe(HeroWindowTalents, 'on_exit', function()
    mod.talents_window = nil
end)

-- Hook HeroViewStateOverview.post_update() to perform the actual equipping of
-- items when a loadout is restored, one at a time from the equipment queue.
mod:hook_safe(HeroViewStateOverview, "post_update", function(self, dt, t)
	local equipment_queue = mod.equipment_queue
    local unit = Managers.player:local_player().player_unit
    local inventory_extn = ScriptUnit.extension(unit, "inventory_system")
    local attachment_extn = ScriptUnit.extension(unit, "attachment_system")
    local busy = inventory_extn:resyncing_loadout() or attachment_extn.resync_id or self.ingame_ui._respawning
    if busy then return end
    -- We're good to go.

	if equipment_queue[1] then
		-- Block input while we are processing the queue to prevent the
		-- hero view being closed while we're still equipping stuff.
        self:block_input()

		-- Check whether we're ready to equip the next item.
		local unit = Managers.player:local_player().player_unit
		if unit and Unit.alive(unit) then
            local next_equip = table.remove(equipment_queue, 1)
            self:_set_loadout_item(next_equip.item, next_equip.slot)
		end
    else 
        mod.is_equipping = false
        self:unblock_input()
    end
end)
