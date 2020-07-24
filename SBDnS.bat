@echo off
@chcp 65001
setlocal enabledelayedexpansion
set ver=2020.7.1f4
set Ph=%~dp0
PUSHD "!Ph!"
mode con cols=120 lines=30
title SBDnS_!ver!

:Preparing
set now=Preparing
title SBDnS_!ver! - Preparing
cls
if not exist ".\Data\.RD" (
	echo.
	echo ~ Preparing SBDnS...
	echo.
	echo ~ Checking Java...
	echo.
	java -version
	if not exist "%userprofile%\appdata\locallow\Sun\Java\Deployment\deployment.properties" (
		goto EJ
	)
	if not "%ERRORLEVEL%" == "0" (
		goto EJ	
	)
	echo.
	echo = Java detected^^!
	echo.
	echo ~ Downloading spigot's buildtools...
	if exist ".\Lib\BuildTools.jar" (
		del ".\Lib\BuildTools.jar"
		start /wait PowerShell -windowstyle hidden -executionpolicy remotesigned -file ".\Lib\downbuildtools.ps1" > nul
	) else (
		start /wait PowerShell -windowstyle hidden -executionpolicy remotesigned -file ".\Lib\downbuildtools.ps1" > nul
	)
	if not exist ".\Lib\BuildTools.jar" (
		goto ED
	)
	for /f "usebackq" %%A in ('".\Lib\BuildTools.jar"') do set btsize=%%~zA
	call ".\Lib\getdatetime.cmd"
	echo.	
	echo !fulltime! [!btsize!B] - !Ph!Lib\BuildTools.jar saved
	echo.
	echo = Download finished^^!
	echo.
	echo Ready on !fulltime!>>nul>".\Data\.RD"
	echo ~ All task finished, entering main...
	timeout /t 5 >> nul
)
goto Main

:Main
set now=Main
title SBDnS_!ver! - Main
cls
echo ┌────────────────────── [ Main ]─────────────────────

echo │

echo │  Welcome to SBDnS^^!

echo │

echo │  The current version is !ver!^^!

echo │

echo │  1. Bukkit donwloader

echo │  2. Server starter

echo │  3. Junk file cleaner

echo │  4. Troubleshooting tool

echo │  Q. Quit

echo │

echo └────────────────────────────────────────────────────
echo.
set /p main=SBDnS^> 
echo !main!| findstr /r "^[1-4]$ ^[qQ]$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
)
if "!main!"=="1" (
	goto Bukkit_downloader
) else if "!main!"=="2" (
	goto Server_starter
) else if "!main!"=="3" (
	goto Junk_file_cleaner
) else if "!main!"=="4" (
	goto Troubleshooting_tool
) else if "!main!"=="q" (
	exit
) else if "!main!"=="Q" (
	exit
)

:Bukkit_downloader
set now=Bukkit_downloader
title SBDnS_!ver! - Choosing_bukkit_version
cls
echo ┌──────────────── [ Bukkit_downloader ]──────────────

echo │

echo │  Please type the version of the bukkit^^!

echo │

echo │  Supported versions are 1.8 ~ latest.

echo │

echo └────────────────────────────────────────────────────
set /p bver=SBDnS^> 
echo !bver!| findstr /r "^1\.[8-9]\.[1-9]$ ^1\.[8-9]$ ^1\.[8-9]\.10$ ^1\.[1-9][0-9]\.[1-9]$ ^1\.[1-9][0-9]$ ^1\.[1-9][0-9]\.10$ ^[mM]$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
)
if "!bver!"=="m" (
	goto Main
) else if "!bver!"=="M" (
	goto Main
)
goto Bukkit_downloader-folder

:Bukkit_downloader-folder
set now=Bukkit_downloader-folder
call ".\Lib\getlist.cmd"
title SBDnS_!ver! - Choosing_folder_name [ !bver! ]
cls
echo ┌──────────────── [ Bukkit_downloader ]──────────────

echo │

echo │  Please type the name of the bukkit folder^^!

echo │

echo │  Folder name will be [Typed name]_[Version]

echo │

echo │  Following folders are already exist:

echo │

call ".\Lib\printlist.cmd"

echo │

echo └────────────────────────────────────────────────────
set /p bname=SBDnS^> 
if exist .\Bukkits\!bname!_!bver! (
	goto EBN
)
goto Bukkit_downloader-downloading

:Bukkit_downloader-downloading
set now=Bukkit_downloader-downloading
title SBDnS_!ver! - Downloading_bukkit [ !bname!_!bver! ]
cls
echo.
echo ~ Checking Java...
echo.
java -version
if not "%ERRORLEVEL%" == "0" (
	goto EJ	
)
echo.
echo = Java detected^^!
echo.
echo ~ Downloading bukkit...
echo.
if not exist ".\Bukkits" (
	md ".\Bukkits"
)
call ".\Lib\downbukkit.cmd"
if not "%ERRORLEVEL%" == "0" (
	goto EBD
)
echo.
if exist ".\Bukkits\!bname!_!bver!\spigot.jar" (
	echo = Download finished^^!
) else (
	echo = Error occurred^^!
	goto EBD
)
PAUSE >> nul
goto Main

