#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/showManyToManyConflicts.sh,v $
id='$Id: showManyToManyConflicts.sh,v 1.2 2007/05/10 17:09:33 fboller Exp $'
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
here=$(pwd)

# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

sourceDir=src/main/java

cd ${sourceDir}
classes=($(fj))
maxCount=${#classes[@]}

for (( nOuter=0; nOuter<$maxCount; nOuter++ )) ; do
  printf "| $nOuter "
  fileOuter=${classes[$nOuter]}
  # echo "fileOuter: $fileOuter"
  typeOuter=$(basename ${fileOuter} .java)

  #echo "typeOuter: $typeOuter"
  #exit

  for (( nInner=$nOuter; nInner<$maxCount; nInner++ )) ; do
    printf "."
    fileInner=${classes[$nInner]}
    typeInner=$(basename ${fileInner} .java)

    listSetOuter=($(grep -l "public Set<${typeOuter}>.*ses" ${fileInner}))
    (( ${#listSetOuter} == 0 )) && continue

    listSetInner=($(grep -l "public Set<${typeInner}>.*ses" ${fileOuter}))
    (( ${#listSetInner} == 0 )) && continue

    printf "\n###%20s %s\n" $typeOuter $typeInner
    echo "${sourceDir}/${fileOuter}"
    grep "public Set<${typeInner}>.*ses" ${fileOuter}
    echo "${sourceDir}/${fileInner}"
    grep "public Set<${typeOuter}>.*ses" ${fileInner}

  done
done

cd ${here}

# rmdir $logDir > /dev/null 2>&1
