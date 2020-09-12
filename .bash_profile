#!/bin/bash

echo 'Loading .bash_profile'

# Prompt
RESTORE=$(echo -en '\033[0m')
RED=$(echo -en '\033[00;31m')
GREEN=$(echo -en '\033[00;32m')
YELLOW=$(echo -en '\033[00;33m')
BLUE=$(echo -en '\033[00;34m')
MAGENTA=$(echo -en '\033[00;35m')
PURPLE=$(echo -en '\033[00;35m')
CYAN=$(echo -en '\033[00;36m')
LIGHTGRAY=$(echo -en '\033[00;37m')
LRED=$(echo -en '\033[01;31m')
LGREEN=$(echo -en '\033[01;32m')
LYELLOW=$(echo -en '\033[01;33m')
LBLUE=$(echo -en '\033[01;34m')
LMAGENTA=$(echo -en '\033[01;35m')
LPURPLE=$(echo -en '\033[01;35m')
LCYAN=$(echo -en '\033[01;36m')
WHITE=$(echo -en '\033[01;37m')

# echo 'Testing color changes'
# echo ${RED}RED${GREEN}GREEN${YELLOW}YELLOW${BLUE}BLUE${PURPLE}PURPLE${WHITE}WHITE${CYAN}CYAN${RESTORE}

# git

# get current branch in git repo
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]; then
      STAT=`parse_git_dirty`
      echo "[${BRANCH}${STAT}] "
    else
      echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
      bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
      bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
      bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
      bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
      bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
      bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
      echo " ${bits}"
    else
      echo ""
    fi
}

# prompt
# put brackets around content with zero length to fix reverse-search: \[content\]
# iterm can be configured to display timestamps, user, host, directory, branch.
export PS1="$ "
# export PS1="[\D{%F %T}] \u@\h:\w \[${CYAN}\]\`parse_git_branch\`\[${RESTORE}\]\\$ "

# path
export PATH="/opt:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/bin:$HOME"

# aliases
alias nr="npm run"
alias gd="git diff"
alias gdc="git diff --cached"
alias gl="git log"
alias gs="git status"
alias gsh="git show"
alias gpoh="git push origin HEAD"
alias gc="git commit"
alias gco="git checkout"
alias gp="git pull"
alias gb="git branch"
alias ga="git add"
alias gwhich="git rev-parse --abbrev-ref HEAD"
alias gcanoe="git commit --amend --no-edit"
alias k="kubectl"

# editor
export VISUAL='code -w'
export EDITOR="$VISUAL"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# NodeJS
NODE_VERSION=12.18.3
nvm use $NODE_VERSION
if [[ $? != 0 ]]; then
  echo "Installing NodeJS $NODE_VERSION"
  nvm install $NODE_VERSION
fi

# docker-compose completion
fpath=(~/.zsh/completion $fpath)
# autoload -Uz compinit && compinit -i

# go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

# bash autocomplete
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ryan/.google/google-cloud-sdk/path.bash.inc' ]; then source '/Users/ryan/.google/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ryan/.google/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/ryan/.google/google-cloud-sdk/completion.bash.inc'; fi

# kubectl
kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl

# nativescript development
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export ANDROID_HOME=/usr/local/share/android-sdk
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$PATH

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

[[ -s "/Users/ryan/.gvm/scripts/gvm" ]] && source "/Users/ryan/.gvm/scripts/gvm"
