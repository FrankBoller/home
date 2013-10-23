#!/bin/bash
Id='$Id: hosts.sh,v 1.12 2005/12/14 17:00:58 fboller Exp $'
#############################################################################

bn=$(basename $0 .sh)
dest=/c/WINDOWS/system32/drivers/etc
fTail=1;# true
fEcho=1;# true
etcDir=/c/WINDOWS/system32/drivers/etc
hosts=( $(cd $etcDir; echo hosts* ) )

typeset -i E_OPTERR=0

options="b:ehlmt"
while getopts $options Option
do
  case $Option in
    b) bn=$OPTARG;;
    e) (( fEcho = fEcho?0:1 ));;
    h) E_OPTERR=65; break;;
    l) ls -latd ${dest}/hosts.*;;
    m) cd ~/links; rm hosts*; for arg in ${hosts[@]}; do if [ ! -f $arg ] ; then ln -s ../scripts/hosts.sh $arg; fi; done;;
    t) (( fTail = fTail?0:1 ));;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
# bn=$bn $Id

  Usage $0 -[$options]
    b   bn=$OPTARG;;
    e   toggle boolean flag fEcho = ${fEcho} $( (( fEcho )) && echo "(true)" || echo "(false)" )
           if true then echo command
    l   lists ${dest}/hosts.*
    m   cd ~/links; rm hosts*; for arg in ${hosts[@]}; do if [ ! -f $arg ] ; then ln -s ../scripts/hosts.sh $arg; fi; done;;
    h   displays (this) Usage
    t   toggle boolean flag fTail = ${fTail} $( (( fTail )) && echo "(true)" || echo "(false)" )
           if true then tail $dest/$bn

    bn        : ${bn}
    echo hosts: ${hosts[*]}
    ls hosts  : $(cd ~/links; echo hosts* )
EOF

  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

if [ ! -f $dest/$bn ] 
then
  if [ -f $dest/hosts.$bn ]; then bn=hosts.$bn; fi
fi

cp $dest/$bn $dest/hosts

(( $fTail )) && (

  hostFiles="$(cd $dest; ls -x hosts* )"

#############################################################################
# fgrep :space: $dest/hosts
#############################################################################
# $(fgrep :space: $dest/hosts)

  (( $fEcho )) && (
    cat <<EOF

#############################################################################
# bn=$bn $Id
# hostFiles=$hostFiles
#############################################################################
cp $dest/$bn $dest/hosts

#############################################################################
# pings
#############################################################################
whoami               : $(whoami)
ping edmunds.com     : $(ping 164.109.16.239 | head -1 )

#############################################################################
# ${d}(grep "^[[:digit:]]" ${etcDir}/hosts)
#############################################################################

$(grep "^[[:digit:]]" ${etcDir}/hosts)
EOF

  )
)
