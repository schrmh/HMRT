@echo off
SetLocal EnableDelayedExpansion
title Home Menu Rebuilding Tool [By TheDeKay]
set HMRTver=0.7
set HMRTch=[Dev]  
mode con:cols=57 lines=25
cd %~dp0
if NOT [%1]==[] (
	if "%~x1"==".cia" (
		set ciaName=%~dpn1
		set expName=!ciaName!_edited
	) else if "%~x1"==".bin" (
		goto LZDECOMPRESSOR
	)
)
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
::============ USER VARIABLES =============================
:: ciaName: Input File (HomeMenu) NO EXTENSION
:: expName: Output File (HomeMenu_edited) NO EXTENSION
:: SDDrive: Letter for the SD Drive

set encheader=NCCH.encheader
set HMRTdir=%~dp0\HMRT
set xordir=%~dp0\xorpads
set LogFile="%~dp0\LZ.log"
set ciaName=%~dp0\HomeMenu
set expName=%ciaName%_edited
:START
set defIP=192.168.178.16

::========================================================

cd %HMRTdir%
set usrchoice="0"
title Home Menu Rebuilding Tool [By TheDeKay]
cls
call :cPrint 7C "                                                                    Home Menu Rebuilding Tool v%HMRTver% %HMRTch%"
call :cPrint 79 "                                 by TheDeKay"
call :cPrint 71 "                                                                                                Thanks to Asia81 and Zan'"
call :cPrint 78 "                                     www.homemenu.co                     _________________________________________________________"
echo.
echo.   [1] Extract CIA
echo.   [2] Build encrypted CIA
echo.   [3] Clean Folder
echo.   [4] Install via FBI (Network Install)
echo.   [5] Decompress all LZ files
echo.   [6] Recompress all LZ files
echo.   [7] Copy to SD (Auto-detect)
echo.   [8] Full Rebuild (Steps: 1, 5, Edit, 6, 2, 3, 4)
echo.   [9] Generate ncchinfo.bin
echo.   [Q] Exit program
echo.
CHOICE /n /c:123456789Q /m ">      Press your choice [Number]: "
set usrchoice=%errorlevel%
cls
if "%usrchoice%"=="1" goto EXTRACT
if "%usrchoice%"=="2" goto BUILD
if "%usrchoice%"=="3" goto CLEAN
if "%usrchoice%"=="4" goto FBI
if "%usrchoice%"=="5" goto DECOMP
if "%usrchoice%"=="6" goto RECOMP
if "%usrchoice%"=="7" goto COPYSD
if "%usrchoice%"=="9" goto NCCHINFO
if "%usrchoice%"=="10" goto EOF
if NOT "%usrchoice%"=="8" goto START 

:EXTRACT
title Home Menu Rebuilding Tool [Extracting]

if NOT exist "%ciaName%.cia" (
	echo Couldn't find CIA file.
	echo You can specify a default CIA Name
	echo in the USER VARIABLES.(example ciaName=HomeMenu^)
	echo Or simply drag a CIA to extract onto this Tool.
	echo.
	set /p ciaName="Enter filename (no extension): "
)
del *.0000.*
ctrtool.exe "%ciaName%.cia" --content=Content
FOR %%S in (*.0000.*) do set cxi0=%%~nxS
3dstool.exe -xvtf cxi %cxi0% --header NCCH.Header --exh DecryptedExHeader.bin --exefs DecryptedExeFS.bin --romfs DecryptedRomFS.bin --logo Logo.bcma.LZ --plain PlainRGN.bin
3dstool.exe -xuvtf exefs DecryptedExeFS.bin --exefs-dir ..\ExtractedExeFS --header ExeFS.Header
rmdir ..\ExtractedRomFS /s /q
3dstool.exe -xvtf romfs DecryptedRomFS.bin --romfs-dir ..\ExtractedRomFS
if NOT exist "..\ExtractedRomFS\" (
	for %%F in ("..\xorpads\*romfs.xorpad") do ( set rfsxor=%%~dpnxF )
	for %%F in ("..\xorpads\*exefs_norm.xorpad") do ( set efsxor=%%~dpnxF )
	for %%F in ("..\xorpads\*exheader.xorpad") do ( set exhxor=%%~dpnxF )
	3dstool.exe -xvtf cxi "%cxi0%" --header NCCH.Header --exh DecryptedExHeader.bin --exh-xor "!exhxor!" --exefs DecryptedExeFS.bin --exefs-xor "!efsxor!" --romfs DecryptedRomFS.bin --romfs-xor "!rfsxor!" --plain PlainRGN.bin
	3dstool.exe -xuvtf exefs DecryptedExeFS.bin --exefs-dir ..\ExtractedExeFS --header ExeFS.Header
	3dstool.exe -xvtf romfs DecryptedRomFS.bin --romfs-dir ..\ExtractedRomFS
	if NOT exist "%encheader%" copy NCCH.Header %encheader%
	set encheader=NCCH.Header
)
if NOT "%usrchoice%"=="8" goto START
:DECOMP
cd %~dp0
echo LZ Decompressionlog [%date:~0%] >> %LogFile%
echo =====================================================>> %LogFile%
set /a cntT=0
set /a cntS=0
title Home Menu Rebuilding Tool [Decompressor]
for /R %%F in (*lz.bin) do (
	set /a cntT=!cntT!+1
    set fn=%%~nF
    set file=!fn:~0,-3!.!fn:~-2,2!
	echo Decompressing: !file!
	"%HMRTdir%\3dstool.exe" -uvf "%%F" --compress-type lzex --compress-out "%%~nF.lz" > NUL
	if exist "%%~nF.lz" (
		del "%%F" > NUL
		move "%%~nF.lz" "%%~dpF!file!" > NUL
		echo [%time:~0,8%] %%~nxF decompressed! >> %LogFile%
		set /a cntS=!cntS!+1
	) else (
		echo [%time:~0,8%] %%~nxF couldn't be decompressed >> %LogFile%
	)
)
echo [%time:~0,8%] Finished %cntS%/%cntT% decompressed >> %LogFile%
echo =====================================================>> %LogFile%
cd %HMRTdir%
if NOT "%usrchoice%"=="8" goto START 

