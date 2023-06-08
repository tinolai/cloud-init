#!/bin/bash

export TELEGRAM_TOKEN="xxx:ooo"
export TELEGRAM_CHAT="ccc"
TELEGRAM="/usr/local/bin/telegram"

hostname=`hostname`

function init(){
tmpf=`mktemp`
hostname=`hostname`
echo "HOST: [$hostname]" >> $tmpf
}

function show-space(){
df -h / >> $tmpf
}

function show-loadavg(){
val=$(cat /proc/loadavg|awk '{print $1}')
echo Loadavg: "$val" >> $tmpf
}

function show-cpuhigh(){
echo "Now the CPU usage is high." >> $tmpf
#TOPPROC=$(ps -eo pid,user,%cpu,%mem,cmd --sort=-%cpu | head -n 6)
TOPPROC=$(ps -eo pid,user,%cpu,%mem,cmd --sort=-%cpu | awk '{print $1,$2,$3,$4,$5,"...",$NF}' | head -n 6)
echo -e "$TOPPROC" >> $tmpf
}

case "$1" in
  space)
    init
    show-space
    ;;
  loadavg)
    init
    show-loadavg
    ;;
  cpu)
    init
    show-cpuhigh
    ;;
  *)
    echo "Usage: $0 {space|loadavg|cpu}"
    exit 1
esac


# start


cat $tmpf | $TELEGRAM -
rm -f $tmpf
