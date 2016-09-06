if [[ $- != *i* ]]; then
    return
fi

. ~/.session/environment
. ~/.session/lib

### Bash settings
HISTCONTROL=ignoreboth
HISTFILESIZE=1000000
shopt -s globstar histappend cmdhist nocaseglob checkhash failglob
PROMPT_COMMAND='history -a'

### Aliases
alias edit="emacsclient -a '' -n -c"
alias make='make --jobs=5 --load-average=4.5'
alias gl='git log --graph --color --pretty=format:"%C(auto)%h%d %s %Cblue%an %ar"'

LESS=-RS

### Path
add_path ~/bin
