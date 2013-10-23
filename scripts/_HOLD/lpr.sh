#!/bin/bash
id='$Id: lpr.sh,v 1.15 2006/10/02 14:26:52 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# format files then print
#############################################################################

EOF

# if [ -f ~/.aliases ] ; then
#     shopt -s expand_aliases
#     source ~/.aliases
# fi
# 
bn=$(basename $0 .sh)
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

# enscript options
eLineNums="--line-numbers"
eLineNums=
eMode="--landscape"
eFont="--font=Courier-Bold@7"
eHeader="--no-header"

# pr -n option number lines
n4="''-n 4''"
n4=

# defaults for landscape
fWidth=180
pLength=67
pWidth=$fWidth
pIndent=--indent=6

kount=100
r2=

bn=$(basename $0 .sh)
echo "bn: $bn"
if [ "$bn" = "land2" ] ;then
  fWidth=$(( pWidth/2-7 ))
  r2="-2r"
elif [ "$bn" = "lpr" ] ;then
  eFont="--font=Courier-Bold@12"
  eFont="--font=Courier-Bold@10"
  pLength=98
  fWidth=127
  pWidth=$fWidth
  eMode="--portrait"
  pIndent=
fi 

for fileName in $*
do
  arg=$(cygpath -u "$fileName")
  echo $0 $arg
  kount=$((kount=$kount+1))

  fileTmp=${logDir}/$kount

  expand "$arg" \
  | fold --width=$fWidth \
  | pr $n4 --page-width=$fWidth --length=$pLength --header="$arg" $pIndent \
  > $fileTmp

done

PATH=/usr/bin:$PATH
enscript $r2 --quiet $eFont $eHeader $eLineNums $eMode ${logDir}/*
# rm -rf ${logDir}
rmdir $logDir > /dev/null 2>&1