echo Contents of the CIA file have been extracted
echo All LZ files have been decompressed
echo Do your Edits now. 
%SystemRoot%\explorer.exe "%~dp0ExtractedRomFS"
echo.
echo Press any key to continue with recompressing and rebuilding.
pause>nul

:RECOMP
cd %~dp0
echo LZ Recompressionlog [%date:~0%] >> %LogFile%
echo =====================================================>> %LogFile%
title Home Menu Rebuilding Tool [Compressor]
set /a cntT=0
set /a cntS=0
for /R %%F in (*.lz) do (
	set /a cntT=!cntT!+1
	echo Compressing: "%%~nxF"
	"%HMRTdir%\3dstool.exe" -zvf "%%F" --compress-type lzex --compress-out "%%~nF_LZ.bin"
	if exist "%%~nF_LZ.bin" (
		del "%%F"  > NUL
		move "%%~nF_LZ.bin" "%%~dpnF_LZ.bin"  > NUL
		echo [%time:~0,8%] %%~nxF compressed! >> %LogFile%
		set /a cntS=!cntS!+1
	)
)
echo [%time:~0,8%] Finished %cntS%/%cntT% compressed >> %LogFile%
echo =====================================================>> %LogFile%
cd %HMRTdir%
if "%usrchoice%"=="2" goto :EOF
if NOT "%usrchoice%"=="8" goto START 

:BUILD
title Home Menu Rebuilding Tool [Building]
if "%expName%"=="" (
	echo No name specified for the CIA file. 
	echo You can specify a default name
	echo in the USER VARIABLES.(example expName=HomeMenu^)
	echo.
	set /p expName="Enter filename (no extension): "
)
del ..\ExtractedRomFS\*.bak
if exist "..\ExtractedRomFS\*.LZ" call :RECOMP
3dstool.exe -cvtf romfs CustomRomFS.bin --romfs-dir ..\ExtractedRomFS
3dstool.exe -czvtf exefs CustomExeFS.bin --exefs-dir ..\ExtractedExeFS --header ExeFS.Header
FOR %%S in (*.0000.*) do set cxi0=%%~nxS

if exist "..\xorpads\*.xorpad" (
	for %%F in ("..\xorpads\*romfs.xorpad") do ( set rfsxor=%%~dpnxF )
	for %%F in ("..\xorpads\*exefs_norm.xorpad") do ( set efsxor=%%~dpnxF )
	for %%F in ("..\xorpads\*exheader.xorpad") do ( set exhxor=%%~dpnxF )
	3dstool.exe -cvtf cxi %cxi0% --header "%encheader%" --exh DecryptedExHeader.bin --plain PlainRGN.bin --exefs CustomExeFS.bin --romfs CustomRomFS.bin --exh-xor "!exhxor!" --exefs-xor "!efsxor!" --romfs-xor "!rfsxor!"
	if "%usrchoice%"=="8" set fbiblock=
) else (
	3dstool.exe -cvtf cxi %cxi0% --header NCCH.Header --exh DecryptedExHeader.bin --plain PlainRGN.bin --exefs CustomExeFS.bin --romfs CustomRomFS.bin
	echo.
	echo Missing XORpads to build encrypted CIA.
	echo CIA will not be encrypted.
	echo Use Decrypt9 to encrypt CIA before installing.
	pause>nul
	if "%usrchoice%"=="8" set fbiblock=ON
)
makerom.exe -f cia -content %cxi0%:0:%RANDOM% -o "%expName%.cia"
if NOT "%usrchoice%"=="8" goto START 
echo.
:CLEAN
title Home Menu Rebuilding Tool [Cleaning]
cd %~dp0
rmdir ExtractedRomFS /s /q
rmdir ExtractedExeFS /s /q
del *.log *.lz
cd %HMRTdir% & del *.bin *.Header *.0000.* *.log

