#!/bin/bash
# $Id: sets.sh,v 1.6 2007/05/15 16:14:05 fboller Exp $
#############################################################################

bn=$(basename $0 .sh)
bs='\'
getsFile=~/links/.gets
pathName="$2"
tmpFile=/tmp/$bn.$$
varName="$1"

test "x$pathName" = "x" && pathName=.
zh=$(cygpath -u ${pathName})

if [ -d ${zh} ] ; then
  zl=$(cygpath -u "$(cygpath -aml ${pathName})");
  zs=$(cygpath -u "$(cygpath -ams ${pathName})");
  ###
  zb=${zl// /${bs} }
  zn=${zl// /}
fi

test "${zb[@]}" != "${zl[@]}" && pathName=$zs || pathName=$zl

#############################################################################

if [ "x$varName" = "x." ] ; then
  varName=here
elif [ "x$varName" = "x" ] ; then
  varName=$(basename $zn)
fi
varName=$(echo $varName | sed -e "s;^\(.\);\L\1;g" | tr -cd '[[:alpha:][:digit:]]' | sed 's/^[[:digit:]]/n&/g' )

# printf "# %4s %s\n" "varName" "${varName[@]}"
# printf "# %4s %s\n" "pathName" "${pathName[@]}"
echo "export ${varName[@]}=${pathName[@]}"

if [ "$bn" = "sets" ] ; then
  touch $getsFile
  cat > $tmpFile <<EOF
  $(fgrep -v " ${varName[@]}=" < $getsFile)
  export ${varName[@]}=${pathName[@]}
EOF
  sed -e 's/^  *//' < $tmpFile > $getsFile
  rm -f $tmpFile

fi
