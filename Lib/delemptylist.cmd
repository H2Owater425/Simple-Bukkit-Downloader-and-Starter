for /f "delims=" %%i in (.\Data\emptylist) do (
	set listitem=%%i
	rd /s /q ".\Bukkits\!listitem!"
)