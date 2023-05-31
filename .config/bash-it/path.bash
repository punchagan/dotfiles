# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin/external" ] ; then
    PATH="$HOME/bin/external:$PATH"
fi

if [ -d "${HOME}/.npm-global/bin" ] ; then
    export PATH="${HOME}/.npm-global/bin:$PATH"
fi

export FLYCTL_INSTALL="/home/punchagan/.fly"
if [ -d "${FLYCTL_INSTALL}" ] ; then
    export PATH="${FLYCTL_INSTALL}/bin:$PATH"
fi
