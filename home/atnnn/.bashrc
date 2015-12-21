#### Sourced by all interactive bash shells

if [[ $- != *i* ]]; then
    # non-interactive shell
    return
fi

. ~/.session/environment
. ~/.session/lib

### Bash settings
HISTCONTROL=ignoredups
HISTFILESIZE=10000
shopt -s autocd globstar histappend

### Aliases
alias edit="emacsclient -a '' -n -c"
alias gl="git log --graph"
LOCAL_TZ='America/Los_Angeles'
alias localdate='TZ=$LOCAL_TZ date'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias less='less -RS'
alias make='make --jobs=6 --load-average=4.5'
alias gl='git log --graph --oneline --decorate'

### Path
add_path ~/bin
