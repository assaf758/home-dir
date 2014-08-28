#!/bin/bash

if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

function deferred_exit()
{
    echo "exit if not ctrl-c.."
    sleep 3
    echo "Too late... bye"
    exit 0
}
#deferred_exit


xhost +local:root > /dev/null 2>&1

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano PKGBUILD'

# ex - archive extractor
# usage: ex <file>
function ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


#################### ssh-agent config

# start the ssh-agent
function start_agent ()
{
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
        echo "Adding ssh-keys of all identities"
        for ident in $(find ~/.ssh | grep 'ssh/assaf'| grep -v pub) 
		do 
			ssh-add "$ident"
			if [ $? -eq 2 ];then
				echo "Could not ssh-add $ident"
			fi
		done
    fi
}

# check for running ssh-agent with proper $SSH_AGENT_PID
function ssh-settings () {
    eval `keychain --eval assafb_a10_id_dsa assaf758_id_rsa`
}

function old-ssh-settings {
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

function ttu {
SRC_FILE_LIST=file_list.in
ctags -L "$SRC_FILE_LIST"
cscope -Rbq -i $SRC_FILE_LIST -f 'cscope.out'
}

#################### main 

export PATH=~/bin:~/scripts:$PATH
export PATH=$PATH:/usr/bin/vendor_perl/

source ~/scripts/svn_functions.sh

# The file ~/hostname.txt is not part of git env (spcific for every machine)
case "`cat ~/hostname.txt`" in 
    'hlinux' | 'wlinux' )
        #export GOROOT=$HOME/Tools/go
	#export PATH=$PATH:$GOROOT/bin
	PS1="\n>>\$(date +%Y.%d.%m\ %H:%M); \h:\w\n$ "
        alias sss="ssh -oCiphers=arcfour -oClearAllForwardings=yes dev64-build8"
        alias ss8="ssh -oCiphers=arcfour -oClearAllForwardings=yes dev64-build8"
        alias ss13="ssh -oCiphers=arcfour -oClearAllForwardings=yes dev64-build13"
	;;
    'assaf-win' )
	export PATH=$PATH:"/c/Program Files (x86)/Java/jre7/bin/"
        export PATH=$PATH:/c/Program\ Files\ \(x86\)/PortableGit/bin
	alias find=/usr/bin/find
	alias winword="/c/Program\ Files\ \(x86\)/Microsoft\ Office/Office14/WINWORD.EXE"
	alias gvim="/c/Program\ Files\ \(x86\)/Vim/vim73/gvim.exe"
	alias emacs='/c/Program\ Files\ \(x86\)/emacs/emacs-24.3/bin/emacs'
        PS1="\[\e[0;31m\][\u@\h \W]\$ \[\e[m\] "
        ;;
    'a10' )
        export LOCAL=~/local
        export WS_TEMP=~/ws/assafb_temp
        export DL=${WS_TEMP}/DL
        export PATH=${LOCAL}/bin:$PATH
	PS1="\n>>\$(date +%Y.%d.%m\ %H:%M); \h:\w\n$ "
        if [ "$(hostname)" ==  "dev64-build13" ]
        then
            export MYVIM="/usr/bin/vim"
        else
            export MYVIM="$LOCAL/bin/vim"
        fi
	export DIR_WAS="target/sources/sto/apps/asm/dplane/waf/"
	export DIR_STO="target/sources/sto/"
	alias cdws="cd $WS"
	alias stbuild="rm -f *build && sudo make MOD=20 64BIT=yes all"
        alias stvim="(cd target/sources/sto/ && ${MYVIM})"
        alias sttag="(cd target/sources/sto/ ; ttf ; ttu)"
	cd ~/ws
	;;
    * )	    
        ;;
esac

# ssh-settings

# pyenv install
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export EDITOR=vim
export LESS=FSRX

# append to the history file, don't overwrite it
shopt -s histappend
#force ignoredups and ignorespace
HISTCONTORL=ignoreboth
ISTTIMEFORMAT="[%F | %R]"
HISTFILESIZE=20000
HISTSIZE=10000

set -o vi # make bash readline behave as vi
# Use jk as ESC mode replacement
bind -m vi-insert '"jk": vi-movement-mode'

# Set WS var to current dir
ws_set() {
	export WS=`pwd`
}

# Aliases config
unalias ls &>/dev/null
alias sbash="pushd .  > /dev/null && source ~/.bashrc && popd  > /dev/null"
alias vbash="$MYVIM ~/.bashrc"

# slickedit
#unalias vs 2>/dev/null
#alias csu='( cd $WS/build && cmake ../src &&  ../tools/genver.sh && cd .. && ~/scripts/create_files_list_swapp.sh )'
