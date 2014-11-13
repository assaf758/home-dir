#!/bin/bash
# convert the path into Windows form:
# all credits to http://www.playonlinux.com/fr/topic-989-Passing_command_line_arguments_to_Apps.html
ArgWinePath=`winepath -w "$4"`  
# make sure that nothing is passed to application when no file is given:
FileName=${4:+$ArgWinePath}
# call application with argument:
playonlinux --run "$1" "$2" "$3" "$FileName"    
exit 0

