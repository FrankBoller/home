#!/bin/bash
id='$Id: batchSoaTest.sh,v 1.31 2006/04/22 19:10:57 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# secsPerSleep: ${secsPerSleep}
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

slosh='\'
dirSoaTest="/.allUsers/Documents/soaTest/"

dirInput=${dirSoaTest}/.input
dirOutput=${dirSoaTest}/.output
extSoaScript=.soaScript
extSoaTest=.tst

typeset -i E_OPTERR=0
typeset -i kountFile=0
typeset -i secsPerDot=15              ;# 15 seconds
typeset -i secsPerSleep=10            ;# 10 second sleep
typeset -i secsPerStamp=$(( 60 * 3 )) ;# three minutes
typeset -i tsBeginDots=0
typeset -i tsBeginPolling=0

options="hl:s:"
while getopts ${options} Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    s) dirSoaTest="$OPTARG";;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ ! -d "${dirSoaTest}" ] ; then
    E_OPTERR=-1;
fi

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[${options}]
    h displays (this) Usage
    l is the name of the logfile    : ${logFile}
    s is the dirSoaTest             : ${dirSoaTest}
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

function resetTimeStamps() {
  tsBeginPolling=$(date +%s)
  tsBeginPolling=$(( tsBeginPolling - (tsBeginPolling%3600) )) ;# nearest hour
  tsBeginDots=${tsBeginPolling}
}

#############################################################################

resetTimeStamps
cd  "${dirSoaTest}"
mkdir -p ${dirInput} ${dirOutput}/{html,log,xml}

while true; do

  # if no files, then sleep and continue
  kountFile=$(ls -t | wc -l)
  tsNow=$(date +%s)

  # output something if no files found
  (( kountFile == 0 )) && \
  {
    (( (tsNow-tsBeginPolling) > secsPerStamp )) && \
    {
      echo " $(now)"
      resetTimeStamps
    } || \
    {
      (( (tsNow-tsBeginDots) > secsPerDot )) && \
      {
        echo -n .
        tsBeginDots=${tsNow}
      }
    }

    sleep ${secsPerSleep};
    continue;
  }
  echo ""

  for anyFile in "$(ls -1t)"; do

    # remove invalid characters from name of anyFile
    validName=$(echo -n "${anyFile}" | tr -cs '[^[:alnum:].]' '_')
    if [ "${anyFile}" != "${validName}" ] ; then
      mv "${anyFile}" "${validName}"
    fi 
    ls -lad ${validName}
    chmod a+rw ${validName}

    validExt=$(echo "x.${validName}" | sed 's/.*[.]//')
    validBn=$(basename ${validName} ${validExt})

    userName=$(ls -lad ${validName} | gawk ' {print $3}' )
    userScript=${dirInput}/${userName}/${validBn}.${extSoaScript}
    userTest=${dirInput}/${userName}/${validBn}.${extSoaTest}

    nowBn=${userName}.$(now).${validBn}
    nowHtml=$dirOutput/html/${nowBn}.html
    nowLog=$dirOutput/log/${nowBn}.log
    nowScript=${nowBn}.${extSoaScript}
    nowTst=${nowBn}.tst
    nowXml=$dirOutput/xml/${nowBn}.xml

    # branch logic off of extension
    case "${validExt}" in
      exit) echo "exit $Id: batchSoaTest.sh,v 1.31 2006/04/22 19:10:57 fboller Exp $"; exit;;
      ${extSoaScript}) userScript="${validName}";
      cp "${validName}" ${dirInput}/${userName};
      ;;
      ${extSoaTest})
      ;;
      *) blat ${validName} -to fboller@cricketcommunications.com; mv ${validName} ${dirInput}; continue;;
    esac

    # use existing script if possible
    if [ -f ${userScript} ] ; then
      cat ${userScript} | sed \
      -e "s/${d}nowTst/${nowTst}/g" \
      -e "s/${d}nowHtml/${nowHtml}/g" \
      -e "s/${d}nowXml/${nowXml}/g" \
      tr '[\n\r]' ' ' \
      > ${nowScript}
    else
      echo "runtest ${nowTst} -report -outputErrors ${nowHtml} -html -report -outputErrors ${nowXml} -xml" > ${userScript}
    fi

    tee ${nowLog} <<EOF

#############################################################################
### $Id: batchSoaTest.sh,v 1.31 2006/04/22 19:10:57 fboller Exp $
### test: ${validName}
### nowTst: ${nowTst}
### started: $(now)
###
### UNC path for script:
### ${slosh}\Casan24855\Documents\soaTest\\${userScript}
###
### UNC path for log:
### ${slosh}\Casan24855\Documents\soaTest\\${nowLog}
###
### UNC path for html:
### ${slosh}\Casan24855\Documents\soaTest\\${nowHtml}
###
### UNC path for xml:
### ${slosh}\Casan24855\Documents\soaTest\\${nowXml}
#############################################################################

EOF

set -x
cp ${validName} ${nowTst}
mkdir -p ${dirInput}/${userName}
mv ${validName} ${dirInput}/${userName}/${validName}

chown fboller ${nowTst}

tsStart=$(date +%s)
st.exe -cmd -run ${userScript} | tee -a ${nowLog}
tsEnd=$(date +%s)
tsElapsed=$(( tsEnd - tsStart ))

if [ -f ${dirInput}/${userName}/${userScript} ] ; then
  cp ${userScript} ${dirInput}/${userName}/${userScript}
fi
rm -f ${nowTst} ${userScript}

tee -a ${nowLog} <<EOF

#############################################################################
### finished: $(now)
### elapsed: ${tsElapsed}
#############################################################################

EOF

    blat ${nowLog} -to ${userName}@cricketcommunications.com
    set +x

  done
done

rmdir $logDir > /dev/null 2>&1
