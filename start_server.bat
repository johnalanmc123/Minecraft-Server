@echo off
cd /d "%~dp0"

echo ===============================
echo Starting playit tunnel...
echo ===============================
start "" playit.exe

echo ===============================
echo Starting Minecraft server...
echo ===============================
echo Type "stop" in the console to close server properly.
echo ===============================

java -Xmx6G -Xms6G -jar server.jar nogui

echo.
echo Server has stopped. Closing script...
pause
