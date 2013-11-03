#!/bin/bash

# Pushes a bare clone or a repo to muse-amuse.in as a "central" repository.

if [ $# -lt 1 ]; then
    echo "Usage:" $0 "/path/to/repo"
    exit
fi

# Stupid declarations
REPO_DIR=$1
REPO_NAME=`basename $REPO_DIR`
BARE_REPO=$REPO_NAME.git
REPO_TAR=$REPO_NAME.tar.gz
REMOTE=dumma@muse-amuse.in
REMOTE_DIR=~/repos

# Create a bare clone and tar it up
git clone --bare $REPO_DIR $BARE_REPO
tar -czf $REPO_TAR $BARE_REPO

# Needs network to work
scp $REPO_TAR dumma@muse-amuse.in:
ssh $REMOTE "cd $REMOTE_DIR && tar xvzf ../$REPO_TAR && rm ../$REPO_TAR"

# Add remote as a git remote
pushd $REPO_DIR
git remote add muse-amuse ssh://$REMOTE/$REMOTE_DIR/$BARE_REPO
popd

# Clean up
rm -rf $BARE_REPO $REPO_TAR
