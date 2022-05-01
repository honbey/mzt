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
alias ls='ls --color=auto' ll='ls -alF' la='ls -A' l='ls -CF' l.='ls -d .*'
alias rm='rm -i' cp='cp -v' mv='mv -v'
alias grep='grep --color=auto'
alias ..='cd ..' ...='cd ../..'
alias vi='vim'
alias :q='exit' :wq='exit'
alias ck='cmake'
alias c='curl'
alias s='ssh'

alias ap='a_pyvenv(){source /opt/data/pyvenv/${1}/bin/activate;}; a_pyvenv'

if [[ "$OSTYPE" == darwin* ]]; then
  # MacOSX
  alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
  alias dl='du -h -d 1'
  # emacs-port
  # alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
  # alias emacsclient='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient'
  alias killemacs="emacsclient -e '(kill-emacs)'"

  # Homebrew
  export PATH="/opt/homebrew/bin:$PATH"
  # If you need to have openssl@1.1 first in your PATH, run:
  #  echo 'export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"' >> ~/.zshrc

  # For compilers to find openssl@1.1 you may need to set:
  #  export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
  #  export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
elif [[ "$OSTYPE" == linux* ]]; then
  # Linux
  alias dl='du -h --max-depth=1'
  # Fast Jump
  alias d='dirs -v'
  alias j='jump_dir_stack(){ cd $(grep -m 1 $1 <(dirs -pl)); };jump_dir_stack'
  alias jj='pushd'
  alias syss='systemctl list-units --type=service'
  # Nginx
  # alias o1t='openresty -t'
  # alias o1c='openresty -T'
  # alias o1r='openresty -s reload'
  # alias n1='/usr/local/nginx/sbin/nginx'
  # alias n1t='/usr/local/nginx/sbin/nginx -t'
  # alias n1c='/usr/local/nginx/sbin/nginx -T'
  # alias n1r='/usr/local/nginx/sbin/nginx -s reload'
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
