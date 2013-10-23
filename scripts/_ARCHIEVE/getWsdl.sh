#!/bin/bash
id='$Id: getWsdl.sh,v 1.9 2006/04/22 19:10:59 fboller Exp $'
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
# logFile="${logDir}/logFile.log"
#################################

someHtml=${logDir}/some.html

aWsdl=( \
  AdminService \
  SOAPMonitorService \
  Version \
  accountactivationgateway \
  accountattributegateway \
  accountsearchgateway \
  accountservicehistorygateway \
  accountstatusgateway \
  accountstructuregateway \
  creditcheckgateway \
  legacyhistorygateway \
  memogateway \
  paymentgateway \
  posgateway \
  productcataloggateway \
  prorationsgateway \
  searchgateway \
  securitygateway \
  serviceactivationgateway \
  serviceattributegateway \
  servicestatusgateway \
  switchgateway \
  usergateway \
)

cat > $someHtml <<EOF
<html>
  <head><title>$Id: getWsdl.sh,v 1.9 2006/04/22 19:10:59 fboller Exp $</title></head>
  <body>
  <h1>$Id: getWsdl.sh,v 1.9 2006/04/22 19:10:59 fboller Exp $</h1>
EOF

for wsdl in ${aWsdl[@]} ; do
  cat >> $someHtml <<EOF
    <a href="http://172.29.246.4:9001/xmlgateway/services/${wsdl}?wsdl">$wsdl</a><br/>
EOF
done

cat >> $someHtml <<EOF
  </body>
</html>
EOF

echo $someHtml
rmdir $logDir > /dev/null 2>&1
