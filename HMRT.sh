#!/bin/bash
#include this boilerplate
function jumpto
{
    #echo UNSER $PWD
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
function pause(){
   read -p "$*"
}

start=${1:-"start"}

jumpto $start

start:

#Windows batch variables:
# Overview: https://ss64.com/nt/syntax-args.html

# %~dp0 will expand to the path to the directory where the file is in
# https://www.reddit.com/r/linuxquestions/comments/1jlgsw/can_someone_explain_this_bash_string_for_me/
# https://stackoverflow.com/questions/207959/equivalent-of-dp0-in-sh
# http://openbook.rheinwerk-verlag.de/shell_programmierung/shell_011_002.htm
# Kind of equivalent?: $(dirname "$(readlink -fn "$0")")

# Or better just to use dirname $0?

# if NOT [%1]==[] () checks wether parameter is NOT empty
# https://www.ibm.com/support/knowledgecenter/de/ssw_aix_72/osmanagement/korn_shell_conditional_exp.html
# https://www.cyberciti.biz/faq/unix-linux-bash-script-check-if-variable-is-empty/
# https://developer.ibm.com/tutorials/l-bash-parameters/
# Kind of equivalent?: if [ -n "$1" ] then fi

# %~x1 extends to the extension e.g. .txt
# https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# Kind pf equivalent?: $(echo  $1  | sed 's/.*\././')


# %~dpn1 means drive e.g. C: + path e.g. /something/ + name e.g. HomeMenu without extension and bracketing quotes
# https://www.imagemagick.org/Usage/windows/
# Kind pf equivalent?: basename /path/to/dir/filename.txt .txt
# Yes this doesn't give the path but this may be not needed..

# !variable!
# https://stackoverflow.com/questions/14354502/difference-between-variable-and-variable-in-batch-file
# https://stackoverflow.com/questions/10558316/example-of-delayed-expansion-in-batch-file
# https://www.unix.com/shell-programming-and-scripting/101380-bash-delay-expansion-variable.html
# https://stackoverflow.com/questions/40345543/bash-delayed-expansion-and-nested-variables
# https://stackoverflow.com/questions/26929684/delayed-variable-expansion-in-bash
# Kind of equivalent?: Is there really a equivalent needed?

# goto
# https://stackoverflow.com/questions/9639103/is-there-a-goto-statement-in-bash
# Kind of equivalent?: https://bobcopeland.com/blog/2012/10/goto-in-bash/

# for
# https://ss64.com/nt/for_f.html
# tokens=1,2 causes first and second item on each line to be proceed
# delims=# # acts as delimiter
# prompt 
# https://de.wikibooks.org/wiki/Batch-Programmierung:_Batch-Befehle#!_(Ausrufezeichen)
# https://ss64.com/nt/prompt.html

# if NOT exist
# https://stackoverflow.com/questions/638975/how-do-i-tell-if-a-regular-file-does-not-exist-in-bash
# https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
# Kind of equivalent?: 
# FILES: if ! [ -e "$file" ]; then fi 
# DIRECTORIES: if [ ! -d "$DIRECTORY" ]; then fi

# if exist *.extension"
# https://stackoverflow.com/a/3856879
# count=`ls -1 *.flac 2>/dev/null | wc -l`
# if [ $count != 0 ]; then fi

# set /p variablename="TEXT"
# https://ryanstutorials.net/bash-scripting-tutorial/bash-input.php
# https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
# Kind of equivalent?: read -p "TEXT" variablename




#folder script is in. CAUTION: DO NOT ADD COMMENT AFTER THE NEXT LINE!
#dp0=$(dirname "$(readlink -fn "$0")")

dp0="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo $dp0

echo "Home Menu Rebuilding Tool [By TheDeKay & schrmh]"
HMRTver=0.8-L1
HMRTch="[Dev]"  

#switch to shell script file's drive:
cd "$dp0"
if [ -n "$1" ]; #if parameter not empty
then
    ext=$(echo  $1  | sed 's/.*\././')

    if [ $ext = ".cia" ]; then
        ciaName=$dp0/$(basename $1 .cia) #@reader: remove $dp0/ if it doesn't work..
        expName="$ciaName"_edited
    elif [ $ext = ".bin" ]; then
        jumpto LZDECOMPRESSOR
    fi
fi

#for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do ( #sets the colours for the block above the options in the main menu; may be hard to do..
#  set "DEL=%%a"
#)


# ============ USER VARIABLES =============================
# ciaName: Input File (HomeMenu) NO EXTENSION
# expName: Output File (HomeMenu_edited) NO EXTENSION
# SDDrive: Letter for the SD Drive

encheader=NCCH.encheader
HMRTdir=$dp0/HMRT
xordir=$dp0/xorpads
LogFile="$dp0/LZ.log"
ciaName="$dp0/HomeMenu" #doesn't work always..
expName="$ciaName"_edited

STARTEN:
defIP=192.168.178.16

# ========================================================

#echo $HMRTdir
#cd $HMRTdir
usrchoice=0
# title Home Menu Rebuilding Tool [By TheDeKay] #do later. Open new shell and set title
clear
#call :cPrint 7C #do later; may be hard
echo "                                                                    Home Menu Rebuilding Tool v$HMRTver $HMRTch"
#call :cPrint 79 "                                 
echo "by TheDeKay & schrmh "
#call :cPrint 71 
echo "                                                                                                Thanks to Asia81 and Zan'"
#call :cPrint 78 "     y
echo "http://axities.github.io                     _________________________________________________________"
echo
echo   "[1] Extract CIA"
echo   "[2] Build encrypted CIA"
echo   "[3] Clean Folder"
echo   "[4] Install via FBI (Network Install)"
echo   "[5] Decompress all LZ files"
echo   "[6] Recompress all LZ files"
echo   "[7] Copy to SD (Auto-detect)"
echo   "[8] Full Rebuild (Steps: 1, 5, Edit, 6, 2, 3, 4)"
echo   "[9] Generate ncchinfo.bin"
echo   "[Q] Exit program"
echo
echo ">      Press your choice [Number]: "
clear
# https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
choice=("Extract CIA" "Build encrypted CIA" "Clean Folder {WIP}" "Install via FBI (Network Install) {WIP}" "Decompress all LZ files" "Recompress all LZ files" "Copy to SD (Auto-detect) {WIP}" "Full Rebuild (Steps: 1, 5, Edit, 6, 2, 3, 4) {3&4 WIP}" "Generate ncchinfo.bin {WIP}" "Exit program")
select usrchoice in "${choice[@]}"
do
    case $usrchoice in
        "Extract CIA") #1
            jumpto EXTRACT
            ;;
        "Build encrypted CIA") #2
            jumpto BUILD
            ;;
        "Clean Folder {WIP}") #3
            jumpto CLEAN
            ;;
        "Install via FBI (Network Install) {WIP}") #4
            jumpto FBI
            ;;
        "Decompress all LZ files") #5
            jumpto DECOMP
            ;;
        "Recompress all LZ files") #6
            jumpto RECOMP
            ;;
        "Copy to SD (Auto-detect) {WIP}") #7
            jumpto COPYSD
            ;;
        "Full Rebuild (Steps: 1, 5, Edit, 6, 2, 3, 4) {3&4 WIP}") #8
            #Continue
            jumpto CONTINUE
            ;;
        "Generate ncchinfo.bin {WIP}") #9
            jumpto NCCHINFO
            ;;
        "Exit program") #10
            exit
            ;;
        *) echo "Invalid option $REPLY. Press CTRL+C or write Q to break/quit.";; 
    esac
