@echo off
setlocal enabledelayedexpansion

REM === Go to script directory ===
cd /d "%~dp0"

echo ===============================
echo 1) Updating from Git (pull)
echo ===============================
git fetch origin
if errorlevel 1 (
    echo [ERROR] git fetch failed. Check your internet or remote.
    pause
    goto :end
)

REM Change "main" to your branch name if different
git pull origin main
if errorlevel 1 (
    echo [ERROR] git pull failed (maybe conflicts?). Fix manually.
    pause
    goto :end
)

echo(
echo Git pull completed successfully.
echo(

echo ===============================
echo 2) Starting playit tunnel
echo ===============================
REM Start playit in background (no wait)
start "" "playit.exe"

echo playit.exe started.
echo(

echo ===============================
echo 3) Starting Minecraft server
echo ===============================
echo Close the server with the "stop" command in the console.
echo(

REM Run server and WAIT until it stops:
REM Adjust memory and jar name as needed
java -Xmx4G -Xms4G -jar server.jar nogui
if errorlevel 1 (
    echo [WARNING] Server exited with an error code: !ERRORLEVEL!
)

echo(
echo ===============================
echo 4) Checking for changed files to push
echo ===============================

set "CHANGES="
for /f "delims=" %%i in ('git status --porcelain') do (
    set "CHANGES=1"
)

if not defined CHANGES (
    echo No changes to commit. Nothing to push.
    goto :end
)

echo Changes detected. Committing and pushing...

REM Add all modified files
git add .

REM Build a safer auto message with time components
for /f "tokens=1-4 delims=:. " %%a in ("%TIME%") do (
    set HOUR=%%a
    set MIN=%%b
    set SEC=%%c
)

set "MSG=Auto-save from %COMPUTERNAME% on %DATE% !HOUR!-!MIN!-!SEC!"

git commit -m "!MSG!"
if errorlevel 1 (
    echo [ERROR] git commit failed (maybe no changes?). Check manually.
    goto :end
)

git push origin main
if errorlevel 1 (
    echo [ERROR] git push failed. Check your internet or credentials.
    goto :end
)

echo(
echo Git push completed successfully (world synced to GitHub).

:end
echo(
echo Done. You can now close this window.
pause
endlocal
