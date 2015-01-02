#!/bin/bash
# mkcd command
function mkcd () {
    mkdir $1
    cd $1
}

# from: http://superuser.com/q/276079/242968
# Git command, to disable specific commands some repos.
## When $HOME is a git repo, things like clean -fdx are a risk!
git () {
    local disabled=$(command git config --bool disabled.$1 2>/dev/null)
    if ${disabled:-false} ; then
        echo "The $1 command is intentionally disabled" >&2
        return 1
    fi
    hub "$@"
}