done

CONTINUE:
EXTRACT:
#title Home Menu Rebuilding Tool [Extracting]
if ! [ -e "$(basename $ciaName .cia).cia" ]; then
    echo "Couldn't find CIA file."
	echo "You can specify a default CIA Name"
	echo "in the USER VARIABLES.(example ciaName=HomeMenu^)"
	echo "Or simply drag a CIA to extract onto this Tool."
	echo
	read -p "Enter filename (no extension): " ciaName
fi
cd $HMRTdir #cases didn't work.. this is why we change dir now..
rm *.0000.*
wine ctrtool.exe "$ciaName.cia" --content=Content
shopt -s nullglob #Guard; exit without trying to process a non-existent file: https://stackoverflow.com/a/14505622
for S in *.0000.* #set ~nxS name and extension of S
do
 echo "cxi0: $S"
    cxi0=$S
done
wine 3dstool.exe -xvtf cxi $cxi0 --header NCCH.Header --exh DecryptedExHeader.bin --exefs DecryptedExeFS.bin --romfs DecryptedRomFS.bin --logo Logo.bcma.LZ --plain PlainRGN.bin
wine 3dstool.exe -xuvtf exefs DecryptedExeFS.bin --exefs-dir ../ExtractedExeFS --header ExeFS.Header
rm -rf ../ExtractedRomFS
wine 3dstool.exe -xvtf romfs DecryptedRomFS.bin --romfs-dir ../ExtractedRomFS
if ! [ -d "../ExtractedRomFS" ]; then
    echo "Contact me @derberg:matrix.org"
    #dpnxF d‎rive, p‎ath, base‎n‎ame and e‎x‎tension of the current file.
	for F in "../xorpads/*romfs.xorpad"; do rfsxor=$(readlink -f $F); done
	for F in "../xorpads/*exefs_norm.xorpad"; do efsxor=$(readlink -f $F); done
	for F in "../xorpads/*exheader.xorpad"; do exhxor=$(readlink -f $F); done
	wine 3dstool.exe -xvtf cxi "$cxi0" --header NCCH.Header --exh DecryptedExHeader.bin --exh-xor "$exhxor" --exefs DecryptedExeFS.bin --exefs-xor "$efsxor" --romfs DecryptedRomFS.bin --romfs-xor "$rfsxor" --plain PlainRGN.bin
	wine 3dstool.exe -xuvtf exefs DecryptedExeFS.bin --exefs-dir ../ExtractedExeFS --header ExeFS.Header
	wine 3dstool.exe -xvtf romfs DecryptedRomFS.bin --romfs-dir ../ExtractedRomFS
	if ! [ -e "$encheader" ]; then cp NCCH.Header $encheader; fi
	encheader=NCCH.Header
