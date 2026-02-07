# =========================================================
# 1. OH-MY-ZSH SETUP
# =========================================================
export ZSH="$HOME/.oh-my-zsh"

# Tema (Används om du inte kör Starship)
ZSH_THEME="dracula"

# Gör så att tab-completion struntar i om det är bindestreck (-) eller understreck (_)
HYPHEN_INSENSITIVE="true"

# Uppdatera Oh My Zsh automatiskt utan att fråga
zstyle ':omz:update' mode auto

# Plugins (Lägg till fler här om du vill, t.ex. 'docker' eller 'python')
# SSH-agent inställningen du hade
zstyle :omz:plugins:ssh-agent identities id_rsa_4096
plugins=(git ssh-agent zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# =========================================================
# 2. GRUNDINSTÄLLNINGAR & PATH
# =========================================================
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=micro
export VISUAL=micro
export LANG=en_US.UTF-8

# Aktivera färger för ls/dir (om din färgfil finns)
[ -f ~/.dir_colors/dircolors ] && eval "$(dircolors ~/.dir_colors/dircolors)"

# =========================================================
# 3. ALIAS (Genvägar)
# =========================================================
alias nano="micro"
alias rg="rg --smart-case"

# SSH Servrar
alias router="ssh router"
alias 3145="ssh -p 22456 thomas@192.168.10.10"
alias 3145-2="ssh -p 22456 thomas@192.168.10.11"
alias ubuntuserver="ssh thomas@192.168.122.7 -p 22456"
alias fedoraserver="ssh thomas@192.168.122.41 -p 22456"

# =========================================================
# 4. ANTECKNINGSSYSTEM (Notes)
# =========================================================
NOTES_DIR=~/notes

# Gå direkt till anteckningarna
alias note="mkdir -p $NOTES_DIR && cd $NOTES_DIR && ls"

# Snabbskapa: n "filnamn"
function n() {
    mkdir -p $NOTES_DIR
    micro "$NOTES_DIR/$1.md"
}

# Sök: ns "sökord"
function ns() {
    if command -v rg &> /dev/null; then
        rg -i "$1" $NOTES_DIR
    else
        grep -rni --color=auto "$1" $NOTES_DIR
    fi
}

# =========================================================
# 5. AUTOMATIK (Venv & Starship)
# =========================================================

# Auto-aktivera Python venv
function chpwd() {
    if [ -d ".venv" ]; then
        if [[ "$VIRTUAL_ENV" == "" ]]; then
            source .venv/bin/activate
            echo "🐍 .venv aktiverad!"
        fi
    elif [[ "$VIRTUAL_ENV" != "" ]]; then
        if typeset -f deactivate > /dev/null; then
            deactivate
            echo "👋 .venv avaktiverad"
        fi
    fi
}
chpwd

# AKTIVERA STARSHIP PROMPT
# (Ta bort # nedan när du installerat Starship för en snyggare prompt)
# eval "$(starship init zsh)"
