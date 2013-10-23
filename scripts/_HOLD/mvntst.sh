#!/bin/bash
id='$Id: mvntst.sh,v 1.4 2007/10/02 15:42:31 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bn=$(basename $0 .sh)
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
#mkdir -p $logDir
#logFile="${logDir}/logFile.log"
#keep=clean
#################################

typeset -i E_OPTERR=0

options="hklt::x"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    t) testNum=$OPTARG;;
    x) set -x;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

aTests=( $(fj | fgrep '/test/' | sed -e 's;.*/;;' -e 's;[.].*;;' | sort -u) )
aMax=${#aTests[@]}

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h) displays (this) Usage
    l) logFile=${d}OPTARG;;
    t) testNum=${d}OPTARG;;
    x) set -x;;
    
    $(printf "%11.11s = %-6s\n" OPTIND   "$OPTIND"       )
    $(printf "%11.11s = %-6s\n" aMax     "${aMax}"       )
    $(printf "%11.11s = %-6s\n" logFile  "$logFile"      )
    $(printf "%11.11s = %-6s\n" testNum  "$testNum"      )
    $(echo "aTests: ${aTests[@]}")
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################


test -n "${testNum}" && (
  thisTest=${aTests[$(( testNum -= 2 )) ]}
  printf "%11.11s = %-6s\n" thisTest  ${thisTest}
  mvntest test -Dtest=${thisTest}
) || {
  select name in exit ${aTests[@]} ; do
    (( $REPLY<2 )) && break
    (( ($REPLY-1)>${aMax} )) && break
    printf "%s:%s\n" "${name}" "${REPLY}"
    mvntest test -Dtest=${name}
  done
}

# rmdir $logDir > /dev/null 2>&1
