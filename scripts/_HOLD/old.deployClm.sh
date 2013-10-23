#!/bin/bash
# $Source: $
id='$Id: deployClm.sh $'
cat <<EOF
#
#############################################################################
# ${id}
#
#############################################################################
#
EOF

if [ -f ~/.aliases ] ; then
  shopt -s expand_aliases
  source ~/.aliases
fi

bn=$(basename $0 .sh)
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir

releaseDir=/c/SCM/inf/releases/rel4.4_today_18-02-18
scpm=${logDir}/SCPM

# ?? reportlogo=${releaseDir}/privateLabels/selectica/pix/reportlogo
tomcatJsp=${releaseDir}/inc
tomcatLib=${releaseDir}/WEB-INF/lib
privateLabelsDcp=${releaseDir}/privateLabels/dcp

scm=/c/SCM/clients/workspace/appSupport/metadatadefsupport/templates/1100/t_1234567890123
selectica=/c/local/workingCvs/CLM_Development/selectica
zipfile=SCPM.$(now).zip

scpm_app=${scpm}/clients/selectica/appSupport
scpm_jsp_inc=${scpm}/inf/releases/current/inc
scpm_lib=${scpm}/inf/releases/current/WEB-INF/lib
scpm_privateLabelsDcp=${scpm}/privateLabels/dcp
# ?? scpm_reportlogo=${scpm}/inf/releases/current/privateLabels/selectica/pix/reportlogo/

scpm_oob=${scpm_app}/metadatadefsupport/templates
scpm_reports=${scpm_app}/reportsupport/1100/templates
# ?? scpm_rules=${scpm_app}/rulesupport/1100/templates
scpm_xml=${scpm_app}/metadatadefsupport/templates/1100/t_1234567890123

mkdir -p ${scpm_app}
mkdir -p ${scpm_jsp_inc}
mkdir -p ${scpm_lib}
mkdir -p ${scpm_oob}
mkdir -p ${scpm_privateLabelsDcp}
mkdir -p ${scpm_reports}
# ?? mkdir -p ${scpm_rules}
mkdir -p ${scpm_xml}

# find ${selectica}/xml/approval-xml -type f \
#  | xargs fgrep -l 'status="Active"' | xargs -i, cp ,                ${scpm_xml}

cp ${selectica}/xml/all-others-xml/*.xml                             ${scpm_xml}
find ${selectica}/xml/approval-xml -type f \
  | xargs fgrep -l ' keep ' | xargs -i, cp ,                         ${scpm_xml}
cp ${selectica}/xml/OOB-selectica-templates/SharedDataDefinition.xml ${scpm_oob}
cp ${selectica}/xml/reports-xml/public-reports/*.xml                 ${scpm_reports}
# ?? cp ${selectica}/xml/rules-xml/public-rules/*.xml                     ${scpm_rules}
cp $tomcatLib/{tcClm-*.jar,commonClmint-*.jar,disney.jar}            ${scpm_lib}
cp $tomcatJsp/{register_account_contact.jsp,poc_form.jsp}            ${scpm_jsp_inc}
# ?? cp $reportlogo/*                                                     ${scpm_reportlogo}
cp -r ${privateLabelsDcp} ${scpm_privateLabelsDcp}

cd ${logDir}
jar -Mcf ${zipfile} SCPM/
jar -tf ${zipfile}

ls -ladt ${logDir}/${zipfile}
# scp ${logDir}/${zipfile} ${userd}:/tmp
# # cp ${logDir}/${zipfile} /c
# scp ${logDir}/${zipfile} ${userp}:/tmp
