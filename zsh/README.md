Min Linux Config (Fedora) 🐧
Här är mina inställningar (dotfiles) för en snabb, tangentbordsfokuserad terminal-miljö med Zsh, WezTerm och Micro.

🛠 Verktyg som krävs
För att mina configs ska fungera måste följande program vara installerade:

OS: Fedora (men fungerar på andra distros med små justeringar)

Terminal: WezTerm (GPU-accelererad)

Shell: Zsh + Oh My Zsh

Editor: Micro

Sök: Ripgrep (rg)

Typsnitt: Ett "Nerd Font" (rekommenderas för ikoner i terminalen)

🚀 Installation
1. Installera paket (Fedora)
Kör följande för att installera grunderna: $ sudo dnf install zsh micro ripgrep git

2. Installera Oh My Zsh
Detta krävs för att temat och pluginsen ska fungera: $ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

3. Hämta Zsh-plugins (Viktigt!)
Kör dessa två kommandon i terminalen för att installera tilläggen:

PLUGINFOLDER=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions $PLUGINFOLDER/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PLUGINFOLDER/zsh-syntax-highlighting

4. Installera Config-filer
Kopiera filerna från detta repo till din hemkatalog:

.zshrc -> ~/.zshrc

.wezterm.lua -> ~/.wezterm.lua

settings.json -> ~/.config/micro/settings.json

🎨 Tema
Jag kör Dracula konsekvent överallt för hög kontrast och bra läsbarhet.

WezTerm: Inställt i .wezterm.lua (High Contrast).

Zsh: ZSH_THEME="dracula"

Micro: Installera med kommandot "micro -plugin install dracula-colors" inne i micro.

⌨️ Mina Egna Kommandon (Alias)
Jag har byggt ett eget system för snabba anteckningar i terminalen.

note: Går direkt till anteckningsmappen (~/notes).

n [namn]: Skapar eller öppnar en anteckning direkt. T.ex: "n server-setup"

ns [sök]: Söker blixtsnabbt i alla anteckningar (använder ripgrep). T.ex: "ns lösenord"

rg: Smart sökning (ignorerar case om du skriver små bokstäver).

SSH Genvägar
router: Kopplar upp mot routern.

ubuntuserver: Kopplar upp mot lab-servern.
