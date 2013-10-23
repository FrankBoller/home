#!/bin/bash
# $Id: impFJB_V3.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
#############################################################################

# To specify parameters, you use keywords:
# 
#      Format:  IMP KEYWORD=value or KEYWORD=(value1,value2,...,valueN)
#      Example: IMP SCOTT/TIGER IGNORE=Y TABLES=(EMP,DEPT) FULL=N
#                or TABLES=(T1:P1,T1:P2), if T1 is partitioned table
# 
# USERID must be the first parameter on the command line.
# 
# BUFFER                 # size of data buffer         
# COMMIT                 # commit array insert (N)
# COMPILE                # compile procedures, packages, and functions (Y)
# CONSTRAINTS            # import constraints (Y)
# DESTROY                # overwrite tablespace data file (N)
# FEEDBACK               # display progress every x rows(0)
# FILE                   # input files (EXPDAT.DMP)    
# FILESIZE               # maximum size of each dump file
# FROMUSER               # list of owner usernames
# FULL                   # import entire file (N)
# GRANTS                 # import grants (Y)           
# IGNORE                 # ignore create errors (N)    
# INCTYPE                # incremental import type
# INDEXES                # import indexes (Y)          
# INDEXFILE              # write table/index info to specified file
# LOG                    # log file of screen output   
# PARFILE                # parameter filename
# RECORDLENGTH           # length of IO record
# RESUMABLE              # suspend when a space related error is encountered(N)
# RESUMABLE_NAME         # text string used to identify resumable statement
# RESUMABLE_TIMEOUT      # wait time for RESUMABLE 
# ROWS                   # import data rows (Y)        
# SHOW                   # just list file contents (N) 
# SKIP_UNUSABLE_INDEXES  # skip maintenance of unusable indexes (N)
# STATISTICS             # import precomputed statistics (always)
# STREAMS_CONFIGURATION  # import streams general metadata (Y)
# STREAMS_INSTANITATION  # import streams instantiation metadata (N)
# TABLES                 # list of table names
# TOID_NOVALIDATE        # skip validation of specified type ids 
# TOUSER                 # list of usernames
# USERID                 # username/password           
# 
# The following keywords only apply to transportable tablespaces
# TRANSPORT_TABLESPACE import transportable tablespace metadata (N)
# TABLESPACES tablespaces to be transported into database
# DATAFILES datafiles to be transported into database
# TTS_OWNERS users that own data in the transportable tablespace set
#

set -x

here=$(pwd)
bn=$(basename $0)
rn=$(echo $bn | sed -e 's/imp//' | sed -e 's/\..*//')
dmpDir="$(cygpath -w $here/)"
FROMUSER=FJB_V1

cd $ORACLE_HOME
pwd

IMP.EXE USERID="$rn/$rn" \
  DESTROY=Y \
  FEEDBACK=10000 \
  FILE='"'${dmpDir}$FROMUSER.dmp'"' \
  FROMUSER=$FROMUSER \
  TOUSER=$rn \
  LOG='"'${dmpDir}$rn.log'"'
set +x

# TABLES=(AD_CAMPAIGN,AD_CONDITION,AD_CONDITION_ATTRIBUTE,AD_CONDITION_TYPE,AD_CONTENT,AD_PLACEMENT,MAIN_MAP)

cd "$here"
ls -lat

# cd $here
