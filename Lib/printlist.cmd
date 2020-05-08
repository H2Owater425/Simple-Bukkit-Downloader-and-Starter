for /f "delims=" %%i in (.\Data\list) do (
	set listitem=%%i
	set listitem=!listitem:: =. !
	echo │  !listitem!
)