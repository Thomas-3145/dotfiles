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

# =========================================================
# 1.5. PERFORMANCE (Snabbare completion)
# =========================================================
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

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
# alias ls="ll"

# Aktivera fzf
source <(fzf --zsh)

# =========================================================
# 3. ALIAS (Genvägar)
# =========================================================
alias nano="micro"
alias rg="rg --smart-case"
alias grep="grep -i --color=auto"
alias reload="source ~/.zshrc && echo 'Config laddad!'"
alias cat='bat'
alias top='btop'
alias memtjuvar="ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 10"

# SSH Servrar
alias router="ssh router"
alias 3145="ssh 3145"
alias pve1="ssh pve1"
alias pve2="ssh pve2
"
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
export NOTES_DIR="$HOME/Dokument/Obsidian Vault/anteckningar"
alias anteckningar='cd "$NOTES_DIR" && ls'
alias an=anteckning

# 1. Skapa/Redigera anteckning
function anteckning() {
    # --- SÄKERHETSSPÄRR ---
    if [ -z "$1" ]; then
        echo "Du glömde filnamnet!"
        echo "Användning: anteckning <filnamn>"
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

# 3. Fuzzy-sök (Öppna med fzf)
function as() {
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
            echo ".venv aktiverad"
        fi
    elif [[ "$VIRTUAL_ENV" != "" ]]; then
        if typeset -f deactivate > /dev/null; then
            deactivate
            echo ".venv avaktiverad"
        fi
    fi
}
chpwd

# Direnv (laddar .envrc automatiskt)
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

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








# --- SNABBMENY ---
echo -e "\n\e[1;34mSnabbkommandon\e[0m"
echo -e "  \e[1;33mGit\e[0m"
echo -e "  \e[36mgs\e[0m             git status (branch + filer)"
echo -e "  \e[36mgb\e[0m             git fetch + visa alla branches"
echo -e "  \e[36mgsw\e[0m <branch>   byt branch"
echo -e "  \e[36mga\e[0m <fil>       git add"
echo -e "  \e[36mgaa\e[0m            git add . (allt)"
echo -e "  \e[36mgcm\e[0m <text>     git commit -m"
echo -e "  \e[36mgp\e[0m             git push"
echo -e "  \e[36mgpl\e[0m            git pull --rebase"
echo -e "  \e[36mgundo\e[0m          ångra senaste commit (behåller ändringar)"
echo -e ""
echo -e "  \e[1;33mAnteckningar\e[0m"
echo -e "  \e[36manteckning\e[0m <namn>  skapa/redigera anteckning"
echo -e "  \e[36manteckningar\e[0m       gå till Obsidian-mappen"
echo -e "  \e[36mas\e[0m                 fuzzy-sök med förhandsvisning"
echo -e ""
echo -e "  \e[1;33mKubernetes\e[0m"
echo -e "  \e[36mk\e[0m                  kubectl"
echo -e "  \e[36mkns\e[0m                visa nuvarande namespace"
echo -e "  \e[36mkubens\e[0m <ns>        byt namespace"
echo -e "  \e[36mkubectx\e[0m <ctx>      byt kluster"
echo -e ""
echo -e "  \e[1;33mÖvrigt\e[0m"
echo -e "  \e[36mmd\e[0m <namn>          skapa mapp och gå in i den"
echo -e "  \e[36mkalk\e[0m <uttryck>     miniräknare (ex: kalk 2*2)"
echo -e "  \e[36mfd\e[0m <mönster>       sök filer (ex: fd .yaml)"







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
    echo -e "\e[34mSkickar $FILE till $SERVER...\e[0m"
    scp "$FILE" "$SERVER:~/"
    if [ $? -eq 0 ]; then
        echo -e "\e[32mKlar! Filen ligger i hemkatalogen på $SERVER\e[0m"
    else
        echo -e "\e[31mNågot gick fel vid överföringen.\e[0m"
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



# ---------------------

unalias md
md() {
  mkdir -p "$1" && cd "$1"
}





alias k="kubectl"
alias k8s-bok="ssh ubuntu@192.168.10.51"
alias kns="kubectl config view --minify | grep namespace"

# =========================================================
# 8. GIT ALIASES
# =========================================================
# Info
alias gs="git status --short --branch"
alias gb="git fetch && git branch -a"

# Navigera
alias gsw="git switch"

# Staging & commit
alias ga="git add"
alias gaa="git add ."
alias gcm='git commit -m'
alias gundo="git undo"

# Remote
alias gp="git push"
alias gpl="git pull --rebase"



gfz() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(echo "$branches" | wc -l) )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}




alias tree="tree -L"
alias homelab="cd /home/thomas/dev/3145"
