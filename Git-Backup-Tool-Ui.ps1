# Define a codificação de saída do console e do PowerShell para UTF-8
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($true)
$OutputEncoding = [System.Text.UTF8Encoding]::new($true)

# Define a largura fixa da tela para centralizar textos
$width = 120

# Define o título da janela do terminal
$host.UI.RawUI.WindowTitle = "Git Backup Tool UI"

# Função para centralizar texto na tela
function Center-Text {
    param ([string]$text)
    $len = $text.Length
    $spaces = [Math]::Max(0, [Math]::Floor(($width - $len) / 2))
    $padding = " " * $spaces
    Write-Host "$padding$text"
}

# Função para centralizar o conteúdo verticalmente na tela
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

# Função para aguardar o usuário pressionar uma tecla para voltar ou sair
function Wait-ReturnOrExit {
    Center-Text "Pressione qualquer tecla para voltar ao menu principal ou 'x' para sair..."
    $keyInfo = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    $keyChar = $keyInfo.Character
    if ($keyChar -eq 'x' -or $keyChar -eq 'X') {
        Center-Text "Saindo..."
        Start-Sleep -Seconds 1
        Clear-Host
        exit
    }
    Clear-Host
}

# Limpa a tela antes de iniciar o menu principal
Clear-Host

# Loop principal do menu
while ($true) {
    $lineCount = 14  # Número de linhas do menu para centralização vertical
    Center-Screen -lineCount $lineCount

    # Verifica se o Git está instalado
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Center-Text "Erro: Git não está instalado ou não está no PATH."
        Wait-ReturnOrExit
        exit
    }

    # Exibe o menu principal centralizado
    Center-Text "==============================="
    Center-Text "GIT BACKUP TOOL UI"
    Center-Text "==============================="
    Write-Host ""
    Center-Text "Diretório atual: $(Get-Location)"
    Write-Host ""
    Center-Text "1 - Criar backup da main"
    Center-Text "2 - Restaurar backup da main"
    Center-Text "3 - Listar branches locais"
    Center-Text "4 - Sair"
    Write-Host ""

    # Lê a opção escolhida pelo usuário
    $escolha = Read-Host "Escolhe uma opção"

    switch ($escolha) {
        "1" {
            # Opção para criar backup da branch main
            Clear-Host
            $lineCount = 14
            Center-Screen -lineCount $lineCount
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
            if ($confirm -ne "s") { continue }

            # Troca para a branch main
            & git checkout main
            if (-not $?) {
                Center-Text "Erro ao mudar pra main."
                Wait-ReturnOrExit
                continue
            }

            # Atualiza a branch main com o remoto
            & git pull origin main
            if (-not $?) {
                Center-Text "Erro ao atualizar a main."
                Wait-ReturnOrExit
                continue
            }

            # Cria o nome da branch de backup com data/hora
            $data = Get-Date -Format "yyyy-MM-dd-HH-mm"
            $backupBranch = "main-backup-$data"

            # Cria a nova branch de backup
            & git checkout -b $backupBranch
            if (-not $?) {
                Center-Text "Erro ao criar a branch $backupBranch"
                Wait-ReturnOrExit
                continue
            }

            # Sobe a branch de backup para o remoto
            & git push origin $backupBranch
            if (-not $?) {
                Center-Text "Erro ao subir a branch $backupBranch"
                Wait-ReturnOrExit
                continue
            }

            # Volta para a branch main
            & git checkout main
            Write-Host ""
            Center-Text "Backup criado: $backupBranch"
            Wait-ReturnOrExit
        }
        "2" {
            # Opção para restaurar backup da main
            Clear-Host
            $lineCount = 12
            Center-Screen -lineCount $lineCount
            Center-Text "==========================================="
            Center-Text ">> RESTAURAR BACKUP <<"
            Center-Text "==========================================="
            Write-Host ""
            # Lista as branches de backup disponíveis
            & git branch --list main-backup-*
            Write-Host ""
            $bkpname = Read-Host "Digite o nome exato do backup que deseja restaurar"
            Write-Host ""

            # Verifica se a branch de backup existe
            & git show-ref --verify --quiet "refs/heads/$bkpname"
            if (-not $?) {
                Center-Text "Backup '$bkpname' não existe."
                Wait-ReturnOrExit
                continue
            }

            Center-Text "Esse processo vai:"
            Center-Text "- Ir pra branch main"
            Center-Text "- Substituir ela com o conteúdo de $bkpname"
            Center-Text "- FORÇAR a mudança com 'git reset --hard'"
            Write-Host ""
            $confirm = Read-Host "Tem certeza que deseja restaurar? (s/n)"
            if ($confirm -ne "s") { continue }

            # Troca para a branch main
            & git checkout main
            if (-not $?) {
                Center-Text "Erro ao mudar para a branch main."
                Wait-ReturnOrExit
                continue
            }

            # Reseta a main para o backup escolhido
            & git reset --hard $bkpname
            if (-not $?) {
                Center-Text "Erro ao resetar para $bkpname."
                Wait-ReturnOrExit
                continue
            }

            Write-Host ""
            Center-Text ">> Restauração completa da main usando $bkpname"
            Wait-ReturnOrExit
        }
        "3" {
            # Opção para listar branches locais
            Clear-Host
            $lineCount = 8
            Center-Screen -lineCount $lineCount
            Center-Text "==========================================="
            Center-Text ">> BRANCHES LOCAIS <<"
            & git branch
            Write-Host ""
            Wait-ReturnOrExit
        }
        "4" {
            # Opção para sair do programa
            Write-Host ""
            Center-Text "Saindo..."
            Start-Sleep -Seconds 1
            exit
        }
        default {
            # Caso o usuário digite uma opção inválida
            Write-Host ""
            Center-Text "Opção inválida. Tente de novo."
            Start-Sleep -Seconds 2
            Clear-Host
        }
    }
}
