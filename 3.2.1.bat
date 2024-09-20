@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

set "current_version=3.2.0"
set "version_file=https://raw.githubusercontent.com/ImproveRei0/frpstartbat/refs/heads/main/version.txt"
set "local_script=script.bat"  
echo 正在检查网络连接
ping -n 1 8.8.8.8 > nul 2>&1
if errorlevel 1 (
    echo 网络连接失败，请检查网络设置。
    pause
    exit /b
)

echo internet is ok
timeout /t 2 > nul


for /f "delims=" %%i in ('curl -s "%version_file%"') do (
    set "remote_version=%%i"
)

if not defined remote_version (
    echo 未找到最新版本，退出。
    pause
    exit /b
)

echo 云端最新版本 !remote_version!
timeout /t 2 > nul



echo 正在下载最新脚本 (!remote_version!)...
timeout /t 2 > nul
set "remote_script=https://raw.githubusercontent.com/ImproveRei0/frpstartbat/refs/heads/main/!remote_version!.bat"
curl -s -o "!local_script!" "!remote_script!"
if errorlevel 1 (
    echo 下载失败，请检查网络。
    pause
    exit /b
)

echo 下载完成，正在执行最新的脚本...
start "" cmd /c "!local_script!"
exit /b
