#!/bin/bash

cat <<EOF

#############################################################################
# $Id: idProps.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
# create std test .properties files
#############################################################################

EOF

tmp=old.$$
if [ -f old ]; then mv old $tmp; fi
if [ ! -d old ]; then mkdir old; fi
if [ -f $tmp ]; then mv $tmp old/old; fi

pwd

cat <<EOF

#############################################################################
# process basenames
#############################################################################

EOF

p=properties

for arg in $(ls -1A *es | fgrep -v _)
do
  bn=$(basename $arg .$p)
  echo ""
  echo process $bn

  for file in ${bn}_*.$p
  do
    test $file = ${bn}'_*.'$p && continue
    echo "cp ${bn}.$p $file"
    cp ${bn}.$p $file
  done
done

cat <<EOF

#############################################################################
# format prop files
#############################################################################

EOF

for arg in *.properties
do
  echo $arg
  tmp=${arg}.$$
  mv $arg $tmp

  sed -e "/^[[:space:]]/d" -e "s/=.*/=/" -e "s,^\([^=]*\).*=,\1=\\\\n\
        [translation for \1]:\\\\n\
                ${PWD}.${arg},g" \
    < $tmp \
    > $arg
  mv $tmp old
done

unset tmp
