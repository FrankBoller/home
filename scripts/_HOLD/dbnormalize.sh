#!/bin/bash
id='$Id: dbnormalize.sh,v 1.11 2007/09/28 19:47:56 fboller Exp $'
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
dn=$(dirname $0)
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0
typeset -i I_COUNT
typeset -i I_GROUP
typeset -i I_OFFSET
typeset -i I_VALUE
export capvalue=yes

options="cf:hnl:x"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    n) unset capvalue; break;;
    f) fileXml=$OPTARG;;
    l) logFile=$OPTARG;;
    x) set -x;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

test -f "${fileXml}" || fileXml=$1
test -f "${fileXml}" || E_OPTERR=65

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h displays (this) Usage
    f) fileXml=${d}OPTARG;;
    l) logFile=${d}OPTARG;;
    n) unset capvalue; break;;
    x) set -x;;
    
    $(printf "%11.11s = %-6s\n" capvalue    "$capvalue"    )
    $(printf "%11.11s = %-6s\n" logFile     "$logFile"     )
    $(printf "%11.11s = %-6s\n" fileXml     "$fileXml"     )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

colsXml=${logDir}/cols.xml
destXml=${logDir}/destXml.xml
fmtXml=${logDir}/fmt.xml
groupCsv=${logDir}/group.csv
groupSed=${logDir}/group.sed
joinsXml=${logDir}/joins.xml
partsXml=${logDir}/parts.xml
pkList=${logDir}/pk.lst
pkSed=${logDir}/single.sed
sortedXml=${logDir}/sorted.xml

cat > ${groupCsv} <<EOF
GROUP,ORDER,TABLE,fk1,fk2,fk3,fk4,ALPHA,#ref
1,01,DLMC_MECHANISMS,0,,,,4,3
1,02,DLRG_REGIONS,0,,,,8,1
1,03,FTPR_PRIORITIES,0,,,,33,1
1,04,FTST_STATUSES,0,,,,34,2
1,05,NTTP_TYPES,0,,,,38,3
1,06,NTEM_EMAILS,nttp,,,,36,0
2,07,DLND_NODES,0,,,,7,2
2,08,EIES_EXT_SYSTEMS,0,,,,14,16
2,09,EISR_SERVICETYPES,eies,,,,26,4
2,10,RFCF_CONTENT_FORMATS,0,,,,39,1
2,11,RFTP_TRANSCODE_PROFILES,0,,,,41,1
2,12,RFOF_OUTPUT_FORMATS,rfcf,rftp,,,40,2
2,13,RFWR_WORKFLOWS,0,,,,43,1
2,14,UGCN_CONTACTS,0,,,,48,3
2,15,UGUS_USERS,ugcn,,,,50,3
2,16,EIBS_BILLING_SPLIT_MAPS,eies(2),,,,12,0
2,17,EIDL_DISTRIBUTION_LISTS,eies,,,,13,0
2,18,EIEU_EXTSYSTEM_USERS,eies,ugus,,,15,0
2,19,EIFS_FORMAT_SHEETS,eies,,,,16,4
2,20,EIFT_FROM_TO_MAPS,eies(2),eifs(2),eisr(2),,17,0
2,21,EIJM_JOB_MAPS,eies,,,,18,0
2,22,EIOS_OUTPUT_SVS_FMT_MAPS,eifs,eisr,rfof,,22,0
2,23,EITF_TYPE_FORMAT_MAPS,eifs,eisr,,,29,0
2,24,EIVV_VENDOR_VALIDATIONS,eies,,,,31,0
2,25,RFWO_WF_OF_MAPS,rfof,rfwr,,,42,0
2,26,SYVR_VERSIONS,0,,,,46,0
3,27,DLMM_MEMBERS,dlrg,,,,5,2
3,28,DLRP_RCV_PROFILES,dlmc,dlmm,dlnd,,10,2
3,29,DLSP_SND_PROFILES,dlmc,dlmm,dlnd,,11,2
3,30,EITE_TITLE_EXT_MAPS,eies,,,,28,0
3,31,UGCN_NTTP_JOINS,ugcn,nttp,,,49,0
3,32,DLMM_UGCN_JOINS,dlmm,ugcn,,,6,0
3,33,DLRP_DLSP_JOINS,dlrp,dlsp,,,9,0
4,34,EIOR_ORDERS,eies,,,,21,2
4,35,EIOH_ORDERPROP_HISTS,eior,,,,20,1
4,36,BAAR_ARCHIVES,0,,,,1,0
4,37,BACA_CPO_ARCHIVES,0,,,,2,0
4,38,BADJ_DMP_JOBS,0,,,,3,0
4,39,EIOD_ORDERPROP_DETAILS,eioh,,,,19,0
4,40,EIOT_ORDERDTL_TASK_MAPS,eies,,,,23,1
4,41,EIPB_PHYSICAL_BARCODES,eies,,,,24,0
4,42,EISD_SHIPPING_DETAILS,eies,,,,25,1
4,43,EITS_TASKS,eior,eiot,eisd,,30,0
4,44,EIST_SERV_TASK_DETAILS,eies,,,,27,0
4,45,FTBT_BATCHES,dlrp,dlsp,ftst,ugus,32,1
4,46,FTTR_TRANSFERS,ftbt,ftpr,ftst,,35,0
4,47,NTRL_RECIPIENT_LOGS,nttp,,,,37,0
4,48,SYLG_LOGS,0,,,,44,0
4,49,SYTS_TEST,0,,,,45,0
4,50,UGCI_CART_ITEMS,ugus,,,,47,0
EOF

