#!/usr/bin/env python
"""A script to automate weekly video generation.

We are going to have a fully org-based system.
- Reminders for videos
- Calendar view of daily/weekly videos.
- ...

The script should run when SD card gets mounted or can be run manually.

"""

from datetime import datetime
from os import listdir, mkdir
from os.path import abspath, dirname, exists, join
from shutil import copy2

# FIXME: Figure out how to access mount point for mtp/ptp drive.
# Copy videos to hard disk, manually

# Pull out videos from specified week
def get_videos_for_week(path, week_number=None):
    if week_number is None:
        # Assuming the script is run on a Sunday, current_week - 1
        week_number = datetime.now().isocalendar()[1]

    week_dir = join(dirname(abspath(path)), 'week_{}'.format(week_number))
    if not exists(week_dir):
        mkdir(week_dir)

    for name in listdir(path):
        if _get_week_from_name(name) == week_number:
            copy2(join(path, name), join(week_dir, name))


def main(path):
    get_videos_for_week(path)


# Helper functions
def _get_week_from_name(name):
    date = datetime.strptime(name.split('_')[1], '%Y%m%d')
    return date.isocalendar()[1]


if __name__ == '__main__':
    path = '/media/punchagan/f9213ab4-a7aa-40c0-91c0-a3d60af751f3/videos/daily/archive'
    main(path)
