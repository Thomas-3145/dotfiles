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
alias grep="grep --color=auto"
alias reload="source ~/.zshrc && echo 'Config laddad!'"
alias cat='bat'
alias top='btop'
alias memtjuvar="ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 10"

# SSH Servrar
alias router="ssh router"
alias 3145="ssh 3145"
alias pve1="ssh pve1"
alias pve2="ssh pve2"
alias pve3="ssh pve3"

# gitlab-runner flyttad till ~/.ssh/config (Host gitlab-runner)

# DevOps Docker-genvägar
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dlogs="docker logs -f"
alias di="docker images"
alias dex="docker exec -it"                           # dex <container> bash
alias dstop='docker stop $(docker ps -q)'             # stoppa alla körande
alias dclean="docker system prune -f"                 # bara dangling — säker default
alias dcleanall="docker system prune -af --volumes"   # allt, inkl. volymer — använd med försiktighet

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
function ans() {
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
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"      ;;
            *.tar.gz)    tar xzf "$1"      ;;
            *.bz2)       bunzip2 "$1"      ;;
            *.rar)       unrar x "$1"      ;;
            *.gz)        gunzip "$1"       ;;
            *.tar)       tar xf "$1"       ;;
            *.tbz2)      tar xjf "$1"      ;;
            *.tgz)       tar xzf "$1"      ;;
            *.zip)       unzip "$1"        ;;
            *.7z)        7z x "$1"         ;;
            *)           echo "'$1' kan inte packas upp via extract()" ;;
        esac
    else
        echo "'$1' är inte en giltig fil"
    fi
}








# --- SNABBMENY ---
[[ -o interactive ]] || return
echo -e "\n\e[1;34mSnabbkommandon\e[0m"
echo -e "  \e[1;33mGit\e[0m"
echo -e "  \e[36mgb\e[0m             git fetch + visa alla branches"
echo -e "  \e[36mgpl\e[0m            git pull"
echo -e "  \e[36mgs\e[0m             git status (branch + filer)"
echo -e "  \e[36mgsw\e[0m            fuzzy-välj branch (eller skriv nytt namn = skapa)"
echo -e "  \e[36mgsw\e[0m <namn>     byt om den finns, annars skapa"
echo -e "  \e[36mga\e[0m <fil>       git add"
echo -e "  \e[36mgaa\e[0m            git add . (allt)"
echo -e "  \e[36mgcm\e[0m <text>     git commit -m"
echo -e "  \e[36mgp\e[0m             fetch + rebasa på main + pusha (pushar bara om det finns commits)"
echo -e ""
echo -e "  \e[1;33mGit-kombos\e[0m (flera steg i ett)"
echo -e "  \e[36mgsync\e[0m          byt till main + pull + prune + lista"
echo -e "  \e[36mgreview\e[0m        status + staged diff (granska innan commit)"
echo -e "  \e[36mgdone\e[0m <branch> städa efter merge (main + pull + radera branch)"
echo -e "  \e[36mgundo\e[0m          ångra senaste commit (behåller ändringar)"
echo -e ""
echo -e "  \e[1;33mKubernetes\e[0m"
echo -e "  \e[36mk\e[0m                  kubectl"
echo -e "  \e[36mkubens\e[0m <ns>        byt namespace"
echo -e "  \e[36mkubectx\e[0m <ctx>      byt kluster"
echo -e "  \e[36mkubeon\e[0m             visa kube-context i prompt"
echo -e "  \e[36mkubeoff\e[0m            dölj kube-context i prompt"
echo -e ""
echo -e "  \e[1;33mÖvrigt\e[0m"
echo -e "  \e[36mmd\e[0m <namn>          skapa mapp och gå in i den"
echo -e "  \e[36mfd\e[0m                 hitta filer och mappar efter namn"
echo -e "  \e[36mrg\e[0m                 sök innehåll i filer"







# Portar — visar alla processer på din maskin som lyssnar på en port
# Inkluderar docker (som 'docker-proxy'). För container → port-mappning, kör 'dps'
alias ports="sudo ss -tlnp"