if NOT "%usrchoice%"=="8" goto START
if "%fbiblock%"=="ON" goto START
FOR %%F in (%expname%) do set cpName=%%~nF
CHOICE /n /c:YN /m "Do you want do install %cpName%.cia via network now? [Y/N]"
if "%errorlevel%"=="2" goto START
:FBI
title Home Menu Rebuilding Tool [NetInstall]
if "%defIP%"=="" (
	echo You can specify a default IP Address
	echo in the USER VARIABLES. (example defIP=127.0.0.1^)
	echo.
	set /p defIP="Enter your 3DS IP: "
)
if NOT exist "%expName%.cia" (  
	java -jar sockfile-2.0.jar "%defIP%" "%ciaName%.cia"
) else (
	java -jar sockfile-2.0.jar "%defIP%" "%expName%.cia"
)
goto START

:COPYSD
title Home Menu Rebuilding Tool [Copy to SD]
echo Looking for valid SD Card
for /f "tokens=1,2,3,4" %%a in ('wmic logicaldisk get caption^,drivetype^,filesystem^,volumename') do (
	if "%%b"=="2" if "%%c"=="FAT32" if exist "%%a\Nintendo 3DS\" set SDDrive=%%a&set SDName=%%d
)
if "%SDDrive%"=="" (
	echo.
	echo Unable to find SD Card
	pause>nul
	goto START
)
cd %~dp0
md %SDDrive%\D9Game 2> nul
if NOT exist "%expName%.cia" ( 
	FOR %%F in (%ciaName%) do set cpName=%%~nF
	echo Copying !cpName!.cia to %SDName% [%SDDrive%]
	copy "%ciaName%.cia" "%SDDrive%\D9Game\!cpName!.cia" 
) else (
	FOR %%F in (%expName%) do set cpName=%%~nF
	echo Copying !cpName!.cia to %SDName% [%SDDrive%]
	copy "%expName%.cia" "%SDDrive%\D9Game\!cpName!.cia" )
ping -n 2 127.0.0.1 > NUL
goto START
cd %HMRTdir%

:NCCHINFO
ctrtool.exe "%ciaName%.cia" --content=NCCHI
FOR %%S in (NCCHI.0000.*) do set cxi=%%~nxS
if "%cxi%"=="" (
	echo Unable to get content from %ciaName%.cia
	echo Use Decrypt9 to decrypt CIA ^(deep^)
	echo Then reencrypt it ^(ncch^) and try again.
	pause>nul
	goto START
)
ncchinfo_gen.py %cxi%
del NCCHI.*
move "ncchinfo.bin" "%~dp0ncchinfo.bin"
goto START

:cPrint
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof

:LZDECOMPRESSOR
title Home Menu Rebuilding Tool [LZ Decompressor]
cd /d %~dp0
echo LZ Compressionlog [%date:~0%] >> %LogFile%
set /a cntT=0
set /a cntS=0
echo =====================================================>> %LogFile%
for %%F in (%*) do (
	set /a cntT=!cntT!+1
    	set fn=%%~nF
    	set file=!fn:~0,-3!.!fn:~-2,2!
	echo Decompressing: !file!
	%HMRTdir%\3dstool -uvf %%F --compress-type lz --compress-out !file! > NUL
	if exist !file! (
		del %%F > NUL
		move !file! "%%~dpF!file!" > NUL
		echo [%time:~0,8%] %%~nxF decompressed! >> %LogFile%
		set /a cntS=!cntS!+1
	) else (
		echo [%time:~0,8%] %%~nxF couldn't be decompressed >> %LogFile%
	)
	cls
)
echo [%time:~0,8%] Finished %cntS%/%cntT% decompressed >> %LogFile%
echo =====================================================>> %LogFile%
:EOF
