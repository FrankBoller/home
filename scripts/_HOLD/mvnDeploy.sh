#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/mvnDeploy.sh,v $
id='$Id: mvnDeploy.sh,v 1.4 2007/08/10 15:09:51 fboller Exp $'
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

bn=$(basename $0 .sh)
export here=$(pwd)
export deteDir=/var/www/html/maven2/com/warnerbros/dete

function mvnDeploy() {

local filePart=$1
local classifier=""

if [ "x$filePart" != "x" ] ; then
  classifier="-Dclassifier=${filePart}"
  filePart="-${filePart}"
fi

set -x
mvn deploy:deploy-file \
-Dfile=${artifactId}-${version}${filePart}.jar \
${classifier} \
-DpomPath=${pomFile} \
-DrepositoryId=dete-repository \
-Durl=file:///var/www/html/maven2
}
set +x

#################################

export zipFile=$1
if [ ! -f ${zipFile} ] ; then echo "usage: $0 zipFileName.zip"; exit; fi

export artifactId=$(basename ${zipFile} .zip)
if [ "${zipFile}" = "${artifactId}" ] ; then echo "usage: $0 zipFileName.zip"; exit; fi

unzip ${zipFile}
export pomPath=$( find ${artifactId} -name '*.pom')
if [ ! -f "${pomPath}" ] ; then echo "### ERROR ### pomfile:[${pomPath}] does not exist"; exit; fi

export version=$(echo ${pomPath} | cut -d/ -f2)
export jarDir=${here}/$(dirname ${pomPath})
pomFile=$(basename ${pomPath})

cd ${jarDir}

#############################################################################

for arg in *.jar; do
  baseName=$(basename $arg .jar)
  fileFragment="$(echo "${baseName}" | sed -e 's/.*-//')"
  if [ "${fileFragment}" == "${version}" ] ; then
    fileFragment=""
  fi
  mvnDeploy "${fileFragment}"
done

set -x
export finalDir=${deteDir}/db/${artifactId}/${version}
if [ ! -d ${finalDir} ] ; then
  finalDir=${deteDir}/${artifactId}/${version}
fi

chgrp -R maven ${finalDir}/..
chmod -R o-w ${finalDir}/..
set +x
