#!/bin/bash
id='$Id: sq.sh,v 1.6 2007/09/04 16:22:56 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

#'m,.s/.*/printf '{%s}: {%s}\n' '&' "$&"/
# @
# #
# ?
# -
# $
# !
# 0
# _#indirect=abc
#yFile="yyy"
#xFile=
#printf '%25s : {%s}\n' '$@'                     "$@"
#printf '%25s : {%s}\n' '$#'                     "$#"
#printf '%25s : {%s}\n' '$?'                     "$?"
#printf '%25s : {%s}\n' '$-'                     "$-"
#printf '%25s : {%s}\n' '$$'                     "$$"
#printf '%25s : {%s}\n' '$!'                     "$!"
#printf '%25s : {%s}\n' '$0'                     "$0"
#printf '%25s : {%s}\n' '$_'                     "$_"
#
#printf '%25s : {%s}\n' '${!M*}'                 "${!M*}"
#printf '%25s : {%s}\n' '${!indirect}'           "${!indirect}"
#
#echo ""
#na=$xFile; printf '%25s : {%s} %s\n' '${#na}'                "${#na}"               "{${na}}"
#na=$xFile; printf '%25s : {%s} %s\n' '${na:-${!indirect}}'   "${na:-${!indirect}}"  "{${na}}"
#na=$xFile; printf '%25s : {%s} %s\n' '${na:=${!indirect}}'   "${na:=${!indirect}}"  "{${na}}"
#na=$xFile; printf '%25s : {%s} %s\n' '${na:+${!indirect}}'   "${na:+${!indirect}}"  "{${na}}"
#na=$xFile; printf '%25s : {%s} %s\n' '${na:+@${na}}'         "${na:+@${na}}"        "{${na}}"
#na=$xFile; printf '%25s : {%s} %s\n' '${na:+is set}'         "${na:+is set}"        "{${na}}"
#
#echo ""
#na=$yFile; printf '%25s : {%s} %s\n' '${#na}'                "${#na}"               "${na}"
#na=$yFile; printf '%25s : {%s} %s\n' '${na:-${!indirect}}'   "${na:-${!indirect}}"  "{${na}}"
#na=$yFile; printf '%25s : {%s} %s\n' '${na:=${!indirect}}'   "${na:=${!indirect}}"  "{${na}}"
#na=$yFile; printf '%25s : {%s} %s\n' '${na:?}'               "${na:?}"              "{${na}}"
#na=$yFile; printf '%25s : {%s} %s\n' '${na:+${!indirect}}'   "${na:+${!indirect}}"  "{${na}}"
#na=$yFile; printf '%25s : {%s} %s\n' '${na:+@${na}}'         "${na:+@${na}}"        "{${na}}"
#na=$yFile; printf '%25s : {%s} %s\n' '${na:+is set}'         "${na:+is set}"        "{${na}}"
#
#echo ""
#printf '%25s : {%s}\n' '${abc:4}'               "${abc:4}"
#printf '%25s : {%s}\n' '${abc:$((-4))}'         "${abc:$((-4))}"
#printf '%25s : {%s}\n' '${abc:4:2}'             "${abc:4:2}"
#printf '%25s : {%s}\n' '${abc:$((-4)):2}'       "${abc:$((-4)):2}"
#printf '%25s : {%s}\n' '${aLogin[1]}'           "${aLogin[1]}"
#printf '%25s : {%s}\n' '${aCmd[1]}'             "${aCmd[1]}"


if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bn=$(basename $0 .sh)
typeset -i E_OPTERR=0
typeset -i indexCmd=0
export fileSql
now="$(now.sh)"
logDir=$(cygpath -am ${HOME}/tmp/logDir/${bn}/${now})
mkdir -p "${logDir}"
logFile="${logDir}/logFile.log"
#################################

aCmd=(   $(alias | fgrep sql | sort -t@ -k2 | cut '-d ' -f4 | cut '-d;' -f1) )
aLogin=( $(alias | fgrep sql | sort -t@ -k2 | cut '-d ' -f6 | sed "s/'//g") )
aFileSql=( *.sql ); test -f "${aFileSql[0]}" || aFileSql=( )
abc='abcdefghijklmnopqrstuvwxyz'

test "sqq" = ${bn} && teeFile=t && quitNow=y
test "sqs" = ${bn} && teeFile=t && sqlOption=S
test "sqt" = ${bn} && teeFile=.

