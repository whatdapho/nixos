# -----------------------------------------------------------------------------
# POWERLEVEL10K INSTANT PROMPT
# ------------------------------------------------------------------------------
# This speeds up shell startup by showing the prompt early.
# Setting this to `quiet` suppresses the startup warning.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Load the Powerlevel10k "instant prompt" feature from cache, if it exists.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------------------------
# HOMEBREW INITIALIZATION
# ------------------------------------------------------------------------------
# Load Homebrew environment if installed.
# This sets up paths and environment variables for Homebrew packages.
#if [[ -f "/opt/homebrew/bin/brew" ]]; then
#  eval "$(/opt/homebrew/bin/brew shellenv)"
# elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
#  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#fi

# ------------------------------------------------------------------------------
# ZINIT SETUP
# ------------------------------------------------------------------------------
# Zinit is a Zsh plugin manager. This section installs and loads it.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# If Zinit is not installed, clone it from GitHub.
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit to start using it.
source "${ZINIT_HOME}/zinit.zsh"

# ------------------------------------------------------------------------------
# THEME: POWERLEVEL10K
# ------------------------------------------------------------------------------
# Powerlevel10k is a fast, customizable Zsh prompt theme.
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ------------------------------------------------------------------------------
# ZSH PLUGINS
# ------------------------------------------------------------------------------
# Syntax highlighting: highlights valid/invalid command syntax.
zinit light zsh-users/zsh-syntax-highlighting

# Tab-completion: enhances completions with better behavior.
zinit light zsh-users/zsh-completions

# Suggestions: shows command suggestions from history as you type.
zinit light zsh-users/zsh-autosuggestions

# Fuzzy tab: enables fzf-based fuzzy completions.
zinit light Aloxaf/fzf-tab

# ------------------------------------------------------------------------------
# OH-MY-ZSH SNIPPETS (via Zinit)
# ------------------------------------------------------------------------------
# These are small, focused plugin scripts from Oh My Zsh.

# Load Git aliases and functions.
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

# Sudo command enhancement.
zinit snippet OMZP::sudo

# OS-specific and tool-specific enhancements.
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# ------------------------------------------------------------------------------
# COMPLETION SYSTEM
# ------------------------------------------------------------------------------
# Enable the completion system and replay Zinit completions.
autoload -Uz compinit && compinit
zinit cdreplay -q

# ------------------------------------------------------------------------------
# POWERLEVEL10K CONFIGURATION FILE
# ------------------------------------------------------------------------------
# This is the config file created by `p10k configure`.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ------------------------------------------------------------------------------
# KEYBINDINGS
# ------------------------------------------------------------------------------
# Use emacs-style keybindings by default.
bindkey -e

# History search keybindings.
bindkey '^p' history-search-backward  # Ctrl+P: search previous command
bindkey '^n' history-search-forward   # Ctrl+N: search next command
bindkey '^[w' kill-region             # Alt+W: cut selected text

# ------------------------------------------------------------------------------
# ZSH HISTORY SETTINGS (Improved)
# ------------------------------------------------------------------------------

HISTFILE=~/.zsh_history               # File to save history to
HISTSIZE=10000                        # Max entries kept in memory
SAVEHIST=10000                        # Max entries saved to file

# History behavior options
setopt append_history                 # Append to history file, don't overwrite
setopt inc_append_history             # Save each command as it's run
setopt share_history                  # Share history between terminal sessions
setopt extended_history               # Save timestamps and command durations

# History duplication control
setopt hist_ignore_space              # Ignore commands starting with space
setopt hist_ignore_all_dups           # Ignore duplicate commands in history
setopt hist_save_no_dups              # Don’t save duplicates to history file
setopt hist_ignore_dups               # Don’t show dupes when searching with ↑
setopt hist_find_no_dups              # Don’t find dupes in reverse-i-search
setopt hist_reduce_blanks             # Remove excess whitespace from commands

# ------------------------------------------------------------------------------
# COMPLETION STYLING
# ------------------------------------------------------------------------------
# Controls how Zsh shows completions and menus.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # Case-insensitive match
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colored output
zstyle ':completion:*' menu no                            # Disable menu selection

# fzf-tab preview: show file previews when completing
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------
# Shortcuts for commonly used commands
alias ls='ls --color'              # Colored directory listing
alias ll='ls -lF --color'          # Long listing with file type
alias vi='nvim'                    # Use Neovim instead of Vim
alias c='clear'                    # Clear terminal
alias history='history -50'	   # Show the last 50 commands in history

alias sshdc='ssh -L 5936:cvg:5936 dannyh@nxtnet.nextsemi.com'
alias sshoffice='ssh -L 5936:lab236:5936 dannyh@office.nextsemi.com'

# ------------------------------------------------------------------------------
# SHELL INTEGRATIONS
# ------------------------------------------------------------------------------
# Load fzf shell extensions (like Ctrl+R for history search)
eval "$(fzf --zsh)"

# Load zoxide for smart directory jumping (e.g., `cd foo`)
# eval "$(zoxide init --cmd cd zsh)"

export XAUTHORITY="$HOME/.Xauthority"

if [ -e /home/dhuynh/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dhuynh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
