# Dotfiles

Detta repository innehåller mina personliga konfigurationsfiler och scripts för min Linux-utvecklingsmiljö. Främst en backup och referens, men kan användas för att replikera min setup på nya system.

## System

- **OS:** Fedora Linux
- **Skal:** Zsh
- **Terminal:** WezTerm
- **Editor:** VS Code
- **Övrigt:** Logitech MX Master 4 mus

## Innehåll

### 📁 config/

#### .wezterm.lua
WezTerm terminal emulator konfiguration.

**Placering:** `~/.wezterm.lua`

**Funktioner:**
- Tema: Dracula
- Teckensnitt: Storlek 12.0
- Minimala fönsterdekorationer
- Custom keybindings:
  - `Alt+H` - Dela horisontellt
  - `Alt+J` - Dela vertikalt
  - `Alt+W` - Stäng aktuell panel
  - `Alt+Piltangenter` - Navigera mellan paneler
  - `Ctrl+Shift+T` - Ny flik
  - `Ctrl+Tab` / `Ctrl+Shift+Tab` - Byt mellan flikar

#### keybindings.json
Custom keybindings för VS Code.

**Placering:** `~/.config/Code/User/keybindings.json`

**Funktioner:**
- `Ctrl+Enter` - Kör Python i dedikerad terminal
- `Ctrl+Up/Down` - Flytta rader
- `Alt+H` - Dela editor höger
- `Alt+Left/Right` - Navigera mellan editor groups och flikar
- `Alt+Up` - Fokusera editor group
- `Alt+Down` - Toggla terminal

#### linux-keybinds
GNOME custom keyboard shortcuts konfiguration.

**Användning:** Importera inställningar manuellt via GNOME Settings

**Shortcuts:**
- `Super+T` - Öppna WezTerm
- `Super+V` - Öppna VS Code
- `Super+A` - Öppna VS Code med anteckningar workspace

#### logid.cfg
Konfiguration för Logitech MX Master 4 via `logiops`.

**Placering:** `/etc/logid.cfg` (kräver sudo)

**Funktioner:**
- DPI: 1000
- SmartShift aktiverad
- Sidoknapp gester:
  - Upp: `Super+Tab` (fönsterväxlare)
  - Ner: `Super+N` (nytt fönster)
  - Vänster/Höger: Byt workspace
  - Klick: `Super` (visa applikationer)
- Framåt/Tillbaka-knappar för webbläsarnavigering
- Tumhjul: Volymkontroll

**Beroenden:**
```bash
sudo dnf install logiops
sudo systemctl enable --now logid
```

Efter ändringar:
```bash
sudo systemctl restart logid
```

### 📁 scripts/

#### create-python-projekt
Bash-script för att skapa nya Python-projekt med komplett struktur och GitHub-integration.

**Placering:** `~/.local/bin/create-python-projekt` (gör körbar med `chmod +x`)

**Funktioner:**
- Interaktiv projektmapp och namnväljare
- Skapar struktur: `src/`, `tests/`, `main.py`, `README.md`, `.gitignore`, `requirements.txt`
- Initierar Git repository (main branch)
- Skapar Python virtual environment (`.venv`)
- Initial commit
- Valfri GitHub repository creation (public/private)
- Automatisk push till GitHub

**Beroenden:**
```bash
sudo dnf install gh
gh auth login
```

**Användning:**
```bash
create-python-projekt
```

### 📁 zsh/

#### auto-activate-venv
Zsh hook för automatisk aktivering av Python virtual environments.

**Placering:** Lägg till i `~/.zshrc`

**Användning:**
```bash
cat zsh/auto-activate-venv >> ~/.zshrc
source ~/.zshrc
```

**Funktioner:**
- Aktiverar automatiskt `.venv` när du går in i en projektmapp
- Deaktiverar när du lämnar mappen
- Förhindrar dubbel aktivering
- Visuell feedback med emojis

## Installation

Eftersom detta är en backup snarare än ett automatiserat setup:

1. **Klona repot:**
   ```bash
   git clone https://github.com/Thomas-3145/dotfiles.git ~/dotfiles
   ```

2. **Kopiera/länka filer manuellt:**
   ```bash
   # WezTerm
   cp ~/dotfiles/config/.wezterm.lua ~/.wezterm.lua

   # VS Code keybindings
   cp ~/dotfiles/config/keybindings.json ~/.config/Code/User/keybindings.json

   # Logiops (kräver sudo)
   sudo cp ~/dotfiles/config/logid.cfg /etc/logid.cfg
   sudo systemctl restart logid

   # Python projekt script
   cp ~/dotfiles/scripts/create-python-projekt ~/.local/bin/
   chmod +x ~/.local/bin/create-python-projekt

   # Zsh auto-venv
   cat ~/dotfiles/zsh/auto-activate-venv >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Installera beroenden:**
   ```bash
   sudo dnf install gh logiops
   gh auth login
   ```

## Beroenden

- **GitHub CLI (gh):** För `create-python-projekt` script
- **logiops:** För Logitech mus-konfiguration
- **WezTerm:** Terminal emulator
- **VS Code:** Code editor
- **Zsh:** Shell (med Oh My Zsh rekommenderat)
- **Python 3:** För virtual environments

## Licens

Personliga konfigurationsfiler - använd fritt!
