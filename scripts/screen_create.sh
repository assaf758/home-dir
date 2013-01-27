#!/bin/bash
LIMIT=6
for ((a=1 ; a <= LIMIT ; a++))
do  # The comma chains together operations.
  xterm -T Desktop-$a -e screen -c ~/.screenrc -S D$a &
done

echo; echo

exit 0
