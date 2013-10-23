#!/bin/sh
# set -x

# echo "CHERE_INVOKING ${CHERE_INVOKING}"

#############################################################################
# $Id: .bashrc,v 1.24 2007/09/25 18:11:05 fboller Exp $
#############################################################################

shopt -s expand_aliases
umask 0000

test "monster" = "$HOSTNAME" && export DISPLAY=monster:0.0

export HISTFILE=$HOME/.history_bash
export HISTFILESIZE=3000;# default is 500
export HISTCONTROL=ignoreboth
test "$OSTYPE" = "cygwin" && export TERM=cygwin

# export CVSROOT=":local:${SYSTEMDRIVE}\local\cvsHome"
# export CVSROOT=":pserver:bollf003@host.acme.com:/main/cvs/LFS/cvsroot_dev"

EDITOR=gvim
FCEDIT=vi

export MANPATH=/usr/local/man:/usr/share/man:/usr/man:/usr/ssl/man:/usr/X11R6/man:/usr/X11R6/share/man
export PATH=${HOME}/links:${HOME}/scripts:${PATH}
test "$OPATH" = "" && export OPATH=${PATH}

# get prev env
if [ -f ~/links/.gets ] ; then . ~/links/.gets; fi

export INCLUDE=.
export LIB=
export MSDEVDIR=
export NLSPATH=
# do not clear screen after less has finished
export LESS=-X
export d='$'
export n=\\n
export nl=$(echo)
export q='"'
export s="'"
export xlatd=" xargs ls -latd "
export NLS_DATE_FORMAT="dd-mon-yyyy hh24:mi:ss"

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

if [ -f "${CHERE_INVOKING}" ] ; then
  . ${CHERE_INVOKING}
else
  . ~/.envrc
fi
source $HOME/.aliases

# set -x
if [ ${#ARGS_BATCH} != 0 ] ; then
  # echo "ARGS_BATCH:{${ARGS_BATCH}}"
  #  ARGS_WIN=$(cygpath -u $ARGS_BATCH)
  for arg in ${ARGS_BATCH[*]}; do
    filePath=$(cygpath $(echo $arg | sed -e 's/"//g' ))
    # echo "filePath:{${filePath}}"
    if [ -f ${filePath} -o -d ${filePath} ] ; then
      arg=${filePath}
      # echo "arg:{${arg}}"
    fi
    ARGS_WIN="${ARGS_WIN}${arg} "
  done
fi

if [ ${#ARGS_WIN} != 0 ] ; then
  eval ${ARGS_WIN}
fi
