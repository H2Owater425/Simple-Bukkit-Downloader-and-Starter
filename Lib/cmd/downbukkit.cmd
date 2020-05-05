md ".\Bukkits\!bname!_!bver!" >> nul
copy ".\Lib\BuildTools.jar" ".\Bukkits\!bname!_!bver!\" >> nul
cd ".\Bukkits\!bname!_!bver!" >> nul
java -Xms1G -Xmx1G -jar BuildTools.jar --rev !bver!
cd !Ph! >> nul
md ".\Temp" >> nul
move ".\Bukkits\!bname!_!bver!\spigot-!bver!.jar" ".\Temp\" >> nul
rd /s /q ".\Bukkits\!bname!_!bver!" >> nul
md ".\Bukkits\!bname!_!bver!" >> nul
move ".\Temp\spigot-!bver!.jar" ".\Bukkits\!bname!_!bver!\" >> nul
ren ".\Bukkits\!bname!_!bver!\spigot-!bver!.jar" spigot.jar >> nul
copy ".\Data\eula.txt" ".\Bukkits\!bname!_!bver!\eula.txt" >> nul
rd /s /q ".\Temp" >> nul