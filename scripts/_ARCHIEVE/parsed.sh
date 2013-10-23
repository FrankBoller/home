#!/bin/bash
id='$Id: parsed.sh,v 1.4 2006/04/22 19:11:00 fboller Exp $'
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

function showBanner() {
cat <<EOF

#############################################################################
# ${id}
#############################################################################
# $(date) $message

EOF
}

message="started"
showBanner

datePath=$(type -p gdate) || datePath=$(type -p date)
yesterday=$($datePath --date "1 days ago" +%Y%m%d)

AV_DATA_PARSER_DIR=/raid/salone/AVDataParser
JAVA_HOME=/usr/bin/java
TXTFILE=AVTECH-${yesterday}.txt

typeset -i E_OPTERR=0

options="a:hl:j:y:"
while getopts $options Option
do
  case $Option in
    a) AV_DATA_PARSER_DIR=$OPTARG;;
    h) E_OPTERR=65; break;;
    j) JAVA_HOME=$OPTARG;;
    l) logFile=$OPTARG;;
    y) yesterday=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

DATA_DIR=${AV_DATA_PARSER_DIR}/datafiles

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    a is the AVDataParser directory : $AV_DATA_PARSER_DIR
    j is JAVA_HOME                  : $JAVA_HOME
    h displays (this) Usage
    l is the name of the logfile    : $logFile
    y is yesterday                  : $yesterday

    test -d $AV_DATA_PARSER_DIR: $(test -d $AV_DATA_PARSER_DIR && echo found || echo missing)
    test -d $DATA_DIR: $(test -d $DATA_DIR && echo found || echo missing)
    test -d $JAVA_HOME: $(test -d $JAVA_HOME && echo found || echo missing)
EOF
  message="failed: $E_OPTERR"
  showBanner
  exit $E_OPTERR
fi

cd $AV_DATA_PARSER_DIR
$JAVA_HOME/bin/java -jar ProcessResponses.jar $DATA_DIR/$TXTFILE

message="finished"
showBanner
rmdir $logDir > /dev/null 2>&1
