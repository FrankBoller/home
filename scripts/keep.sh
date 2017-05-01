#!/usr/bin/bash
# $Id: keep.sh,v 1.9 2006/11/14 17:41:30 fboller Exp $
#############################################################################

files2keep=$*
whereFilesWere=$(pwd)

mkdir -p ${HOME}/tmp;
cp $files2keep ${HOME}/tmp;
pushd ${HOME}/tmp

for arg in "${files2keep}"; do
  kount=$(cvs ls -q "$(cat CVS/Repository)/$arg" 2>/dev/null | wc -c) 
  (( kount > 0 )) && cvs --lf -q ci -m "work in progress" "$arg" ||
  {
    cvs add "$arg"
    cvs --lf -q ci -m "initial import" "$arg"
  }
  cp "$arg" $whereFilesWere
done

popd

ls -ladt $files2keep
