-- local pprint = require("pprint").pprint
-- local lookups = require("ranalds_gift_lookups")
local lookups = dofile("scripts/mods/RanaldsGiftLoadout/ranalds_gift_lookups")

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

URL path segments after /heroes/ in order:
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
    PROP1 - PROP2 - TRAIT
    where PROP1 and PROP2 index PROPMAP, TRAIT indexes TRAITMAP 

CHARM:
    see NECKLACE

TRINKET:
    see NECKLACE

--]]

local function parse_talents(talent_spec)
    if not talent_spec or #talent_spec ~= 6 then
        return nil
    end

    local talents = {}
    for i = 1, 6 do 
        local t = tonumber(talent_spec:sub(i, i))
        if t and t >= 0 and t <= 3 then
            talents[i] = t
        else
            return nil
        end
    end
    return talents
end


local function parse_trait_and_properties(trait_category, prop_category, trait, prop1, prop2)
    local traits = lookups.traits[trait_category]
    local props = lookups.properties[prop_category]
    if not (traits and props) then
        return nil
    end

    trait = traits[tonumber(trait)]
    prop1 = props[tonumber(prop1)]
    prop2 = props[tonumber(prop2)]

    if prop1 and prop2 and trait then
        return {
            trait = trait,
            prop1 = prop1,
            prop2 = prop2,
        }
    end
end 

local function parse_weapon(s)
    if not s then return end
    local id, prop1, prop2, trait = string.gmatch(s, "(%d+)%-(%d+)%-(%d+)%-(%d+)")()
    local id = tonumber(id)
    if not id then return end
    local weapon = lookups.weapons[id]

    local item = parse_trait_and_properties(
        weapon.trait_category,
        weapon.property_category,
        trait,
        prop1,
        prop2
    )
    if item then
        item.type = weapon.item_type
        return item
    end
end

local function parse_jewellery(kind, s) 
    if not s then return end
    local prop1, prop2, trait = string.gmatch(s, "(%d+)%-(%d+)%-(%d+)")()
    local item = parse_trait_and_properties(kind, kind, trait, prop1, prop2)
    if item then
        if kind == "charm" then 
            item.type = "ring"
        else 
            item.type = kind
        end
        return item
    end
end


return function (url) 
    local career, talent_spec, primary, secondary, necklace, charm, trinket = string.gmatch(url, 
        '/(%d+)/(%d%d%d%d%d%d)/(%d+%-%d+%-%d+%-%d+)/(%d+%-%d+%-%d+%-%d+)/(%d+%-%d+%-%d+)/(%d+%-%d+%-%d+)/(%d+%-%d+%-%d+)$'
    )()

    -- print(url)
    -- print(necklace, trinket, charm)
    career = lookups.careers[tonumber(career)]
    talents = parse_talents(talent_spec)
    primary = parse_weapon(primary)
    secondary = parse_weapon(secondary)
    necklace = parse_jewellery('necklace', necklace)
    charm = parse_jewellery('charm', charm)
    trinket = parse_jewellery('trinket', trinket)

    -- print(career, talents, primary, secondary, necklace, charm, trinket)

    if not (career and talents and primary and secondary and necklace and trinket and charm) then
        return nil
    end

    return {
        career = career,
        talents = talents,
        primary = primary,
        secondary = secondary,
        necklace = necklace,
        trinket = trinket,
        charm = charm,        
    }
end

-- pprint(parse_url("https://www.ranalds.gift/heroes/15/012221/2-1-2-1/47-1-2-1/5-2-1/1-2-3/2-3-1"))
-- pprint(parse_url("https://www.ranalds.gift/heroes/12/211323/38-1-6-1/72-1-4-4/3-2-2/1-4-4/2-3-3"))
-- pprint(parse_url("https://www.ranalds.gift/heroes/12/211323/38-1-6-1/72-1-4-4/3-2-1/1-4-4/2-3-3"))