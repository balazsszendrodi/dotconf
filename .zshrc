zmodload zsh/zprof

if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

eval "$(ssh-agent -s > /dev/null)"

# open man pages in nvim
export MANPAGER="nvim -c 'Man!' -o -"

# Export paths
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/balazs/go/bin
export PATH=$PATH:/home/balazs/node-v22.14.0-linux-x64/bin
export PATH=$PATH:/opt/nvim-linux-x86_64/bin
export PATH=$PATH:/home/balazs/.local/share/nvim/mason/bin
export VISUAL=nvim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
export SUDO_EDITOR=nvim
export GOROOT=/usr/local/go
if [[ -n "$SSH_TTY" && "$TERM" = "xterm-ghostty" ]]; then
    export TERM=xterm-256color
fi
#
# Aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

fpath+=${ZDOTDIR:-~}/.zsh_functions

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Exit yazi on the cwd instead of where it was invoked from. To avoid this press 'Q' to quit instead of 'q'
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Syntax highlighting for git diffs
function batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# Vi mode settings
bindkey -v
# Set key bindings for insert mode (main mode)
bindkey -M main '^A' beginning-of-line       # Ctrl-a to go to the beginning of the line
bindkey -M main '^E' end-of-line             # Ctrl-e to go to the end of the line
bindkey -M main '^K' kill-line               # Ctrl-k to delete everything after the cursor
bindkey -M main '^U' backward-kill-line      # Ctrl-u to delete everything before the cursor
bindkey -M main '^Y' yank                    # Ctrl-y to paste the last killed text
bindkey -M main '^R' fzf-history-widget  # Ctrl-r for reverse search
bindkey -M main '^F' fzf-file-widget

# Reduce the amount of time before vi mode activates
export KEYTIMEOUT=1

# Backspace and ^h working even after returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# Ctrl-w to remove word backwards
bindkey '^w' backward-kill-word

eval "$(starship init zsh)"
. "$HOME/.cargo/env"

http_proxy='http://10.158.100.1:8080'
minikube_ip='192.168.49.2'
export http_proxy https_proxy="${http_proxy}" ftp_proxy="${http_proxy}" no_proxy="nokia.net,localhost,127.0.0.1,${minikube_ip}"
export HTTP_PROXY="${http_proxy}" HTTPS_PROXY="${http_proxy}" FTP_PROXY="${http_proxy}" NO_PROXY="nokia.net,localhost,127.0.0.1,${minikube_ip}"


eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
