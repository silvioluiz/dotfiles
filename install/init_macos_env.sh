#!/bin/bash
#
# Script auxiliar para configurar o ambiente para outros scripts chezmoi.
# - No macOS, configura o PATH para o Homebrew.
# - No Linux, não faz nada e termina com sucesso.

# Verifica se estamos no macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    
    # Este bloco SÓ é executado no macOS.
    # Adiciona o Homebrew ao PATH da sessão ATUAL do script.
    
    # Prioriza o caminho do Apple Silicon, mas funciona para Intel também.
    if [ -x "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Validação final: se o brew ainda não for encontrado, o script falha.
    if ! command -v brew >/dev/null 2>&1; then
        echo "[!] Erro Crítico (macOS): O comando 'brew' não pôde ser encontrado." >&2
        echo "    Certifique-se de que o Homebrew está instalado no local padrão." >&2
        exit 1
    fi
    
fi
