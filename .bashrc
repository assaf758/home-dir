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

