# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Update history each time a new prompt is shown.
# export PROMPT_COMMAND="history -n; history -a"


######################################################################
# From https://gist.github.com/785566
# Set the prompt

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1

win-divider() {
    s="_"
    o=""
    let nl=$COLUMNS

    for i in `seq 1 $nl`; do o="${o}${s}"; done
    echo $o
}

TBytes() {
    TBytes=0
    for Bytes in $(ls -l | grep "^-" | awk '{ print $5 }')
    do
        let TBytes=$TBytes+$Bytes
    done
    TotalMeg=$(echo -e "scale=3 \n$TBytes/1048576 \nquit" | bc)
    echo -n "$TotalMeg"
}
export HISTTIMEFORMAT='%F %T '
export PS1="| \[\e[1;30;31m\][\$(date +'%F %T')] \[\e[1;30;32m\]\h:\[\e[1;30;34m\]\w \[\e[1;30;36m\](\$(TBytes) Mb)\[\e[1;30;37m\]\$(__git_ps1)\[\e[0m\]\n\$ "

######################################################################

declare -a sources=(
    "$HOME/.bash_aliases"  # aliases
    "$HOME/.bash_functions"  # functions
    "$HOME/software/random/autoenv/activate.sh"   # autoenv
    "/etc/bash_completion.d/docker"   # docker
    "$HOME/bin/project"   # project path completion
    "$HOME/.travis/travis.sh"   # travis gem
    "$HOME/.nikola_bash"  # nikola bash completions
)
for path in "${sources[@]}"
do
    if [ -f ${path} ]; then
        . ${path}
    fi
done

# All PATH additions
export PATH=$HOME/.local/bin:$HOME/bin:$PATH
# Ruby stuff
export PATH=$HOME/.gem/ruby/1.9.1/bin:$PATH
# Node stuff
export PATH=$PATH:~/node_modules/.bin
# Elm stuff
export PATH=$HOME/software/random/Elm/Elm-Platform/master/bin:$PATH
# Cabal
export PATH=$HOME/.cabal/bin:$PATH
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

#export CLICOLOR=1
export EDITOR='emacsclient -nw -a vim'
export PYTHON_EGG_CACHE=$HOME/.python-eggs
export MAKEFLAGS="-j7"
export GOPATH=/home/punchagan/gocode

#### EOF ######################################################################
