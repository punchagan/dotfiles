#!/usr/bin/env python3

from glob import glob
import os
from os.path import expanduser, join, split, splitext
import shutil
import subprocess
import time

MAILDIR = expanduser('~/.config/msmtp/emails')
SENTDIR = join(MAILDIR, 'sent')
DELAY = 2  # avoid sending emails until 2 minutes after they have been written

os.makedirs(SENTDIR, exist_ok=True)


def since_email(path):
    _, name = split(path)
    timestamp, _ = splitext(name)
    return (time.time() - float(timestamp)) / 60


def send_emails():
    # FIXME: Add a delay!
    emails = sorted(glob(join(MAILDIR, '*.txt')))
    undelay = [email for email in emails if since_email(email) > DELAY]
    if emails != undelay:
        print('Delaying {} email(s)'.format(len(emails) - len(undelay)))

    for email in undelay:
        try:
            do_send_email(email)
        except subprocess.CalledProcessError as e:
            message = '{}: {}'.format(e.output.decode('utf8'), email)
            print(message)
            subprocess.check_call(
                ['notify-send', '-u', 'critical', '-a', 'msmtp', 'Email failure', message]
            )
        else:
            shutil.move(email, SENTDIR)

def do_send_email(path):
    with open(path) as f:
        subprocess.check_output(
            ['msmtp', '--read-envelope-from', '-t'], stdin=f, stderr=subprocess.STDOUT
        )


if __name__ == '__main__':
    send_emails()
