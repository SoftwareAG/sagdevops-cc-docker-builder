#!/bin/sh
set -e

# if managed image (SPM is present)
if [ -d $SAG_HOME/profiles/SPM/bin ]; then
    # self-register
    $SAG_HOME/profiles/SPM/bin/register.sh
    # start SPM in background
    $SAG_HOME/profiles/SPM/bin/startup.sh
fi

if [ $# -gt 0 ]; then
    exec "$@"
    exit 1
fi

# staying online before force stop container
tail -f /dev/null