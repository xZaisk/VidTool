@echo off
setlocal enabledelayedexpansion
title YouTube Video Utility

mode con cols=60 lines=30

:menu
cls
echo ==========================
echo   YouTube Video Utility  
echo ==========================
echo 1. Download video
echo 2. Convert .webm to .mp4
echo 3. Install yt-dlp (via pip)
echo 4. Install ffmpeg (via Chocolatey)
echo 5. Get Python and Chocolatey (Show Links)
echo 6. Exit
echo ==========================
set /p choice="Select an option (1-6): "

:: Validate input
if "%choice%"=="1" goto check_yt_dlp
if "%choice%"=="2" goto check_ffmpeg
if "%choice%"=="3" goto install_yt_dlp
if "%choice%"=="4" goto check_chocolatey
if "%choice%"=="5" goto get_python_choco
if "%choice%"=="6" exit

:: If invalid input, show error and return to menu
echo Invalid option. Please enter a number between 1 and 6.
pause
goto menu

:check_yt_dlp
yt-dlp --version >nul 2>nul
if %errorlevel% neq 0 (
    echo yt-dlp is not installed. Please install it first.
    pause
    goto menu
)
goto download

:check_ffmpeg
ffmpeg -version >nul 2>nul
if %errorlevel% neq 0 (
    echo ffmpeg is not installed. Please install it first.
    pause
    goto menu
)
goto convert

:download
cls
echo ===== Download Video =====
set /p url="Enter URL: "
set /p filetime="Enter time (format: 0:00:00-0:30:00): "
yt-dlp --download-sections "*%filetime%" "%url%"
echo Download complete!
pause
goto menu

:convert
cls
echo === Convert .webm to .mp4 ===
set /p filename="Enter your file name (without extension): "
ffmpeg -i "%filename%.webm" "%filename%.mp4"
echo Conversion complete!
pause
goto menu

:install_yt_dlp
cls
echo Installing yt-dlp via pip...
pip install yt-dlp
echo yt-dlp installation complete!
pause
goto menu

:check_chocolatey
:: Check if Chocolatey is installed
choco -v >nul 2>nul
if %errorlevel% neq 0 (
    echo Chocolatey is not installed. Please install it manually.
    echo.
    echo Visit this link to install Chocolatey:
    echo https://chocolatey.org/install
    echo.
    echo Copy and paste the URL into your browser.
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
echo If you do not have Python or Chocolatey installed, use the links below:
echo.
echo Python: https://www.python.org/downloads/
echo Chocolatey: https://chocolatey.org/install
echo.
echo Copy and paste these URLs into your browser to download them.
pause
goto menu
