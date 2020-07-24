if exist ".\Data\emptylist" (
	del ".\Data\emptylist"
)
if exist ".\Data\emptylisttemp" (
	del ".\Data\emptylisttemp"
)
set /a no=0
for /f %%i in ('dir /b .\Bukkits') do (
	echo %%i >> ".\Data\emptylisttemp"
)
for /f "delims=" %%i in (.\Data\emptylisttemp) do (
	set bfilewo=%%i
	set bfilewo=!bfilewo: =!
	if not exist ".\bukkits\!bfilewo!\spigot.jar" (
		set /a no+=1 >> nul
		echo %%i >> ".\Data\emptylist"
	)
)
if !no! == 0 (
	if exist ".\Data\emptylist" (
		del ".\Data\emptylist"
	)
)
if exist ".\Data\emptylisttemp" (
	del ".\Data\emptylisttemp"
)