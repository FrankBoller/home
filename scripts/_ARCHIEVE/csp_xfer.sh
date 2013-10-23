#!/bin/bash
id='$Id: csp_xfer.sh,v 1.5 2006/04/28 00:36:31 fboller Exp $'
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

N=$(echo "16o$(date +%N) 2 22^/16i100+fq" | dc | cut -b 2,3) 
now=$(echo $(date +%Y%m%d.%H%M%S.$N))

bn=$(basename $0 .sh)
logDir="/tmp/logDir/${bn}/${now}"
mkdir -p $logDir
logFile="${logDir}/logFile.log"

#################################

typeset -i E_OPTERR=0

remoteDir=dev_put_files
remoteSystem=casanblol01.cricketcommunications.com
remoteUser=csp_xfer

options="d:hl:s:u:x"
while getopts $options Option
do
    case $Option in
        d) remoteDir=$OPTARG;;
        h) E_OPTERR=65; break;;
        l) logFile=$OPTARG;;
        s) remoteSystem=$OPTARG;;
        u) remoteUser=$OPTARG;;
        x) set -x;;
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

    d) $(printf "%15.15s = %-55s : [%s]\n" remoteDir     $remoteDir     '$OPTARG' )
    l) $(printf "%15.15s = %-55s : [%s]\n" logFile       $logFile       '$OPTARG' )
    s) $(printf "%15.15s = %-55s : [%s]\n" remoteSystem  $remoteSystem  '$OPTARG' )
    u) $(printf "%15.15s = %-55s : [%s]\n" remoteUser    $remoteUser    '$OPTARG' )
    x) set -x
EOF
    echo "failed: $E_OPTERR"
    exit $E_OPTERR
fi

#############################################################################

for port in csp-8001 csp-8002 ; do
    cspServer=/usr/local/lib/jboss/server/${port}
    mkdir ${logDir}/${port}

    mainFiles=( $(cd ${cspServer}/log/translog; ls *.main.txt) )

    for filetype in main detail; do
        srcDir=${cspServer}/log/translog

        cat <<EOF

        # $cspServere $filetype ${cspServer}

EOF
        files=( $(cd ${cspServer}/log/translog; ls *.${filetype}.txt) )

        # count of files more than 0
        (( ${#files} > 0 )) && {

        #################################
        # this block entered only when there are files
        #################################

        destDir=${logDir}/${logDir}/${port}
        mkdir -p ${destDir}

        cat <<EOF >> ${logFile}

#################################
# ${id}
# copy ${#files[@]} files from ${srcDir} to
#   ${remoteSystem}:~${remoteUser}/${remoteDir}
#   ${logDir} 
#################################

EOF
        cd ${srcDir}
        cp ${files[*]} ${destDir}
        scp ${files[*]} ${remoteUser}@${remoteSystem}:raw.${remoteDir}
        ssh ${remoteUser}@${remoteSystem} mkdir -p raw.${remoteDir}
        ssh ${remoteUser}@${remoteSystem} mv "raw.${remoteDir}/*.txt" ${remoteDir}
        rm ${files[*]}
        }
    done
done

for arg in 1 2 3 ; do echo ""; done
echo "logfile: ${logFile}"

set +x
# rmdir $logDir > /dev/null 2>&1