fi
if [ "$usrchoice" != 8 ]; then
    cd "$dp0"
    jumpto STARTEN
fi
DECOMP:
cd $dp0
echo "LZ Decompressionlog [$dp0]" >> $LogFile
echo =====================================================>> $LogFile
cntT=0
cntS=0
#title Home Menu Rebuilding Tool [Decompressor]
shopt -s nullglob
for F in $(find ./Extracted[RE][ox][me]FS -name '*LZ.bin') #recursive within Extracted folders (R or E, o or x, m or e; not a perfect solution tho)
do  
    d=$(dirname -- "$F")
    echo FILE $F
    echo DIR $d
	cntT=$(($cntT+1))
    fn=$(basename $F .bin) #E.g. miiverse_intro_LZ
    file=$(echo $fn | sed 's/\(.*\)_/\1./') #E.g. miiverse_intro.LZ ; maybe append tr 'LZ' 'lz'
	echo "Decompressing: $file"
	wine "$HMRTdir/3dstool.exe" -uvf "$F" --compress-type lzex --compress-out "$fn.lz" #> NUL #check if correct... Is miiverse_intro_LZ.lz correct?
	if [ -e "$fn.lz" ]; 
	then 
		rm $F #> NUL
		echo PARENT ${PWD}
		mv $fn.lz $d/$(basename $file .LZ).lz
		echo $(date +%s) $F "decompressed!" >> $LogFile #unixtime
		cntS=$(($cntS+1))
    else
		echo $(date +%s) $F "couldn't be decompressed" >> $LogFile #unixtime
	fi
done
echo $(date +%s) "Finished $cntS/$cntT decompressed" >> $LogFile #unixtime
echo =====================================================>> $LogFile
cd $HMRTdir
if [ "$usrchoice" != 8 ]; then
    cd "$dp0"
    jumpto STARTEN
fi

echo "Contents of the CIA file have been extracted"
echo "All LZ files have been decompressed"
echo "Do your Edits now."
# nemo $dp0/ExtractedRomFS" #Open folder.. Dunno wether I should do this. Disabled for now.
echo
pause 'Press Enter to continue with recompressing and rebuilding.'

RECOMP:
recomp() {
cd "$dp0"
echo LZ Recompressionlog [$dp0] >> $LogFile
echo =====================================================>> $LogFile
cntT=0
cntS=0
#title Home Menu Rebuilding Tool [Compressor]
shopt -s nullglob
for F in $(find ./Extracted[RE][ox][me]FS -iname '*lz') #recursive within Extracted folders (R or E, o or x, m or e; not a perfect solution tho)
do
    d=$(dirname -- "$F")
    echo FILE $F
    echo DIR $d
	cntT=$(($cntT+1))
	[ "$d/$(basename $F .lz).lz" = "$F" ] && fn=$(basename $F .lz) || fn=$(basename $F .LZ) #Linux || Windows; E.g. miiverse_intro
	file=$(echo "$fn+LZ.bin" | sed 's/\(.*\)+/\1_/') #E.g. miiverse_intro_LZ.bin ; $fn_LZ.bin is not possible in bash.
	echo "Compressing: $file"
	wine "$HMRTdir/3dstool.exe" -zvf "$F" --compress-type lzex --compress-out "$file"
	if [ -e "$file" ]; 
    then 
		rm $F #> NUL
		echo PARENT ${PWD}
		mv "$file" $d/"$file"
		echo $(date +%s) $F compressed! >> $LogFile
		cntS=$(($cntS+1))
    fi
done
echo $(date +%s) Finished $cntS/$cntT compressed >> $LogFile
echo =====================================================>> $LogFile
cd $HMRTdir
if [ "$usrchoice" == 2 ]; then
    break
fi
if [ "$usrchoice" != 8 ]; then
    cd "$dp0"
    jumpto STARTEN
fi
}
recomp

