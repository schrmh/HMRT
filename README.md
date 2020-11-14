Home Menu Rebuilding Tool (HMRT) v0.8.1  
=====================================  
### NOW FOR GNU/LINUX!  

----
  
This is WIP but useable!  
Feel free to contribute (e.g. code or tutorials)  

[14th November 2020]: Broke full rebuild with some changes. Choose previous commit or call each step individually until I fix it.  
Added `bclimtool` and `darctool` and a script `extractLZ` so that GNU/Linux users don't need to wait until Kuriimu2 (which uses dotnetcore!) finally works to be able to view PNG files within bclim files..  
Useful tip: Use `magick display 'vid:*.png'` (needs `imagemagick`) to view all png files in a folder at once.  
[2nd September 2020]: A full rebuild COULD work (on GNU/Linux after a few tries) and IF it builds a edited CIA then it SHOULDN'T  lead to a softbrick.  
It should be possible to exchange files between Windows and GNU/Linux regardless of the steps that were executed  
(Design choice: for files extracted from or modified on linux the LZ extension is lowercase -> we won't need to ask which plattform people use)  
I don't plan to test the xorpad parts soon and I would be glad if you could test them for me.  
Next steps for GNU/Linux include  
- moving away from wine  
- improving a few parts of the script (e.g. don't rm `*.0000.*` if it doesn't exist; ignore_3dstool.txt warning)  
- Give people more information e.g. if BUILD (step 6) gets called and it can't do anything now, then say so!
- Move or get rid of a few pauses especially in BUILD (step 6) – do they exist because of missing pauses in previous steps?
- Use dialog for a better UI
- Try it on Android.. Maybe rewrite in C if it doesn't work?
- Replace parameters like `--content` with the correct ones. ctrtool expands, so we could e.g. use `--co` instead of `--contents`, but we shouldn't.
- Maybe add log for EXTRACT
- Make finished steps more clear (Maybe put strings in array and display the step name?)
- Integrate `extractLZ.sh` into `HMRT.sh`
- Option to re-inject bclim files
- Options to quickly replace files (like bclim) in LZ compressed archives by using some syntax like `hud.lz/timg/HudBatBase_01.bclim newHudBatBase_01.png`
- Call HMRT options directly from command line
- Add a tool that lets users easily search for Strings, Offsets, Hex values, Words (from a dictionary; regex?) within all files
- Add an option to patch files with new values (mass replace matching values; individual values written in a file; presets written in a file like "Background" or "BtnBase")
- Option to inject compressed lz files like in https://cdn.discordapp.com/attachments/265917056837353472/600180023986487296/Modded_Home_Menu_3DS.zip. Either by a file structure that is written in a file or by searching, if that file doesn't exist)
- If possible, run generated cia in citra?
- Rewrite some of the used tools or turn everything into a single C project. e

----
  
#### Credits:   
_3dstool_   
https://github.com/dnasdw/3dstool Didn't know there was a linux version. MIT in /HMRT  
_ctrtool & makerom_  
https://github.com/jakcron/Project_CTR MIT license copied to /HMRT  
_sockfile_  
https://github.com/Steveice10/  
_ncchinfo_gen_  
https://github.com/d0k3/3DS-Tools-Collection/tree/master/Decrypt9%20Scripts  
_bclimtool_  
https://github.com/dnasdw/bclimtool  
_darctool_  
https://github.com/yellows8/darctool/  
