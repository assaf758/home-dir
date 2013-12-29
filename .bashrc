#!/bin/sh

#################### ssh-agent config

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
}

# test for identities
function test_identities {
    # test whether standard identities have been added to the agent already
    ssh-add -l > /dev/null
    if [ $? -eq 2 ]; then 
        start_agent
    fi 
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Adding ssh-key for assaf758"
        ssh-add $SSH_KEY_FILE 
        if [ $? -eq 2 ];then
            echo "Could not ssh-add assaf758 key"
        fi
    fi
}

# check for running ssh-agent with proper $SSH_AGENT_PID
function ssh-settings {
    SSH_ENV="$HOME/.ssh/environment"
    if [ -n "$SSH_AGENT_PID" ]; then
        ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
        if [ $? -eq 0 ]; then
            test_identities
        fi
    # if $SSH_AGENT_PID is not properly set, we might be able to load one from 
    # $SSH_ENV
    else
        if [ -f "$SSH_ENV" ]; then
        . "$SSH_ENV" > /dev/null
        fi
        ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
        if [ $? -eq 0 ]; then
            test_identities
        else
            start_agent
        fi
    fi
}

function compass-global-settings {
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Compass users  bashrc definitions
if [ -f /home/compass/bashrc.global ]
then
        . /home/compass/bashrc.global
fi
}

#################### main 

export PATH=~/bin:~/scripts:$PATH
export PATH=$PATH:/usr/bin/vendor_perl/

# The file ~/hostname.txt is not part of git env (spcific for every machine)
case "`cat ~/hostname.txt`" in 
    'hlinux' )
        #export GOROOT=$HOME/Tools/go
	#export PATH=$PATH:$GOROOT/bin
	;;
    'assaf-lap-debian64' )
	export SSH_KEY_FILE='/home/assaf/.ssh/id_assaf758_rsa'
        ;;
    'assaf-lap' )
	export SSH_KEY_FILE='/c/Users/assaf/.ssh/id_assaf758_rsa'
	export PATH=$PATH:"/c/Program Files (x86)/Java/jre7/bin/"
        export PATH=$PATH:/c/Program\ Files\ \(x86\)/PortableGit/bin
	alias find=/usr/bin/find
	alias winword="/c/Program\ Files\ \(x86\)/Microsoft\ Office/Office14/WINWORD.EXE"
	alias gvim="/c/Program\ Files\ \(x86\)/Vim/vim73/gvim.exe"
	alias emacs='/c/Program\ Files\ \(x86\)/emacs/emacs-24.3/bin/emacs'
        PS1="\[\e[0;31m\][\u@\h \W]\$ \[\e[m\] "
        ;;
    'compass' )
        compass-global-settings
        export SSH_KEY_FILE='/home/assaf/.ssh/id_assaf758_rsa'
        PS1='[\w$(__git_ps1 " (%s)")]\$ '
	;;
    * )	    
        ;;
esac

ssh-settings

export EDITOR=vim

# append to the history file, don't overwrite it
shopt -s histappend
#force ignoredups and ignorespace
HISTCONTORL=ignoreboth
ISTTIMEFORMAT="[%F | %R]"
HISTFILESIZE=20000
HISTSIZE=10000
set -o vi # make bash readline behave as vi

# Aliases config
unalias ls &>/dev/null
alias lsl="ls -lah"
unalias vs 2>/dev/null
alias sss="ssh -X cmp-sft-srv1"
alias csu='( cd $WS/build && cmake ../src &&  ../tools/genver.sh && cd .. && ~/scripts/create_files_list_swapp.sh )'
alias eclipse_indigo='/auto/software/tools/indigo/eclipse/eclipse'
alias eclipse_helios='/auto/software/tools/helios/eclipse/eclipse'

