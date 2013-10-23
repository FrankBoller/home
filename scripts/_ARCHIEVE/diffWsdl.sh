#!/bin/bash
id='$Id: diffWsdl.sh,v 1.12 2006/04/22 19:10:58 fboller Exp $'
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
# logFile="${logDir}/logFile.log"
#################################

alias sd='sdiff --strip-trailing-cr --width=200 --ignore-all-space --ignore-blank-lines --speed-large-files '

html=${logDir}/top.html
body=${logDir}/top.body
touch $body

newest=( $(ls -1td wsdl.* | head -2) )
here=$(pwd)

dirName0=${newest[0]}
dirName1=${newest[1]}

for arg in ${newest[@]}; do
  cd $here/$arg
  ls -1d *.wsdl > $logDir/${arg}.txt
done

cat <<EOF | tee -a $body

###--------------------------------------------------------------------------
# sd -ls ${dirName0}.txt ${dirName1}.txt
###--------------------------------------------------------------------------
$(sd -ls $logDir/${dirName0}.txt $logDir/${dirName1}.txt)

EOF

sort -u $logDir/*.txt > $logDir/file.lst

cd $here
for arg in $(cat $logDir/file.lst); do
  cat <<EOF | tee -a $body
###########################################################################
$(sd -ls $here/$dirName0/$arg $here/$dirName1/$arg)

EOF
done

cat <<EOF

###--------------------------------------------------------------------------
# finished
###--------------------------------------------------------------------------
EOF

echo -n "display $html (y/n) [n]: "
read 
if [ "$REPLY" = "y" ] ; then 

  cd $logDir

  cat > $html <<EOF
<html>
  <head> <title>$Id: diffWsdl.sh,v 1.12 2006/04/22 19:10:58 fboller Exp $</title> </head>
  <body>
    <pre>
EOF

  sed -e 's/</\&lt;/g' -e 's/>/\&gt;/g' < $body >> $html

  cat >> $html <<EOF
    </pre>
  </body>
</html>
EOF

  explorer $html
fi

echo -n "rm -rf ${logDir}/.. (y/n) [n]: "
read 
if [ "$REPLY" = "y" ] ; then rm -rf ${logDir}/..; fi
rmdir $logDir > /dev/null 2>&1
