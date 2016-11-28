#!/bin/bash

function deferred_exit()
{
    echo "exit if not ctrl-c.."
    sleep 3
    echo "Too late... bye"
    exit 0
}
#deferred_exit


function cdranger {
    tempfile="$(mktemp)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# updating tmux session imported vars to latest
# https://gist.github.com/simonjbeaumont/4672606
tmup () 
{ 
    echo -n "Updating to latest tmux environment...";
    export IFS=",";
    for line in $(tmux showenv -t $(tmux display -p "#S") | tr "\n" ",");
    do
        if [[ $line == -* ]]; then
            unset $(echo $line | cut -c2-);
        else
            export $line;
        fi;
    done;
    unset IFS;
    echo "Done"
}


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

add_to_path ()
{
    if [[ "$PATH" =~ (^|:)"$1"(:|$) ]]
    then
        return 0
    fi
    export PATH=$1:$PATH
}

function hgrep () {
  cat ~/Dropbox/.persistent_history | grep $1
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
function ssh_settings () {
    eval `keychain --eval assafb_a10 id_rsa`
}

function log_bash_persistent_history()
{
  [[
    $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$
  ]]
  local date_part="${BASH_REMATCH[1]}"
  local command_part="${BASH_REMATCH[2]}"
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
  then
    echo $date_part "|" "$command_part" >> ~/Dropbox/.persistent_history
    export PERSISTENT_HISTORY_LAST="$command_part"
  fi
}


#################### main

if [ -z ${ORIG_PATH+x} ]; then
	# echo "setting ORIG_PATH to $PATH"
	export ORIG_PATH=$PATH
fi

export -f hgrep


if [ -f /usr/share/bash-completion/bash_completion ] ; then
    source /usr/share/bash-completion/bash_completion
fi

if [[ -n $SSH_CONNECTION ]] ; then
           export TERM=linux
   elif [[ $COLORTERM == xfce4-terminal ]] ; then
    # http://vim.wikia.com/wiki/256_colors_in_vim
    export TERM=gnome-256color
    # http://pkgs.fedoraproject.org/cgit/coreutils.git/tree/
    eval `dircolors --sh "/etc/DIR_COLORS.256color"`
else
        export TERM=linux
    eval `dircolors`
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# dont enable by default - bad when debugging fuse.. :-)
# shopt -s cdspell

shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s histverify
shopt -s hostcomplete
shopt -s nocaseglob

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T  "

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano PKGBUILD'
alias tmux='TERM=linux-assafb tmux'
alias nvim='TERM=linux-assafb nvim'

export LOCAL=~/.local

add_to_path "$HOME/scripts"
# add_to_path "/usr/bin/vendor_perl/"
# add_to_path "$LOCAL/go/bin"
add_to_path "$HOME/bin"
add_to_path "$LOCAL/bin"

export GOPATH=$HOME/ws/go_ws
add_to_path $GOPATH/bin

source ~/scripts/svn_functions.sh

# The file ~/hostname.txt is not part of git env (spcific for every machine)
case "`cat ~/hostname.txt`" in
    'hlinux' | 'wlinux' )
        export GOPATH=$HOME/ws/go_ws
        add_to_path $GOPATH/bin
        PS1="\n>>\$(date +%Y.%m.%d\ %H:%M); \h:\w\n$ "
        add_to_path /opt/junest/bin
	PS1="\n>>\$(date +%Y.%m.%d\ %H:%M); \h:\w\n$ "
        # alias sss='cd ~/ws/vagrant/ubuntu-1504; vagrant ssh'
        alias s1504='ssh -X -p 2224 assafb@localhost'
        alias s1604='ssh -X -p 2223 assafb@localhost'
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
    'iguazio' )
        PS1="\n>>\$(date +%Y.%m.%d\ %H:%M); \h:\w\n$ "
        source ~/scripts/iguazio_common.sh
        ;;
    'a10' )
        export WS_STORAGE=~/ws/assafb_storage
        export DL=${WS_STORAGE}/DL
        export JUNEST_HOME=${WS_STORAGE}/junest_home
        if [ -z ${JUNEST_ENV+x} ]; then
            MYVIM=${LOCAL}/bin/vim
	    add_to_path "$HOME/junest/bin/"
	    PS1="\n>>\$(date +%Y.%m.%d\ %H:%M); \h:\w\n$ "

            if [ -f ~/.cwdfile ]; then
		cd $(cat ~/.cwdfile)
		if [ $? -ne 0 ]; then
		    cd ~/ws
		fi
	        rm ~/.cwdfile
	    else
		cd ~/ws
	    fi
        else
            MYVIM=vim
            export PATH=${ORIG_PATH}
            add_to_path "$HOME/scripts"
	    EFFECTIVE_UID=$(id -u)
	    if [ ${EFFECTIVE_UID} -eq 0 ]; then
		JPR="jnr"
	    else
		JPR="jn"
	    fi
	    PS1="\n>>\$(date +%Y.%m.%d\ %H:%M); \h(${JPR}):\w\n$ "
	fi
        export DIR_WAS="target/sources/sto/apps/asm/dplane/waf/"
        export DIR_STO="target/sources/sto/"
        alias cdws="cd $WS"
        alias stbuild20="rm -f *build && sudo make MOD=20 64BIT=yes all"
        alias stbuild52="rm -f *build && sudo make MOD=52 64BIT=yes all"
        alias stdist20="sudo make MOD=20 64BIT=yes distclean"
        alias stdist52="sudo make MOD=52 64BIT=yes distclean"
        alias stvim="${MYVIM} --cmd 'cd target/sources/sto'"
	alias nvim="TERM=screen-256color nvim"
        alias stnvim="nvim --cmd 'cd target/sources/sto'"
        alias sttag="(cd target/sources/sto/ && rm cscope.* ; ttf ; ttu)"
        ;;
    * )
        ;;
esac


# alias ss8="ssh -oCiphers=arcfour -oClearAllForwardings=yes dev64-build8"
# alias jnr="junest -p \"-k 3.10\" -f"
# alias jn="run_junest"
# alias into17="cdssh dev64-build17"

# ssh-settings


# global / gtags env
export GTAGSLABEL=pygments
export GTAGSCONF=/usr/local/share/gtags/gtags.conf

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export EDITOR=nvim

export BROWSER=google-chrome-stable
export LESS=FSRX

# append to the history file, don't overwrite it
shopt -s histappend
#force ignoredups and ignorespace
HISTCONTORL=ignoreboth
ISTTIMEFORMAT="[%F | %R]"
HISTFILESIZE=20000
HISTSIZE=10000

# For now use emacs readline
set -o emacs # make bash readline behave as vi
# Use jk as ESC mode replacement
# bind -m vi-insert '"jk": vi-movement-mode'

# bind readline ^g to delete char
#http://superuser.com/a/212455
# stty werase undef
bind '"\C-g": backward-delete-char'

PROMPT_COMMAND='log_bash_persistent_history'

# Aliases config
unalias ls &>/dev/null
alias sbash="pushd .  > /dev/null && source ~/.bashrc && popd  > /dev/null"
alias vbash="vim ~/.bashrc"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[ -f ~/.iguazio.bashrc ] && source ~/.iguazio.bashrc

source ~/.git-completion.bash

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
    source /usr/share/bash-completion/completions/git
fi

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done