BUILD:
#title Home Menu Rebuilding Tool [Building]
if [ -z "$expName" ]; 
then
    echo "No name specified for the CIA file."
	echo "You can specify a default name"
	echo "in the USER VARIABLES.(example ciaName=HomeMenu^)"
	echo
	read -p "Enter filename (no extension): " expName
fi
cd $HMRTdir
#rm ../ExtractedRomFS/*.bak #I guess files created by some hex editor. But why only in that folder?
pause "Press enter once  {WIP: Move to BUILD maybe?}"
count=`find ../ExtractedRomFS -maxdepth 1 -type f -name "*.lz" | wc -l`
if [ "$count" -ne 0 ]
then
    echo "Calling RECOMP"
    pause "Enter"
    recomp #Sub routine; call recomp function. Dunno wether there is a way with labels without additional if statements..
fi
pause "Press enter once again {WIP: REPLACE maybe?}"
wine 3dstool.exe -cvtf romfs CustomRomFS.bin --romfs-dir ../ExtractedRomFS
wine 3dstool.exe -czvtf exefs CustomExeFS.bin --exefs-dir ../ExtractedExeFS --header ExeFS.Header
for S in *.0000.* #set ~nxS name and extension of S
do
 echo "cxi0: $S"
    cxi0=$S
done

echo "$expName.cia will be the path to your new cia."
count=`ls -1 ../xorpads/*.xorpad 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
    echo "Contact me @derberg:matrix.org :)"
	for F in "../xorpads/*romfs.xorpad"; do rfsxor=$(readlink -f $F); done
	for F in "../xorpads/*exefs_norm.xorpad"; do efsxor=$(readlink -f $F); done
	for F in "../xorpads/*exheader.xorpad"; do exhxor=$(readlink -f $F); done	
	wine 3dstool.exe -cvtf cxi "$cxi0" --header "$encheader" --exh DecryptedExHeader.bin --plain PlainRGN.bin --exefs CustomExeFS.bin --romfs CustomRomFS.bin --exh-xor "$exhxor" --exefs-xor "$efsxor" --romfs-xor "$rfsxor"
	if [ "$usrchoice" == 8 ]; then
        fbiblock=""
    fi
else
    wine 3dstool.exe -cvtf cxi "$cxi0" --header NCCH.Header --exh DecryptedExHeader.bin --plain PlainRGN.bin --exefs CustomExeFS.bin --romfs CustomRomFS.bin
	echo
	echo Missing XORpads to build encrypted CIA.
	echo CIA will not be encrypted.
	echo You need to use Decrypt9 or GodMode9 to encrypt CIA.
	echo -e "\033[1;31mIf you do not encrypt it before installing your 3DS will softbrick. \033[0m"
	echo "(Read https://axities.github.io/ Section VI)"
	echo This CIA is only for the firmware version your device is on.
    echo -e "\033[1;31mIf the 3DS version changes or the region is different it will softbrick. \033[0m"
	echo Reinstall the original HomeMenu before updating your device.
	echo -e "If you seek for help: \033[1;34mhttps://discord.gg/0z7IGZ5Sv3D0mEN0\033[0m"
	echo -e "(or \033[1;37mhttps://matrix.to/#/+custom-3ds-assets:matrix.org\033[0m)"
	
	pause 'Press Enter to finish & to return to the menu' #>nul
    if [ "$usrchoice" == 8 ]; then
        fbiblock="ON"
    fi
fi
wine makerom.exe -f cia -content "$cxi0":0:$RANDOM -o "$expName.cia" #%cxi0%:0:%RANDOM% WTF? RANDOM?!
if [ "$usrchoice" != 8 ]; then
    cd "$dp0"
    jumpto STARTEN
fi
echo.
