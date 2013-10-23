#!/bin/bash
# $Id: howbig.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
#############################################################################

#############################################################################

for arg in \
  ADVERTISING_V2/ADVERTISING_V2@PORSCHE \
  ADVERTISING_V2/ADVERTISING_V2@FJB \
  FJB_V1/FJB_V1@FJB \
  FJB_V3/FJB_V3@FJB
do
  echo ""
  echo "### $arg"

  cat <<EOF | sqlplus $arg | fgrep _
  set sqlprompt ''
  set heading off
  select 'AD_CAMPAIGN            ', count(*) from AD_CAMPAIGN;
  select 'AD_CONDITION           ', count(*) from AD_CONDITION;
  select 'AD_CONDITION_ATTRIBUTE ', count(*) from AD_CONDITION_ATTRIBUTE;
  select 'AD_CONDITION_TYPE      ', count(*) from AD_CONDITION_TYPE;
  select 'AD_CONTENT             ', count(*) from AD_CONTENT;
  select 'AD_PLACEMENT           ', count(*) from AD_PLACEMENT;
  select 'MAIN_MAP               ', count(*) from MAIN_MAP;
  exit;
EOF
done
