if status is-interactive
    set -x LESS "$LESS -i"
    set -x LESSCOLORIZER "pygmentize -f 256"
end
