# Disable the greeting
set -U fish_greeting

# Make `less` use `pygmentize` for syntax highlighting
set -x LESS "$LESS -i"
set -x LESSCOLORIZER "pygmentize -f 256"

# Bind `Ctrl+Backspace` to delete a word behind the cursor
bind ctrl-backspace backward-kill-word
