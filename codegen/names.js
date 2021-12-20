// https://github.com/Aussiemon/Vermintide-2-Source-Code/blob/master/scripts/settings/equipment/weapon_properties.lua
const property_names = new Map()
property_names.set("Attack Speed", "attack_speed")
property_names.set("Stamina", "stamina")
property_names.set("Health", "health")
property_names.set("Block Cost Reduction", "block_cost")
property_names.set("Crit Chance", "crit_chance")
property_names.set("Crit Power", "crit_power")
property_names.set("Push/Block Angle", "push_block_arc")
property_names.set("Power vs Skaven", "power_vs_skaven")
property_names.set("Power vs Chaos", "power_vs_chaos")
property_names.set("Power vs Infantry", "power_vs_unarmoured")
property_names.set("Power vs Armored", "power_vs_armoured")
property_names.set("Power vs Berserkers", "power_vs_frenzy")
property_names.set("Power vs Monsters", "power_vs_large")
property_names.set("Damage reduction vs Skaven", "protection_skaven")
property_names.set("Damage reduction vs Chaos", "protection_chaos")
property_names.set("Damage reduction vs Area", "protection_aoe")
property_names.set("Curse Resistance", "curse_resistance")
property_names.set("Cooldown Reduction", "ability_cooldown_reduction")
property_names.set("Movement Speed", "movespeed")
property_names.set("Revive Speed", "revive_speed")
property_names.set("Respawn Speed", "respawn_speed")
property_names.set("Stamina Recovery Rate", "fatigue_regen")

// https://github.com/Aussiemon/Vermintide-2-Source-Code/blob/master/scripts/settings/equipment/weapon_traits.lua
const trait_names = new Map()
trait_names.set("Barkskin", "necklace_damage_taken_reduction_on_heal")
trait_names.set("Barrage", "ranged_consecutive_hits_increase_power")
trait_names.set("Boon of Shallya", "necklace_increased_healing_received")
trait_names.set("Concoction", "ring_all_potions")
trait_names.set("Conservative Shooter", "ranged_replenish_ammo_headshot")
trait_names.set("Decanter", "ring_potion_duration")
trait_names.set("Explosive Ordnance", "trinket_increase_grenade_radius")
trait_names.set("Grenadier", "trinket_not_consume_grenade")
trait_names.set("Hand of Shallya", "necklace_heal_self_on_heal_other")
trait_names.set("Healers Touch", "necklace_not_consume_healing")
trait_names.set("Heat Sink", "ranged_remove_overcharge_on_crit")
trait_names.set("Heroic Intervention", "melee_shield_on_assist")
trait_names.set("Home Brewer", "ring_not_consume_potion")
trait_names.set("Hunter", "ranged_increase_power_level_vs_armour_crit")
trait_names.set("Inspirational Shot", "ranged_restore_stamina_headshot")
trait_names.set("Natural Bond", "necklace_no_healing_health_regen")
trait_names.set("Off Balance", "melee_increase_damage_on_block")
trait_names.set("Opportunist", "melee_counter_push_power")
trait_names.set("Parry", "melee_timed_block_cost")
trait_names.set("Proxy", "ring_potion_spread")
trait_names.set("Resourceful Combatant", "melee_reduce_cooldown_on_crit")
trait_names.set("Resourceful Sharpshooter", "ranged_reduce_cooldown_on_crit")
trait_names.set("Scrounger", "ranged_replenish_ammo_on_crit")
trait_names.set("Shrapnel", "trinket_grenade_damage_taken")
trait_names.set("Swift Slaying", "melee_attack_speed_on_crit")
trait_names.set("Thermal Equalizer", "ranged_reduced_overcharge")

//ranged_increase_power_level_vs_armour_crit
//ranged_movespeed_on_damage_taken

function name_to_id(map, name) {
    let val = map.get(name);
    if (val === undefined) {
        throw name + " not recognised"
    } 
    return val
}

export function prop_name_to_id(name) {
    return name_to_id(property_names, name)
}


export function trait_name_to_id(name) {
    return name_to_id(trait_names, name)
}