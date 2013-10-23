#!/bin/bash
# $Id: expFJB_V1.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
#############################################################################
#
# You can let Export prompt you for parameters by entering the EXP
# command followed by your username/password:
#
#      Example: EXP SCOTT/TIGER
#
# Or, you can control how Export runs by entering the EXP command followed
# by various arguments. To specify parameters, you use keywords:
#
#      Format:  EXP KEYWORD=value or KEYWORD=(value1,value2,...,valueN)
#      Example: EXP SCOTT/TIGER GRANTS=Y TABLES=(EMP,DEPT,MGR)
#                or TABLES=(T1:P1,T1:P2), if T1 is partitioned table
#
# USERID must be the first parameter on the command line.
#
# BUFFER                  # size of data buffer
# COMPRESS                # import into one extent (Y)
# CONSISTENT              # cross-table consistency(N)
# CONSTRAINTS             # export constraints (Y)
# DIRECT                  # direct path (N)
# FEEDBACK                # display progress every x rows (0)
# FILE                    # output files (EXPDAT.DMP)
# FILESIZE                # maximum size of each dump file
# FLASHBACK_SCN           # SCN used to set session snapshot back to
# FLASHBACK_TIME          # time used to get the SCN closest to the specified time
# FULL                    # export entire file (N)
# GRANTS                  # export grants (Y)
# INCTYPE                 # incremental export type
# INDEXES                 # export indexes (Y)
# LOG                     # log file of screen output
# OBJECT_CONSISTENT       # transaction set to read only during object export (N)
# OWNER                   # list of owner usernames
# PARFILE                 # parameter filename
# QUERY                   # select clause used to export a subset of a table
# RECORD                  # track incr. export (Y)
# RECORDLENGTH            # length of IO record
# RESUMABLE               # suspend when a space related error is encountered(N)
# RESUMABLE_NAME          # text string used to identify resumable statement
# RESUMABLE_TIMEOUT       # wait time for RESUMABLE
# ROWS                    # export data rows (Y)
# STATISTICS              # analyze objects (ESTIMATE)
# TABLES                  # list of table names
# TABLESPACES             # list of tablespaces to export
# TEMPLATE                # template name which invokes iAS mode export
# TRANSPORT_TABLESPACE    # export transportable tablespace metadata (N)
# TRIGGERS                # export triggers (Y)
# TTS_FULL_CHECK          # perform full or partial dependency check for TTS
# USERID                  # username/password
#############################################################################

set -x

here=$(pwd)
bn=$(basename $0)
rn=$(echo $bn | sed -e 's/exp//' | sed -e 's/\..*//')
dmpDir="$(cygpath -w $here/)"

cd $ORACLE_HOME
pwd

EXP.EXE USERID="$rn/$rn" \
  COMPRESS=Y \
  FEEDBACK=10000 \
  FILE='"'${dmpDir}$rn.dmp'"' \
  LOG='"'${dmpDir}$rn.log'"'
set +x

# TABLES=(AD_CAMPAIGN,AD_CONDITION,AD_CONDITION_ATTRIBUTE,AD_CONDITION_TYPE,AD_CONTENT,AD_PLACEMENT,MAIN_MAP)

cd "$here"
ls -lat

# cd $here
