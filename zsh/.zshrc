# AUTO-START HYPRLAND
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
  exec start-hyprland
fi

# ZSH CORE

autoload -Uz compinit
compinit

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt AUTO_CD
setopt CORRECT


# ENV

export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=kitty
export BROWSER=firefox
export PATH="$HOME/.local/bin:$PATH"

#EZA

alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias la='eza -a --icons'
alias tree='eza --tree --icons'

#SAFETY

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#TOOLS

alias cat='bat'
alias find='fd'
alias grep='rg'

codium() {
  if [ $# -eq 0 ]; then
    /usr/bin/codium .
  else
    /usr/bin/codium "$@"
  fi
}

#FZF

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--preview "bat --style=numbers --color=always {} 2>/dev/null"
'

#ZOXIDE

eval "$(zoxide init zsh)"
alias cd='z'

#NNN

export NNN_FIFO=/tmp/nnn.fifo
export NNN_OPTS="deH"
export NNN_PLUG='p:preview-tui;z:autojump'

n() {
  nnn -P p "$@"
}

#STARSHIP
PROMPT=''
RPROMPT=''
eval "$(starship init zsh)"

#ASCII

if [[ $- == *i* ]]; then
  clear
  ~/.config/greeting.sh
fi

#COMPLETION

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
KEYTIMEOUT=1

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/akk/.lmstudio/bin"
# End of LM Studio CLI section

