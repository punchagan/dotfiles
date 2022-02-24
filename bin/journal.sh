#!/bin/bash
MODE="$1"
emacsclient -ne "(pc/journal ${MODE})"
