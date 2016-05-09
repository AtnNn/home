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
LOCAL_TZ='America/New_York'
alias localdate='TZ=$LOCAL_TZ date'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias less='less -RS'
alias make='make --jobs=6 --load-average=4.5'
alias gl='git log --graph --color --pretty=format:"%C(auto)%h%d %s %Cblue%an %ar"'

### Path
add_path ~/bin
add_path ~/lib/ghc-7.8.2/bin
add_path ~/.cabal/bin


# @begin(26550862)@ - Do not edit these lines - added automatically!
if [ -f /home/atnnn/code/ciao/core/etc/DOTprofile ] ; then
  . /home/atnnn/code/ciao/core/etc/DOTprofile
fi
# @end(26550862)@ - End of automatically added lines.
