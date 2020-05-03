@echo off
@chcp 65001
setlocal enabledelayedexpansion
set ver=2020.5.1
set Ph=%~dp0
PUSHD !Ph!
mode con cols=120 lines=30
title SBDnS_!ver!

:Preparing
set now=Preparing
if not exist .\Data\.RD (
	title SBDnS_!ver! - Preparing
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
	echo ~ Downloading spigot's buildtool...
	if exist .\Lib\BuildTools.jar (
		del .\Lib\BuildTools.jar
		powershell "(New-Object System.Net.WebClient).DownloadFile('https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar','.\Lib\BuildTools.jar')" >> nul
	) else (
		powershell "(New-Object System.Net.WebClient).DownloadFile('https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar','.\Lib\BuildTools.jar')" >> nul
	)
	if not exist .\Lib\BuildTools.jar (
		goto ED
	)
	for /f "usebackq" %%A in ('.\Lib\BuildTools.jar') do set btsize=%%~zA
	call .\Lib\cmd\getdatetime.cmd
	echo.	
	echo !fulltime! [!btsize!B] - !Ph!\Lib\BuildTools.jar saved
	echo.
	echo = Downlaod finished^^!
	echo.
	echo Ready on !fulltime!>>nul>.\Data\.RD
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

echo │  3. Self-diagnosis tools

echo │  Q. Quit

echo │

echo └────────────────────────────────────────────────────
echo.
set /p main=Run: 
echo !main!| findstr /r "^[1-3]$ ^[qQ]$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
)
if "!main!"=="1" (
	goto Bukkit_downloader
) else if "!main!"=="2" (
	goto Server_starter
) else if "!main!"=="3" (
	goto Self-diagnosis_tools
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
set /p bver=Run: 
echo !bver!| findstr /r "^1\.[8-9]\.[1-9]$ ^1\.[8-9]$ ^1\.[8-9]\.10$ ^1\.[1-9][0-9]\.[1-9]$ ^1\.[1-9][0-9]$ ^1\.[1-9][0-9]\.10$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
)
goto Bukkit_downloader-folder

:Bukkit_downloader-folder
set now=Bukkit_downloader-folder
call .\Lib\cmd\getlist.cmd
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

for /f "delims=" %%i in (.\Data\list) do echo │  %%i
for /f "tokens=1 delims=:" %%a in (.\Data\list) do set no=%%a
echo │

echo └────────────────────────────────────────────────────
set /p bname=Run: 
if exist .\Bukkits\!bname!_!bver! (
	goto EBN
)

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
call .\Lib\cmd\downbukkit.cmd
if not "%ERRORLEVEL%" == "0" (
	goto EBD
)
echo.
echo = Download finished^^!
PAUSE
cd !Ph!
goto Main

:Server_starter
set now=Server_starter
call .\Lib\cmd\getlist.cmd
title SBDnS_!ver! - Selecting_bukkit
cls
echo ┌────────────────── [ Server_starter ]───────────────

echo │

echo │  Please select one of the bukkit's NUMBER from the list:

echo │

for /f "delims=" %%i in (.\Data\list) do echo │  %%i
for /f "tokens=1 delims=:" %%a in (.\Data\list) do set no=%%a
echo │

echo └────────────────────────────────────────────────────
set /p bs=Run: 
for /f "tokens=1,2 delims=. " %%a in (.\Data\list) do (
	if "%%a"=="!bs!" (
		set bfolder=%%b
	)
)
echo !bs!| findstr /r "^[1-9][0-9]*$">nul
if not "%ERRORLEVEL%" == "0" (
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
set /p ram=Run: 
echo !ram!| findstr /r "^[1-9][0-9]*$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
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
if exist .\Bukkits\!bfolder!\spigot.jar (
	call .\Lib\cmd\getfilesize.cmd
	if !bsize! lss 19818087 (
		goto EBFIS
	)
) else (
	goto EBFI
)
echo !Ph!\Bukkits\!bfolder!\spigot.jar [!bsize!B]
echo.
echo = bukkit file detected^^!
echo.
echo ~ Starting server...
echo.
cd .\Bukkits\!bfolder!\
java -Xms!ram!G -Xmx!ram!G -jar spigot.jar
echo.
PAUSE >> nul
cd !Ph!
echo = Server stopped^^!
PAUSE
goto Main

:Self-diagnosis_tools
set now=Self-diagnosis_tools
title SBDnS_!ver! - Self-diagnosis_tools
cls
echo ┌─────────────── [ Self-diagnosis_tools ]────────────

echo │

echo │  Following tools are prepared for you:

echo │

echo │  1. Java checker

echo │  2. BuildTools.jar checker

echo │  Q. Quit

echo │

echo └────────────────────────────────────────────────────
echo.
set /p diag=Run: 
echo !diag!| findstr /r "^[1-2]$ ^[qQ]$">nul
if not "%ERRORLEVEL%" == "0" (
	goto EI
)
if "!diag!"=="1" (
	goto Self-diagnosis_tools-java_checking
) else if "!diag!"=="2" (
	goto Self-diagnosis_tools-buildtool_checking
) else if "!diag!"=="q" (
	exit
) else if "!diag!"=="Q" (
	exit
)

:Self-diagnosis_tools-java_checking
set now=Self-diagnosis_tools-java_checking
title SBDnS_!ver! - Checking_Java
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
PAUSE
goto Main

:Self-diagnosis_tools-buildtool_checking
set now=Self-diagnosis_tools-buildtool_checking
title SBDnS_!ver! - Checking_BuildTools.jar
cls
echo.
echo ~ Checking BuildTools.jar...
if exist .\Lib\BuildTools.jar (
	echo.
	echo = BuildTools.jar detected^^!
) else (
	echo.
	echo = There was no BuildTools.jar detected^^!
	echo.
	echo ~ Downloading spigot's buildtool...
	powershell "(New-Object System.Net.WebClient).DownloadFile('https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar','.\Lib\BuildTools.jar')" >> nul
	if not exist .\Lib\BuildTools.jar (
		goto ED
	)
	for /f "usebackq" %%A in ('.\Lib\BuildTools.jar') do set btsize=%%~zA
	call .\Lib\cmd\getdatetime.cmd
	echo.	
	echo !fulltime! [!btsize!B] - !Ph!\Lib\BuildTools.jar saved
	echo.
	echo = Downlaod finished^^!
)
PAUSE
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

echo │  There was an unexpected error on downloading the bukkit file^^!

echo │

echo │  Please contact to developer...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
start mailto:h2o@h2owr.xyz

:EBFI
title SBDnS_!ver! - Error_code-05_01
cls
echo ┌───────────────── [ Error_code-05_01 ]─────────────────

echo │

echo │  There are no bukkit file detected in the folder: !bfolder!^^!

echo │

echo │  Please download or redownload the bukkit...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!

:EBFIS
title SBDnS_!ver! - Error_code-05_02
cls
echo ┌───────────────── [ Error_code-05_02 ]─────────────────

echo │

echo │  There are wrongly downloaded bukkit file in the folder: !bfolder!^^!

echo │

echo │  Please download or redownload the bukkit...

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!

:EI
title SBDnS_!ver! - Error_code-06
cls
echo ┌───────────────── [ Error_code-06 ]─────────────────

echo │

echo │  Unauthorized string or integer detected^^!

echo │

echo │  Nope, You can't type that.

echo │

echo └────────────────────────────────────────────────────
PAUSE >> nul
goto !now!