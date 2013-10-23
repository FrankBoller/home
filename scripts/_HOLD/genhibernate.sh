#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/genhibernate.sh,v $
id='$Id: genhibernate.sh,v 1.12 2007/07/09 16:34:05 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

# cat <<EOF
# mvn org.appfuse:appfuse-maven-plugin:gendaotest
# mvndescribe.sh -a appfuse-maven-plugin -g org.appfuse -v 2.0-chris-m4 -f | fgrep Goal
#
# Goal Prefix: appfuse
# Goal: 'gendao'
# Goal: 'genhibernatedao'
# Goal: 'genmanager'
# Goal: 'genmanagerimpl'

# Goal: 'gendaotest'
# Goal: 'genmodel'

# Goal: 'genhibernatecontext'
# Goal: 'genmanagercontext'

# Goal: 'genjsfform'
# Goal: 'genjsflist'
# Goal: 'genspringform'
# Goal: 'genspringlist'
# Goal: 'genstrutsaction'
# Goal: 'gentapestryform'
# Goal: 'gentapestrylist'

# Goal: 'hello'
# EOF

if [ -f ~/.aliases ] ; then
  shopt -s expand_aliases
  source ~/.aliases
fi

bn=$(basename $0 .sh)
here=$(cygpath -u $(cygpath -aml .))
srcMainResources=${here}/src/main/resources
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
#################################

set -x
###
# define environment
###
export PATH=/e/local/oraclexe/app/oracle/product/10.2.0/server/jdbc/lib/ojdbc14.jar:${PATH}
export MVN_OPTS="-Djdbc.groupId=com.oracle -Djdbc.artifactId=ojdbc14 -Djdbc.version=10.2.0.2.0"

mainPath=src/main
genSourcesPath=target/generated-sources
genDbPath=target/generated-sources/com/warnerbros/dete/db

mainDbPath=src/main/java/com/warnerbros/dete/db

###
# clean project and load base (non-generated) files
###

mvn clean
unzip -o baseFiles.zip

###
# generate POJOs using 2.0-m5-wb-SNAPSHOT
###
mvn -f m5.pom.xml org.appfuse:appfuse-maven-plugin:genmodel ${MVN_OPTS}
# mvn compile
# mkdir -p target/generated-sources
# cp src/main/resources/hibernate.cfg.xml target/generated-sources

#############################################################################
# *** CHEAT use code from zip file with PREVIOUSLY FIXED duplicate references for ManyToMany
#############################################################################
if [ -f fixedDuplicateRefs.zip ] ; then

  unzip -o fixedDuplicateRefs.zip
  cp -r src/main/java/com/warnerbros/dete/db/model target/generated-sources/com/warnerbros/dete/db
  fo | xargs rm
  mvn compile

  cat <<EOF
  ###
  # generate Dao, HibernateDao, Service and ServiceImpl files using 2.0-chris-m4
  ###

mvn org.appfuse:appfuse-maven-plugin:gendao
mvn org.appfuse:appfuse-maven-plugin:genhibernatedao
mvn org.appfuse:appfuse-maven-plugin:genmanager
mvn org.appfuse:appfuse-maven-plugin:genmanagerimpl
mvn org.appfuse:appfuse-maven-plugin:genhibernatecontext
mvn org.appfuse:appfuse-maven-plugin:genmanagercontext

EOF

  for arg in gendao genhibernatedao genmanager genmanagerimpl genhibernatecontext genmanagercontext
  do
    thisLog=${logDir}/${arg}.log
    mvn org.appfuse:appfuse-maven-plugin:$arg > ${thisLog} 2>&1
    fgrep BUILD ${thisLog}
  done

  ###
  # copy files from generated-sources
  ###
  cd ${srcMainResources}

  applicationContextDaoXml=applicationContext-dao.xml
  cp template.${applicationContextDaoXml} ${applicationContextDaoXml}
  cat ${here}/target/generated-sources/com/warnerbros/dete/db/dao/hibernate/*.xml >> ${applicationContextDaoXml}
  echo "</beans>" >> ${applicationContextDaoXml}

  applicationContextServiceXml=applicationContext-service.xml
  cp template.${applicationContextServiceXml} ${applicationContextServiceXml}
  cat ${here}/target/generated-sources/com/warnerbros/dete/db/service/*.xml >> ${applicationContextServiceXml}
  echo "</beans>" >> ${applicationContextServiceXml}

  # copy generated hibernate.cfg.xml (without properties)
  cat ${here}/target/generated-sources/hibernate.cfg.xml | fgrep -v 'property name' > hibernate.cfg.xml

  # remove generated XML
  cd ${here}/target/generated-sources/com/warnerbros/dete/db ; fx | xargs rm -f
  find ${here}/target/generated-sources/com/warnerbros/dete/db -path '*.xml' | xargs rm -f
  cd ${here}
  find -path '*.jdbc.properties' | xargs rm -f

  ###
  # copy java files from generated-sources
  ###
  # ( cd src; ton $(fff) )
  cp -r ${here}/target/generated-sources/com/warnerbros/dete/db ${here}/src/main/java/com/warnerbros/dete/

  ###
  # build it
  ###
  fp | fgrep jdbc | xargs rm
  mvn compile
  banner "mvn install"
  echo "mvn install"

  #   ###
  #   # generate Test files using 2.0-chris-m4
  #   ###
  #   mvn org.appfuse:appfuse-maven-plugin:gendaotest
  #   mkdir -p ${tstPath}/dao
  #   # cp ${tgtPath}/dao/*DaoTest.java ${tstPath}/dao

else
  showManyToManyConflicts.sh
fi

set +x

# rmdir $logDir > /dev/null 2>&1
