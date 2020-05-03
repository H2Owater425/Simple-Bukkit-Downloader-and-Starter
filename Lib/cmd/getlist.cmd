if exist .\Data\list (
	del .\Data\list
)
if exist .\Data\listtemp (
	del .\Data\listtemp
)
set /a no=0
FOR /F %%i IN ('dir /b .\Bukkits') DO echo %%i >> .\Data\listtemp
for /f "delims=" %%i in (.\Data\listtemp) do (
	set /a no+=1 >> nul
	echo !no!. %%i >> .\Data\list
)
if exist .\Data\listtemp (
	del .\Data\listtemp
)