alias ls='ls --color=auto'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias less='less -RS'
alias make='nice -n 19 make -j 12'
alias gl='git log --graph --oneline --decorate'
alias gla='git log --graph --oneline --decorate --all'
alias gls='git log --graph --oneline --decorate --simplify-by-decoration --all --no-merges --date-order'

substr () {
    [[ "$2" != "${2%$1*}" ]]
}

add_path () {
    for dir in "$@"; do
        [[ -d "$dir" ]] && ! substr ":$dir:" ":$PATH:" && PATH="$dir:$PATH"
    done
}

PAGER=less
EDITOR=vim

add_path ~/.gem/ruby/*/bin
add_path ~/.python/bin
add_path ~/.cabal/bin
add_path ~/bin

SSH_AGENT_RC=~/.ssh-agent-env

[[ -d "$SSH_AGENT_RC" ]] && source "$SSH_AGENT_RC"

ssh-agent-start () {
    if ! ps -p $SSH_AGENT_PID >/dev/null 2>/dev/null; then
        ssh-agent > "$SSH_AGENT_RC"
    fi
    [[ -d "$SSH_AGENT_RC" ]] && source "$SSH_AGENT_RC"
}

ssh-agent-stop () {
    ssh-agent -k
}
