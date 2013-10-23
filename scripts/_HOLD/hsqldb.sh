#!/bin/bash
id='$Id: hsqldb.sh,v 1.1 2007/08/01 23:16:40 fboller Exp $'
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
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
hsqldbJar="i:/local/M2639C~1/repo/hsqldb/hsqldb/180~1.7/HSQLDB~1.JAR"
hsqldbHome="i:/local/hsqldb"
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
  Usage $0 -[$options]
    h displays (this) Usage
    
    l) $(printf "%11.11s = %-6s : [%s]\n" logFile    $logFile     '$OPTARG' )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

cd ${hsqldbHome}
java -cp ${hsqldbJar} org.hsqldb.Server -database.0 file:mydb -dbname.0 xdb

# rmdir $logDir > /dev/null 2>&1
