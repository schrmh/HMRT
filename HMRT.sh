#!/bin/bash
# include this boilerplate
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

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
# Kind of equivalent?: if [ -n "$1" ] then fi

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





dp0=$(dirname "$(readlink -fn "$0")") #folder script is in


echo "Home Menu Rebuilding Tool [By TheDeKay & schrmh]"
HMRTver=0.8-L1
HMRTch=[Dev]  

cd dp0 #switch to shell script file's drive
if [ -n "$1" ] #if parameter not empty
then
    ext=$(echo  $1  | sed 's/.*\././')
	if [ $ext == ".cia" ]
    then
        ciaName=$dp0/$(basename $1 .cia) #@reader: remove $dp0/ if it doesn't work..
        expName="$ciaName"_edited
    elif [ $ext == ".bin" ]
    then
		jumpto $LZDECOMPRESSOR
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
HMRTdir=dp0/HMRT
xordir=dp0/xorpads
LogFile="dp0/LZ.log"
ciaName=dp0/HomeMenu
expName="$ciaName"_edited

START:
defIP=192.168.178.16

# ========================================================

cd $HMRTdir
usrchoice="0"
# title Home Menu Rebuilding Tool [By TheDeKay] #do later. Open new shell and set title
clear
#call :cPrint 7C #do later; may be hard
echo "                                                                    Home Menu Rebuilding Tool v$HMRTver $HMRTch"
#call :cPrint 79 "                                 
echo "by TheDeKay & schrmh "
#call :cPrint 71 
echo "                                                                                                Thanks to Asia81 and Zan'"
#call :cPrint 78 "     
echo "http://axities.github.io                     _________________________________________________________"
echo
echo   [1] Extract CIA
echo   [2] Build encrypted CIA
echo   [3] Clean Folder
echo   [4] Install via FBI (Network Install)
echo   [5] Decompress all LZ files
echo   [6] Recompress all LZ files
echo   [7] Copy to SD (Auto-detect)
echo   [8] Full Rebuild (Steps: 1, 5, Edit, 6, 2, 3, 4)
echo   [9] Generate ncchinfo.bin
echo   [Q] Exit program
echo
echo ">      Press your choice [Number]: "
usrchoice=$? #errorlevel? https://unix.stackexchange.com/questions/305200/returns-errorlevel-0-instead-of-4
clear
# https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
choice=("1" "2" "3" "4" "5" "6" "7" "8" "9" "Q")
select opt in "${choice[@]}"
do
    case $opt in
        "1")
            jumpto $EXTRACT
            ;;
        "2")
            jumpto $BUILD
            ;;
        "3")
            jumpto $CLEAN
            ;;
        "4")
            jumpto $FBI
            ;;
        "5")
            jumpto $DECOMP
            ;;
        "6")
            jumpto $RECOMP
            ;;
        "7")
            jumpto $RECOMP
            ;;
        "8")
            echo "you chose choice 2"
            ;;
        "9")
            jumpto $NCCHINFO
            ;;
        "Q") #may save us some lines later..
            break
            ;;
        *) echo "invalid option $REPLY. Press CTRL+C or write Q to break/quit.";; 
    esac
done


