#!/bin/bash
# This script will check for network connectivity, then retrieve any available
#   workbook content per the git configuration in the $DOCROOT location
# NOTE: This requires a properly configured ssh client and an authorized SSH
#   client key for the appropriate repository!!

# parse any command line arguments
VERBOSE=0
DEBUGLOG=0
if [ $# -gt 0 ]; then
    while true; do
        if [ $1 ]; then
            if [ $1 == '-verbose' ]; then
                VERBOSE=1
            elif [ $1 == '-debuglog' ]; then
                DEBUGLOG=1
            fi
            shift
        else
            break
        fi
    done
fi

# determine if we are in linux or windows, then set $DOCROOT accordingly
if ( uname -r | grep -qi Microsoft ); then
    OS=windows
    DOCROOT="/mnt/c/SANS/workbook"
else
    OS=linux
    DOCROOT="/var/www/html/workbook"
fi

if [ $DEBUGLOG -eq 1 ]; then
    logfile=/tmp/workbook-update.log
    now=$( date -Iseconds )
    echo "$now Running workbook-update" >> $logfile
else
    logfile=/dev/null
fi

# check for Internet connectivity
nc -zw1 github.com 22 > /dev/null 2>&1
if [ "$?" != 0 ]; then
    echo 'This system does not appear to have Internet connectivity.'
    echo 'This script requires access to github.com on port TCP/22.'
    echo 'Please fix this and try again.'
    exit 1
fi

echo 'Beginning update process...'

cd $DOCROOT
echo "- running git clean" >> $logfile
git clean -fd >> $logfile 2>&1
echo "- running git reset --hard" >> $logfile
git reset --hard >> $logfile 2>&1
echo "- running git remote update" >> $logfile
git remote update >> $logfile 2>&1

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @{0})
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @{0} "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo '- No workbook updates available'

elif [ $LOCAL = $BASE ]; then
    echo '- Updating workbook files'
    if [ $VERBOSE -eq 1 ]; then
        git pull
        echo
        echo -n "Origin URL: "
        git config --get remote.origin.url
        echo -n "Branch and latest commit: "
        git --no-pager log --oneline --decorate -n 1
    else
        git pull >> $logfile 2>&1

    fi

    if [ ${OS} == "linux" ] && [ -f ${DOCROOT}/resources/ewb-update.cron ] && ( which crontab > /dev/null 2>&1 ); then
        echo '- Installing crontab' >> $logfile
        crontab ${DOCROOT}/resources/ewb-update.cron
    fi
fi

echo ''
echo 'Complete!'
echo >> $logfile
