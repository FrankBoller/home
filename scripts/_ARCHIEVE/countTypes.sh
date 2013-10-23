#!/bin/bash
# $Id: countTypes.sh,v 1.13 2005/11/10 19:50:10 fboller Exp $
#############################################################################

bn=$(basename $0 .sh)
bnDir=.$bn

if [ -d $bnDir ] ; then
  cat <<EOF

  #############################################################################
  # $bnDir exists already!
  #
  # remove and try running script again
  #############################################################################

EOF

  exit
fi

d='$'
sq="'"

#############################################################################

extPartLst=$bnDir/extPartLst.lst
fileLst=$bnDir/file.lst
fileNoExtLst=$bnDir/fileNoExt.lst
fileTextLst=$bnDir/fileText.lst
fileTypeLst=$bnDir/fileType.lst
fileWithExtLst=$bnDir/fileWithExt.lst
listDir=$bnDir/.lists
pairCountExtLst=$bnDir/pairCountExt.lst
reportTxt=$bnDir/report.txt
sortedPairLst=$bnDir/sortedExtCount.lst
typeExtLst=$bnDir/typeExt.lst
typeFileLst=$bnDir/typeFile.lst
wcExt=$bnDir/wcExt.lst

extSum=0
noExtSum=0

rm -rf $listDir;mkdir -p $listDir

cat <<EOF | tee $reportTxt

#############################################################################
# $Id: countTypes.sh,v 1.13 2005/11/10 19:50:10 fboller Exp $
# $(date)
#
# find * -type f > $fileLst
#
EOF

find * -type f | sort -u > $fileLst
wcFiles=$(cat $fileLst | wc -l)

# remove any leading DIRNAME
# keep only the extension
# sort unique
sed 's;.*/;;' $fileLst | sed 's;.*\.;.;' | sort -u > $extPartLst

fgrep . $extPartLst > $typeExtLst

wcETypes=$(cat $typeExtLst | wc -l)

cat <<EOF | tee -a $reportTxt
# number of extension types = $wcETypes
# number of files           = $wcFiles
#
#############################################################################

EOF

for typeExt in $(cat $typeExtLst )
do
  extLst=$listDir/$typeExt.lst

  # if $typeExt starts with a '.'
  if [ ${typeExt:0:1}='.' ] ; then
    # build list of files with given extension
    grep "[.]${typeExt:1}$d" $fileLst > $extLst
  else
    # expand list with files which ARE the extension
    grep "^$typeExt$d" $fileLst > $extLst
  fi

  # count number of entries in list
  wcExt=$(cat $extLst | wc -l)
  extSum=$((extSum=$extSum+wcExt))


  # append to list
  echo -n $(printf "%5d %s\n" $wcExt $typeExt | tee -a $pairCountExtLst) ,
done

noExtSum=$(($wcFiles - $extSum))

echo -n $(printf "%5d %s\n" $extSum "(HaveExtension)" | tee -a $pairCountExtLst) ,
echo -n $(printf "%5d %s\n" $noExtSum "(NoExtension)" | tee -a $pairCountExtLst) ,

echo
sort -n -r $pairCountExtLst > $sortedPairLst
pr --columns=3 --expand-tabs -T -t -w100 $sortedPairLst | expand >> $reportTxt

#############################################################################

sort -u ${listDir}/.*lst > ${fileWithExtLst}
comm -23 ${fileLst} ${fileWithExtLst} > ${fileNoExtLst}

wc -l ${fileNoExtLst} ${fileWithExtLst} ${fileLst}

# create complete file list (with types)
time file -f ${fileLst} > ${fileTypeLst}

# create unique type (of file) list
sed 's/.*:[[:space:]]*//' ${fileTypeLst} | sort -u > ${typeFileLst}

grep -i ':.*text' ${fileTypeLst} | sed 's/:.*//' | sort -u > ${fileTextLst}

#############################################################################

if [ "$noExtSum" <> "$wcFiles" ] ; then
  cat <<EOF | tee -a $reportTxt

#############################################################################
Percent of files with (NoExtension): $( echo "2k $noExtSum 100* $wcFiles /f" | dc )%
Percent of files with (text type): $( echo "2k $(wc -l < ${fileTextLst}) 100* $wcFiles /f" | dc )%

EOF
fi

cat $reportTxt
