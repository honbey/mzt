### Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Fast-syntax-highlighting & autosuggestions
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

# lib/git.zsh is loaded mostly to stay in touch with the plugin (for the users)
zinit wait lucid for \
    zdharma-continuum/zsh-unique-id \
    OMZ::lib/git.zsh \
 atload \
    OMZ::plugins/git/git.plugin.zsh

### End of plugins

### My zshrc ###################################################################

export PATH="$HOME/.bin:$PATH"

# Let Meta-B work well
WORDCHARS=''

# User specific aliases and functions
alias ls='ls --color=auto' la='ls -A' ll='ls -ahlrt' l.='ls -d .*' l='ls -alF'
alias rm='rm -i' cp='cp -v' mv='mv -v'
alias grep='grep --color=auto'
alias ..='cd ..' ...='cd ../..'
alias vi='vim'
alias :q='exit' :wq='exit'
alias ck='cmake'
alias c='curl'
alias s='ssh'

if type emacs > /dev/null 2>&1; then
  function start_emacs(){exec emacsclient -c -a "" "$@"}
  alias killemacs="emacsclient -e '(kill-emacs)'"
  alias emacs='start_emacs'
fi

function ap(){source /opt/data/pyvenv/${1}/bin/activate;}
function be(){base64          <(echo "$1")}
function bd(){base64 --decode <(echo "$1")}

if [[ "$OSTYPE" == darwin* ]]; then
  # macOS
  alias dl='du -h -d 1'
  alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

  function ts2td(){date -r "$1" '+%Y-%m-%d %H:%M:%S'}

  # Homebrew
  export PATH="/opt/homebrew/bin:$PATH"

elif [[ "$OSTYPE" == linux* ]]; then
  alias dl='du -h --max-depth=1'
  alias syss='systemctl list-units --type=service'
  # Fast Jump
  alias d='dirs -v'
  alias j='jump_dir_stack(){ cd $(grep -m 1 $1 <(dirs -pl)); };jump_dir_stack'
  alias p='pushd'

  # Nginx
  if   [[ -f "/usr/local/nginx/sbin/nginx"      ]]; then
    alias ng='/usr/local/nginx/sbin/nginx'
  elif [[ -f "/usr/local/nginx-quic/sbin/nginx" ]]; then
    alias ng='/usr/local/nginx-quic/sbin/nginx'
  else
    alias ng='nginx'
  fi

  function ts2td(){date -d "@$1" '+%Y-%m-%d %H:%M:%S'}

  # NVIDIA
  if [[ -d "/usr/local/cuda" ]]; then
    export PATH=$PATH:/usr/local/cuda/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64/
    export CUDA_HOME=/usr/local/cuda
  fi
fi

if [[ -f "$HOME/.env" ]]; then
  source "$HOME/.env"
fi

if type gpg > /dev/null 2>&1; then
  export GPG_TTY=$(tty)
fi

# Custom theme
# PS1="%F{green}✓ %F{green}%n%F{cyan}@%F{green}%m %F{green} %F{cyan}%c "
if [[ "$USER" == "root" ]]; then
  PS1="%F{gray} %F{cyan}%c "
elif [[ "$OSTYPE" == darwin* ]]; then
  PS1="%F{gray} %F{cyan}%c "
elif grep -Eq "CentOS" /etc/*-release; then
  PS1="%F{magenta} %F{cyan}%c "
elif grep -Eq "Debian" /etc/*-release; then
  PS1="%F{magenta} %F{cyan}%c "
elif grep -Eq "Kali" /etc/*-release; then
  PS1="%F{blue} %F{cyan}%c "
else
  PS1="%F{green}✓ %F{cyan}%c "
fi
zinit ice wait lucid atload
zinit ice lucid wait='!0'
zinit light honbey/mzt

# History file configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Wirte to the history file immediately, not when the shell exit
setopt INC_APPEND_HISTORY
# Share history between all sessions
setopt SHARE_HISTORY
# Expire duplicate entries first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST
# Don't record an entry that was just recorded angin
setopt HIST_IGNORE_DUPS
# Delete old recorded entry if new entry is a duplicate
setopt HIST_IGNORE_ALL_DUPS
# Don't display a line previously fount
setopt HIST_FIND_NO_DUPS
# Don't record an entry starting with a space
setopt HIST_IGNORE_SPACE
# Don't write dulicate entries in the history file
setopt HIST_SAVE_NO_DUPS
# Remove superfluous blanks before recording entry
setopt HIST_REDUCE_BLANKS
# Don't execute immediately upon history expansion
setopt HIST_VERIFY
# Don't store ts and duration of the execution
#setopt EXTENDED_HISTORY

### My zshrc ###################################################################