# Skicka fil
function send() {
    if [ $# -ne 2 ]; then
        echo "Användning: send [fil] [server-alias]"
        return 1
    fi
    local FILE=$1
    local SERVER=$2
    echo -e "\e[34mSkickar $FILE till $SERVER...\e[0m"
    if scp "$FILE" "$SERVER:~/"; then
        echo -e "\e[32mKlar! Filen ligger i hemkatalogen på $SERVER\e[0m"
    else
        echo -e "\e[31mNågot gick fel vid överföringen.\e[0m"
    fi
}


# =========================================================
# 7. EXTRA Kalkylator & Random
# =========================================================

# 1. Den "riktiga" funktionen (vi ger den ett understreck så den inte syns)
function _kalkylator() {
    python3 -c "print($*)"
}

# 2. Aliaset 'kalkylator' som stänger av fil-sökning (noglob)
# Detta gör att du kan skriva 2*2 utan att Zsh letar efter filer.
alias kalkylator='noglob _kalkylator'



# ---------------------

unalias md
md() {
  mkdir -p "$1" && cd "$1"
}





# =========================================================
# 8. GIT ALIASES  (ordnade efter typisk workflow)
# =========================================================

# --- 1. Synka & orientera (börja dagen här) ---
alias gb="git fetch --prune && git branch -a"   # hämta + rensa stale remotes + lista alla branches
alias gpl="git pull --rebase --autostash"       # hämta senaste main utan merge-commits
alias gs="git status --short --branch"          # kort status + branch

# Kombo: byt till main + pull + fetch --prune + lista branches
gsync() { git switch main && git pull --rebase --autostash && git fetch --prune && git branch -a; }

# --- 2. Byt/skapa branch ---
# gsw                 → fuzzy-välj (eller skriv nytt namn + Enter = skapa)
# gsw <namn>          → byt om den finns, annars skapa
# gsw -c <namn>       → tvinga skapa (felar om den redan finns)
unalias gsw 2>/dev/null
gsw() {
  if [ $# -eq 0 ]; then
    local out query branch
    out=$(git branch --all --no-color | grep -v HEAD \
      | fzf-tmux -d 20 +m --print-query \
          --header="Enter=byt | skriv nytt namn + Enter=skapa") || return 1
    [[ -z "$out" ]] && return 1

    query=$(echo "$out" | head -1)
    branch=$(echo "$out" | sed -n '2p')

    if [[ -z "$branch" ]]; then
      git switch -c "$query" && git status --short --branch
    else
      branch=$(echo "$branch" | sed 's/.* //' | sed 's#remotes/[^/]*/##')
      git switch "$branch" && git status --short --branch
    fi
    return
  fi

  # Pass-through för flaggor (t.ex. gsw -c / -C)
  if [[ "$1" == -* ]]; then
    git switch "$@" && git status --short --branch
    return
  fi

  # Byt om branchen finns (lokalt eller på remote), annars skapa
  if git show-ref --verify --quiet "refs/heads/$1" \
     || git show-ref --verify --quiet "refs/remotes/origin/$1"; then
    git switch "$1" && git status --short --branch
  else
    git switch -c "$1" && git status --short --branch
  fi
}

# --- 3. Staging (lägg till ändringar för commit) ---
alias ga="git add"                          # ga <fil> — explicit, säkert
alias gaa="git add ."                       # all ändringar — akta i grupprojekt

# --- 4. Granska innan commit ---
alias greview="git status --short --branch && echo '---' && git diff --staged"  # status + staged diff i ett svep

# --- 5. Commit ---
alias gcm='git commit -m'

# --- 6. Pusha till remote ---
unalias gp 2>/dev/null
gp() {
  git fetch origin main && git rebase origin/main || return 1
  if [ "$(git rev-list HEAD ^origin/main --count)" -gt 0 ]; then
    git push -u origin HEAD
  fi
}

# --- 7. Ångra ---
alias gundo="git undo"                      # kräver git-config alias 'undo'

# --- 8. Städa efter merge ---
# gdone <branch>  byt till main + synka + radera mergad branch
# Använder -d (inte -D) så git vägrar om branchen inte är mergad — det är en feature.
gdone() {
  if [ -z "$1" ]; then echo "Användning: gdone <branch>"; return 1; fi
  git switch main && git pull --rebase --autostash && git fetch --prune && git branch -d "$1"
}




# =========================================================
# 9. KUBERNETES ALIASES
# =========================================================

alias k="kubectl"

# Context & namespace
alias kns="kubectl config view --minify | grep namespace"
alias kn='kubectl config set-context --current --namespace'
alias kctx='kubectl config current-context'
alias kct='kubectl config use-context'

# Get — lista resurser
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods -A"
alias kgs="kubectl get svc"
alias kgn="kubectl get nodes"
alias kga="kubectl get all"

# Inspektera
alias kd="kubectl describe"                 # kd pod <namn>
alias kl="kubectl logs -f"                  # kl <pod>
alias kex="kubectl exec -it"                # kex <pod> -- bash

# Ändra
alias ka="kubectl apply -f"                 # ka manifest.yaml
alias kdel="kubectl delete"




# Osorterad

alias tree="tree -L"
alias homelab="cd /home/thomas/dev/3145"


# =========================================================
# 10. KUBE-PS1 (kube-context i prompten)
# =========================================================
source ~/.kube-ps1/kube-ps1.sh
PROMPT='$(kube_ps1)'$PROMPT



alias ai-dator="ssh -p 22 root@192.168.10.34"
