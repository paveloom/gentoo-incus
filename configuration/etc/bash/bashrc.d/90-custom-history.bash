# /etc/bash/bashrc.d/90-custom-history.bash

export HISTCONTROL=erasedups
export HISTFILESIZE=10000
export HISTSIZE=1000

# Disable XON/XOFF flow control, thus allowing the
# use of `C-s` for forward searching the history
stty -ixon
