# ============================================================
# History settings
# ============================================================
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS      # don’t record duplicates
setopt HIST_IGNORE_SPACE     # don’t record lines starting with space
setopt APPEND_HISTORY        # append instead of overwrite
setopt SHARE_HISTORY         # share history across sessions

export EDITOR="nvim"

# ============================================================
# Aliases
# ============================================================
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias vi=nvim
alias vim=nvim

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
"$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Load extra aliases if file exists
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# ============================================================
# Completions
# ============================================================
autoload -Uz compinit
compinit

# ============================================================
# Environment paths
# ============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$HOME/.fzf/bin:$PATH

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export COMPOSE_BAKE=true
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# opencode
export PATH=/home/cesar/.opencode/bin:$PATH

# ============================================================
# Prompt handled by Starship
# ============================================================
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"

# ============================================================
# tmux auto attach
# ============================================================
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach -t default || tmux new -s default
fi

# ============================================================
# zoxide + fzf
# ============================================================
eval "$(zoxide init zsh)"

export _ZO_FZF_ENABLE_PREVIEW=1
export _ZO_FZF_OPTS="--layout=reverse --info=inline"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
