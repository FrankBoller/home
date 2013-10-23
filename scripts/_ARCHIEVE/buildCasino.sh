#!/bin/bash
id='$Id: buildCasino.sh,v 1.9 2006/05/30 15:10:39 fboller Exp $'
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
logFile="${logDir}/logFile.log"
#################################

here=$(pwd)
export JBOSS_HOME="${SYSTEMDRIVE}\\java\\jboss-3.2.7"
###
coreDir=${here}/csp-adapters_casino_core
cspDir=${here}/csp
dcDir=${here}/csp-adapters_casino_dependent-components
jbossDefaultDir=$(cygpath -u ${JBOSS_HOME}/server/csp-default)
nextgenDir=${here}/NextGenAPI
wtDir=${here}/csp-adapters_casino_websvc-types
###
jbossConfDir=${jbossDefaultDir}/conf
jbossDeployDir=${jbossDefaultDir}/deploy
jbossLibDir=${jbossDefaultDir}/lib
wsdlDir=${cspDir}/websvcs/wsdl
websvcs=${cspDir}/websvcs

function gimmeSpace() {
for (( i=0; i<16; i++ )) ; do echo ""; done
}

cat <<EOF
#############################################################################
# Deal with compile time config properties files
#############################################################################

EOF

if [ -d "${nextgenDir}" ] ; then
  gimmeSpace
  cat <<EOF
  #############################################################################
  # Generate NextGenApi
  #############################################################################

EOF

  cd ${nextgenDir}
  maven -q ${JAVA_OPTS} jar:install | tee ${logDir}/maven.log
fi

gimmeSpace
cat <<EOF
#############################################################################
# Build casino
#############################################################################

EOF

for arg in ${coreDir} ${wtDir}
do
  if [ -d "${arg}" ] ; then
    cd ${arg}; maven -q ${JAVA_OPTS} jar:install | tee ${logDir}/maven.log
  fi
done

  if [ -d "${dcDir}" ] ; then
    cd ${dcDir}
    antFile=cp-build.inline.maven.xml
    ant ${JAVA_OPTS} -q -f ${antFile} | tee ${logDir}/${antFile}.log

    antFile=build.xml
    ant ${JAVA_OPTS} -q -f ${antFile} deploy | tee -a ${logDir}/${antFile}.log
  fi

gimmeSpace
cat <<EOF
#############################################################################
# Generate csp
#############################################################################

EOF

  if [ -d "${wsdlDir}" ] ; then
    cd ${wsdlDir}
    maven -q ${JAVA_OPTS} jar:install | tee ${logDir}/maven.log
  fi

  if [ -d "${websvcs}" ] ; then
    cd ${websvcs}
    maven -q ${JAVA_OPTS} jar:install | tee ${logDir}/maven.log
  fi

  if [ -d "${cspDir}" ] ; then
    cd ${cspDir}

    antFile=build.xml
    ant ${JAVA_OPTS} -q -f ${antFile} deploy-local-stable | tee ${logDir}/${antFile}.log
  fi

gimmeSpace
rm -f ${jbossDeployDir}/{cspequifaxadapter,csptuadapter,csphoadapter,csppingadapter,cspppdcagent}.sar
rm -f ${jbossLibDir}/hoadapterobjs.jar
rm -f ${jbossLibDir}/hoxmlgateway.jar

cd ${here}
# cp Log4j.properties log4j.xml ${jbossConfDir}

rmdir $logDir > /dev/null 2>&1
