#!/bin/bash
set -e

VM_NAME="chezmoi-test"
UBUNTU_VERSION="24.04"
GITHUB_USER="${GITHUB_USER:-silvioluiz}" # padrão silvioluiz
CLEANUP=false

# Parse argumentos
for arg in "$@"; do
  case $arg in
    --clean)
      CLEANUP=true
      shift
      ;;
    *)
      ;;
  esac
done

echo "🚀 Criando VM Multipass: $VM_NAME ($UBUNTU_VERSION)..."
multipass launch "$UBUNTU_VERSION" --name "$VM_NAME" --disk 20G --memory 3G

echo "⏳ Aguardando VM iniciar..."
sleep 5

echo "📦 Instalando chezmoi na VM..."
multipass exec "$VM_NAME" -- sudo apt update
multipass exec "$VM_NAME" -- sudo apt install -y chezmoi curl

echo "📥 Clonando e aplicando repositório chezmoi de $GITHUB_USER..."
multipass exec "$VM_NAME" -- chezmoi init --apply "$GITHUB_USER"

echo "🧪 Criando script de checklist na VM..."
multipass exec "$VM_NAME" -- bash -c "cat <<'EOF' > /tmp/chezmoi_test_checklist.sh
#!/bin/bash
set -e
echo '===== 🚀 Iniciando checklist do ambiente chezmoi ====='

# 1. Shell
[[ \"\$SHELL\" == *\"zsh\"* ]] && echo '✅ Shell padrão é Zsh' || echo '❌ Shell padrão não é Zsh'
command -v starship >/dev/null && echo '✅ Starship: ' \$(starship --version) || echo '❌ Starship não encontrado'

# 2. Plugins
[[ -n \"\$(typeset -f _fzf_tab_completion 2>/dev/null)\" ]] && echo '✅ fzf-tab' || echo '⚠️ fzf-tab não detectado'
[[ -n \"\$ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE\" ]] && echo '✅ zsh-autosuggestions' || echo '⚠️ zsh-autosuggestions não detectado'
command -v zoxide >/dev/null && echo '✅ zoxide' || echo '❌ zoxide não encontrado'

# 3. mise
if command -v mise >/dev/null 2>&1; then
  echo "✅ mise: $(mise --version | head -n1)"

  for tool in node python go; do
    # há algo instalado/configurado para esse tool?
    if out="$(mise ls "$tool" 2>/dev/null)" && [[ -n "$out" ]]; then
      # tenta mostrar a versão do binário ativo no PATH
      case "$tool" in
        node)   bin=node ;;
        python) bin=python3 ;;  # costuma ser python3
        go)     bin=go ;;
      esac

      if command -v "$bin" >/dev/null 2>&1; then
        ver="$("$bin" --version 2>/dev/null | head -n1)"
        echo "✅ $tool no mise — ${ver:-instalado}"
      else
        echo "⚠️  $tool listado no mise, mas binário não está no PATH (ative o shell e rode 'mise install')."
      fi
    else
      echo "❌ $tool não encontrado no mise"
    fi
  done
else
  echo "❌ mise não encontrado"
fi

# 4. CLIs cloud
for cli in aws gh gcloud; do
  command -v \$cli >/dev/null && echo \"✅ \$cli: \$($cli --version | head -n1)\" || echo \"❌ \$cli não encontrado\"
done

# 5. Multiplexadores
for mux in tmux zellij; do
  command -v \$mux >/dev/null && echo \"✅ \$mux: \$($mux -V 2>/dev/null || $mux --version)\" || echo \"❌ \$mux não encontrado\"
done

# 6. Neovim
command -v nvim >/dev/null && echo '✅ Neovim: ' \$(nvim --version | head -n1) || echo '❌ Neovim não encontrado'

# 7. Utilitários comuns
for tool in bat btop curlie dust eza fd fzf htop hurl k9s lazygit lazydocker navi nu rg shellcheck starship yazi zoxide; do
  command -v \$tool >/dev/null && echo \"✅ \$tool\" || echo \"❌ \$tool não encontrado\"
done

echo '===== ✅ Fim ====='
EOF"

multipass exec "$VM_NAME" -- chmod +x /tmp/chezmoi_test_checklist.sh

echo "▶️ Rodando checklist..."
multipass exec "$VM_NAME" -- /tmp/chezmoi_test_checklist.sh

if [ "$CLEANUP" = true ]; then
  echo "🧹 Limpando VM..."
  multipass delete "$VM_NAME"
  multipass purge
  echo "✅ VM apagada."
else
  echo "💡 Para entrar na VM manualmente:"
  echo "    multipass shell $VM_NAME"
  echo "💡 Para apagar depois:"
  echo "    multipass delete $VM_NAME && multipass purge"
fi
