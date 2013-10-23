#!/bin/bash
set -v
id='$Id: mkShortcut.sh,v 1.10 2007/05/15 16:14:05 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

j5home=$(cygpath -u "$J5_HOME")
j5bn=$(basename ${j5home})

# if [ -f ~/.aliases ] ; then
#     shopt -s expand_aliases
#     source ~/.aliases
# fi
# 
# bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

docsDir=/.allDocs
mkdir -p ${docsDir}

for arg in apache jakarta oss sourceforge wiki; do 
  mkdir -p "${docsDir}/$arg"
done

# mkshortcut -n $arg "${!arg}"

#############################################################################
cd "${docsDir}"
rm -f \
  ebooks \
  ${j5bn}

mkshortcut -n ebooks                        "\\10.140.204.21\\eBooks\\ebooks.html"
mkshortcut -n ${j5bn}                       ${j5home}/docs/api/index.html 

#############################################################################
cd "${docsDir}/apache"
rm -f apacheApacheAnt1.6.5 apacheLog4j1.2.13 apacheLog4jApi1.2.13 apacheTomcat5.5.17

mkshortcut -n apacheApacheAnt1.6.5          /d/java/apache/apache-ant-1.6.5/docs/manual/api/index.html 
mkshortcut -n apacheLog4j1.2.13             /d/java/apache/logging-log4j-1.2.13/docs/index.html
mkshortcut -n apacheLog4jApi1.2.13          /d/java/apache/logging-log4j-1.2.13/docs/api/index.html
mkshortcut -n apacheTomcat5.5.17            /d/java/apache/apache-tomcat-5.5.17/webapps/tomcat-docs/catalina/docs/api/index.html 

#############################################################################
cd "${docsDir}/jakarta"
rm -f  \
  jakartaCommonsBeanutils1.7.0 \
  jakartaCommonsCollections3.1 \
  jakartaCommonsDigester1.7 \
  jakartaCommonsHttpclient3.0 \
  jakartaCommonsLang2.1 \
  jakartaCommonsLogging1.0.4 \
  jakartaEcs1.4.2

mkshortcut -n jakartaCommonsBeanutils1.7.0  /d/java/jakarta/commons-beanutils-1.7.0/docs/api/index.html 
mkshortcut -n jakartaCommonsCollections3.1  /d/java/jakarta/commons-collections-3.1/docs/apidocs/index.html 
mkshortcut -n jakartaCommonsDigester1.7     /d/java/jakarta/commons-digester-1.7/docs/apidocs/index.html 
mkshortcut -n jakartaCommonsHttpclient3.0   /d/java/jakarta/commons-httpclient-3.0/docs/apidocs/index.html 
mkshortcut -n jakartaCommonsLang2.1         /d/java/jakarta/commons-lang-2.1/docs/api/index.html 
mkshortcut -n jakartaCommonsLogging1.0.4    /d/java/jakarta/commons-logging-1.0.4/docs/apidocs/index.html 
mkshortcut -n jakartaEcs1.4.2               /d/java/jakarta/ecs-1.4.2/docs/apidocs/index.html 
#############################################################################

# 
# pageList=( \
#     AdapterTemplateSetup \
#     CheckoutAndDeployCSPCore \
#     CheckoutAndDeployMavenizedCSPCore \
#     InitialCSPDevSetup \
#     MAJInstall \
#     MavenJamDirStruct \
# )
# 
# cd "${docsDir}/wiki"
# 
# for arg in ${pageList[@]}; do
#   rm -f $arg
#   mkshortcut -n ${arg} "http://casancspbuild:8080/csp-wiki/Wiki.jsp?page="$arg
# done
# mkshortcut -n wikiMain                      "http://casancspbuild:8080/csp-wiki/"
# 
# rm -f wikiMain
# cd "${docsDir}"
#
# mkshortcut -n CruiseControl                 "http://casancspbuild:22000/mbean?objectname=CruiseControl+Project%3Aname%3DNextGenAPI"
# mkshortcut -n nextgenapi                    "http://casancspbuild/nextgenapi"
# mkshortcut -n soaTest                       "file:///${SYSTEMDRIVE}/Program%20Files/Parasoft/SOA%20Test/4.1/docs/index.htm"
# rmdir $logDir > /dev/null 2>&1
set +v
