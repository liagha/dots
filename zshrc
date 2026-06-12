# ~/.zshrc

ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

fpath=(~/.zsh_functions $fpath)

export HISTFILE="${ZDOTDIR}/history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST

source "${ZDOTDIR}/completion.zsh"
source "${ZDOTDIR}/vi.zsh"
source "${ZDOTDIR}/prompt.zsh"
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/fzf.zsh"
source "${ZDOTDIR}/zoxide.zsh"

export PATH="$HOME/.local/bin:$PATH"

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
