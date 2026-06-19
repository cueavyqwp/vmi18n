@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /D %~dp0
title VMware汉化

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo 此汉化基于`17.6.4 build-24832109`的官方简体中文本地化,差异对比后补全(使用deepseek根据官方日文汉化)
echo 安装过程会重启VMware,请确保没在运行虚拟机
echo 汉化不会修改或破坏原程序

:ask
set /p vmpath=请指定"vmware.exe"路径(右键快捷方式^>打开文件的所在位置^>复制)右键粘贴至此处并回车^>
set "vmpath=!vmpath:"=!"
echo "!vmpath!" | findstr .lnk > nul && (
    echo 不要直接拖拽快捷方式!
    goto ask
) || (
    if not exist "!vmpath!" echo 路径不存在! && goto ask
    for %%a in ("!vmpath!") do set "vmdir=%%~dpa"
    set "tarpath=!vmdir!messages"
    if exist "!tarpath!" (
        echo 工作目录: "!tarpath!"
    ) else (
        echo 路径无效!
        goto ask
    )
)

echo 回车后开始汉化...
pause > nul

echo 复制文件
if not exist "!tarpath!\zh_CN" md "!tarpath!\zh_CN"
xcopy zh_CN "!tarpath!\zh_CN" /E /Y

echo 更新"preferences.ini"
if exist "%APPDATA%\VMware\preferences.ini" (
    echo 读取并修改"preferences.ini"
    "initool/initool.exe" set "%APPDATA%\VMware\preferences.ini" "" pref.locale "zh_CN" > "%APPDATA%\VMware\preferences.ini"
) else (
echo 创建"preferences.ini"
if not exist "%APPDATA%\VMware" md "%APPDATA%\VMware"
echo pref.locale = "zh_CN" > "%APPDATA%\VMware\preferences.ini"
)

echo 终止VMware
taskkill /f /im vmware.exe /t  > nul

echo 重新启动VMware
start "" "!tarpath!/../vmware.exe"

echo 完成!
echo 回车退出
pause > nul
