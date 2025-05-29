<p align="center">
  <img src="images/cover.png" alt="Capa do Git Backup Tool UI" style="height: 250px; margin: 50px;">
</p>

# Git Backup Tool UI

**Git Backup Tool UI** é um utilitário interativo em PowerShell para facilitar o backup e a restauração da branch **main** do seu repositório Git. Ele oferece uma interface de menu no terminal, tornando o processo de backup e restauração mais seguro, rápido e prático, mesmo para quem não domina comandos Git avançados.

## Funcionalidades

- **Criar backup da branch main:**  
  Cria uma nova branch de backup a partir da main, com data e hora no nome, e faz o push para o repositório remoto.
- **Restaurar a branch main:**  
  Permite restaurar a main a partir de qualquer backup criado anteriormente, de forma simples e segura.
- **Listar branches locais:**  
  Exibe todas as branches locais, facilitando a escolha do backup desejado.
- **Menu interativo:**  
  Interface amigável no terminal, com navegação por teclado e mensagens centralizadas.
- **Compatibilidade:**  
  Funciona em Windows, diretamente no PowerShell.

## Como usar

1. **Pré-requisitos:**  
   - Ter o [Git](https://git-scm.com/) instalado e disponível no PATH.
   - Ter o PowerShell instalado (versão 5 ou superior).

2. **Executando o script:**  
   - Abra o PowerShell na pasta do seu repositório Git.
   - Execute o script:
     ```powershell
     .\Git-Backup-Tool-Ui.ps1
     ```
   - Siga as instruções do menu interativo.

3. **Navegação:**  
   - Pressione o número da opção desejada e siga as instruções na tela.
   - Após cada operação, pressione qualquer tecla para voltar ao menu principal ou 'x' para sair.

## Licença

Este projeto está licenciado sob a licença MIT.  
Veja o arquivo `LICENSE` para mais detalhes.

---

Feito por [Diones Souza](https://github.com/dionesrosa)