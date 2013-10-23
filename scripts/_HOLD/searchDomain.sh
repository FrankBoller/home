#!/bin/bash
id='$Id: searchDomain.sh,v 1.8 2006/10/02 14:26:52 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

# if [ -f ~/.aliases ] ; then
#     shopt -s expand_aliases
#     source ~/.aliases
# fi

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################


if [ $bn = "sp" ] ; then
  bn="searchDomainpro"
fi
if [ $bn = "sy" ] ; then
  bn="searchDomainYahoo"
fi

echo bn = $bn

codeComma="%2C"
firefox=/Mozzila/firefox.exe
wordfile=""
wordlist=""

# http://search.yahoo.com/search?_adv_prop=web&x=op&ei=UTF-8&fr=FP-tab-web-t&va=fboller+bollerf&va_vt=any&vp_vt=any&vo=bollerfrank+frankjboller&vo_vt=any&ve_vt=any&vd=all&vst=0&vf=all&vm=r&fl=1&vl=lang_en&n=100
# DomainName=fboller%0D%0Afjboller%0D%0Afrankboller%0D%0Abollerf&
# DomainName=fboller%2Cfjboller%2Cfrankboller%2Cbollerf&
# https://secure.registerapi.com/dds2/index.php?siteid=38206&affid=DB-741&comtld=.com&Submit=SEARCH&

# .s/[&]/&
/g
typeset -i E_OPTERR=0

options="f:hl:"
while getopts $options Option
do
  case $Option in
    f) wordfile="$wordfile $OPTARG"; wordlist="$wordlist $(cat $OPTARG)";;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

allArgs=$(echo $wordlist $* | sed 's/[[:space:]]/\n/g' | tr '[[:upper:]]' '[[:lower:]]' | sort -u | tr '[[:space:]]' ' ')
commaArgs=$(echo $allArgs | sed "s/[[:space:]][[:space:]]*/$codeComma/g" )

if [ $E_OPTERR != 0 ] ; then
  cat <<EOF
  Usage $0 -[$options]
  f is a list of a wordfiles      : $wordfile
  h displays (this) Usage
  l is the name of the logfile    : $logFile

  allArgs=${allArgs}
  commaArgs=${commaArgs}
EOF

  exit $E_OPTERR
fi

#############################################################################

set -vx
if [ $bn = searchDomainpro ] ; then
  url="https://secure.registerapi.com/dds2/index.php?siteid=38206&affid=DB-741&comtld=.com&Submit=SEARCH&DomainName=$commaArgs";
  $firefox "${url}$arg";
else
  url="http://order.sbs.yahoo.com/ds/DomainSearchResults?x=0&y=0&.src=sbs&.refer=other&d=";
  for arg in $*
  do
    echo "$arg"
    $firefox "${url}$arg"
  done
fi
set +vx

# case $bn in
#   searchDomainYahoo)
#   ;;
#   searchDomainpro)
#   ;;
# esac
# rmdir $logDir > /dev/null 2>&1
