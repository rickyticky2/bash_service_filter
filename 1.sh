#!/bin/bash

# checking arguments
if [ $# -eq 0 ]
  then
     namef="server_$(date +"%d-%m-%Y")_failed"
     namer="server_$(date +"%d-%m-%Y")_running"
     namere="server_$(date +"%d-%m-%Y")_report"
  else
     namef="$1_$(date +"%d-%m-%Y")_failed"
     namer="$1_$(date +"%d-%m-%Y")_running"
     namere="$1_$(date +"%d-%m-%Y")_report"
  fi

# file creation
wget https://raw.githubusercontent.com/GreatMedivack/files/master/list.out
touch $namef && touch $namer && touch $namere
sudo chmod ugo+r $namere 

# text operations
cat list.out | grep 'Error\|CrashLoopBackOff' | cut -d ' ' -f 1 > $namef
cat list.out | grep 'Running' | cut -d ' ' -f 1 > $namer

awk '{sub(/-[0-9a-z]{9,10}-[0-9a-z]{5}$/,"")}1' $namef > temp.txt && mv temp.txt $namef
awk '{sub(/-[0-9a-z]{9,10}-[0-9a-z]{5}$/,"")}1' $namer > temp.txt && mv temp.txt $namer

 
echo "number of running service: " > $namere
cat $namer | wc -l >> $namere 
echo "Number of error service: " >> $namere
cat $namef | wc -l >> $namere
echo "Number of resstart service: " >> $namere
awk '$4 > 0' list.out | wc -l >> $namere
echo "System username: " >> $namere
whoami >> $namere
echo "Date: " >> $namere
date >> $namere


# packing and checking the archive
tar -cvf $(date +"%d-%m-%Y") $namer $namef $namere --remove-files
cp -n $(date +"%d-%m-%Y") archives/


if ! tar tf archives/$(date +"%d-%m-%Y") &> /dev/null; then
    echo "Achive is BAD!"
else
    echo "Archive is OK"
fi
