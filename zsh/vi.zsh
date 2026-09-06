KEYTIMEOUT=1

bindkey -v

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

for keymap in viins vicmd; do
    bindkey -M $keymap '^[[A' up-line-or-beginning-search
    bindkey -M $keymap '^[OA' up-line-or-beginning-search
    bindkey -M $keymap '^[[B' down-line-or-beginning-search
    bindkey -M $keymap '^[OB' down-line-or-beginning-search
done

bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word

VI_MODE="I"

function zle-keymap-select {
    case $KEYMAP in
        vicmd)
            echo -ne '\e[2 q'
            VI_MODE="N"
            ;;
        viins|main)
            echo -ne '\e[5 q'
            VI_MODE="I"
            ;;
    esac
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
    zle -K viins
    echo -ne '\e[5 q'
    VI_MODE="I"
}
zle -N zle-line-init

function zle-line-finish {
    echo -ne '\e[5 q'
}
zle -N zle-line-finish

function vi-visual-mode {
    zle visual-mode
    VI_MODE="V"
}
zle -N vi-visual-mode
bindkey -M vicmd 'v' vi-visual-mode

function vi-visual-line-mode {
    zle visual-line-mode
    VI_MODE="VL"
}
zle -N vi-visual-line-mode
bindkey -M vicmd 'V' vi-visual-line-mode

function vi-visual-block-mode {
    zle visual-block-mode
    VI_MODE="VB"
}
zle -N vi-visual-block-mode
bindkey -M vicmd '^V' vi-visual-block-mode

function edit_command_line {
    local ed="${EDITOR:-vim}"
    command -v nvim >/dev/null 2>&1 && ed="nvim"
    local tmpfile=$(mktemp)
    print -r -- "$BUFFER" > "$tmpfile"
    $ed "$tmpfile"
    BUFFER=$(<"$tmpfile")
    zle reset-prompt
    rm "$tmpfile"
}
zle -N edit_command_line
bindkey -M vicmd 'vv' edit_command_line

function surround {
    local left="$1"
    local right="$2"
    zle vi-backward-word
    zle vi-forward-word
    RBUFFER="$right$RBUFFER"
    zle vi-backward-word
    LBUFFER="$LBUFFER$left"
    zle vi-forward-char
}

function surround_quote { surround "'" "'" }
zle -N surround_quote
bindkey -M vicmd "s'" surround_quote

function surround_double_quote { surround '"' '"' }
zle -N surround_double_quote
bindkey -M vicmd 's"' surround_double_quote

function surround_paren { surround '(' ')' }
zle -N surround_paren
bindkey -M vicmd 's(' surround_paren

function surround_brace { surround '{' '}' }
zle -N surround_brace
bindkey -M vicmd 's{' surround_brace

function surround_bracket { surround '[' ']' }
zle -N surround_bracket
bindkey -M vicmd 's[' surround_bracket

function surround_angle { surround '<' '>' }
zle -N surround_angle
bindkey -M vicmd 's<' surround_angle