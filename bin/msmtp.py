#!/usr/bin/env python3

import os
from os.path import abspath, expanduser, join
import subprocess
import sys
import time

MAILDIR = expanduser('~/.config/msmtp/emails')
os.makedirs(MAILDIR, exist_ok=True)


def persist_email():
    name = str(time.time())
    path = join(MAILDIR, '{}.txt'.format(name))
    with open(path, 'w') as f:
        f.write(sys.stdin.read())
    return path

persist_email()
