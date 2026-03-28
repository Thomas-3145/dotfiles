# Dotfiles

Detta repository innehåller mina personliga konfigurationsfiler och scripts för en snabb och effektiv Linux-utvecklingsmiljö (Fedora).

Projektet fungerar som backup och referens, strukturerat för att enkelt kunna replikera min setup på nya system.

---

## Systemöverblick

- **OS:** Fedora Linux
- **Skal:** Zsh (med Oh My Zsh)
- **Terminal:** WezTerm (GPU-accelererad)
- **Editor:** VS Code & Micro (terminal)
- **Anteckningar:** Obsidian
- **Hårdvara:** Logitech MX Master 4 via logiops

---

## Mappstruktur

```
dotfiles/
├── config/
│   ├── gnome/        # GNOME keybindings
│   ├── logitech/     # logid.cfg för MX Master 4
│   ├── micro/        # Terminal-editor inställningar
│   ├── vscode/       # Keybindings
│   └── wezterm/      # WezTerm-konfiguration
├── git/              # Git-konfiguration
├── obsidian/         # Obsidian vault-inställningar (.obsidian/)
├── scripts/          # Bash-scripts
├── ssh/              # SSH config
├── systemd/          # Systemd timer för automatiska uppdateringar
└── zsh/              # Zsh-konfiguration (.zshrc)
```

---

## zsh/

### .zshrc

Shell-konfiguration optimerad för DevOps- och Python-utveckling.

**Funktioner:**
- **DevOps Dashboard** — visar RAM, Disk och Docker-status varje gång terminalen öppnas
- **Auto-venv** — aktiverar Python `.venv` automatiskt när du går in i en projektmapp
- **Anteckningssystem** — `n [namn]` skapa/öppna anteckning, `ns [ord]` sök i anteckningar
- **myip** — snygg vy av lokal och publik IP-adress
- **fzf** (Ctrl+R) — fuzzy-sökning i historiken
- **z** — hoppa snabbt till mappar du ofta besöker
- **extract** — packa upp valfri komprimerad fil
- **Docker-alias** — `dps`, `dlogs`, `dclean`

---

## config/

### WezTerm (`wezterm/.wezterm.lua`)
- Tema: Dracula (High Contrast)
- `Alt + H/J` — dela fönster
- `Alt + Pilar` — navigera mellan paneler

### VS Code (`vscode/keybindings.json`)
- `Ctrl + Enter` — kör Python-kod i terminalen
- `Alt + H` — split screen
- `Alt + Pilar` — navigera mellan flikar

### Micro (`micro/settings.json`)
- Terminal-editor med Dracula-tema, sparad undo-historik och automatisk mappskapande

### Logitech (`logitech/logid.cfg`)
- Gester, tumhjul (volym) och snabb växling mellan workspaces för MX Master 4

### GNOME (`gnome/keybindings.txt`)
- Backup av GNOME keyboard shortcuts

---

## obsidian/

Obsidian vault-inställningar (motsvarar `.obsidian/` i vaulten).

Symlänkad till vault:
```bash
ln -s ~/dev/dotfiles/obsidian "~/Dokument/Obsidian Vault/.obsidian"
```

Innehåller: `app.json`, `appearance.json`, `hotkeys.json`, `core-plugins.json`, `graph.json`, `workspace.json`, teman.

---

## git/

Git-konfiguration.

---

## ssh/

SSH `config`-fil med host-definitioner.

---

## scripts/

- **`new_python_project.sh`** — skapar mappstruktur, initierar Git, skapar `.venv` och GitHub-repo via `gh`
- **`pi-setup.sh`** — setup-script för Raspberry Pi

---

## systemd/

Systemd timer för automatiska systemuppdateringar var 24:e timme.

> Filerna är kopior (backuper) — de körs inte automatiskt härifrån. De måste kopieras till `/etc/systemd/system/`.

---

## Installation

### 1. Installera baspaket

```bash
sudo dnf install zsh micro ripgrep git gh logiops fzf
```

### 2. Länka konfigurationsfiler

```bash
cp ~/dev/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dev/dotfiles/config/wezterm/.wezterm.lua ~/.wezterm.lua
ln -s ~/dev/dotfiles/config/micro/settings.json ~/.config/micro/settings.json
ln -s ~/dev/dotfiles/config/vscode/keybindings.json ~/.config/Code/User/keybindings.json
ln -s ~/dev/dotfiles/obsidian "~/Dokument/Obsidian Vault/.obsidian"
```

### 3. Aktivera Logitech-gester

```bash
sudo ln -s ~/dev/dotfiles/config/logitech/logid.cfg /etc/logid.cfg
sudo systemctl enable --now logid
```

### 4. Ladda om konfigurationen

```bash
source ~/.zshrc
```

### 5. Aktivera automatiska uppdateringar

```bash
sudo cp ~/dev/dotfiles/systemd/daily-update.* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now daily-update.timer
```
