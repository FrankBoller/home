#!/bin/bash
id='$Id: now.sh,v 1.12 2006/10/02 14:26:52 fboller Exp $'
# cat <<EOF
# 
# #############################################################################
# # ${id}
# # 
# #############################################################################
# 
# EOF
# 
# if [ -f ~/.aliases ] ; then
#     shopt -s expand_aliases
#     source ~/.aliases
# fi

bn=$(basename $0 .sh)
#################################
# DO NOT use now.sh R-E-C-U-R-S-I-V-E-L-Y
#################################
### logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
### mkdir -p $logDir
### logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0

options="hl:"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

  Usage $0 -[$options]
    h displays (this) Usage
    l is the name of the logfile    : $logFile

    jdf.default: date string like: Wed Apr 05 16:46:20 PDT 2006
    jdf.full   : date string like: Wednesday, April 5, 2006 4:46:50 PM PDT
    jdf.long   : date string like: April 5, 2006 4:46:54 PM PDT
    jdf.medium : date string like: Apr 5, 2006 4:46:58 PM
    jdf.short  : date string like: 4/5/06 4:47 PM
    log.detail : date string like: san24863_8001_2006-04-05-16-47_44280830_1.detail.txt
    log.main   : date string like: san24863_8001_2006-04-05-16-47_1144220400.main.txt
    nano       : date string like: 891010000
    now        : date string like: 20060405.164722.91
    ts         : date string like: 1144280844 
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

if [ "$bn" = "ts" ] ; then
    date +%s;# seconds since 1970-01-01 00:00:00 UTC
elif [ "$bn" = "jdf.default" ] ; then
    # date   :   Wed Apr 05 13:45:32 PDT 2006
    #            Wed Apr 05 14:29:30 PDT 2006
    jdf="+%a %b %d %T %Z %Y";
    date "$jdf" | sed -e 's/PST/PDT/g'
elif [ "$bn" = "jdf.full" ] ; then
    jdf="+%A, %B %e, %Y %r %Z";# DF_FULL:   Wednesday, April 5, 2006 1:45:32 PM PDT
    date "$jdf" | sed -e 's;0\([[:digit:]][/:]\);\1;g' -e 's/  */ /g' -e 's/PST/PDT/g'
elif [ "$bn" = "jdf.long" ] ; then
    jdf="+%B %e, %Y %r %Z";# DF_LONG:   April 5, 2006 1:45:32 PM PDT
    date "$jdf" | sed -e 's;0\([[:digit:]][/:]\);\1;g' -e 's/  */ /g' -e 's/PST/PDT/g'
elif [ "$bn" = "jdf.medium" ] ; then
    jdf="+%b %e, %Y %r";# DF_MEDIUM: Apr 5, 2006 1:45:32 PM
    date "$jdf" | sed -e 's;0\([[:digit:]][/:]\);\1;g' -e 's/  */ /g'
elif [ "$bn" = "jdf.short" ] ; then
    jdf="+%D %l:%M %p";# DF_SHORT:  4/5/06 1:45 PM
    date "$jdf" | sed -e 's;0\([[:digit:]]/\);\1;g' -e 's/  */ /g'
elif [ "$bn" = "log.detail" ] ; then
    # detailSoapMessage   : ${hostname}_${timestamp}_${transactionId}_${dataSeq}.detail.txt
    # basename            : \(.*\).detail.txt
    hostname=$(hostname)_8001
    jdf="+%Y-%m-%d-%H-%M"
    timestamp=$(date "$jdf")
    transactionId=$(echo "$(date +%s) 10 8^% 10 8^+p" | dc | cut -b2-)
    dataSeq=1
    echo "${hostname}_${timestamp}_${transactionId}_${dataSeq}.detail.txt"
elif [ "$bn" = "log.main" ] ; then
    # mainTransactionLog  : ${hostname}_${timestamp}_${serverSessionSeq}.main.txt"
    # basename            : \(.*\).main.txt
    hostname=$(hostname)_8001
    jdf="+%Y-%m-%d-%H-%M"
    timestamp=$(date "$jdf")
    serverSessionSeq=$(date -d "$(date +%F)" +%s)
    echo "${hostname}_${timestamp}_${serverSessionSeq}.main.txt"
elif [ "$bn" = "nano" ] ; then
    date +%N;# nanoseconds (000000000..999999999)
else
    # now
    N=$(echo "16o$(date +%N) 2 22^/16i100+fq" | dc | cut -b 2,3) 
    echo $(date +%Y%m%d.%H%M%S.$N)
fi
# rmdir $logDir > /dev/null 2>&1
