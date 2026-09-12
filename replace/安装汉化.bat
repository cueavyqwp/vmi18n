@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /D %~dp0
title VMware汉化

:: 获取管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: 信息
echo 项目地址: https://github.com/cueavyqwp/vmi18n
echo 此汉化基于`17.6.4 build-24832109`的官方简体中文本地化,差异对比后补全缺失部分(使用deepseek根据官方日文本地化进行汉化)
echo 安装过程会重启VMware,请确保没在运行虚拟机
echo 确保批处理以管理员权限运行!!!
echo 汉化所作的修改可逆,你随时都可以删除汉化(具体见项目README.md)

:: 获取程序所在目录
:ask
echo 请指定"vmware.exe"路径(右键快捷方式^>打开文件的所在位置^>复制)
set /p vmpath=右键粘贴至此处并回车^>
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

:: 再次确认
echo 回车后开始汉化...
pause > nul

:: 确保未在运行
tasklist | find /i "vmware.exe" > nul
if %errorlevel% == 0 (
    echo 终止VMware
    taskkill /f /im vmware.exe /t
)

:: 移除旧汉化
if exist "!tarpath!\zh_CN" (
    echo 移除旧汉化
    takeown /f "!tarpath!\zh_CN" /r /d y > nul
    rd /s /q "!tarpath!\zh_CN"
)
md "!tarpath!\zh_CN"

:: 复制
echo 复制文件
xcopy zh_CN "!tarpath!\zh_CN" /E /Y

:: 创建或更新
echo 更新"preferences.ini"
if exist "%APPDATA%\VMware\preferences.ini" (
    echo 读取并修改"preferences.ini"
    "initool/initool.exe" set "%APPDATA%\VMware\preferences.ini" "" pref.locale "zh_CN" > "%APPDATA%\VMware\preferences.ini"
) else (
echo 创建"preferences.ini"
if not exist "%APPDATA%\VMware" md "%APPDATA%\VMware"
echo pref.locale = "zh_CN" > "%APPDATA%\VMware\preferences.ini"
)

:: 重启
echo 重新启动VMware
start "" "!tarpath!/../vmware.exe"

:: 结束
echo 完成
echo 回车退出
pause > nul
