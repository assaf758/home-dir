#!/bin/bash
# convert the path into Windows form:
# all credits to http://www.playonlinux.com/fr/topic-989-Passing_command_line_arguments_to_Apps.html
# make sure that nothing is passed to application when no file is given:
FileName=$2
# call application with argument:
okular --page "$1" "$FileName"    
exit 0

