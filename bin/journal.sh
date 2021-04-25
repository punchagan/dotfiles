#!/bin/bash
MODE="$1"
echo "${MODE}" > /tmp/journal-arg
emacsclient -ne "(pc/journal ${MODE})"
