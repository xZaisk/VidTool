@echo off
setlocal enabledelayedexpansion

:: Set window size and colors
powershell -Command "& { $h = (Get-Host).UI.RawUI; $h.WindowSize = New-Object Management.Automation.Host.Size(70, 25); $h.BufferSize = New-Object Management.Automation.Host.Size(70, 1000) }"
color 0A 

:: Default download folder
set "download_folder=C:\Users\%USERNAME%\Videos"

:menu
cls
echo ==========================
echo   YouTube Video Utility  
echo ==========================
echo [32m1. Download video[0m  
echo [34m2. Convert .webm to .mp4 (Drag / Drop)[0m  
echo [33m3. Install yt-dlp (via pip)[0m  
echo [35m4. Install ffmpeg (via Chocolatey)[0m  
echo [36m5. Get Python and Chocolatey (Show Links)[0m  
echo [31m6. Help (?)[0m  
echo [37m7. Exit[0m  
echo ==========================
set /p choice="Select an option (1-7): "

if "%choice%"=="1" goto check_yt_dlp
if "%choice%"=="2" goto convert
if "%choice%"=="3" goto install_yt_dlp
if "%choice%"=="4" goto check_chocolatey
if "%choice%"=="5" goto get_python_choco
if "%choice%"=="6" goto help
if "%choice%"=="7" exit

echo Invalid option. Please enter a number between 1 and 7.
pause
goto menu

:check_yt_dlp
yt-dlp --version >nul 2>nul
if %errorlevel% neq 0 (
    echo yt-dlp is not installed.
    set /p install_yt="Would you like to install yt-dlp? (Y/N): "
    if /I "%install_yt%"=="Y" goto install_yt_dlp
    echo Skipping yt-dlp installation.
    pause
    goto menu
)
goto download

:check_ffmpeg
ffmpeg -version >nul 2>nul
if %errorlevel% neq 0 (
    echo ffmpeg is not installed.
    set /p install_ffmpeg="Would you like to install ffmpeg? (Y/N): "
    if /I "%install_ffmpeg%"=="Y" goto install_ffmpeg
    echo Skipping ffmpeg installation.
    pause
    goto menu
)
goto convert

:download
cls
echo ===== Download Video =====
set /p url="Enter URL: "

:: Show available formats and estimated size
yt-dlp -F "%url%" | findstr "video"
set /p confirm="Proceed with download? (Y/N): "
if /I "%confirm%"=="Y" yt-dlp -o "%download_folder%\%%(title)s.%%(ext)s" "%url%"
echo Download complete!
pause
goto menu

:convert
cls
echo === Convert .webm to .mp4 ===
echo Drag and drop your .webm file here:
set /p filename="> "

:: Ensure double quotes are added around the filename and properly formatted
set "filename=%filename:"=%"
set "filename=%filename:'=%"

:: Run FFmpeg with properly formatted input
ffmpeg -i "%filename%" "%filename%.mp4"

echo Conversion complete!
pause
goto menu


:install_yt_dlp
cls
echo Installing yt-dlp, please wait...
for /l %%x in (1,1,5) do ( echo . / timeout /t 1 >nul )
pip install yt-dlp
echo yt-dlp installation complete!
pause
goto menu

:check_chocolatey
choco -v >nul 2>nul
if %errorlevel% neq 0 (
    echo Chocolatey is not installed. Please install it manually.
    echo.
    echo Visit this link to install Chocolatey:
    echo https://chocolatey.org/install
    pause
    goto menu
)
goto install_ffmpeg

:install_ffmpeg
cls
echo Installing ffmpeg via Chocolatey...
choco install ffmpeg -y
echo ffmpeg installation complete!
pause
goto menu

:get_python_choco
cls
echo === Download Python and Chocolatey ===
echo Python: https://www.python.org/downloads/
echo Chocolatey: https://chocolatey.org/install
echo Copy and paste these URLs into your browser to download them.
pause
goto menu

:help
cls
echo === Help Guide ===
echo - 1: Download videos (Shows file size before downloading)
echo - 2: Convert .webm to .mp4 (Drag / Drop support)
echo - 3: Install yt-dlp via pip if missing
echo - 4: Install ffmpeg via Chocolatey
echo - 5: Display Python / Chocolatey download links
echo - 6: This Help menu
echo - 7: Exit the script
pause
goto menu
