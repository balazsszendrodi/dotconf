zmodload zsh/zprof
autoload -U compinit; compinit

if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

eval "$(ssh-agent -s >/dev/null)"

# open man pages in nvim
export MANPAGER="nvim -c 'Man!' -o -"

# setup autoload for custom functions that are not used that often
fpath=(~/.config/zsh/autoload $fpath)
autoload -Uz batdiff update-nvim pass-gen

# load custom functions that are used regularly
if [ -f ~/.zsh_functions/utils ]; then
  source ~/.zsh_functions/utils
fi

appendpath "/usr/local/go/bin"
# appendpath "/opt/glab/bin"
appendpath "/opt/nvim-linux-x86_64/bin"
appendpath "/home/balazs/go/bin"
# appendpath "/home/balazs/node-v22.19.0-linux-x64/bin"
appendpath "/home/balazs/.local/share/nvim/mason/bin"
# appendpath "/home/balazs/programming/mobile/flutter/bin"
# appendpath "/opt/android-studio/bin"
appendpath "/home/balazs/.local/bin"

# Export paths
export VISUAL=nvim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
export SUDO_EDITOR=$VISUAL
export GOROOT=/usr/local/go

if [[ -n "$SSH_TTY" && "$TERM" = "xterm-ghostty" ]]; then
  export TERM=xterm-256color
fi
#
# Aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases


HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Automatically start tmux on shell startup
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux a -t default || exec tmux new -s default && exit
fi


# Vi mode settings
bindkey -v
# Set key bindings for insert mode (main mode)
bindkey -M main '^A' beginning-of-line  # Ctrl-a to go to the beginning of the line
bindkey -M main '^E' end-of-line        # Ctrl-e to go to the end of the line
bindkey -M main '^K' kill-line          # Ctrl-k to delete everything after the cursor
bindkey -M main '^U' backward-kill-line # Ctrl-u to delete everything before the cursor
bindkey -M main '^Y' yank               # Ctrl-y to paste the last killed text
bindkey -M main '^R' fzf-history-widget # Ctrl-r for reverse search
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

# http_proxy='http://10.158.100.1:8080/'
minikube_ip='192.168.49.2'
if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
  export BROWSER=brave-browser

  http_proxy='http://10.158.100.2:8080'
  https_proxy='http://10.158.100.2:8080'
  ftp_proxy='http://10.158.100.2:8080'
  no_proxy="${minikube_ip},localhost,127.0.0.1,instance-data,169.254.169.254,10.135.73.50,.nokia.net,.nsn-net.net,.nsn-rdnet.net,.nokia.com,.nsn.com,.nokiasiemensnetworks.com,.alcatel-lucent. com,.internal,.testing"
  HTTP_PROXY='http://10.158.100.2:8080'
  HTTPS_PROXY='http://10.158.100.2:8080'
  FTP_PROXY='http://10.158.100.2:8080'
  NO_PROXY="${minikube_ip},localhost,127.0.0.1,instance-data,169.254.169.254,10.135.73.50,.nokia.net,.nsn-net.net,.nsn-rdnet.net,.nokia.com,.nsn.com,.nokiasiemensnetworks.com,.alcatel-lucent. com,.internal,.testing"
  export http_proxy https_proxy ftp_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY
  export GOPROXY="https://repo.cci.nokia.net/proxy-golang-org/,https://repo.cci.nokia.net/nc-go-candidates/,direct"
  export GONOSUMDB=gitlabe2.ext.net.nokia.com,nokia.com
fi

# export GOSUMDB="sum.golang.org https://repo-cache-pl.cci.nokia.net/sum-golang-org"

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
if command -v kpt &>/dev/null && [ -x "$(command -v kpt)" ]; then
  source <(kpt completion zsh)
  compdef _kpt kpt
fi

# fnm
FNM_PATH="/home/balazs/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

# Load Angular CLI autocompletion.
source <(ng completion script)
