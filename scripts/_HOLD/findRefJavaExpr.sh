#!/bin/bash
id='$Id: findRefJavaExpr.sh,v 1.19 2006/10/02 14:26:51 fboller Exp $'
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
mkdir -p $logDir
logFile="${logDir}/logFile.log"
#################################

d='$'
excludeExpr=$(date)
number=
optionList=
logName="all"
typeset -i E_OPTERR=0
typeset -i fTail=1
typeset -i fVerbose=0

options="chl:ntv"
while getopts $options Option
do
  case $Option in
    c) excludeExpr='^[[:space:]]*//';;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    n) number="-n";;
    t) (( fTail = ! fTail ));;
    v) (( fVerbose = ! fVerbose ));;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

shift $(($OPTIND - 1))
# Move argument pointer to next.

(( $fVerbose != 0 )) && verbose="-v";

# prepare default log name
if [ -z $logFile ] ; then
  catArgs=$(echo $* | tr -dc '[[:alpha:]]')
  logFile=${logDir}/${catArgs}.log
fi

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    c is excludeExpr: $excludeExpr
    h displays (this) Usage
    l is the name of the logfile: $logFile
    n number: $number
    p is the log name: $logName
    t toggle fTail: $fTail
    v toggle fVerbose: $fVerbose $verbose

  Links:
    findRefJavaExpr
    findRefJavaHttp
    findRefJavaIcWord
    findRefJavaNakedException
    findRefJavaSQLException
    findRefJavaUrlPathLine
    findRefJavaWord
EOF
  exit $E_OPTERR
fi

cat > $logFile <<EOF

#############################################################################
# $Id: findRefJavaExpr.sh,v 1.19 2006/10/02 14:26:51 fboller Exp $
#
# $bn $*
# $(date) started
#############################################################################
EOF

cat $logFile

javaLst=.countTypes/.lists/.java.lst
CR='\r'
NL='\n'

if [ ! -f $javaLst ] ; then
  cat <<EOF

  #############################################################################
  # could not find $javaLst
  #
  # try to "cd ${d}perforce/IT-Program/JavaProjects" and/or 
  #   try running countTypes.sh first
  #############################################################################

EOF

  exit
fi

#############################################################################

optionList="$number"

for arg in $(cat $javaLst)
do
  if [ "$bn" = "findRefJavaExpr" ] ; then
    ( tr $CR $NL < $arg | grep $optionList "$1" && echo "### $arg" ) | tee -a $logFile
  elif [ "$bn" = "findRefJavaHttp" ] ; then
    cat >> $logFile <<EOF
#
# find References in perforce2/IT-Program/JavaProjects of string "http:"
#
#############################################################################
EOF
    ( tr $CR $NL < $arg | grep $optionList -iw 'http:' && echo "### $arg" ) | tee -a $logFile
  elif [ "$bn" = "findRefJavaIcWord" ] ; then
    ( tr $CR $NL < $arg | grep $optionList -iw "$1" && echo "### $arg" ) | tee -a $logFile
  elif [ "$bn" = "findRefJavaNakedException" ] ; then
    cat >> $logFile <<EOF
#
# find References in perforce2/IT-Program/JavaProjects of -s (Exact) string "Exception"
#
#############################################################################
EOF
    ( tr $CR $NL < $arg | grep $optionList -w "Exception" && echo "### $arg" ) | tee -a $logFile
  elif [ "$bn" = "findRefJavaSQLException" ] ; then
    cat >> $logFile <<EOF
#
# find References in perforce2/IT-Program/JavaProjects of -s (Exact) string "SQLException"
#
#############################################################################
EOF
    ( tr $CR $NL < $arg | grep $optionList -w "SQLException" && echo "### $arg" ) | tee -a $logFile
  elif [ "$bn" = "findRefJavaUrlPathLine" ] ; then
    ( \
    tr $CR $NL < $arg \
    | sed "s/^[[:space:]]*//" \
    | grep $optionList -inw 'http:' \
    | sed "s;\(^[^:]*\):.*\([Hh][Tt][Tt][Pp]://[^/][^/]*\)[\"/].*;\2::\t${arg}:\1;" \
    | sed "s;\(^[[:digit:]][[:digit:]]*\):\(.*\);    :\2::\t${arg}:\1;" \
    ) | tee -a $logFile
  elif [ "$bn" = "findRefJavaWord" ] ; then
    ( tr $CR $NL < $arg | grep $optionList -v "$excludeExpr" | grep -w "$1" && echo "### $arg" ) | tee -a $logFile
  else echo "do not grok $bn";
  fi
done

if [ "$bn" = "findRefJavaUrlPathLine" ] ; then

  head -6 $logFile > ${bn}.freeform.log
  echo "# create list of freeform items" | tee -a ${bn}.freeform.log
  grep -iv "^http" $logFile >> ${bn}.freeform.log

  echo "# create list of unique http constant expressions"
#  grep -i '^http:' findRefJavaUrlPathLine..log | sed 's/::.*/::/' | sed 's/".*//' | sed "s/[.][[:space:]].*/::/g" | sort -u > findRefJavaUrlPathLine.unique.http.log
  grep -i '^http:' $logFile \
  | sed 's/\\n//g' \
  | sed 's/::.*/::/' \
  | sed 's/["\\[:space:]].*//' \
  | sed "s/[.][[:space:]].*/::/g" \
  | sort -u > ${bn}.unique.http.lst

  echo "# for each unique http, count how many times it is used" 
# for http in $(cat findRefJavaUrlPathLine.unique.http.lst);do echo $http; echo "$(grep --count "^$http" findRefJavaUrlPathLine..log) : $http" >> findRefJavaUrlPathLine.count.unique.url.log; done

  head -6 $logFile > ${bn}.count.unique.url.log
  echo "# for each unique url, count how many times it is used" >> ${bn}.count.unique.url.log

  for http in $(sort -u ${bn}.unique.http.lst)
  do
    echo "$(grep --count "^$http" $logFile) : $http" >> ${bn}.$$
  done

  sort -rn ${bn}.$$ | pr --columns=2 --expand-tabs -T -t -w100 | expand >> ${bn}.count.unique.url.log

fi

cat | tee -a $logFile <<EOF

#############################################################################
# $Id: findRefJavaExpr.sh,v 1.19 2006/10/02 14:26:51 fboller Exp $
#
# $bn $*
# $(date) finished
#############################################################################
EOF

# (( fTail != 0 )) && ( cat $logFile; tail -f $logFile; ) || echo "cat $logFile; tail -f $logFile"

# mkLinks.sh
#
# for findRefJavaExpr findRefJavaHttp findRefJavaIcWord findRefJavaNakedException findRefJavaSQLException findRefJavaUrlPathLine findRefJavaWord
# do
#   if [ ! -f $arg ] ; then ln -s ../scripts/fj $arg; fi
# done
# 
rmdir $logDir > /dev/null 2>&1
