if exist ".\Data\list" (
	del ".\Data\list"
)
if exist ".\Data\listtemp" (
	del ".\Data\listtemp"
)
set /a no=0
for /f %%i in ('dir /b .\Bukkits') do (
	echo %%i >> ".\Data\listtemp"
)
for /f "delims=" %%i in (.\Data\listtemp) do (
	set bfilewo=%%i
	set bfilewo=!bfilewo: =!
	if exist ".\bukkits\!bfilewo!\spigot.jar" (
		set /a no+=1 >> nul
		echo !no!: %%i >> ".\Data\list"
	)
)
if !no! == 0 (
	echo ^(No bukkit in directory^) > ".\Data\list"
)
if exist ".\Data\listtemp" (
	del ".\Data\listtemp"
)