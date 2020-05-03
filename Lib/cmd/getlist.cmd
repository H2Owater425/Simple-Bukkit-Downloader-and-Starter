if exist .\Data\list (
	del .\Data\list
)
if exist .\Data\listtemp (
	del .\Data\listtemp
)
set /a no=0
for /f %%i in ('dir /b .\Bukkits') do echo %%i >> .\Data\listtemp
for /f "delims=" %%i in (.\Data\listtemp) do (
	set /a no+=1 >> nul
	echo !no!. %%i >> .\Data\list
)
if %no% == 0 (
	echo There are no bukkit file! > .\Data\list
)
if exist .\Data\listtemp (
	del .\Data\listtemp
)