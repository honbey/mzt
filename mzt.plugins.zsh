# ls colors
autoload -U colors && colors

# Enable ls colors only if not already set by the user
if [[ -z "$LS_COLORS" ]]; then
  export LS_COLORS="Gxfxcxdxbxegedabagacad"
fi

if [[ "$DISABLE_LS_COLORS" != "true" ]]; then
  # Find the option for using colors in ls, depending on the version
  if [[ "$OSTYPE" == netbsd* ]]; then
    # On NetBSD, test if "gls" (GNU ls) is installed (this one supports colors);
    # otherwise, leave ls as is, because NetBSD's ls doesn't support -G
    gls --color -d . &>/dev/null && alias ls='gls --color=tty'
  elif [[ "$OSTYPE" == openbsd* ]]; then
    # On OpenBSD, "gls" (ls from GNU coreutils) and "colorls" (ls from base,
    # with color and multibyte support) are available from ports.  "colorls"
    # will be installed on purpose and can't be pulled in by installing
    # coreutils, so prefer it to "gls".
    gls --color -d . &>/dev/null && alias ls='gls --color=tty'
    colorls -G -d . &>/dev/null && alias ls='colorls -G'
  elif [[ "$OSTYPE" == (darwin|freebsd)* ]]; then
    # this is a good alias, it works by default just using $LSCOLORS
    ls -G . &>/dev/null && alias ls='ls -G'

    # only use coreutils ls if there is a dircolors customization present ($LS_COLORS or .dircolors file)
    # otherwise, gls will use the default color scheme which is ugly af
    [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias ls='gls --color=tty'
  else
    # For GNU ls, we use the default ls color theme. They can later be overwritten by themes.
    if [[ -z "$LS_COLORS" ]]; then
      (( $+commands[dircolors] )) && eval "$(dircolors -b)"
    fi

    ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G . &>/dev/null && alias ls='ls -G' }

    # Take advantage of $LS_COLORS for completion as well.
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  fi
fi

# enable diff color if possible.
if command diff --color . . &>/dev/null; then
  alias diff='diff --color'
fi

setopt auto_cd
setopt multios
setopt prompt_subst

[[ -n "$WINDOW" ]] && SCREEN_NO="%B$WINDOW%b " || SCREEN_NO=""

# PROMPT=""
# cat > ${PROMPT} <<- EOF
# %{$fg_bold[green]%}%n%{$fg[cyan]%}@%{$fg_bold[green]%}%m %{$fg_bold[green]%} 
# %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % 
# %{$reset_color%}
# EOF
# git theming default: Variables for theming the git info prompt
if [[ "$USER" == "root" ]]; then
  PROMPT="%(?:%{$fg_bold[gray]%} :%{$fg_bold[red]%} )"
elif [[ "$OSTYPE" == darwin* ]]; then
  PROMPT="%(?:%{$fg_bold[gray]%} :%{$fg_bold[red]%} )"
elif grep -Eq "CentOS" /etc/*-release; then
  PROMPT="%(?:%{$fg_bold[magenta]%} :%{$fg_bold[red]%} )"
elif grep -Eq "Debian" /etc/*-release; then 
  PROMPT="%(?:%{$fg_bold[magenta]%} :%{$fg_bold[red]%} )"
elif grep -Eq "Kali" /etc/*-release; then 
  PROMPT="%(?:%{$fg_bold[blue]%} :%{$fg_bold[red]%} )"
else
  PROMPT="%(?:%{$fg_bold[green]%}✓ :%{$fg_bold[red]%}✗ )"
fi
PROMPT+='%{$fg[cyan]%}%c%{$reset_color%} %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}'
ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
