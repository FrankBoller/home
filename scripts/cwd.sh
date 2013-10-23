#!/bin/bash
# $Id: cwd.sh,v 1.5 2007/05/15 16:14:05 fboller Exp $
#############################################################################

thisWd=$(pwd)

# produce like:
# 
#   -u    .
# /i/local/sandbox/cloveDevE1/sharedcomponents/fjbHibernate
# /i/local/sandbox/CLOVED~1/SHARED~1/FJBHIB~1
# 
#   -m    .
# i:/local/sandbox/cloveDevE1/sharedcomponents/fjbHibernate
# i:/local/sandbox/CLOVED~1/SHARED~1/FJBHIB~1
# 
# -aws    i:\local\sandbox\CLOVED~1\SHARED~1\FJBHIB~1
# i:\\local\\sandbox\\CLOVED~1\\SHARED~1\\FJBHIB~1
# 
# -awl    i:\local\sandbox\cloveDevE1\sharedcomponents\fjbHibernate
# i:\\local\\sandbox\\cloveDevE1\\sharedcomponents\\fjbHibernate

export bs='\'
set +x

for arg in u m awl aws
do
  zh=$(cygpath -${arg} .)
  zs=$(cygpath -${arg} "$(cygpath -ams .)")
  zl=$(cygpath -${arg} "$(cygpath -aml .)")
  zd=${zs//${bs}${bs}/${bs}${bs}}
  test "${arg}" = "u" && zb=${zl// /${bs} } || zb=$zl

  printf "#\n"
  printf "# %4s %s\n" "$arg" "${zh[@]}"
  test "${zs[@]}" != "${zl[@]}" && printf "# %4s %s\n" "zs" "${zs[@]}";
  test "${zl[@]}" != "${zh[@]}" && printf "# %4s %s\n" "zl" "${zl[@]}";
  test "${zb[@]}" != "${zl[@]}" && printf "# %4s %s\n" "zb" "'${zb[@]}'";
  test "${zd[@]}" != "${zs[@]}" && printf "# %4s %s\n" "zd" "${zd[@]}";

  #  set | fgrep z
done
set +x

