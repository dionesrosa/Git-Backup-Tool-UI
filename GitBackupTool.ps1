$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new($true)

# Define a largura fixa da tela
$width = 120
$host.UI.RawUI.WindowTitle = "Git Backup Tool"

function Center-Text {
    param ([string]$text)
    $len = $text.Length
    $spaces = [Math]::Max(0, [Math]::Floor(($width - $len) / 2))
    $padding = " " * $spaces
    Write-Host "$padding$text"
}

function Center-Screen {
    param (
        [int]$lineCount
    )
    $height = [Console]::WindowHeight
    $topPadding = [Math]::Max(0, [Math]::Floor(($height - $lineCount) / 2))
    for ($i = 0; $i -lt $topPadding; $i++) {
        Write-Host ""
    }
}

Clear-Host
$lineCount = 10  # número total de linhas que teu menu usa
Center-Screen -lineCount $lineCount

# Verifica se o Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Center-Text "Erro: Git não está instalado ou não está no PATH."
    Pause
    exit
}

Center-Text "==============================="
Center-Text "GIT BACKUP TOOL"
Center-Text "==============================="
Write-Host ""
Center-Text "Diretório atual: $(Get-Location)"
Write-Host ""
Center-Text "1 - Criar backup da main"
Center-Text "2 - Restaurar backup da main"
Center-Text "3 - Listar branches locais"
Center-Text "4 - Sair"
Write-Host ""

$escolha = Read-Host "Escolhe uma opção"

switch ($escolha) {
    "1" {
        Clear-Host
        Center-Text "==========================================="
        Center-Text ">> CRIAR BACKUP DA BRANCH MAIN <<"
        Center-Text "==========================================="
        Write-Host ""
        Center-Text "Esse processo vai:"
        Center-Text "- Ir pra branch main"
        Center-Text "- Atualizar com o remoto (git pull)"
        Center-Text "- Criar uma nova branch com data/hora"
        Center-Text "- Subir essa branch pro Git remoto"
        Center-Text "- Voltar pra main"
        Write-Host ""
        $confirm = Read-Host "Deseja mesmo continuar? (s/n)"
        if ($confirm -ne "s") { exit }
        git checkout main
        git pull origin main
        $data = Get-Date -Format "yyyy-MM-dd-HHmm"
        git checkout -b "main-backup-$data"
        git push origin "main-backup-$data"
        git checkout main
        Write-Host ""
        Center-Text "Backup criado: main-backup-$data"
        Pause
    }
    "2" {
        Clear-Host
        Center-Text "==========================================="
        Center-Text ">> RESTAURAR BACKUP <<"
        Center-Text "==========================================="
        Write-Host ""
        Center-Text "Branches disponíveis:"
        git branch --list main-backup-*
        Write-Host ""
        $bkpname = Read-Host "Digite o nome exato do backup que deseja restaurar"
        Write-Host ""

        # Verifica se a branch existe
        if (-not (git show-ref --verify --quiet "refs/heads/$bkpname")) {
            Center-Text "Backup '$bkpname' não existe."
            Pause
            exit
        }

        Center-Text "Esse processo vai:"
        Center-Text "- Ir pra branch main"
        Center-Text "- Substituir ela com o conteúdo de $bkpname"
        Center-Text "- FORÇAR a mudança com 'git reset --hard'"
        Write-Host ""
        $confirm = Read-Host "Tem certeza que deseja restaurar? (s/n)"
        if ($confirm -ne "s") { exit }
        git checkout main
        git reset --hard $bkpname
        Write-Host ""
        Center-Text ">> Restauração completa da main usando $bkpname"
        Pause
    }
    "3" {
        Clear-Host
        Center-Text "==========================================="
        Center-Text ">> BRANCHES LOCAIS <<"
        Center-Text "==========================================="
        Write-Host ""
        git branch
        Write-Host ""
        Pause
    }
    "4" {
        Write-Host ""
        Center-Text "Saindo..."
        Start-Sleep -Seconds 1
        exit
    }
    default {
        Write-Host ""
        Center-Text "Opção inválida. Tente de novo."
        Start-Sleep -Seconds 2
    }
}