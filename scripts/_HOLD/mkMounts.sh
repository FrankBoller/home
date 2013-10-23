#!/bin/bash
id='$Id: mkMounts.sh,v 1.28 2007/05/15 16:14:05 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
#
#############################################################################

EOF

# if [ -f ~/.aliases ] ; then
#     shopt -s expand_aliases
#     source ~/.aliases
# fi
#
# bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

# Usage: cygpath (-d|-m|-u|-w|-t TYPE) [-f FILE] [OPTION]... NAME...
#        cygpath [-c HANDLE]
#        cygpath [-ADHPSW]
# Convert Unix and Windows format paths, or output system path information
#
# Output type options:
#   -d, --dos             print DOS (short) form of NAMEs (C:\PROGRA~1\)
#   -m, --mixed           like --windows, but with regular slashes (C:/WINNT)
#   -M, --mode            report on mode of file (binmode or textmode)
#   -u, --unix            (default) print Unix form of NAMEs (/cygdrive/c/winnt)
#   -w, --windows         print Windows form of NAMEs (C:\WINNT)
#   -t, --type TYPE       print TYPE form: 'dos', 'mixed', 'unix', or 'windows'
# Path conversion options:
#   -a, --absolute        output absolute path
#   -l, --long-name       print Windows long form of NAMEs (with -w, -m only)
#   -p, --path            NAME is a PATH list (i.e., '/bin:/usr/bin')
#   -s, --short-name      print DOS (short) form of NAMEs (with -w, -m only)
# System information:
#   -A, --allusers        use `All Users' instead of current user for -D, -P
#   -D, --desktop         output `Desktop' directory and exit
#   -H, --homeroot        output `Profiles' directory (home root) and exit
#   -P, --smprograms      output Start Menu `Programs' directory and exit
#   -S, --sysdir          output system directory and exit
#   -W, --windir          output `Windows' directory and exit
# Try `cygpath --help' for more information.

# 'm,.s/.*/&=\$(cygpath -ams --&)         ;# --&/

# allusers=$(cygpath -ams --allusers)     ;# --allusers
desktop=$(cygpath -ams --desktop)       ;# --desktop
homeroot=$(cygpath -ams --homeroot)     ;# --homeroot
smprograms=$(cygpath -ams --smprograms) ;# --smprograms
sysdir=$(cygpath -ams --sysdir)         ;# --sysdir
windir=$(cygpath -ams --windir)         ;# --windir
adesktop=$(cygpath -amsA --desktop)       ;# --desktop
asmprograms=$(cygpath -amsA --smprograms) ;# --smprograms

adocs=$( cygpath -ams "${asmprograms}/../docs" )
allUsers="${adesktop}/.."
gotoDir=$( cygpath -ams "${asmprograms}/../goto" )
myDocuments=$(cygpath -ams "${desktop}/../My Documents" )
programFiles=$(cygpath -ams "${SYSTEMDRIVE}/Program Files" )
ie=$(cygpath -ams "${SYSTEMDRIVE}/Program Files/Internet Explorer" )
quickLaunch=$(cygpath -ams  "${desktop})/../Application Data/Microsoft/Internet Explorer/Quick Launch" )
userProfile=$(cygpath -ams "${desktop})/.." )

uncDir='/.unc'

# # sysdir=$(cygpath -ams -S)                                 ;#  -S, --sysdir          output system directory and exit
# allDocs=$( cygpath -ams "$(cygpath -A -a -P)"/../docs )
# allUsers=$( cygpath -ams "$(cygpath -A -a -D)"/.. )
# desktop=$(cygpath -ams -D)                                  ;#  -D, --desktop         output `Desktop' directory and exit
# gotoDir=$( cygpath -ams "$(cygpath -A -a -P)"/../goto )
# homeroot=$(cygpath -ams -H)                                 ;#  -H, --homeroot        output `Profiles' directory (home root) and exit
# myDocuments=$( cygpath -ams "${desktop}/../My Documents" )
# quickLaunch=$(cygpath -ams "$(cygpath -a -D)/../Application Data/Microsoft/Internet Explorer/Quick Launch" )
# smprograms=$(cygpath -ams -AP)                               ;#  -P, --smprograms      output Start Menu `Programs' directory and exit
# userProfile=$( cygpath -ams "$(cygpath -a -D)"/.. )
# windir=$(cygpath -ams -W)                                   ;#  -W, --windir          output `Windows' directory and exit

#############################################################################


shortcutDir="${gotoDir}/.shortcuts"

#  startMenu \
#  desktop \
#  msoffice \

linkList=( \
  adesktop \
  adocs \
  allUsers \
  asmprograms \
  desktop \
  gotoDir \
  homeroot \
  ie \
  myDocuments \
  programFiles \
  quickLaunch \
  smprograms \
  sysdir \
  userProfile \
  windir \
)

uncList=( \
#   fboller_c \
#   fboller_d \
#   mgajjar_c \
#   mgajjar_soatest \
#   san24868c_zkazmi \
)

# umount -U
# mount -c /

rm -rf ${uncDir}
rm -rf ${shortcutDir}
rm -f /.???*
mkdir -p "${uncDir}"
mkdir -p "${shortcutDir}"

for arg in ${linkList[@]}; do
  linkName=/.$arg

  rm -f $linkName
  echo "ln -s ${!arg} $linkName"
  ln -s "${!arg}" $linkName
done

for arg in ${uncList[@]}; do
  linkName="${uncDir}/$arg"

  rm -f $linkName
  echo "ln -s ${!arg} $linkName"
  ln -s "${!arg}" $linkName
done

rm -rf "${shortcutDir}"
mkdir -p "${shortcutDir}"
cd "${shortcutDir}"

for arg in ${uncList[@]}; do
  echo "mkshortcut -n $arg ${!arg}"
  mkshortcut -n $arg "${!arg}"
done

# rmdir $logDir > /dev/null 2>&1
