#!/bin/bash

source ~/.bashrc

echo "Running Lab1.2 for $STUDENT in $CLASS"
gobuster dns -d $CLASS.sec588.cloud -q -w /home/sec588/Coursefiles/wordlists/subdomains-5k.txt -o /home/sec588/Coursefiles/workdir/gobuster-hosts-$CLASS-sec588-cloud -r 143.198.165.145
gobuster dns -d sec588.org -q -w /home/sec588/Coursefiles/wordlists/subdomains-5k.txt -o /home/sec588/Coursefiles/workdir/gobuster-hosts-sec588-org -i -r 143.198.165.145
dnsrecon --iw -d $CLASS.sec588.cloud -D /home/sec588/Coursefiles/wordlists/subdomains-5k.txt -k -t brt,crt,std -n 143.198.165.145,143.198.165.155 --threads 10 -c /home/sec588/Coursefiles/workdir/dnsrecon.csv
dnsrecon --iw -d sec588.org -D /home/sec588/Coursefiles/wordlists/subdomains-5k.txt -k -t brt,crt,std -n 143.198.165.145,143.198.165.155 --threads 10 -c /home/sec588/Coursefiles/workdir/dnsrecon2.csv

echo "The output of DNS Recon is:"
cat /home/sec588/Coursefiles/workdir/dnsrecon.csv | awk -F, '{ print tolower($2) }' | sort -u | grep -v name | grep -v dns | grep -v s3-w | grep -v s3-1-w | grep -v heroku

echo "For .COM it is: "
cat /home/sec588/Coursefiles/workdir/dnsrecon2.csv | awk -F, '{ print   tolower($2) }' | sort -u | grep -v name | grep -v dns | grep -v office

