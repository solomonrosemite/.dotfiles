if status is-interactive
    # Commands to run in interactive sessions can go here
end

set win_user_path (readlink -e /mnt/c/Users/{solomon,Jesse}/ | head -1)
set h $win_user_path
set hd "$win_user_path/Donwloads"

# Open configurations
alias c.='n. && nvim . && cd -'
alias cb='nvim ~/.config/bat/config'
alias cf='nvim ~/.config/fish/config.fish'
alias ch='nvim ~'
alias cs='nvim ~/.config/starship.toml'
alias cn='nn && nvim . && cd -'
alias ck='nk && nvim . && cd -'
alias ct="nvim $win_user_path/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json"
alias cw='nw && nvim . && cd -'
alias cws='nws && nvim . && cd -'
alias cy='ny && nvim . && cd -'

alias n.='cd ~/.dotfiles/'
alias nn='cd ~/.dotfiles/nvim/.config/nvim/'
alias nk="cd $win_user_path/.config/komorebi/"
alias nw="cd $win_user_path/.win.dotfiles/"
alias nd="cd /mnt/c/Users/Jesse/Pictures/Walli/.drawings"
alias nws="cd $win_user_path/AppData/Roaming/Microsoft/Windows/Start\ Menu/Programs/Startup/"
alias ny="cd $win_user_path/.yasb/"

# ai stuff
alias ai='aichat'
function cl
    echo "$argv - model: claude:claude-3-5-sonnet-latest:" >> ~/.ai/outputs.md
    aichat -m claude:claude-3-5-sonnet-latest $argv | tee -a ~/.ai/outputs.md
    printf "\n---\n" >> ~/.ai/outputs.md
end

function sam
    echo "$argv - model: openai:gpt-4o-mini:" >> ~/.ai/outputs.md
    aichat -m claude:claude-3-5-sonnet-latest $argv | tee -a ~/.ai/outputs.md
    printf "\n---\n" >> ~/.ai/outputs.md
end

function oa
    echo "$argv - model: openai:gpt-4o-mini:" >> ~/.ai/outputs.md
    aichat -m claude:claude-3-5-sonnet-latest $argv | tee -a ~/.ai/outputs.md
    printf "\n---\n" >> ~/.ai/outputs.md
end

function pp
    echo "$argv - model: perplexity:llama-3.1-sonar-huge-128k-online:" >> ~/.ai/outputs.md
    aichat -m perplexity:llama-3.1-sonar-huge-128k-online $argv | tee -a ~/.ai/outputs.md
    printf "\n---\n" >> ~/.ai/outputs.md
end

alias d='docker'
alias dp='docker ps'
alias ds='docker stop'
alias dr='docker remove'

alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dclf='docker compose logs -f'

alias dv='docker volume'
alias dvl='docker volume ls'
alias dvr='docker volume rm'

alias cc='cd (~/.dotfiles/scripts/.config/scripts/open_dir.sh "$HOME/personal/active" "$HOME/personal/tldr" "$HOME/work/micro/" "$HOME/work/common/" "$HOME/work/ad-tech/") && [ -f package.json ] || cd src > /dev/null 2>&1 || true'

alias ffd='_fzf_search_directory'
alias ffh='_fzf_search_history'
alias ffp='_fzf_search_processes'

alias fm='fzf-make'

alias gs='git status'
alias gsw='git switch -'
alias gc='git_commit_or_git_checkout'
alias gco='git checkout'
alias gpl='git pull'
alias gp='git push'
alias gl='sh ~/.dotfiles/scripts/.config/scripts/git_log.sh -i'
alias gbc='sh ~/.dotfiles/scripts/.config/scripts/git_clear_branches.sh'
alias gmr='sh ~/.dotfiles/scripts/.config/scripts/glab-mr.sh'

alias ga='git add'
alias gap='git add -p'
alias gaa='git add -A'
alias gdd='git diff'
alias gdc='git diff --cached'


alias glow='glow -p'

alias a='~/.dotfiles/scripts/.config/scripts/authy.sh'
alias auth='~/.dotfiles/scripts/.config/scripts/authy.sh'
alias authy='~/.dotfiles/scripts/.config/scripts/authy.sh'
alias cat='bat'
alias clip='utf8clip.exe'
alias fj='~/.dotfiles/scripts/.config/scripts/format_json.sh'
alias grep='rg'
alias gtp='~/.dotfiles/scripts/.config/scripts/increment_tag_push.sh'
alias jwt='~/.dotfiles/scripts/.config/scripts/decode_jwt.sh'
alias l='eza -hl'
alias la='eza -hla'
alias lt='eza --tree'
alias less='bat --paging=always'
alias task='go-task'
alias vim='nvim'

alias nvm='fnm'
alias r='trash'

alias hd="cd $win_user_path/Downloads"

alias s='source ~/.config/fish/config.fish'
alias take 'function __take; mkdir -p $argv; cd $argv; end; __take'

alias v='nvim .'
alias vv='nvim -c "Codeium Disable" .'

alias wts="sh $win_user_path/.win.dotfiles/scripts/win-terminal-background.sh --select"

alias za='zellij attach -c'
alias ze='zellij'

set fish_greeting ""
set fish_user_paths "$HOME/.nix-profile/bin/" $fish_user_paths
set fish_user_paths "$HOME/.go/bin/" $fish_user_paths
set fish_user_paths "$HOME/.local/bin/" $fish_user_paths
set fish_user_paths "$HOME/.cargo/bin/" $fish_user_paths
set fish_user_paths "$HOME/.local/share/fnm" $fish_user_paths
set fish_user_paths "/opt/homebrew/bin/" $fish_user_paths
set fish_user_paths "/opt/homebrew/opt/openjdk/bin" $fish_user_paths
set -gx GOPATH "$HOME/.go/"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

fnm env | source
starship init fish | source
eval (/opt/homebrew/bin/brew shellenv)

# opam configuration
source ~/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
bash -c 'syncthing &>/dev/null &'
export FZF_DEFAULT_OPTS='--layout=reverse'

envsource ~/.aireal.env
envsource ~/.personal.env

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# functions
function git_commit_or_git_checkout
    set -l cmd "git commit"
    set -l found_m false
    for arg in $argv
        if test "$arg" = "-m"
            set cmd "$cmd -m"
            set found_m true
        else
            set cmd "$cmd \"$arg\""
        end
    end

    if test "$found_m" = "false"
      sh ~/.dotfiles/scripts/.config/scripts/git_checkout.sh
    else
        eval $cmd
    end
end

function pre_exec_zellij_tab_rename --on-event fish_preexec
    if set -q ZELLIJ
        set title (string split ' ' $argv)[1..-1]
        if test (string length "$argv") -gt 20
            set title (string split ' ' $argv)[1]
        end
        command nohup zellij action rename-tab "$title" >/dev/null 2>&1
    end
end

function post_exec_zellij_tab_rename --on-event fish_prompt
    if set -q ZELLIJ && test -z "$argv" && status is-interactive
        set title 'fish'
        command nohup zellij action rename-tab $title >/dev/null 2>&1
    end
end
post_exec_zellij_tab_rename
