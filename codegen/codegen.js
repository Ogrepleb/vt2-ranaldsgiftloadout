#!/usr/bin/node
import { heroesDataMap } from "./HeroesDataMap.js";
import { propertiesData } from "./Properties.js";
import { traitsDataMap } from "./TraitsDataMap.js";
import { weaponsDataMap } from "./WeaponsDataMap.js";
import { weaponsData } from "./Weapons.js";
import { prop_name_to_id, trait_name_to_id } from "./names.js";
import { writeFileSync } from "fs";
import { fileURLToPath } from "url";
import * as path from "path";

let code = [];

code.push("local careers = { ")
for (let hero of heroesDataMap) {
    if (hero.codeName === "none") {
        continue
    }
    code.push(`    [${hero.id}] = '${hero.codeName}',`)
}
code.push("}", "")

code.push("local weapons = { ")
for (const w of weaponsDataMap) {
    const data = weaponsData[w.codeName]
    code.push(`    [${w.id}] = { `)
    code.push(`        item_type = '${w.codeName}',`)
    code.push(`        property_category = '${data.propertyCategory}',`)
    code.push(`        trait_category = '${data.traitCategory}',`)
    code.push("    },")
}
code.push("}", "")

code.push("local properties = {")
for (const item_group in propertiesData) {
    const group = { 
        "range" : "ranged",
        "offence_accessory" : "charm",
        "utility_accessory" : "trinket",
    }[item_group] || item_group;

    code.push(`    ${group} = {`)
    for (const prop of propertiesData[item_group]) {
        const prop_id = prop_name_to_id(prop.name)
        code.push(`        [${prop.id}] = '${prop_id}',`)
        
    }
    code.push(`    },`)
}
code.push("}", "")


code.push("local traits = {")
for (const item_group in traitsDataMap) {    
    const group = { 
        "defence_accessory" : "necklace",
        "offence_accessory" : "charm",
        "utility_accessory" : "trinket",
    }[item_group] || item_group;

    code.push(`    ${group} = {`)
    for (const prop of traitsDataMap[item_group]) {
        const prop_id = trait_name_to_id(prop.name)
        code.push(`        [${prop.id}] = '${prop_id}',`)
        
    }
    code.push(`    },`)
}
code.push("}", "")

code.push("return {")
for (const table of ["careers", "weapons", "traits", "properties"]) {
    code.push(`    ${table} = ${table},`)
}
code.push("}", "")

code = code.join("\n")

// console.log(code.join("\n"))
// console.log(propertiesData)
const dest = path.resolve(
    path.dirname(fileURLToPath(import.meta.url)), 
    "../scripts/mods/RanaldsGiftLoadout/ranalds_gift_lookups.lua"
)
writeFileSync(dest, code)