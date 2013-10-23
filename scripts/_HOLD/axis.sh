#!/bin/bash
id='$Id: axis.sh,v 1.4 2007/09/11 14:17:38 fboller Exp $'
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

XMLBEANS_LIB=i:/local/apache/xmlbeans-2.3.0/lib
export artifactId=xmlbean-dete
export bn=$(basename $0 .sh)
export destSrcDir="src/main/java"
export groupId=com.warnerbros.dete.db
export here="$(pwd)"
export logDir
export targetNamespace
export version="1.0.0"
export xsdconfig=$(cygpath -aml "config.xsdconfig")
test -z "${logDir}" && {
  logDir=$(cygpath -am ${HOME}/tmp/logDir/${bn}/$(now))
  mkdir -p $logDir
}
logFile="${logDir}/logFile.log"
#################################
export package=${groupId}.${version//./}.xmlbean.proto

typeset -i E_OPTERR=0

options="a:c:f:hl:t:v:x"
while getopts $options Option
do
  case $Option in
    a) artifactId="$OPTARG";;
    c) xsdconfig=$(cygpath -aml "$OPTARG");;
    f) xmlFiles="$OPTARG";;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    t) targetNamespace="$OPTARG";;
    v) version="$OPTARG";;
    x) set -x;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

test -z "${xmlFiles}" && {
  if [ $# = 0 ] ; then
    xmlFiles=( ~+/*.xml )
  else
    xmlFiles=( $* )
  fi
}

package=${groupId}.v${version//./}.xmlbean.proto
test -z "${targetNamespace}" && targetNamespace="http://${package//.//}"
passedOptions="${artifactId:+-a$artifactId} ${logFile:+-l$logFile} ${targetNamespace:+-l$targetNamespace} ${version:+-v$version} ${xsdconfig:+-c$xsdconfig}"

if [ $E_OPTERR != 0 ]
then
  cat <<EOF

  Usage $0 -[$options]
    a) artifactId="${d}OPTARG";;
    c) xsdconfig="${d}OPTARG";;
    f) xmlFiles="${d}OPTARG";;
    h) E_OPTERR=65; break;;
    l) logFile=${d}OPTARG;;
    t) targetNamespace="${d}OPTARG";;
    v) version="${d}OPTARG";;
    x) set -x;;

    $(printf "%15.15s = %-6s\n" artifactId      "$artifactId"      )
    $(printf "%15.15s = %-6s\n" groupId         "$groupId"         )
    $(printf "%15.15s = %-6s\n" here            "$here"            )
    $(printf "%15.15s = %-6s\n" logDir          "$logDir"          )
    $(printf "%15.15s = %-6s\n" logFile         "$logFile"         )
    $(printf "%15.15s = %-6s\n" package         "$package"         )
    $(printf "%15.15s = %-6s\n" passedOptions   "$passedOptions"   )
    $(printf "%15.15s = %-6s\n" targetNamespace "$targetNamespace" )
    $(printf "%15.15s = %-6s\n" version         "$version"         )
    $(printf "%15.15s = %-6s\n" xmlFiles        "${xmlFiles[*]}"   )
    $(printf "%15.15s = %-6s\n" xsdconfig       "$xsdconfig"       )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################
cp=( $(cygpath -aw $XMLBEANS_LIB/*.jar) )
oldIFS="$IFS"
IFS=";"
cp="${cp[*]}"
IFS="$oldIFS"
touch -f ${logFile}

orgApacheXmlbeansImpl=org.apache.xmlbeans.impl
toolDir=${orgApacheXmlbeansImpl}.tool

# aXmlBeanCmd=( dumpxsb inst2xsd scomp sdownload sfactor svalidate validate xpretty xsd2inst xsdtree xstc)

dumpxsb=${toolDir}.XsbDumper 
inst2xsd=${orgApacheXmlbeansImpl}.inst2xsd.Inst2Xsd 
scomp=${toolDir}.SchemaCompiler 
sdownload=${toolDir}.SchemaResourceManager 
sfactor=${toolDir}.FactorImports 
svalidate=${toolDir}.StreamInstanceValidator 
validate=${toolDir}.InstanceValidator 
xpretty=${toolDir}.PrettyPrinter 
xsd2inst=${orgApacheXmlbeansImpl}.xsd2inst.SchemaInstanceGenerator 
xsdtree=${toolDir}.TypeHierarchyPrinter 
xstc=${toolDir}.XSTCTester 

if [ "$bn" = "xcomp" ] ; then
  cp "${xmlFiles[@]}" "${xsdconfig:+$xsdconfig}" ${logDir}
  cd ${logDir}
  xmlFiles=( *.xml )
  
  inst2xsd ${passedOptions} ${xmlFiles[@]} | tee -a ${logFile} 2>&1
  scomp ${passedOptions} ${xmlFiles[@]} | tee -a ${logFile} 2>&1
  exit
fi

#############################################################################

if [ -f ${xsdconfig} ] ; then
  # use a config file if we have it
  if [ ! -f "${xsdconfig}" ] ; then
    banner -w200 '! -f '"${xsdconfig}"
    ll ${xsdconfig}
    xsdconfig=config.xsdconfig
  fi
  # use a TMP config file if this is not found again
  if [ ! -f "${xsdconfig}" ] ; then
    banner -w200 '! -f '"${xsdconfig}"
    ll ${xsdconfig}
    xsdconfig=${logDir}/config.xsdconfig

    if [ ! -f config.xsdconfig ] ; then
      banner -w200 '! -f config.xsdconfig'
      xsdconfig=${logDir}/config.xsdconfig
      ll ${xsdconfig}
      cat > ${xsdconfig} <<EOF
      <xb:config xmlns:xb="http://xml.apache.org/xmlbeans/2004/02/xbean/config"
      xmlns:ct="http://xmlbeans.apache.org/samples/catalog"
      xmlns:xs="http://www.w3.org/2001/XMLSchema" >

      <!--  
      <namespace/> element specifies configuration for namespace.
      Attribute uri contains namespace list. <package/> element specifies package name 
      to be used for types generated in this namespace.

      <xb:namespace uri="http://xmlbeans.apache.org/samples/catalog http://anotherurihere.org">
      -->  	
      <xb:namespace uri="${targetNamespace} http://detewiki.dete-devtest.warnerbros.com/DeteWiki/">
        <xb:package>${package}</xb:package>    	
      </xb:namespace> 

      <!-- ##any indicates all URIs. 
      A <prefix/> is used to prepend to top-level Java type names generated in this namespace. 
      A <suffix/> is used to append to top-level Java types names generated in this namespace.
      The <prefix/> and <suffix/> are not used for inner Java type definitions.
      -->

      <xb:namespace uri="##any">
      <xb:prefix>Xml</xb:prefix>
      <xb:suffix>Bean</xb:suffix>
      </xb:namespace>

      <!--<qname/> specifies a Java class name for a Qualified name
      <xb:qname name="ct:forsample" javaname="GoodName" /> 
      <xb:qname name="ct:a-very-long-description-element" javaname="XmlShortItemBean" /> 
      -->   

      </xb:config>
EOF
      xsdconfig="$(cygpath -am ${xsdconfig})"
    fi
  fi

fi
# echo "${d}xsdconfig={$xsdconfig}"

#############################################################################

if [ "$bn" = "scomp" ] ; then
  # scomp [options] [dirs]* [xsdFiles]* [wsdl]* [xsdconfig]*
  options="\
  -d d \
  -javasource 1.5 \
  -novdoc \
  -out "${artifactId}-${version}.jar" \
  -src ${destSrcDir} \
  "

  # -noupa -nopvr

  dirs=
  xsdFiles=( *.xsd )
  wsdl=

  set -x
  java -Xmx256m -cp "${cp}" ${scomp} ${options} ${dirs} ${xsdFiles[*]} ${wsdl} ${xsdconfig}

  mvn install:install-file \
    -DartifactId=${artifactId} \
    -DgeneratePom=true \
    -DgroupId=${groupId} \
    -Dpackaging=jar \
    -Dversion=${version} \
    -Dfile="${artifactId}-${version}.jar"

  ( cd ${destSrcDir}
    filename="../${artifactId}-${version}-sources.jar" 
    jar -cf ${filename} $(fj)

    mvn install:install-file \
      -DartifactId=${artifactId} \
      -Dclassifier=sources \
      -DgroupId=${groupId} \
      -Dpackaging=jar \
      -Dversion=${version} \
      -Dfile=${filename}
  )

  set +x
  
  ll *.jar
  find ${M2_REPO}/${groupId//./\/}/${artifactId} -type f | xargs ls -latd

else

  if [ "$bn" = "dumpxsb" ] ; then
    java -Xmx256m -cp "${cp}" ${dumpxsb} "${arg}"
  elif [ "$bn" = "inst2xsd" ] ; then
    for arg in ${xmlFiles[@]}; do
      bnXml=$(basename $arg .xml)
      # inst2xsd [options] instance.xml*
      # skip non-xml files
      if [ "${bnXml}" = "${arg}" ] ; then
        echo "${bnXml} is ${arg}"
        continue
      fi
      #  -outPrefix "schema"
      java -Xmx256m -cp "${cp}" ${inst2xsd} \
      -design rd \
      -simple-content-types string \
      -validate "${arg}"

      # -enumerations never \

      if [ ! -e  schema0.xsd ] ; then
        echo "*** ERROR*** schema0.xsd does not exist"
        continue
      else
        set -x
        target=$(fgrep targetNamespace schema0.xsd)
        if [ "${#target}" != "0" ] ; then
          echo "mv schema0.xsd ${bnXml}.xsd"
          mv schema0.xsd ${bnXml}.xsd
        else
          # baseDirName=$(basename $(pwd))
          # sed "s;xs:schema ;xs:schema targetNamespace=${q}${targetNamespace}/${baseDirName}${q} ;" schema0.xsd > ${bnXml}.xsd
#            -e 's;type="xs:string";type="xs:string" minOccurs="0";g' \
          sed \
            -e "s;xs:schema ;xs:schema targetNamespace=${q}${targetNamespace}/xml${q} ;" schema0.xsd \
            > ${bnXml}.xsd
          echo "${bnXml}.xsd"
          rm -f schema0.xsd
        fi
        set +x
        # $(( ${#target} > 0 )) && echo "target > 0 "$target" || echo "target <> 0 "$target"
      fi
    done
  elif [ "$bn" = "sdownload" ] ; then java -Xmx256m -cp "${cp}" ${sdownload} "$1"
  elif [ "$bn" = "sfactor" ] ; then java -Xmx256m -cp "${cp}" ${sfactor} "$1"
  elif [ "$bn" = "svalidate" ] ; then java -Xmx256m -cp "${cp}" ${svalidate} "$1"
  elif [ "$bn" = "validate" ] ; then java -Xmx256m -cp "${cp}" ${validate} "$1"
  elif [ "$bn" = "xpretty" ] ; then java -Xmx256m -cp "${cp}" ${xpretty} "$1"
  elif [ "$bn" = "xsd2inst" ] ; then java -Xmx256m -cp "${cp}" ${xsd2inst} "$1"
  elif [ "$bn" = "xsdtree" ] ; then java -Xmx256m -cp "${cp}" ${xsdtree} "$1"
  elif [ "$bn" = "xstc" ] ; then java -Xmx256m -cp "${cp}" ${xstc} "$1"
  fi
fi
# cd /c/ftp/apache.org
# mvn install:install-file -DgroupId=xmlbeans -DartifactId=xmlbeans-jsr173-api -Dversion=2.0-dev -Dpackaging=jar -DgeneratePom=true -Dfile=
