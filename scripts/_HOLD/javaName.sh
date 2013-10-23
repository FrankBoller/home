#!/bin/bash
# $Id: javaName.sh,v 1.2 2006/05/30 15:10:39 fboller Exp $
#############################################################################

bn=$(basename $0 .sh)
scriptArgs=$*

if [ ${#*} == 0 ] ; then
  scriptArgs=
  while read -a aR
  do
    for arg in ${aR[@]}
    do
      scriptArgs="$scriptArgs $arg"
    done
  done
fi

# echo "scriptArgs: ${#scriptArgs} $scriptArgs"

if [ "$bn" = "javaName"   ] ; then
  for arg in $scriptArgs
  do
    echo "$arg" \
    | tr '[A-Z]' '[a-z]' \
    | sed -e 's;_.;\U&\E;g' -e 's;.;\u&;' \
    | tr -d '_'
  done
elif [ "$bn" = "accessor"   ] ; then
  for arg in $scriptArgs
  do
    oracleName=$arg
    javaName=$(echo "$arg" \
      | tr '[A-Z]' '[a-z]' \
      | sed -e 's;_.;\U&\E;g' -e 's;.;\u&;' \
      | tr -d '_')

      cat <<EOF

  public String get$javaName() {
    String     s$javaName = Str.getTrim(m_aaoRowsByIndex[0][$oracleName]);
    s$javaName = s$javaName.toUpperCase();
    LOGGER.debug("get$javaName(): " + s$javaName);
    return (s$javaName);
  }      

EOF

  done
else
  for arg in $scriptArgs
  do
    echo "$arg" \
    | sed 's;[A-Z];_&;g' \
    | tr '[a-z]' '[A-Z]' 
  done
fi
