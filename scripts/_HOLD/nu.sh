#!/bin/bash
id='$Id: nu.sh,v 1.3 2006/10/02 14:26:52 fboller Exp $'
# cat <<EOF
#
# #############################################################################
# # ${id}
# #
# #############################################################################
#
# EOF

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bs='\'

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0

options="b:h"
while getopts $options Option
do
  case $Option in
    0) print0="-print0";;
    b) bn=$OPTARG;;
    c) skipCVS="grep .";;
    d) findType="-type d";;
    f) findType="-type f";;
    h) E_OPTERR=65; break;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h displays (this) Usage

    b) $(printf "%11.11s = %-6s\n" bn        $bn         )

    if [ "$bn" = "nua" ] ;   then net use a: ${bs}${bs}pbs03-1008511${bs}c                /persistent:NO /user:p-west${bs}fboller          pwdPwest
    elif [ "$bn" = "nup" ] ; then net use p: ${bs}${bs}pbs-fs2${bs}projects               /persistent:NO /user:p-west${bs}fboller          pwdPwest
    elif [ "$bn" = "nuq" ] ; then net use q: ${bs}${bs}pbs-fs2${bs}groups                 /persistent:NO /user:p-west${bs}fboller          pwdPwest
    elif [ "$bn" = "nus" ] ; then net use s: ${bs}${bs}pbs-isalesdev${bs}sharedDocuments  /persistent:NO /user:pbs-isalesdev${bs}fboller   pwdLocal
    elif [ "$bn" = "nuu" ] ; then net use u: ${bs}${bs}pbs-fs2${bs}unixadmin              /persistent:NO /user:p-west${bs}fboller          pwdPwest
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

function findOrExpression() {
    expression="${bs}( -iname '*$1' ${bs})"
    shift
    for arg in ${@}; do
        expression="${expression} -or ${bs}( -iname '*${arg}' ${bs})"
    done

    test ${print0} && {
      expression="${bs}( ${expression} ${bs})"
      eval find "${expression}" -print0 $findType | xargs -0n1 -i, echo , | sed 's;^\./;;' | ${skipCVS}
    } || {
      eval find "${expression}" $findType | sed 's;^\./;;' | ${skipCVS}
    }
}

pwdPwest='fb0ller!'
pwdLocal='java4fun'

# 'm,.s;\\;\${bs};g
if [ "$bn" = "nua" ] ;   then net use a: ${bs}${bs}pbs03-1008511${bs}c                /persistent:NO /user:p-west${bs}fboller        $pwdPwest
elif [ "$bn" = "nup" ] ; then net use p: ${bs}${bs}pbs-fs2${bs}projects               /persistent:NO /user:p-west${bs}fboller        $pwdPwest
elif [ "$bn" = "nuq" ] ; then net use q: ${bs}${bs}pbs-fs2${bs}groups                 /persistent:NO /user:p-west${bs}fboller        $pwdPwest
elif [ "$bn" = "nus" ] ; then net use s: ${bs}${bs}pbs-isalesdev${bs}sharedDocuments  /persistent:NO /user:pbs-isalesdev${bs}fboller $pwdLocal
elif [ "$bn" = "nuu" ] ; then net use u: ${bs}${bs}pbs-fs2${bs}unixadmin    /persistent:NO /user:p-west${bs}fboller        $pwdPwest
fi
mount


# mkLinks.sh
#
# for arg in nua nup nuq nus nuu; do ln -s ../scripts/nu.sh $arg; done
#
# rmdir $logDir > /dev/null 2>&1
