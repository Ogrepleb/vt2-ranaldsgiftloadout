#!/bin/bash

URL="https://raw.githubusercontent.com/ranaldsgift/ranalds.gift/master/src/data/"
FILES=(
    WeaponsDataMap.js
    Weapons.js
    TraitsDataMap.js
    Properties.js
    HeroesDataMap.js   
)

for F in "${FILES[@]}" ; do 
    curl "${URL}${F}" -o "$F"
done