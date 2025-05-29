@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Git-Backup-Tool-UI.ps1"
pause