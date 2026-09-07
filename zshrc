fpath=(~/.zsh/completions $fpath)

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

for module in completion vi prompt aliases fzf zoxide; do
    [[ -f "$ZDOTDIR/$module.zsh" ]] && source "$ZDOTDIR/$module.zsh"
done

export PATH="$HOME/.local/bin:$PATH"

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
# <<< grok installer <<<

export PATH="$HOME/.opencode/bin:$PATH"

export PATH="$HOME/.gapcode/bin:$PATH"
# kimi-code
export PATH="$HOME/.kimi-code/bin:$PATH"
