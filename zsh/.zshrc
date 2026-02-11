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

# Plugins
zstyle :omz:plugins:ssh-agent identities id_rsa_4096
plugins=(git ssh-agent z zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# =========================================================
# 2. GRUNDINSTÄLLNINGAR & PATH
# =========================================================
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=micro
export VISUAL=micro
export LANG=en_US.UTF-8

# Aktivera Solarized färger (Nu pekar vi på filen direkt)
if [[ -f "$HOME/.dir_colors" ]]; then
    eval "$(dircolors -b "$HOME/.dir_colors")"
fi

alias ls='ls --color=auto'

# Aktivera fzf
source <(fzf --zsh)

# =========================================================
# 3. ALIAS (Genvägar)
# =========================================================
alias nano="micro"
alias rg="rg --smart-case"
alias reload="source ~/.zshrc && echo 'Config laddad!'"
alias memtjuvar="ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 10"

# SSH Servrar
alias router="ssh router"
alias media="ssh media"
alias 3145="ssh 3145"
alias proxmox="ssh proxmox"

# DevOps Docker-genvägar
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dlogs="docker logs -f"
alias dclean="docker system prune -af --volumes"

# lazydocker & lazygit
alias lg="lazygit"
alias ld="lazydocker"


# =========================================================
# 4. ANTECKNINGSSYSTEM
# =========================================================
export NOTES_DIR=~/anteckningar

# 1. Gå till anteckningsmappen
alias anteckningar="mkdir -p $NOTES_DIR && cd $NOTES_DIR && ls"

# 2. Skapa/Redigera anteckning
function an() {
    # --- SÄKERHETSSPÄRR ---
    if [ -z "$1" ]; then
        echo "❌ Du glömde filnamnet!"
        echo "👉 Användning: a <filnamn>"
        return 1
    fi

    # Bygg sökväg
    local full_path="$NOTES_DIR/$1.md"
    local target_dir=$(dirname "$full_path")

    # Skapa mapp om den saknas
    mkdir -p "$target_dir"

    # --- LOGIK FÖR INNEHÅLL ---
    if [ ! -f "$full_path" ]; then
        # SCENARIO 1: Helt ny fil (skapa rubrik)
        echo "# $(date "+%Y-%m-%d")" > "$full_path"
        echo "" >> "$full_path"
    else
        # SCENARIO 2: Filen finns redan (lägg till tidsstämpel)
        echo "" >> "$full_path"
        echo "## $(date "+%Y-%m-%d %H:%M")" >> "$full_path"
    fi

    # Öppna filen och hoppa till slutet
    micro +99999 "$full_path"
}

# 3. Sök (Innehåll)
function as() {
    if [ -z "$1" ]; then
        echo "🔍 Vad vill du söka efter? (Skriv: as sökord)"
        return 1
    fi

    if command -v rg &> /dev/null; then
        rg -i "$1" "$NOTES_DIR"
    else
        grep -rni --color=auto "$1" "$NOTES_DIR"
    fi
}

# 4. Hitta "Att Göra" (Smartare sökning)
function at() {
    echo "📝 Saker att göra:"

    # Förklaring av sök-mönstret (Regex):
    # \-      = Ett bindestreck
    # \s* = Noll eller flera mellanslag (fångar både "-[]" och "- []")
    # \[      = Vänsterklammer
    # \s* = Noll eller flera mellanslag (fångar både "[]" och "[ ]")
    # \]      = Högerklammer

    if command -v rg &> /dev/null; then
        # -N stänger av radnummer om du vill ha renare lista (valfritt)
        rg "\-\s*\[\s*\]" "$NOTES_DIR"
    else
        # grep -E (Extended regex) för att förstå \s*
        grep -rE "\-\s*\[\s*\]" "$NOTES_DIR"
    fi
}

# 5. Fuzzy Find (Öppna med fzf)
function af() {
    # Går till mappen, kör fzf med förhandsvisning, öppnar vald fil i micro
    cd "$NOTES_DIR" && fzf --preview 'cat {}' | xargs -r micro
}


# =========================================================
# 5. AUTOMATIK (Venv & Shell Hooks)
# =========================================================

# Auto-aktivera Python venv vid mappsökning
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

# =========================================================
# 6. HJÄLPFUNKTIONER & DASHBOARD
# =========================================================

function myip() {
    local L_IP=$(hostname -I | awk '{print $1}')
    local TS_IP=$(tailscale ip -4 2>/dev/null || echo "Ej aktiv")
    local P_IP=$(curl -s --max-time 1 https://ifconfig.me || echo "Offline/Timeout")

    echo -e "\e[1;34m╭─ Webb & Nätverk ───────────────────────────╮\e[0m"
    echo -e "\e[1;34m│\e[0m  \e[32m󰩟 Lokal IP:\e[0m   $L_IP"
    echo -e "\e[1;34m│\e[0m  \e[36m󰖂 Tailscale:\e[0m  $TS_IP"
    echo -e "\e[1;34m│\e[0m  \e[35m󰖟 Publik IP:\e[0m  $P_IP"
    echo -e "\e[1;34m╰────────────────────────────────────────────╯\e[0m"
}

# Packa upp allt
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1      ;;
            *.tar.gz)    tar xzf $1      ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar x f $1      ;;
            *.tbz2)      tar xjf $1      ;;
            *.tgz)       tar xzf $1      ;;
            *.zip)       unzip $1        ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' kan inte packas upp via extract()" ;;
        esac
    else
        echo "'$1' är inte en giltig fil"
    fi
}

