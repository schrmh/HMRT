#!/bin/sh
#This might be integrated into HMRT.sh at some point

echo "Extract all LZ files & convert BCLIM to PNG"
mkdir -p lz/extracted/
for F in $(find ./ExtractedRomFS -name '*.lz') #recursive within ExtractedRomFS folder; not a perfect solution tho)
do  
    d=$(dirname -- "$F")
    fn=$(basename $F .lz) #E.g. hud.lz -> hud
    HMRT/darctool --extract $F lz/extracted/$fn
    for B in ./lz/extracted/$fn/timg/*.bclim
    do
        fnb=$(basename $B .bclim) #E.g. SubBtn_01.bclim -> SubBtn_01
        mkdir -p ./lz/converted/$fn/timg/
        HMRT/bclimtool.sh -dvfp $B ./lz/converted/$fn/timg/$fnb.png 2>/dev/null #there are some "illegal magnum" things I need to check out
    done
done

echo "Ignore the warning for now."