cat > ${pkSed} <<EOF
s/\w*="[^"]*"/\n&\n/g
EOF

#  | sort '-t"' -n +1 \
sed -f ${pkSed} ${fileXml} \
  | grep "^\w*_ID_PK" \
  | sort -n '-t=' +1.1 \
  > ${pkList}

cat <<EOF

#############################################################################
#  process ${d}{groupCsv} ${groupCsv}
#############################################################################

EOF

OLDIFS=${IFS}
IFS=","
while read csv; do
  printf "."
  set ${csv/,0/,}
  I_GROUP=$1
  test ${I_GROUP} -lt 1 && continue
  I_OFFSET=$(( ( ( ${I_GROUP} * 100 ) + $2 ) * 1000 ))
  eval "typeset -i $3=${I_OFFSET}"
done < ${groupCsv}

#set | grep '^[A-Z][A-Z][A-Z][A-Z]_.*=......$'

touch ${groupSed}

cat <<EOF

#############################################################################
#  process ${d}{pkList} ${pkList}
#############################################################################

EOF

I_COUNT=0
IFS='="'
while read pk; do
  (( I_COUNT++ ))
  printf "."
  set $pk
  I_VALUE=$3
  test -n "${capvalue}" && (( ${I_VALUE} > 1000000 )) && printf "\n%s\n" "break > 1m @ $I_COUNT" && break ;# do not process values over 1m
  name="${1/_ID_PK}"
  # prefix="$(echo $name | sed 's/\(....\).*/\1/g')"
  prefix="$(echo $name | cut -c1-4)"
  value=$3
  (( ++$name ))
  echo "s/\(${prefix}[A-Z_]*_ID\)\(_[FP]K\)*=${q}${value}${q}/\1\2=${q}x$(( name ))${q}/g" >> ${groupSed}
done < ${pkList}
IFS=${OLDIFS}

echo "s;[^[:space:]]*_XML=.*/;/;g" >> ${groupSed}

cat <<EOF

#############################################################################
#  process ${d}{destXml} ${destXml}
#############################################################################

EOF
sed -f ${groupSed} ${fileXml} \
  | sed 's/="x/="/g' \
  > ${destXml}

cat <<EOF

#############################################################################
#  process ${d}{sortedXml} ${sortedXml}
#############################################################################

EOF

cat ${destXml} \
  | dos2unix \
  | sed 's/\([&]\)apos;/\1amp;apos;/g' \
  | xmllint.exe --noblanks --format - \
  > ${fmtXml}

grep '^[[:space:]][[:space:]]*' ${fmtXml} | fgrep -v _JOINS | sort -n '-t=' +1.1 > ${colsXml}
grep '^[[:space:]][[:space:]]*' ${fmtXml} | fgrep _JOINS | sort -n '-t=' +1.1 > ${joinsXml}

#  | sort "-t${q}" -n +1.0 \
cat > ${sortedXml} <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<ns:dataset xmlns:ns="http://com/warnerbros/dete/db/v133/xmlbean/proto/xml">
$(cat ${colsXml})
$(cat ${joinsXml})
</ns:dataset>
EOF

( set -x
mv ${fileXml} ${fileXml}.$(now)
cp ${sortedXml} ${fileXml}
)

set +x
