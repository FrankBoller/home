#!/usr/bin/bash
id='$Id: gb.sh,v 1.3 2007/07/09 16:34:05 fboller Exp $'
#cat <<EOF
#
############################################################################
# ${id}
# 
############################################################################
#
#EOF

if [ -f ~/.aliases ] ; then
  shopt -s expand_aliases
  source ~/.aliases
fi

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0

options="ghl:t"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    g) bn=g;;
    t) bn=gt;;
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

  l) $(printf "%11.11s = %-6s\n" logFile    $logFile      )
  t) $(printf "%11.11s = %-6s\n" timeOrder    $timeOrder     )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

filenames=( $(echo $@|xargs cygpath -aw) )

case $bn in
  "gt")
  {
    lastestFile="$(find * -maxdepth 0 -mindepth 0 -type f | xargs ls -t1 | head -1)"
    nohup gvim ${lastestFile} > /dev/null 2>&1 &
  };;
  *)
  {
    nohup gvim ${filenames[@]} > /dev/null 2>&1 &
  };;
esac
