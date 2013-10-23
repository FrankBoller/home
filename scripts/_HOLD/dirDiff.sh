#!/bin/bash
id='$Id: dirDiff.sh,v 1.5 2006/10/02 14:26:51 fboller Exp $'
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
logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0
typeset -i kount=1
typeset -a aDir

options="d:hl:"
while getopts $options Option
do
    case $Option in
        d) if [ -d "${OPTARG}" ] ; then aDir=( "${aDir[@]}" "${OPTARG}" ); fi;;
        h) E_OPTERR=65; break;;
        l) logFile=$OPTARG;;
        *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
    esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

for arg in $*; do
    #    if [ -d "${arg}" ] ; then aDir=( "${aDir[@]}" "${arg}" ); fi
    test -d "${arg}" && aDir=( "${aDir[@]}" "${arg}" )
done

# (( ${#aDir[@]} != 2 )) && E_OPTERR=65;

if [ $E_OPTERR != 0 ]
then
    cat <<EOF
    Usage $0 -[$options]

    h displays (this) Usage

    d) $(printf "%11.11s = %s       : [%s]\n" aDir       "${aDir[*]}"   '$OPTARG' )
    l) $(printf "%11.11s = %-11.11s : [%s]\n" logFile    $logFile       '$OPTARG' )

EOF
    echo "failed: $E_OPTERR"
    exit $E_OPTERR
fi

#############################################################################

mkdir -p $logDir

here=$(pwd)

for arg in "${aDir[@]}"; do
    cd ${here}
    thisDir="$(cygpath -a ${arg})"
    logBase=${logDir}/$(( kount++ ))

    echo "processing dir: ${thisDir}"
    cd "${thisDir}"

    set -x
    find "${thisDir}" -type f -print0 | xargs -0 md5sum > ${logBase}.md5sum.txt
    cut '-d ' -f1 ${logBase}.md5sum.txt | sort > ${logBase}.sort.txt
    sort -u ${logBase}.sort.txt > ${logBase}.unique.txt
    comm -3 ${logBase}.sort.txt ${logBase}.unique.txt > ${logBase}.dupMaster.txt
    fgrep -hf ${logBase}.dupMaster.txt ${logBase}.md5sum.txt | sort > ${logBase}.allDups.txt
    set +x

    test -s ${logBase}.allDups.txt && cat <<EOF

    #############################################################################
    # following files in ${thisDir} are dups:
    #############################################################################

    $(cat ${logBase}.allDups.txt | fgrep -v cygwin.com )

EOF
done

(( kount > 2 )) &&
{
    comm -23 ${logDir}/1.unique.txt ${logDir}/2.unique.txt > ${logDir}/1.only.txt
    comm -13 ${logDir}/1.unique.txt ${logDir}/2.unique.txt > ${logDir}/2.only.txt

    test -s ${logBase}.allDups.txt && cat <<EOF

    cat <<EOF
    #############################################################################
    # following files ONLY in first dir
    #############################################################################

EOF

    fgrep -f ${logDir}/1.only.txt ${logDir}/1.md5sum.txt
}
rmdir $logDir > /dev/null 2>&1
