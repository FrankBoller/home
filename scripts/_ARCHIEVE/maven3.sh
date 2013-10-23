#!/bin/bash

bn=$(basename $0 .sh)
ANT_HOME=$(cygpath --windows "${SYSTEMDRIVE}\\java\\apache\\apache-ant-1.6.5")
AXIS_HOME=$(cygpath --windows "${SYSTEMDRIVE}\\java\\apache\\axis-1_1")
JAM_HOME=$(cygpath --windows "${SYSTEMDRIVE}\\java\\oss\\jam-2.1")
JAVA_HOME=$(cygpath --windows "${SYSTEMDRIVE}\\java\\j2sdk1.4.2_10")
JBOSS_HOME=$(cygpath --windows "${SYSTEMDRIVE}\\java\\sourceforge\\jboss-3.2.7-src")
MAVEN_HOME=$(cygpath --windows "${SYSTEMDRIVE}\\Program Files\\Apache Software Foundation\\Maven 1.0.2\\")
USER_HOME=$(cygpath --windows "$HOME")

typeset -i E_OPTERR=0
# comment
options="34b:hj:m:u:"
while getopts $options Option
do
  case $Option in
    3) bn=maven3;;
    4) bn=maven4;;
    b) JBOSS_HOME=$(cygpath --path --windows "$OPTARG");;
    h) E_OPTERR=65; break;;
    j) JAVA_HOME=$(cygpath --path --windows "$OPTARG");;
    m) MAVEN_HOME=$(cygpath --path --windows "$OPTARG");;
    u) USER_HOME=$(cygpath --path --windows "$OPTARG");;
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
    b is JBOSS_HOME    : $JBOSS_HOME
    j is JAVA_HOME     : $JAVA_HOME
    m is MAVEN_HOME    : $MAVEN_HOME
    u is USER_HOME     : $USER_HOME
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

export ANT_HOME
export AXIS_HOME
export JAM_HOME
export JAVA_HOME
export JBOSS_HOME
export MAVEN_HOME
export USER_HOME

#############################################################################
# TODO: change below when JBOSS 4 is configured
#############################################################################

if [ "$bn" = "maven3" ] ; then
#  . ~/.envJboss3
  "$MAVEN_HOME"/bin/maven -Duser.home=$(cygpath -w "$USER_HOME") $*
elif [ "$bn" = "maven4" ] ; then
#  . ~/.envJboss4
  "$MAVEN_HOME"/bin/maven -Duser.home=$(cygpath -w "$USER_HOME") $*
fi
