#!/bin/bash

URL=$(echo "${1}" | sed -n "s/.*url=\(.*\)&title=.*/\1/p")
curl --verbose -L "https://web.archive.org/save/${URL}" > /tmp/org-protocol-wayback.log &
emacsclient "$@"
