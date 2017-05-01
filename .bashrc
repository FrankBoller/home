#!/bin/sh

# echo "CHERE_INVOKING ${CHERE_INVOKING}"

#############################################################################
# $Id: .bashrc,v 1.24 2007/09/25 18:11:05 fboller Exp $
#############################################################################

shopt -s expand_aliases
umask 0000

export d='$'
export n=\\n
export nl=$(echo)
export q='"'
export s="'"

test "$OSTYPE" = "cygwin" && export TERM=cygwin
export DISPLAY=monster:0.0; # export DISPLAY=$(hostname):0.0
export EDITOR=gvim
export FCEDIT=vi
export HISTCONTROL=ignoreboth
export HISTFILE=$HOME/.history_bash
export HISTFILESIZE=3000;# default is 500
export INCLUDE=.
export LESS=-X; # do not clear screen after less has finished
export LIB=
export MANPATH=/usr/local/man:/usr/share/man:/usr/man:/usr/ssl/man:/usr/X11R6/man:/usr/X11R6/share/man
export MSDEVDIR=
export NLS_DATE_FORMAT="dd-mon-yyyy hh24:mi:ss"
export NLSPATH=
export OPATH=${PATH}
export TERM=cygwin; #TERM=ansi
export xlatd=" xargs ls -latd "

function cdd () {
  pushd .; cd $(dirname $1);
  cd $(cygpath -u $(cygpath -aml .));
}

function pd () {
  pushd $(dirname $1);
}

# function cdir () {
#   local fpath=~; [ ! x"$1" = x ] && local u=$(u "$1") && [ -d "$u" ] && fpath="$u" || fpath="${u}/.."; pushd "$fpath"
# }

function u() { cygpath -u "$1"; }

# if [ -f "${CHERE_INVOKING}" ] ; then
#   . ${CHERE_INVOKING}
# else
#   . ~/.envrc
# fi

export PATH=/.fjb/.fabric8/bin:${PATH}
export PATH=${HOME}/links:${PATH}
export PATH=${HOME}/scripts:${PATH}

# if [ ${#ARGS_BATCH} != 0 ] ; then
#   # echo "ARGS_BATCH:{${ARGS_BATCH}}"
# #  ARGS_WIN=$(cygpath -u $ARGS_BATCH)
#   for arg in ${ARGS_BATCH[*]}; do
#     filePath=$(cygpath $(echo $arg | sed -e 's/"//g' ))
#     # echo "filePath:{${filePath}}"
#     if [ -f ${filePath} -o -d ${filePath} ] ; then
#       arg=${filePath}
#       # echo "arg:{${arg}}"
#     fi
#     ARGS_WIN="${ARGS_WIN}${arg} "
#   done
# fi
# 
# if [ ${#ARGS_WIN} != 0 ] ; then
#   eval ${ARGS_WIN}
# fi

[[ -f ~/.aliases ]] && . ~/.aliases
[[ -f ~/links/.gets ]] && . ~/links/.gets; # get prev env
export MAVEN_HOME=${M2_HOME}
export CLASSPATH=

#export KUBERNETES_DOMAIN=vagrant.f8
#export DOCKER_HOST=tcp://vagrant.f8:2375

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="/home/fjb/.sdkman"
# [[ -s "/home/fjb/.sdkman/bin/sdkman-init.sh" ]] && source "/home/fjb/.sdkman/bin/sdkman-init.sh"