for login in $( echo "${aCmd[@]}" | sort )
do
  aCmd[${indexCmd}]=$(printf "%15s @ %s\n" ${login/@/ })
  indexCmd=$((++indexCmd))
done

options="adf:hl:o:qt:x"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    a) all=all;;
    d) dete="dete/dete@localhost";;
    f) fileSql="$OPTARG";;
    l) logFile="$OPTARG";;
    o) sqlOption="$OPTARG";;
    q) quitNow=y;;
    t) teeFile="$OPTARG";;
    x) set -x;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

test -z "${fileSql}" && fileSql="$1";
test "-" = "${teeFile}" && unset teeFile
test "." = "${teeFile}" && teeFile="sq.${fileSql}.log"
test "t" = "${teeFile}" && teeFile="${logDir}/sq.${fileSql}.log"

# (( ${#*} < 2 )) && E_OPTERR=65

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h) E_OPTERR=65; break;;
    a) all=all;;
    d) dete="dete/dete@localhost";;
    f) fileSql=${d}OPTARG;;
    l) logFile=${d}OPTARG;;
    o) sqlOption=${d}OPTARG;;
    q) quitNow=y;;
    t) teeFile=${d}OPTARG;;
    x) set -x;;
    
    $(printf "%11.11s = %-6s\n" all        "$all"        )
    $(printf "%11.11s = %-6s\n" dete       "$dete"       )
    $(printf "%11.11s = %-6s\n" fileSql    "$fileSql"    )
    $(printf "%11.11s = %-6s\n" logFile    "$logFile"    )
    $(printf "%11.11s = %-6s\n" quitNow    "$quitNow"    )
    $(printf "%11.11s = %-6s\n" sqlOption  "$sqlOption"  )
    $(printf "%11.11s = %-6s\n" teeFile    "$teeFile"    )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

aMax=${#aCmd[@]}

#if [ "." == "${teeFile}" ] 
#then
#  teeFile="sq.${fileSql}.log"
#fi

test -n "${teeFile}" && (
  test -f "${teeFile}" && mv "${teeFile}" "${teeFile}.$(now)"
  printf "# %s\n# %s\n" "${id}" "$(now)" > ${teeFile}
)

test -n "${dete}" && (
    test -n ${teeFile} && printf "\n# %s %s // %s\n\n " "${dete}" "${fileSql:+@$fileSql}" "$(now)" >> ${teeFile}

    eval "sqlplus.exe ${sqlOption:+-$sqlOption} "${dete}" ${fileSql:+@$fileSql} ${teeFile:+| tee -a $teeFile}"
)

test -z "${quitNow}" && (
  test -n "${all}" && (
    indexCmd=0
    for name in "${aCmd[@]}" ; do
      test -n ${teeFile} && printf "\n# %s %s // %s\n\n " "${name}" "${fileSql:+@$fileSql}" "$(now)" >> ${teeFile}

      cat <<EOF

  #############################################################################
  # $(printf "%s:%s\n" "${name}" "${indexCmd}")
  #############################################################################

EOF
      eval "sqlplus.exe ${sqlOption:+-$sqlOption} ${aLogin[${indexCmd}]} ${fileSql:+@$fileSql} ${teeFile:+| tee -a $teeFile}"
      indexCmd=$((++indexCmd))
    done
  ) || (
    PS3="${fileSql:+@$fileSql} select LOGIN: "
    select name in exit "${aCmd[@]}" "select fileSql"; do
      (( $REPLY<2 )) && break
      (( ($REPLY-1)>${aMax} )) && PS3='select fileSql: ' && select fileSql in "" "${aFileSql[@]}" ; do break; done && REPLY=0 && PS3="${fileSql:+@$fileSql }select LOGIN: "
      (( $REPLY<2 )) && continue

      test -n "${teeFile}" && printf "\n# %s %s // %s\n\n " "${name}" "${fileSql:+@$fileSql}" "$(now)" >> ${teeFile:+$teeFile}

      printf "%s:%s %s\n" "${name}" "${REPLY}" "${fileSql:+@$fileSql}"

      eval "sqlplus.exe ${sqlOption:+-$sqlOption} ${aLogin[($REPLY-2)]} ${fileSql:+@$fileSql} ${teeFile:+| tee -a $teeFile}"
      REPLY=0
    done
  )
)

test -n "${teeFile}" && ton "${teeFile}"
echo "${d}{teeFile} ${teeFile}"
set +x
