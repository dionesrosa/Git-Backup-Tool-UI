@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

:MENU
cls
echo ===============================
echo        GIT BACKUP TOOL
echo ===============================
echo Diretório atual: %CD%
echo.
echo 1 - Criar backup da main
echo 2 - Restaurar backup da main
echo 3 - Listar branches locais
echo 4 - Sair
echo.
set /p escolha="Escolhe uma opcao: "

if "%escolha%"=="1" goto BACKUP
if "%escolha%"=="2" goto RESTAURAR
if "%escolha%"=="3" goto LISTAR
if "%escolha%"=="4" goto FIM
goto MENU

:BACKUP
cls
echo ===========================================
echo       >> CRIAR BACKUP DA BRANCH MAIN <<
echo ===========================================
echo Esse processo vai:
echo - Ir pra branch main
echo - Atualizar com o remoto (git pull)
echo - Criar uma nova branch com data/hora
echo - Subir essa branch pro Git remoto
echo - Voltar pra main
echo.
set /p confirm="Deseja mesmo continuar? (s/n): "
if /i not "%confirm%"=="s" if /i not "%confirm%"=="S" goto MENU

echo.
git checkout main
git pull origin main

for /f %%i in ('powershell -command "Get-Date -Format yyyy-MM-dd-HHmm"') do set DATA=%%i
git checkout -b main-backup-%DATA%
git push origin main-backup-%DATA%
git checkout main

echo.
echo Backup criado: main-backup-%DATA%
pause
goto MENU

:RESTAURAR
cls
echo ===========================================
echo         >> RESTAURAR BACKUP <<
echo ===========================================
echo Atualizando lista de branches remotas...
git fetch --all

echo Branches de backup disponíveis:
git branch -a --list "remotes/origin/main-backup-*"
echo.

set /p bkpname="Digite o nome exato do backup (ex: main-backup-2024-05-28-1530): "
if "%bkpname%"=="" goto MENU

REM Verifica se a branch existe remotamente
git show-ref --verify --quiet refs/remotes/origin/%bkpname%
if errorlevel 1 (
    echo ERRO: Branch de backup '%bkpname%' nao encontrada no remoto.
    pause
    goto MENU
)

echo.
echo Esse processo vai:
echo - Ir pra branch main
echo - Substituir ela com o conteudo de %bkpname%
echo - FORCAR a mudanca com 'git reset --hard'
echo.
set /p confirm="Tem certeza que deseja restaurar? (s/n): "
if /i not "%confirm%"=="s" if /i not "%confirm%"=="S" goto MENU

git checkout main
git fetch origin %bkpname%:%bkpname%
git reset --hard %bkpname%

echo.
echo >> Restauracao completa da main usando %bkpname%
pause
goto MENU

:LISTAR
cls
echo ===========================================
echo       >> BRANCHES LOCAIS <<
echo ===========================================
git branch
pause
goto MENU

:FIM
echo.
echo Saindo...
timeout /t 1 >nul
exit
