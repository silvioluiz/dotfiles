# Chezmoi Dotfiles for macOS & Ubuntu

This repository contains my personal dotfiles and system setup using [chezmoi](https://www.chezmoi.io/), tailored for:

- ✅ macOS (Apple Silicon – M1/M2/M3/M4)
- ✅ Ubuntu 24.04+

## 🧰 Tools included

> Installation is modular and separated by tool.

- **Shells & Prompt**
  - `zsh`, `oh-my-zsh`, plugins
  - `starship` prompt with `catppuccin-powerline` preset
  - `nushell` included
- **CLI tools**
  - `bat`, `ripgrep`, `fzf`, `eza`, `curlie`, `atuin`, `yazi`, `navi`, `lazygit`, `lazydocker`, `nushell`
- **Multiplexers**
  - `tmux` and `zellij` with clean configs
- **Editors**
  - `nvim` with LazyVim and plugins
- **Version managers**
  - `asdf` with `nodejs`, `go` and `python` plugins
- **Cloud CLI**
  - `awscli`, `gh` (GitHub CLI), `gcloud`
- **Terminal**
  - `ghostty` installed via official manager

## 📦 Structure

```bash
chezmoi/
├── dot_zshrc.tmpl
├── dot_config/
│   ├── nvim/init.lua
│   ├── tmux/tmux.conf
│   └── zellij/config.kdl
└── install/
    ├── run_once_common_packages.sh.tmpl
    ├── run_once_zsh_ohmyzsh.sh.tmpl
    ├── run_once_starship.sh.tmpl
    ├── run_once_asdf.sh.tmpl
    ├── run_once_aws.sh.tmpl
    ├── run_once_gh.sh.tmpl
    ├── run_once_gcloud.sh.tmpl
    ├── run_once_ghostty.sh.tmpl
    └── run_once_tmux_zellij.sh.tmpl
```

## 🚀 Usage

Install chezmoi:

```bash
brew install chezmoi     # macOS
sudo apt install chezmoi # Ubuntu
```

Initialize your dotfiles:

```bash
chezmoi init --apply <your-github-username>
```

## ✅ Goals

- Reproducible development environment
- Easy to maintain and expand
- Clean shell experience with modern CLI tools
- Cross-platform support

---

Feel free to fork and customize!
