#!/bin/bash
set -v

mvnInstall="$(cygpath -au ${MAVEN_HOME}/bin/mvn) install:install-file -DgeneratePom=true -DcreateChecksum=true -Dpackaging=jar "
scmDir='C:\SCM\inf\releases\rel4.4_today_18-02-18\WEB-INF\lib'
wsDir='C:\local\IBM\WebSphere\AppServer\lib'
sybaseDir='C:\sybase\Shared\lib'
oracleDir='C:\oraclexe\app\oracle\product\10.2.0\server\jdbc\lib'

cd $(cygpath -au ${scmDir})
${mvnInstall}   -DgroupId=vendor     -DartifactId=axis        -Dversion=1.0beta    -Dfile=axis.jar
${mvnInstall}   -DgroupId=vendor     -DartifactId=origination -Dversion=1.0beta    -Dfile=origination.jar
${mvnInstall}   -DgroupId=vendor     -DartifactId=disney      -Dversion=2011.08.01 -Dfile=disney.jar
# ${mvnInstall} -DgroupId=sibc       -DartifactId=jms         -Dversion=1.0beta    -Dfile=sibc.jms.jar
# ${mvnInstall} -DgroupId=sibc       -DartifactId=jndi        -Dversion=1.0beta    -Dfile=sibc.jndi.jar
# ${mvnInstall} -DgroupId=sibc       -DartifactId=orb         -Dversion=1.0beta    -Dfile=sibc.orb.jar

cd $(cygpath -au ${wsDir})
${mvnInstall}   -DgroupId=com.ibm    -DartifactId=j2ee        -Dversion=6.1        -Dfile=j2ee.jar

cd ${sybaseDir}
cd $(cygpath -au ${sybaseDir})
${mvnInstall}   -DgroupId=com.sybase -DartifactId=jconn3      -Dversion=6.0        -Dfile=jconn3.jar

cd $(cygpath -au ${oracleDir})
${mvnInstall}   -DgroupId=ojdbc      -DartifactId=ojdbc       -Dversion=14         -Dfile=ojdbc14.jar
${mvnInstall}   -DgroupId=ojdbc      -DartifactId=ojdbc       -Dversion=5          -Dfile=ojdbc5.zip
${mvnInstall}   -DgroupId=ojdbc      -DartifactId=ojdbc       -Dversion=5_g        -Dfile=ojdbc5_g.zip
set +v
