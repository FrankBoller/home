#!/bin/bash
id='$Id: bld.sh,v 1.13 2006/04/22 19:10:58 fboller Exp $'
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
logDir="/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
#################################

antOpts="build-all"
argList="$*"
cleanOpt=
d='$'
dirProp=
# dirProp="../../"
fileProp="deploy.properties"
mwd=$(cygpath -m $(pwd))
propertyOpt="-propertyfile $fileProp"

typeset -i E_OPTERR=0

options="a:cdf:hl:p:"
while getopts $options Opt
do
  case $Opt in
    a) antOpts=$OPTARG;;
    c) cleanOpt=clean;;
    d) dirProp=${mwd}; fileProp="${dirProp}/deploy.properties"; propertyOpt=;;
    h) E_OPTERR=65; break;;
    f) fileProp=$OPTARG; propertyOpt=;;
    l) logFile="$OPTARG";;
    p) propertyOpt="$OPTARG";;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Opt"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

propertyOpt=${propertyOpt:-${fileProp:+"-propertyfile $fileProp"}}

touch $logFile

function showBanner () {

cat <<EOF | tee -a $logFile
#############################################################################
# $id
# logFile: $logFile
# argList: $argList
# mwd    : $mwd
#############################################################################

ant $propertyfile $cleanOpt $antOpts | tee -a $logFile 2>&1

EOF
}

showBanner;

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    a) antOpts=${d}OPTARG
    c) cleanOpt=clean
    d) dirProp=clean
    h) displays (this) Usage
    l) logFile=${d}OPTARG
    p) fileProp=${d}OPTARG

    $(printf "%15s: %s\n" antOpts "$antOpts")
    $(printf "%15s: %s\n" cleanOpt "$cleanOpt")
    $(printf "%15s: %s\n" dirProp "$dirProp")
    $(printf "%15s: %s\n" logFile "$logFile")
    $(printf "%15s: %s\n" fileProp "$fileProp")
    $(printf "%15s: %s\n" propertyOpt "$propertyOpt")

EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

ant $propertyOpt $cleanOpt $antOpts | tee -a $logFile 2>&1

rmdir $logDir > /dev/null 2>&1
