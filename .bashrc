#!/bin/bash

# prevent interfering with remote commands (scp etc)
[ -z "$PS1" ] && return

get_crtime() {

  for target in "${@}"; do
    inode=$(stat -c %i "${target}")
    # fs=$(df  --output=source "${target}"  | tail -1)
    fs=$(df "${target}" | awk '{a=$1}END{print a}')
    crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | grep -oP 'crtime.*--\s*\K.*')
    printf "%s\t%s\n" "${target}" "${crtime}"
  done
}

function dist_name()
{
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    elif [ -f /etc/SuSe-release ]; then
        # Older SuSE/etc.
        ...
    elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
        ...
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    export OS=$OS
}

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
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.tar.xz)    tar xJf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
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



PERSISTENT_HISTORY=/home/assafb/Drive/assaf758@gmail.com/persistent_history

function hgrep () {
  cat ${PERSISTENT_HISTORY} | grep $1
}

function log_bash_persistent_history()
{
  local command_result=$?
  [[
    $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$
  ]]
  local date_part="${BASH_REMATCH[1]}"
  local command_part="${BASH_REMATCH[2]}"
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
  then
    echo $date_part "|" $command_result "|"  "$command_part" | sed  's/[ \t]*$//' >> ${PERSISTENT_HISTORY}
    export PERSISTENT_HISTORY_LAST="$command_part"
  fi
}


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# _fzf_compgen_path() {
#   ag -g "" "$1"
# }


__fzf_history ()
{
__ehc "$(cat ${PERSISTENT_HISTORY}| fzf --tac --tiebreak=index | cut -d\| -s --complement -f1,2 | cut -b1 --complement)"
}

__ehc()
{
if
        [[ -n $1 ]]
then
        bind '"\er": redraw-current-line'
        bind '"\e^": magic-space'
        READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${1}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
        READLINE_POINT=$(( READLINE_POINT + ${#1} ))
else
        bind '"\er":'
        bind '"\e^":'
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
function ssh_settings () {
    eval `keychain --eval id_rsa`
}

function my_prompt () {
    local target=""
    if [[ $ROOT_BIN_DIR =~ .*Release$ ]] ; then target="Release"; fi
    if [[ $ROOT_BIN_DIR =~ .*Debug$ ]] ; then target="Debug"; fi
    echo "$(date +%Y.%m.%d\ %H:%M); {${target}}"
}


#################### main

if [ -z ${ORIG_PATH+x} ]; then
	# echo "setting ORIG_PATH to $PATH"
	export ORIG_PATH=$PATH
fi

export -f hgrep


if [[ -n $SSH_CONNECTION ]] ; then
    echo;
    # export TERM=xterm-termite # needed for current version of git - WARNING: terminal is not fully functional
elif [[ $COLORTERM == xfce4-terminal ]] ; then
    # http://vim.wikia.com/wiki/256_colors_in_vim
    # export TERM=gnome-256color
    # http://pkgs.fedoraproject.org/cgit/coreutils.git/tree/
    eval `dircolors --sh "/etc/DIR_COLORS.256color"`
else
    # export TERM=xterm-termite
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

alias ls='ls --group-directories-first --time-style=+"%Y.%m.%d %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%Y.%m.%d %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%Y.%m.%d %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano PKGBUILD'
# alias tmux='TERM=linux-assafb tmux'
# alias nvim='TERM=tmux-256color nvim'

export LOCAL=~/.local

add_to_path "$HOME/scripts"
# add_to_path "/usr/bin/vendor_perl/"
# add_to_path "$LOCAL/go/bin"
add_to_path "$HOME/bin"
add_to_path "$LOCAL/bin"

export GOPATH=$HOME/ws/go_ws
add_to_path $GOPATH/bin
add_to_path "$(ruby -e 'print Gem.user_dir')/bin"
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
add_to_path /usr/local/go/bin

source ~/scripts/svn_functions.sh

dist_name

# The file ~/hostname.txt is not part of git env (spcific for every machine)
case "`cat ~/hostname.txt`" in
    'hlinux' | 'wlinux' )
        add_to_path $GOPATH/bin
        PS1="\n>>\$(date +%Y.%m.%d\ %H:%M); \h:\w\n$ "
        add_to_path /opt/junest/bin
        alias s1604='ssh -X -p 2223 assafb@localhost'
        alias sc='ssh -X assafb@assafb-centos'
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
        PS1="\n>>\$(my_prompt); \h:\w\n$ "
        source ~/scripts/iguazio_common.sh
	    add_to_path "~/.local/share/junest/bin"
        if [ -n "${JUNEST_ENV}" ]; then
            EFFECTIVE_UID=$(id -u)
            if [ ${EFFECTIVE_UID} -eq 0 ]; then
                JN_STATE="jnr"
            else
                JN_STATE="jn"
            fi
            PS1+="(${JN_STATE})"       
        fi
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
        ;;
    * )
        ;;
esac

# global / gtags env
export GTAGSLABEL=pygments
export GTAGSCONF=/usr/local/share/gtags/gtags.conf

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export EDITOR=nvim

export BROWSER=firefox
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

# disable ctrl-s / ctrl-q
tty -s && stty -ixon

# bind hgrep to ctrl-r
bind '"\C-r": "\C-x1\e^\er"'
bind -x '"\C-x1": __fzf_history';

PROMPT_COMMAND='log_bash_persistent_history'

# Aliases config
unalias ls &>/dev/null
alias sbash="pushd .  > /dev/null && source ~/.bashrc && popd  > /dev/null"
alias vbash="vim ~/.bashrc"

[ -f ~/.iguazio.bashrc ] && source ~/.iguazio.bashrc

source ~/.git-completion.bash


case "$OS" in
    'Manjaro Linux' | 'arch linux' )
        if [ -f /usr/share/bash-completion/bash_completion ] ; then
            source /usr/share/bash-completion/bash_completion
        fi
        ;;
    'Ubuntu')
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        source /etc/bash_completion
        source /usr/share/bash-completion/completions/git
    fi
    ;;
    'CentOS Linux')
    if [ -d /etc/bash_completion.d ] ; then
        source /etc/bash_completion.d/git
    fi
    ;;
esac

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done
