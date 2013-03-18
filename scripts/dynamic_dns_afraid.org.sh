## INSTRUCTIONS 
## FIRST, change UPDATEURL (below) based on http://freedns.afraid.org/dynamic/ 
## SECOND, change DOMAIN to your domain name
## THEN, it doesn't hurt to do the following (change permissions)
## FINALLY, add the following line to /etc/crontab
## 54 *    * * *   root    /home/assaf/scripts/dynamic_dns_afraid.org.sh >/dev/null 

#!/bin/sh
#FreeDNS updater script

UPDATEURL="https://freedns.afraid.org/dynamic/update.php?VVR4R0RxMzFVMVVBQUJNZmQ4RUFBQUF5OjkyMzI1MTM="
DOMAIN="assaf758.linuxd.org"

registered=$(nslookup $DOMAIN|tail -n2|grep A|sed s/[^0-9.]//g)

current=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)
[ "$current" != "$registered" ] && {                           
   wget -q -O /dev/null $UPDATEURL 
   echo "DNS updated to $current on:"; date
}