# Snabbhjälp (GRYM! Testa: qs python)
function qs() {
    curl -s "https://cht.sh/$1" | less -R
}




# DevOps Dashboard vid start
function dashboard() {
    echo -e "\n\e[1;36m🚀 Systemstatus för $HOST\e[0m"

    # --- HÅRDVARA ---
    local RAM=$(free -m | awk '/Mem:/ { printf("%3.1f%%", $3/$2*100) }')
    local DISK=$(df -h / | awk 'NR==2 {print $5}')

    # CPU Temp
    local TEMP=""
    if command -v sensors &> /dev/null; then
        TEMP=$(sensors | awk '/Package id 0/ {print $4}' | tr -d '+')
    fi
    [[ -z "$TEMP" ]] && TEMP="N/A"

    echo -e "  \e[33m󰍛 RAM:\e[0m $RAM    \e[34m󰋊 Disk:\e[0m $DISK    \e[31m CPU:\e[0m $TEMP"

    # --- AKTIVA TJÄNSTER (Visas bara om de är igång) ---
    local SERVICE_FOUND=false

    # Docker status
    if command -v docker &> /dev/null; then
        local D_RUNNING=$(docker ps -q | wc -l)
        if [ "$D_RUNNING" -gt 0 ]; then
            if [ "$SERVICE_FOUND" = false ]; then echo -e "\n\e[1;35m🔥 Active Workloads\e[0m"; SERVICE_FOUND=true; fi
            echo -e "  \e[34m󰡨 Docker:\e[0m    $D_RUNNING containrar igång"
        fi
    fi

    # --- ANTECKNINGAR (Brain Stats) ---
    if [ -d "$NOTES_DIR" ]; then
        echo -e "\n\e[1;32m🧠 Second Brain\e[0m"

        # Räkna filer
        local NOTE_COUNT=$(find "$NOTES_DIR" -name "*.md" | wc -l)

        # Räkna ofärdiga To-Dos
        local TODO_COUNT=$(grep -r "\- \[ \]" "$NOTES_DIR" 2>/dev/null | wc -l)

        # Senaste filen (sed tar bort .md på slutet för snyggare look)
        local LAST_FILE=$(ls -t "$NOTES_DIR" | head -n 1 | sed 's/.md//')

        echo -e "  \e[36m📝 Filer:\e[0m     $NOTE_COUNT st"
        echo -e "  \e[31m✅ Att göra:\e[0m  $TODO_COUNT uppgifter"
        echo -e "  \e[33m⏮  Senast:\e[0m    $LAST_FILE"
    fi
    echo ""
}



# STARTKNAPPEN: Kör dashboard om vi är i en terminal
[[ $- == *i* ]] && dashboard

# Portar
alias ports="sudo lsof -i -P -n | grep LISTEN"

# Skicka fil
function send() {
    if [ $# -ne 2 ]; then
        echo "Användning: send [fil] [server-alias]"
        return 1
    fi
    local FILE=$1
    local SERVER=$2
    echo -e "\e[34m📤 Skickar $FILE till $SERVER...\e[0m"
    scp "$FILE" "$SERVER:~/"
    if [ $? -eq 0 ]; then
        echo -e "\e[32m✅ Klar! Filen ligger i hemkatalogen på $SERVER\e[0m"
    else
        echo -e "\e[31m❌ Något gick fel vid överföringen.\e[0m"
    fi
}


# =========================================================
# 7. EXTRA Kalkylator & Random
# =========================================================

# 1. Den "riktiga" funktionen (vi ger den ett understreck så den inte syns)
function _kalk() {
    python3 -c "print($*)"
}

# 2. Aliaset 'kalk' som stänger av fil-sökning (noglob)
# Detta gör att du kan skriva 2*2 utan att Zsh letar efter filer.
alias kalk='noglob _kalk'