:Server_starter
set now=Server_starter
call ".\Lib\getlist.cmd"
title SBDnS_!ver! - Selecting_bukkit
cls
echo ┌────────────────── [ Server_starter ]───────────────

echo │

echo │  Please select one of the bukkit's NUMBER from the list:

echo │

call ".\Lib\printlist.cmd"

echo │

echo └────────────────────────────────────────────────────
set /p bs=SBDnS^> 
for /f "tokens=1,2 delims=: " %%a in (.\Data\list) do (
	if "%%a"=="!bs!" (
		set bfolder=%%b
	)
)
echo !bs!| findstr /r "^[1-9][0-9]*$ ^[mM]$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
)
set filenum=0
for /f  %%i in ('DIR ".\Bukkits\" /b') do (
	set /a filenum+=1
)
if not exist ".\Bukkits\!bfolder!\" (
	goto ENB
)
if "!bs!"=="m" (
	goto Main
) else if "!bs!"=="M" (
	goto Main
) else if !bs! gtr !filenum! (
	goto EI
) else if !bs! leq 0 (
	goto EI
)
goto Server_starter-ram

:Server_starter-ram
set now=Server_starter-ram
title SBDnS_!ver! - Choosing_RAM_limitation
cls
echo ┌────────────────── [ Server_starter ]───────────────

echo │

echo │  Please type the RAM limitation for your server^^!

echo │

echo │  The unit is Gigabyte(GB).

echo │

echo └────────────────────────────────────────────────────
set /p ram=SBDnS^> 
echo !ram!| findstr /r "^[1-9][0-9]*$ ^[mM]$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
)
if "!ram!"=="m" (
	goto Main
) else if "!ram!"=="M" (
	goto Main
)
goto Server_starter-starting

:Server_starter-starting
set now=Server_starter-strating
title SBDnS_!ver! - Starting_server [ !bfolder! : !ram!GB ]
cls
echo.
echo ~ Checking Java...
echo.
java -version
if not "%ERRORLEVEL%" == "0" (
	goto EJ	
)
echo.
echo = Java detected^^!
echo.
echo ~ Checking bukkit file...
echo.
if exist ".\Bukkits\!bfolder!\spigot.jar" (
	for /f "usebackq" %%A in ('".\Bukkits\!bfolder!\spigot.jar"') do set bsize=%%~zA
	if !bsize! lss 19818087 (
		goto EBFIS
	)
) else (
	goto EBFI
)
call ".\Lib\getdatetime.cmd"
echo !fulltime! [!btsize!B] - !Ph!Bukkits\!bfolder!\spigot.jar detected
echo.
echo = bukkit file detected^^!
echo.
echo ~ Starting server...
echo.
cd ".\Bukkits\!bfolder!\"
call ".\Lib\getdatetime.cmd"
set serverstart=!fulltime!
java -Xms!ram!G -Xmx!ram!G -jar spigot.jar
if not "%ERRORLEVEL%" == "0" (
	goto ESS
)
echo.
cd "!Ph!"
call ".\Lib\getdatetime.cmd"
set serverstop=!fulltime!
echo = Server stopped^^!
echo = Server lasted !serverstart! ~ !serverstop!
PAUSE >> nul
goto Main

:Junk_file_cleaner
set now=Junk_file_cleaner
title SBDnS_!ver! - Checking_junk_files
cls
echo.
echo ~ Checking Junk files...
if exist ".\Bukkits" (
	call ".\Lib\getemptylist.cmd"
	if exist ".\Data\emptylist" (
		set emptyno=0
		for /f "delims=" %%i in (.\Data\emptylist) do (
			set bfilewo=%%i
			set bfilewo=!bfilewo: =!
			if not exist ".\Bukkits\!bfilewo!\spigot.jar" (
				set /a emptyno+=1 >> nul
			)
		)
		if "!emptyno!" == "1" (
			echo.
			echo = There is 1 junk file detected^^!
			echo.
			echo ~ Do you want to delete all the junk file?
			echo.
			set /p junk=[Y]es or [N]o ~ 
			if "!junk!"=="y" (
				call ".\Lib\delemptylist.cmd"
				echo.
				echo = 1 junk file deleted^^!
			) else if "!junk!"=="Y" (
				call ".\Lib\delemptylist.cmd"
				echo.
				echo = 1 junk file deleted^^!
			) else if "!junk!"=="n" (
				echo.
				echo = Ignoring junk file...
			) else if "!junk!"=="N" (
				echo.
				echo = Ignoring junk file...
			)
		) else (
			echo.
			echo = There are !emptyno! junk files detected^^!
			echo.
			echo ~ Do you want to delete all the junk files?
			echo.
			set /p junk=[Y]es or [N]o ~ 
			if "!junk!"=="y" (
				call ".\Lib\delemptylist.cmd"
				echo.
				echo = !emptyno! junk files deleted^^!
			) else if "!junk!"=="Y" (
				call ".\Lib\delemptylist.cmd"
				echo.
				echo = !emptyno! junk files deleted^^!
			) else if "!junk!"=="n" (
				echo.
				echo = Ignoring junk files...
			) else if "!junk!"=="N" (
				echo.
				echo = Ignoring junk files...
			)
		)
	) else (
		echo.
		echo = There was no junk file detected^^!
	)
	echo.
	echo ~ Junk file check finished, entering main...
) else (
	set now=Main
	goto ENB
)
timeout /t 5 >> nul
goto Main

