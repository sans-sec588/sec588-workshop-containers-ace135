#!/bin/bash
source ~/.bashrc

./lab1.2.sh

echo "Running catchup for Lab1.3 for $STUDENT in $CLASS"

echo "The following DNS Requests will be used:"
cat /home/sec588/Coursefiles/workdir/dnsrecon.csv
cat /home/sec588/Coursefiles/workdir/dnsrecon*.csv | grep -v dns | grep -v MX | grep -v : | grep -v heroku | awk -F, '{ print $3 }' | grep -v "^$" | grep -v office | grep -v Address >> /tmp/ips.txt

cat /home/sec588/Coursefiles/workdir/gobuster-hosts-* | grep -v mail |  grep -v www-dev | awk -F'[][]' '{ print $2 }' | tr "," "\n" >> /tmp/ips.txt
cat /home/sec588/Coursefiles/workdir/gobuster-hosts-* | grep -v mail |  grep -v www-dev | awk -F'[][]' '{ print $2 }' | tr "," "\n" >> /tmp/ips.txt 
cat /tmp/ips.txt | sort -u > /home/sec588/Coursefiles/workdir/ips.txt

sudo masscan --adapter tun0 --open-only --source-port 40000-41023 -p 1-1024,3000,5000,6379,27017 -oB /home/sec588/Coursefiles/workdir/masscan.bin -iL /home/sec588/Coursefiles/workdir/ips.txt

masscan --readscan /home/sec588/Coursefiles/workdir/masscan.bin | awk -F\/ '{ print $1 }' | sort -u | awk '{ print $4 }' | tr "\n" "," > /home/sec588/Coursefiles/workdir/portlist.txt

sudo nmap -iL /home/sec588/Coursefiles/workdir/ips.txt -e tun0 -p `echo $(cat /home/sec588/Coursefiles/workdir/portlist.txt)` -n -O -sV --script redis-info,mongodb-databases,http-git,http-methods,http-passwd --reason -Pn -oA /home/sec588/Coursefiles/workdir/scan1
