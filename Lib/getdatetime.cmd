for /f "tokens=2" %%i in ('date /t') do (
	set date=%%i
)
set fulltime=%date% %time%