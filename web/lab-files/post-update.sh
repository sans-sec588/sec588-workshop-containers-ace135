#!/bin/bash

FILE="/home/sec588/.zshrc"
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
CURDIR=`pwd`

if [ "$EUID" = 0 ]
then echo "Please don't run as root or sudo!"
exit
fi

function UPDATE_WIKI () {
    echo "[+] Working on updates, please wait..."
    cd /var/www/html/workbook
    REM=.sec588.cloud
    CLASS=$(printf '%s\n' "${CLASS//$REM/}")
    grep -rl \$STUDENT . --exclude-dir=.git --include=*.html | xargs --no-run-if-empty sed -i "s/\$STUDENT/$STUDENT/g"
    grep -rl \$CLASS . --exclude-dir=.git --include=*.html | xargs --no-run-if-empty sed -i "s/\$CLASS/$CLASS/g"
    grep -rl \$CLSSNOPACE . --exclude-dir=.git --include=*.html | xargs --no-run-if-empty sed -i "s/\$CLSSNOPACE/$CLSSNOPACE/g"
}

function UPDATE_SYSTEM () {
    TEAMFILTRATION_VERSION=$(cat /opt/teamfiltration/.version)
    if [ "$TEAMFILTRATION_VERSION" != "3.5.3" ]; then
        rm -Rf /opt/teamfiltration/TeamFiltration-Linux-v3.3.8-.zip
        curl -s -L https://github.com/Flangvik/TeamFiltration/releases/download/v3.5.3/TeamFiltration-v3.5.3-linux-x86_64.zip --output /opt/teamfiltration/TeamFiltration-v3.5.3.zip
        cd /opt/teamfiltration/
        unzip -o TeamFiltration-v3.5.3.zip
        chmod 777 /opt/teamfiltration/TeamFiltration
        echo "3.5.3" > .version
    fi
}

#function UPDATE_ENV() {
#    if [ -f "$FILE" ]
#    then
#    if grep -q "CLASS" "$FILE"
#    then
#        sed -i '/CLASS=/d' $FILE
#    fi
#    if grep -q "CLSSNOPACE" "$FILE"
#    then
#        sed -i '/CLSSNOPACE=/d' $FILE
#    fi
#    if grep -q "STUDENT" "$FILE"
#    then
#        sed -i '/STUDENT=/d' $FILE
#    fi
#    if grep -q "UA" "$FILE"
#    then
#        sed -i '/UA=/d' $FILE
#    fi
#    fi
#}

#function HELP () {
#    echo "[+] This course features a quest to update this wiki, you must"
#    echo "[+] pass lab 1.5 to update your local wiki! Have fun exploring"
#}

#function QUESTIONS () {
#    echo "[+] What is your class name? It will be found in the MyLabs portal,"
#    echo "[+] Look for the targets range domain, example: pickle-orchid.sec588.cloud"
#    read -p "You would enter pickle-orchid in this prompt: " CLASS
#
#    TEMPNUM=`echo $((1000 + $RANDOM % 8999))`
#
#    read -p "[+] Do you want us to set your student number to $TEMPNUM? [y/N]" NEWNUM
#    case $NEWNUM in
#        [Yy]* ) STUNUM=$TEMPNUM;;
#        * ) read -p "What is your student number? Numbers only please : " STUNUM;;
#    esac
#
#    STUDENT=student$STUNUM
#    UPDATE_ENV
#    UPDATE_WIKI
#
#}

#if [[ -z "$CLASS" || -z "$STUDENT" ]]
#then
#    QUESTIONS
#else
#    echo "[+] Student Number currently set to $STUDENT"
#    echo "[+] Class name currently set to $CLASS"
#    read -p "Do you need to Update your Student Number or Class Name? [y/N]" UPDATE
#    case $UPDATE in
#        [Yy]* ) QUESTIONS;;
#        * ) UPDATE_WIKI;;
#    esac
#
#fi

UPDATE_WIKI
UPDATE_SYSTEM

cd $CURDIR
