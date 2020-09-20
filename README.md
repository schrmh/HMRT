Home Menu Rebuilding Tool (HMRT) v0.8  
=====================================  
### NOW FOR GNU/LINUX!  

----
  
This is WIP but useable!  
Feel free to contribute (e.g. code or tutorials)  

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

  
