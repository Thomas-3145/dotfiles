# Dotfiles 🐧

Detta repository innehåller mina personliga konfigurationsfiler och scripts för en snabb och effektiv Linux-utvecklingsmiljö (Fedora). Främst en backup och referens, men strukturerad för att enkelt kunna replikera min setup på nya system.

## 🛠 Systemöverblick

- **OS:** Fedora Linux
- **Skal:** Zsh (med Oh My Zsh)
- **Terminal:** WezTerm (GPU-accelererad)
- **Editor:** VS Code & Micro (Terminal)
- **Hårdvara:** Logitech MX Master 4 via `logiops`

---

## 📁 Innehåll i mappen `config/`

### WezTerm (`.wezterm.lua`)
- **Tema:** Dracula (High Contrast)
- **Custom Keybindings:** `Alt + H/J` (Dela panel), `Alt + Pil` (Navigera), `Alt + W` (Stäng).

### VS Code (`keybindings.json`)
- `Ctrl + Enter`: Kör Python-kod i dedikerad terminal.
- `Alt + H`: Dela editor till höger.
- `Alt + Vänster/Höger`: Växla snabbt mellan flikar.

### Micro (`settings.json`)
- **Inställningar:** Dracula-tema, `mkparents` (skapar mappar automatiskt) och sparad undo-historik.

### Logitech (`logid.cfg`)
- **Tumhjul:** Volymkontroll.
- **Gestknapp:** Byt workspace, Task view (`Super+Tab`) och nytt fönster (`Super+N`).

---

## 📁 Innehåll i mappen `scripts/`

### `create-python-projekt`
Bash-script som automatiserar startprocessen:
- Skapar mappstruktur, initierar Git, skapar `.venv`.
- **GitHub Integration:** Skapar repot på GitHub via `gh` CLI och pushar automatiskt.

---

## 📁 Innehåll i mappen `zsh/`

### `.zshrc`
- **Auto-venv:** Aktiverar Python `.venv` automatiskt vid `cd`.
- **Anteckningssystem:** - `n [namn]`: Skapa markdown-anteckning.
  - `ns [ord]`: Sök i alla anteckningar med `ripgrep`.
- **Smart Sök:** Alias för `rg` med `--smart-case`.

---


## 🚀 Installation

### 1. Installera paket (Fedora)

```bash
sudo dnf install zsh micro ripgrep git gh logiops
```

---

### 2. Klona repot

```bash
git clone https://github.com/Thomas-3145/dotfiles.git ~/dotfiles
```

---

### 3. Länka konfigurationer

#### Zsh (kopiera grundfilen)

```bash
cp ~/dotfiles/zsh/.zshrc ~/.zshrc
```

#### WezTerm

```bash
ln -s ~/dotfiles/config/wezterm/.wezterm.lua ~/.wezterm.lua
```

#### Micro

```bash
mkdir -p ~/.config/micro
ln -s ~/dotfiles/config/micro/settings.json ~/.config/micro/settings.json
```

#### VS Code

```bash
ln -s ~/dotfiles/config/vscode/keybindings.json ~/.config/Code/User/keybindings.json
```

#### Logitech (kräver sudo)

```bash
sudo ln -s ~/dotfiles/config/logitech/logid.cfg /etc/logid.cfg
sudo systemctl enable --now logid
```

---

### 4. Installera Zsh-plugins

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

---

## 📦 Beroenden

- **GitHub CLI (`gh`)** – används av scriptet `create-python-projekt`
- **Ripgrep (`rg`)** – snabb sökning i anteckningar och kod
- **Logiops** – mus-gesturer för Logitech-enheter
