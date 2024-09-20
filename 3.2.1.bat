@echo off
chcp 65001 > nul
setlocal

:: 设置当前版本号和云端基本 URL
set "current_version=3.2.1"
set "username=ImproveRei0"  :: 替换为你的 GitHub 用户名
set "repository=frpstartbat"  :: 替换为你的仓库名称
set "branch=main"  :: 替换为你的分支名称（如 main 或 master）
set "base_url=https://raw.githubusercontent.com/%username%/%repository%/%branch%/"
set "local_script=%current_version%.bat"
set "remote_script=%base_url%%local_script%"

:: 检查网络连接
ping -n 1 8.8.8.8 > nul 2>&1
if errorlevel 1 (
    echo 网络连接失败，请检查网络设置。
    pause
    exit /b
)

:: 获取云端版本号（文件名）
for /f "delims=" %%i in ('curl -s "%base_url%" ^| findstr /R "^[0-9]*\.[0-9]*\.[0-9]*\.bat$"') do (
    set "remote_script=%%i"
    set "remote_version=%%~ni"  :: 获取文件名（去掉 .bat 后缀）
)

:: 比较版本号
if "%current_version%" == "%remote_version%" (
    echo 当前脚本已是最新版本 (%current_version%)，无需下载。
    pause
    exit /b
)

:: 下载最新脚本
echo 正在下载最新脚本 (%remote_version%)...
curl -s -o "%local_script%" "%remote_script%"
if errorlevel 1 (
    echo 下载失败，请检查 URL。
    pause
    exit /b
)

:: 执行最新的脚本
echo 下载完成，正在执行最新的脚本...
start "" cmd /c "%local_script%"
exit /b
