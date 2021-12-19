pprint = require("pprint").pprint
url = "https://www.ranalds.gift/heroes/15/012221/2-1-2-1/47-1-2-1/5-2-1/1-2-3/2-3-1"

career, talent_spec, melee, ranged, necklace, trinket, charm = string.gmatch(url, '/(%d+)/(%d%d%d%d%d%d)/(%d+%-%d+%-%d+%-%d+)/(%d+%-%d+%-%d+%-%d+)/(%d+%-%d+%-%d+)/(%d+%-%d+%-%d+)/(%d+%-%d+%-%d+)$')()

local function parse_talent_spec(talent_spec)
    if not talent_spec or #talent_spec ~= 6 then
        return nil
    end

    local talents = {}
    for i = 1, 6 do 
        local t = tonumber(talent_spec:sub(i, i))
        print(t)
        if t and t >= 0 and t <= 3 then
            print("ok")
            talents[i] = t
        else
            return nil
        end
    end
    return talents
end

career = tonumber(career)
talents = parse_talent_spec(talent_spec)


-- for career, talents, melee, ranged, necklace, trinket, charm in  do 
--     print(career)
--     print(talents)
--     print(melee)
--     print(ranged)
--     print(necklace)
--     print(trinket)
--     print(charm)
-- end
