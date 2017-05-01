#!/usr/bin/bash
id='$Id: fj.sh,v 1.30 2007/08/01 23:15:31 fboller Exp $'
# cat <<EOF
# 
# #############################################################################
# # ${id}
# # 
# #############################################################################
#
# EOF

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bs='\'
print0=
findType="-type f"
grepINV="grep -v ^\\."
grepCVS="grep -v CVS"
grepCC="fgrep -v .copyarea"
grepSVN="grep -v .svn"
mtime=

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0

options="0ab:cCdfhm:"
while getopts $options Option
do
  case $Option in
    0) print0="-print0";;
    a) findType=;;
    b) bn=$OPTARG;;
    c) grepCVS="grep .";;
    C) grepCC="grep .";;
    i) grepINV="grep .";;
    s) grepSVN="grep .";;
    d) findType="-type d";;
    f) findType="-type f";;
    h) E_OPTERR=65; break;;
    m) mtime="-mtime $OPTARG";;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
  0) print0="-print0";;# ignore spaces in filenames
  a) findType=;;# show all types
  b) bn=\$OPTARG;;# override basename
  c) grepCVS="grep .";;# show CVS paths
  C) grepCC="grep .";;# show ClearCase paths
  d) findType="-type d";;# show only directories
  f) findType="-type f";;# show only files
  h) displays (this) Usage
  m) mtime="-mtime \$OPTARG";;
  s) grepSVN="grep .";;# show SVN paths
    
  $(printf "%2.2s %11.11s = %-6s\n" "" findType "$findType" )
  $(printf "%2.2s %11.11s = %-6s\n" 0  print0   "$print0"   )
  $(printf "%2.2s %11.11s = %-6s\n" b  bn       "$bn"       )
  $(printf "%2.2s %11.11s = %-6s\n" c  grepCVS  "$grepCVS"  )
  $(printf "%2.2s %11.11s = %-6s\n" c  grepCC   "$grepCC"   )
  $(printf "%2.2s %11.11s = %-6s\n" c  grepINV  "$grepINV"  )
  $(printf "%2.2s %11.11s = %-6s\n" c  grepSVN  "$grepSVN"  )
  $(printf "%2.2s %11.11s = %-6s\n" m  mtime    "$mtime"    )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

function findOrExpression() {
    expression="${bs}( -iname '*$1' ${bs})"
    shift
    for arg in ${@}; do
        expression="${expression} -or ${bs}( -iname '*${arg}' ${bs})"
    done

    test ${print0} && {
      expression="${bs}( ${expression} ${bs})" 
      eval find "${expression}" ${mtime} -print0 ${findType} | xargs -0n1 -i, echo , | sed 's;^\./;;' | ${grepCVS} | ${grepSVN} | ${grepCC} | ${grepINV}
    } || {
      eval find "${expression}" ${mtime} ${findType} | sed 's;^\./;;' | ${grepCVS} | ${grepSVN} | ${grepCC} | ${grepINV}
    }
}

# note: "fc" is unavailable.  see bash: fcedit
if [ "$bn" = "f2" ] ; then findOrExpression .ear .jar .sar .war .zip 
elif [ "$bn" = "fa" ] ; then findOrExpression .jar
elif [ "$bn" = "fb" ] ; then find * -iname '*~' $* | sed 's;^\./;;'
elif [ "$bn" = "fd" ] ; then findOrExpression .doc
elif [ "$bn" = "fe" ] ; then findOrExpression .ear
elif [ "$bn" = "ff" ] ; then findOrExpression $*
elif [ "$bn" = "ffd" ] ; then findType="-type d"; findOrExpression $*
elif [ "$bn" = "fff" ] ; then findType="-type f"; findOrExpression $*
elif [ "$bn" = "fh" ] ; then findOrExpression .htm .html
elif [ "$bn" = "fhelp" ] ; then cat ~/scripts/fj.sh
elif [ "$bn" = "fimg" ] ; then findOrExpression .bmp .gif .jpeg .jpg .png
elif [ "$bn" = "fj" ] ; then findOrExpression .java
elif [ "$bn" = "fl" ] ; then findOrExpression .lst
elif [ "$bn" = "fm" ] ; then findOrExpression .bat .cmd
elif [ "$bn" = "fn" ] ; then findType="-type f"; mtime="-mtime 0" ; findOrExpression $* | xargs ls -1dt
elif [ "$bn" = "fo" ] ; then findOrExpression .class
elif [ "$bn" = "fp" ] ; then findOrExpression .properties
elif [ "$bn" = "fs" ] ; then findOrExpression .sh
elif [ "$bn" = "ft" ] ; then findOrExpression .txt
elif [ "$bn" = "ftl" ] ; then findOrExpression .ftl
elif [ "$bn" = "ftypef" ] ; then find * -type f $* | sed 's;^\./;;'
elif [ "$bn" = "fw" ] ; then findOrExpression .war
elif [ "$bn" = "fx" ] ; then findOrExpression .xml
elif [ "$bn" = "fz" ] ; then findOrExpression .zip
elif [ "$bn" = "fall" ] ; then 

  lstStd=( f2 fff fh fimg fj fp fx )
  lstRest=( css ftl js jwc prefs sql )
  lstMisc=( ccf flv jsp ods rb rhtml swf torrent ttf txt )

  set -x
  for arg in ${lstStd[@]}; do
    eval $arg > /tmp/${arg}.lst
  done

  for arg in ${lstRest[@]}; do
    eval "ff .$arg" > /tmp/${arg}.lst
  done

  rm -f /tmp/misc.lst
  touch /tmp/misc.lst
  for arg in ${lstMisc[@]}; do
    rm -f /tmp/${arg}.lst
    eval "ff .$arg" >> /tmp/misc.lst
  done
  set +x

# elif [ "$#" != "0" ] ; then findOrExpression ${@}
# 
else ( arg=$(echo ${bn} | sed 's/.//'); findOrExpression $arg )
fi

# mkLinks.sh
#
# for arg in f2 fa fall fb fd fe ff ffd fff fh fhelp fimg fj fl fm fn fo fp fs ft ftl ftypef fw fx fz ; do ln -s ../scripts/fj.sh $arg; done
# for arg in bat bmp class cmd doc dtd ear gif htm html inc jar java jpeg jpg ; do ln -s ../scripts/fj.sh f$arg; done
# for arg in js jsp lst png properties sar sh sql tld txt war xml xsd zip ; do ln -s ../scripts/fj.sh f$arg; done
# 
# rmdir $logDir > /dev/null 2>&1