:Troubleshooting_tool
set now=Troubleshooting_tool
title SBDnS_!ver! - Troubleshooting
cls
echo.
echo ~ Checking Java...
echo.
if not exist "%userprofile%\appdata\locallow\Sun\Java\Deployment\deployment.properties" (
	goto EJ
)
java -version
if not "%ERRORLEVEL%" == "0" (
	goto EJ	
)
echo.
echo = Java detected^^!
echo.
echo ~ Checking BuildTools.jar...
if exist ".\Lib\BuildTools.jar" (
	for /f "usebackq" %%A in ('".\Lib\BuildTools.jar"') do set btsize=%%~zA
	if !btsize! lss 3879731 (
		echo.
		echo = Wrongly downloaded BuildTools.jar detected^^!
		del ".\Lib\BuildTools.jar"
		start /wait PowerShell -windowstyle hidden -executionpolicy remotesigned -file "./Lib/downbuildtools.ps1" > nul
		echo.
		echo ~ Re-downloading spigot's buildtools...
		echo.	
		for /f "usebackq" %%A in ('".\Lib\BuildTools.jar"') do set btsize=%%~zA
		call ".\Lib\getdatetime.cmd"
		echo !fulltime! [!btsize!B] - !Ph!Lib\BuildTools.jar saved
		echo.
		echo = Download finished^^!
	) else (
		echo.
		echo = BuildTools.jar detected^^!
	)
) else (
	echo.
	echo = There was no BuildTools.jar detected^^!
	echo.
	echo ~ Downloading spigot's buildtools...
	start /wait PowerShell -windowstyle hidden -executionpolicy remotesigned -file "./Lib/downbuildtools.ps1" > nul
	if not exist ".\Lib\BuildTools.jar" (
		goto ED
	)
	for /f "usebackq" %%A in ('".\Lib\BuildTools.jar"') do set btsize=%%~zA
	call ".\Lib\getdatetime.cmd"
	echo.	
	echo !fulltime! [!btsize!B] - !Ph!Lib\BuildTools.jar saved
	echo.
	echo = Download finished^^!
)
echo.
echo ~ All check finished, entering main...
timeout /t 5 >> nul
goto Main

:EJ
title SBDnS_!ver! - Error_code-01
cls
echo ┌───────────────── [ Error_code-01 ]─────────────────

echo │

echo │  You must install Java before you run this program^^!

echo │

echo │  Please install Java...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
start https://java.com/
exit

:ED
title SBDnS_!ver! - Error_code-02
cls
echo ┌───────────────── [ Error_code-02 ]─────────────────

echo │

echo │  There was an unexpected error on downloading BuildTools.jar^^!

echo │

echo │  Please contact to developer...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
start mailto:h2o@h2owr.xyz
exit

:EBN
title SBDnS_!ver! - Error_code-03
cls
echo ┌───────────────── [ Error_code-03 ]─────────────────

echo │

echo │  There is folder that has same name^^!

echo │

echo │  Please type other name...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!

:EBD
title SBDnS_!ver! - Error_code-04
cls
echo ┌───────────────── [ Error_code-04 ]─────────────────

echo │

echo │  There was an unexpected error on downloading spigot.jar^^!

echo │

echo │  Please use Troubleshooting tool or contact to developer...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
start mailto:h2o@h2owr.xyz
goto main

:ENB
title SBDnS_!ver! - Error_code-05
cls
echo ┌───────────────── [ Error_code-05 ]─────────────────

echo │

echo │  There are no bukkit folder^^!

echo │

echo │  Please download the bukkit...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!

:EBFI
title SBDnS_!ver! - Error_code-06_01
cls
echo ┌───────────────── [ Error_code-06_01 ]─────────────────

echo │

echo │  There are no bukkit file detected in the folder: !bfolder!^^!

echo │

echo │  Please download or re-download the bukkit...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!

:EBFIS
title SBDnS_!ver! - Error_code-06_02
cls
echo ┌───────────────── [ Error_code-06_02 ]─────────────────

echo │

echo │  There are wrongly downloaded bukkit file in the folder: !bfolder!^^!

echo │

echo │  Please download or re-download the bukkit...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!

:ESS
title SBDnS_!ver! - Error_code-07
cls
echo ┌───────────────── [ Error_code-07 ]─────────────────

echo │

echo │  There was error while starting server: !bfolder! with !ram!GB of ram^^!

echo │

echo │  Please re-select ram limitation or check bukkit folder...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!

:EI
title SBDnS_!ver! - Error_code-07
cls
echo ┌───────────────── [ Error_code-07 ]─────────────────

echo │

echo │  Unauthorized string or integer detected^^!

echo │

echo │  Nope, You can't type that.

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!