#!/bin/bash
MODE="${1:-default}"
emacsclient -ne "(pc/journal '${MODE})"
