#!/bin/bash
# $Id: izCompile.sh,v 1.2 2006/05/30 15:10:39 fboller Exp $
#############################################################################

bn=$(basename $(pwd))
installXml=install.xml

if [ -f $installXml ]; then
  shift
else
  installXml=
fi

outputJar=izInstall${bn}.jar
(rm ${outputJar} 2>/dev/null) && echo "rm ${outputJar}" || echo "${outputJar} does not exist"

# Launches the IzPack compiler.
# Use the '-?' argument to know the parameters and call syntax.

# Sets the IzPack home directory
IZPACK_HOME="${SYSTEMDRIVE}\\Program Files\\IzPack"

# Does the effective launching
java -jar "${IZPACK_HOME}/lib/compiler.jar" -HOME "$IZPACK_HOME" $installXml "$@" -o izInstall${bn}.jar
