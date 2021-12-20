local careers = { 
    [1] = 'es_mercenary',
    [2] = 'es_huntsman',
    [3] = 'es_knight',
    [16] = 'es_questingknight',
    [4] = 'dr_ranger',
    [5] = 'dr_ironbreaker',
    [6] = 'dr_slayer',
    [17] = 'dr_engineer',
    [7] = 'we_waywatcher',
    [8] = 'we_maidenguard',
    [9] = 'we_shade',
    [18] = 'we_thornsister',
    [10] = 'wh_captain',
    [11] = 'wh_bountyhunter',
    [12] = 'wh_zealot',
    [19] = 'wh_priest',
    [13] = 'bw_adept',
    [14] = 'bw_scholar',
    [15] = 'bw_unchained',
}

local weapons = { 
    [1] = { 
        item_type = 'bw_1h_mace',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [2] = { 
        item_type = 'bw_dagger',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [3] = { 
        item_type = 'bw_flame_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [4] = { 
        item_type = 'bw_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [5] = { 
        item_type = 'dr_1h_axe',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [6] = { 
        item_type = 'dr_1h_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [7] = { 
        item_type = 'dr_2h_axe',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [8] = { 
        item_type = 'dr_2h_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [9] = { 
        item_type = 'dr_2h_pick',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [10] = { 
        item_type = 'dr_dual_wield_axes',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [11] = { 
        item_type = 'dr_shield_axe',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [12] = { 
        item_type = 'dr_shield_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [13] = { 
        item_type = 'es_1h_flail',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [14] = { 
        item_type = 'es_1h_mace',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [15] = { 
        item_type = 'es_1h_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [16] = { 
        item_type = 'es_2h_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [17] = { 
        item_type = 'es_2h_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [18] = { 
        item_type = 'es_2h_sword_executioner',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [19] = { 
        item_type = 'es_halberd',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [20] = { 
        item_type = 'es_mace_shield',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [21] = { 
        item_type = 'es_sword_shield',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [22] = { 
        item_type = 'we_1h_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [23] = { 
        item_type = 'we_2h_axe',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [24] = { 
        item_type = 'we_2h_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [25] = { 
        item_type = 'we_dual_wield_daggers',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [26] = { 
        item_type = 'we_dual_wield_sword_dagger',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [27] = { 
        item_type = 'we_dual_wield_swords',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [28] = { 
        item_type = 'we_spear',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [29] = { 
        item_type = 'wh_1h_axe',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [30] = { 
        item_type = 'wh_1h_falchion',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [31] = { 
        item_type = 'wh_2h_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [32] = { 
        item_type = 'wh_fencing_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [33] = { 
        item_type = 'es_dual_wield_hammer_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [34] = { 
        item_type = 'es_2h_heavy_spear',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [35] = { 
        item_type = 'we_1h_axe',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [36] = { 
        item_type = 'we_1h_spears_shield',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [37] = { 
        item_type = 'dr_dual_wield_hammers',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [38] = { 
        item_type = 'wh_dual_wield_axe_falchion',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [39] = { 
        item_type = 'wh_2h_billhook',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [40] = { 
        item_type = 'bw_1h_crowbill',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [41] = { 
        item_type = 'bw_1h_flail_flaming',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [42] = { 
        item_type = 'es_sword_shield_breton',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [43] = { 
        item_type = 'es_bastard_sword',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [44] = { 
        item_type = 'dr_2h_cog_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [45] = { 
        item_type = 'bw_skullstaff_beam',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [46] = { 
        item_type = 'bw_skullstaff_fireball',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [47] = { 
        item_type = 'bw_skullstaff_flamethrower',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [48] = { 
        item_type = 'bw_skullstaff_geiser',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [49] = { 
        item_type = 'bw_skullstaff_spear',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [50] = { 
        item_type = 'dr_crossbow',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [51] = { 
        item_type = 'dr_drake_pistol',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [52] = { 
        item_type = 'dr_drakegun',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [53] = { 
        item_type = 'dr_handgun',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [54] = { 
        item_type = 'dr_rakegun',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [55] = { 
        item_type = 'es_blunderbuss',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [56] = { 
        item_type = 'es_handgun',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [57] = { 
        item_type = 'es_longbow',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [58] = { 
        item_type = 'es_repeating_handgun',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [59] = { 
        item_type = 'we_crossbow_repeater',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [60] = { 
        item_type = 'we_longbow',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [61] = { 
        item_type = 'we_shortbow',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [62] = { 
        item_type = 'we_shortbow_hagbane',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [63] = { 
        item_type = 'wh_brace_of_pistols',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [64] = { 
        item_type = 'wh_crossbow',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [65] = { 
        item_type = 'wh_crossbow_repeater',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [66] = { 
        item_type = 'wh_repeating_pistols',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [67] = { 
        item_type = 'dr_1h_throwing_axes',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [68] = { 
        item_type = 'dr_steam_pistol',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [69] = { 
        item_type = 'es_deus_01',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [70] = { 
        item_type = 'dr_deus_01',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [71] = { 
        item_type = 'we_deus_01',
        property_category = 'ranged',
        trait_category = 'ranged_energy',
    },
    [72] = { 
        item_type = 'wh_deus_01',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [73] = { 
        item_type = 'bw_deus_01',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [74] = { 
        item_type = 'we_life_staff',
        property_category = 'ranged',
        trait_category = 'ranged_heat',
    },
    [75] = { 
        item_type = 'we_javelin',
        property_category = 'ranged',
        trait_category = 'ranged_ammo',
    },
    [76] = { 
        item_type = 'wh_1h_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [77] = { 
        item_type = 'wh_2h_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [78] = { 
        item_type = 'wh_hammer_shield',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [79] = { 
        item_type = 'wh_dual_hammer',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [80] = { 
        item_type = 'wh_hammer_book',
        property_category = 'melee',
        trait_category = 'melee',
    },
    [81] = { 
        item_type = 'wh_flail_shield',
        property_category = 'melee',
        trait_category = 'melee',
    },
}

local properties = {
    melee = {
        [1] = 'attack_speed',
        [2] = 'stamina',
        [3] = 'block_cost',
        [4] = 'crit_chance',
        [5] = 'crit_power',
        [6] = 'push_block_arc',
        [7] = 'power_vs_skaven',
        [8] = 'power_vs_chaos',
    },
    ranged = {
        [1] = 'crit_chance',
        [2] = 'crit_power',
        [3] = 'power_vs_skaven',
        [4] = 'power_vs_chaos',
        [5] = 'power_vs_unarmoured',
        [6] = 'power_vs_armoured',
        [7] = 'power_vs_frenzy',
        [8] = 'power_vs_large',
    },
    necklace = {
        [1] = 'stamina',
        [2] = 'block_cost',
        [3] = 'health',
        [4] = 'push_block_arc',
        [5] = 'protection_skaven',
        [6] = 'protection_chaos',
        [7] = 'protection_aoe',
    },
    charm = {
        [1] = 'attack_speed',
        [2] = 'crit_power',
        [3] = 'power_vs_skaven',
        [4] = 'power_vs_chaos',
        [5] = 'power_vs_unarmoured',
        [6] = 'power_vs_armoured',
        [7] = 'power_vs_frenzy',
        [8] = 'power_vs_large',
    },
    trinket = {
        [1] = 'ability_cooldown_reduction',
        [2] = 'crit_chance',
        [3] = 'curse_resistance',
        [4] = 'movespeed',
        [5] = 'respawn_speed',
        [6] = 'revive_speed',
        [7] = 'fatigue_regen',
    },
}

local traits = {
    melee = {
        [1] = 'melee_shield_on_assist',
        [2] = 'melee_increase_damage_on_block',
        [3] = 'melee_counter_push_power',
        [4] = 'melee_timed_block_cost',
        [5] = 'melee_reduce_cooldown_on_crit',
        [6] = 'melee_attack_speed_on_crit',
    },
    ranged_ammo = {
        [1] = 'ranged_consecutive_hits_increase_power',
        [2] = 'ranged_replenish_ammo_headshot',
        [3] = 'ranged_increase_power_level_vs_armour_crit',
        [4] = 'ranged_restore_stamina_headshot',
        [5] = 'ranged_reduce_cooldown_on_crit',
        [6] = 'ranged_replenish_ammo_on_crit',
    },
    ranged_heat = {
        [1] = 'ranged_consecutive_hits_increase_power',
        [2] = 'ranged_remove_overcharge_on_crit',
        [3] = 'ranged_increase_power_level_vs_armour_crit',
        [4] = 'ranged_restore_stamina_headshot',
        [5] = 'ranged_reduce_cooldown_on_crit',
        [6] = 'ranged_reduced_overcharge',
    },
    ranged_energy = {
        [1] = 'ranged_consecutive_hits_increase_power',
        [3] = 'ranged_increase_power_level_vs_armour_crit',
        [4] = 'ranged_restore_stamina_headshot',
        [5] = 'ranged_reduce_cooldown_on_crit',
    },
    necklace = {
        [1] = 'necklace_damage_taken_reduction_on_heal',
        [2] = 'necklace_heal_self_on_heal_other',
        [3] = 'necklace_not_consume_healing',
        [4] = 'necklace_no_healing_health_regen',
        [5] = 'necklace_increased_healing_received',
    },
    charm = {
        [1] = 'ring_all_potions',
        [2] = 'ring_potion_duration',
        [3] = 'ring_not_consume_potion',
        [4] = 'ring_potion_spread',
    },
    trinket = {
        [1] = 'trinket_increase_grenade_radius',
        [2] = 'trinket_not_consume_grenade',
        [3] = 'trinket_grenade_damage_taken',
    },
}

return {
    careers = careers,
    weapons = weapons,
    traits = traits,
    properties = properties,
}
