const trait_name = new Map()
https://github.com/Aussiemon/Vermintide-2-Source-Code/blob/master/scripts/settings/equipment/weapon_traits.lua
trait_name.set("Attack Speed", "attack_speed")


export function prop_name_to_id(name) {
    let val = trait_name.get(name);
    if (val === undefined) {
        throw name + " not recognised"
    } 
    return val
}