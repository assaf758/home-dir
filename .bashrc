export PS1="\e[0;31m[\u@\h \W]\$ \e[m "
alias find=/usr/bin/find
export PATH=$PATH:/c/Program\ Files\ \(x86\)/PortableGit/bin
#  .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Compass users  bashrc definitions
if [ -f /home/compass/bashrc.global ]
then
        . /home/compass/bashrc.global
fi

# User specific aliases and functions

export EDITOR=vim

#################### ssh-agent config
SSH_ENV="$HOME/.ssh/environment"

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}

# test for identities
function test_identities {
    # test whether standard identities have been added to the agent already
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        ssh-add /c/Users/assaf/.ssh/id_assaf758_rsa
        # $SSH_AUTH_SOCK broken so we start a new proper agent
        if [ $? -eq 2 ];then
            start_agent
        fi
    fi
}

# check for running ssh-agent with proper $SSH_AGENT_PID
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
#################### ssh-agent config


case "`hostname`" in 
    'hlinux' )
        export GOROOT=$HOME/Tools/go
	export PATH=$PATH:$GOROOT/bin
	;;
    'assaf-lap' )
	export PS1="\[\e[0;31m\][\u@\h \W]\$ \[\e[m\] "
        ;;
    * )	    
        PS1='[\w$(__git_ps1 " (%s)")]\$ '
        ;;
esac

unalias ls &>/dev/null
alias lsl="ls -lah"

unalias vs 2>/dev/null

alias sss="ssh -X cmp-sft-srv1"
alias csu='( cd $WS/build && cmake ../src &&  ../tools/genver.sh && cd .. && tools/create_files_list.sh )'
alias eclipse_indigo='/auto/software/tools/indigo/eclipse/eclipse'
alias eclipse_helios='/auto/software/tools/helios/eclipse/eclipse'

#force ignoredups and ignorespace

export HISTCONTORL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

export PATH=~/bin:~/scripts:$PATH

alias find=/usr/bin/find
export PATH=$PATH:/c/Program\ Files\ \(x86\)/PortableGit/bin

