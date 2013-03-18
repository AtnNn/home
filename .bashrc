# /etc/skel/.bashrc:
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

HOME=/usr/home/atnnn

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]]; then
	eval `dircolors -b ~/.dir_colors`
else
	eval `dircolors -b /etc/DIR_COLORS`
fi

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

PATH=~/bin/:/usr/local/Gambit-C/current/bin/:/home/atnnn/.snow/current/bin:$PATH
MAIL=~/Mail/Inbox/
FRONTAL=laurieti@frontal05.iro.umontreal.ca

alias emacs='emacs -nw'

alias week='remind -q -c+2 -w$COLUMNS'
week
fortune -sn 256

memSize=400100100
ddHEAP_SIZE="-Xms$memSize -Xmx$memSize -DMEMORY=$memSize"
ddPATH='-cp ${HOME}/Debugger/debugger.jar:${CLASSPATH} -Xbootclasspath/p:${HOME}/Debugger/ClassLoader.jar'
alias odb="java $ddHEAP_SIZE $ddPATH -DDONT_SHOW com.lambda.Debugger.Debugger"
alias debugify="java $ddHEAP_SIZE $ddPATH com.lambda.Debugger.Debugify"

PATH=/opt/intel/cc/9.1.047/bin/:/opt/intel/idb/9.1.047/bin/:$PATH

export ALTERNATIVE_EDITOR=emacs
alias e="emacsclient -c -a emacs"
alias et="DISPLAY= emacsclient -t -a emacs"
TZ='America/Montreal'; export TZ

alias latex-shell-escape="latex -shell-escape"

export PERL5LIB=/home/atnnn/.perl/lib/perl5/site_perl/5.8.8/

export BROWSER="firefox '%s' &"

PATH=$PATH:/home/atnnn/speech/htk/bin.linux/:/home/atnnn/speech/julius/bin/
[[ -f "/usr/home/atnnn/.config/autopackage/paths-bash" ]] && . "/usr/home/atnnn/.config/autopackage/paths-bash"

source /etc/bash_completion

PATH=$PATH':/usr/sbin'

unset MAILCHECK

export TEXINPUTS=.:/home/atnnn/.TeX:/home/atnnn/.TeX/unicode-math:$TEXINPUTS
