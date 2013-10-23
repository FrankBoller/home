#!/bin/bash
id='$Id: cmpDirs.sh,v 1.8 2006/10/02 14:26:51 fboller Exp $'
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
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

srcDir=$1;
destDir=$2;

if [ -z "$srcDir" ] ; then srcDir=$src;
elif [ "$srcDir" = "." ] ; then srcDir=$PWD;
elif [ -f "$srcDir" ] ; then srcDir=$(dirname $srcDir);
fi;

if [ -z "$destDir" ] ; then destDir=$dest;
elif [ "$destDir" = "." ] ; then destDir=$PWD;
elif [ -f "$destDir" ] ; then destDir=$(dirname $destDir);
fi;

if [ -z "$srcDir" ] ; then srcDir=$PWD;
elif [ -z "$destDir" ] ; then destDir=$PWD;
fi;

if [ "$srcDir" = "$destDir" ]; then
    if [ "$destDir" != "$PWD"     ] ; then destDir=$PWD;
  elif [ "$srcDir"  != "$PWD"     ] ; then srcDir=$PWD;
  elif [ "$destDir"  != "$OLDPWD" ] ; then destDir=$OLDPWD;
  else                                     srcDir=$OLDPWD;
  fi
fi

cat <<EOF

#############################################################################
# $Id: cmpDirs.sh,v 1.8 2006/10/02 14:26:51 fboller Exp $
# usage: $bn ${d}src ${d}dest
#############################################################################
# env ${d}src:($src)
# env ${d}dest:($dest)
#
# srcDir:($srcDir)
# destDir:($destDir)
#############################################################################

EOF

if [ ! -d "$srcDir" ] || [ ! -d "$destDir" ] || [ "$srcDir" = "$destDir" ]; then echo "*** ERROR ***"; exit -1; fi;

here=$PWD
destFiles=${logDir}/destFiles.txt
destList=${logDir}/destList.txt
srcFiles=${logDir}/srcFiles.txt
srcList=${logDir}/srcList.txt
tmpFiles=${logDir}/tmpFiles.txt
tmpList=${logDir}/tmpList.txt

cd $srcDir;
echo "$srcDir/nul" > $srcFiles;
find * -maxdepth 0 -type f >> $srcFiles;

cd $destDir;
echo "$destDir/nul" > $destFiles;
find * -maxdepth 0 -type f >> $destFiles;

sort -u $srcFiles $destFiles > $tmpFiles;
cd $here

if [ "$bn" = "sdDirs"   ] ; then 
  for arg in $(cat $tmpFiles)
  do
    if [ ! -f  "$srcDir/$arg"  ] ; then echo "src missing File $srcDir/$arg" | less; continue; fi;
    if [ ! -f  "$destDir/$arg" ] ; then echo "    no dest File $destDir/$arg" | less; continue; fi;

    cmp -s "$srcDir/$arg" "$destDir/$arg" && echo -n . || (

    sdiff -l                \
      --width=150           \
      --speed-large-files   \
      --ignore-blank-lines  \
      --minimal             \
      --ignore-space-change \
      --expand-tabs         \
      --strip-trailing-cr   \
      $srcDir/$arg $destDir/$arg > $tmpList

    cat <<EOF

#############################################################################
# file: $arg
# srcDir: $srcDir
# destDir: $destDir
#############################################################################

EOF
    less -P "$tmpList" $tmpList
    
    if [ ! -f "$tmpList" ] ; then break; fi;
    )

  done
  echo ""

else
  cd $srcDir; wc --bytes $(cat $srcFiles) \
  | gawk ' { print $2, $1; }' \
  | xargs printf "%-30.30s %s\n" \
  | sort > $srcList;

  cd $destDir; wc --bytes $(cat $destFiles) \
  | gawk ' { print $2, $1; }' \
  | xargs printf "%-30.30s %s\n" \
  | sort > $destList;

  cd $here

  comm -3 $srcList $destList | less
  # comm -3 $srcList $destList | sed 's/^/./' | xargs printf "%40.40s %s \n" | less

    cat <<EOF

#############################################################################
# not in srcDir: $srcDir
#############################################################################

EOF
  comm -13 $srcList $destList

    cat <<EOF

#############################################################################
# not in destDir: $destDir
#############################################################################

EOF
  comm -23 $srcList $destList
fi
rm -rf ${logDir}

rmdir $logDir > /dev/null 2>&1
