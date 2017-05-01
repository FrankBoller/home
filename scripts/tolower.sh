#!/usr/bin/bash
id='$Id: tolower.sh,v 1.19 2007/07/23 13:59:30 fboller Exp $'
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
logFile="${logDir}/logFile.log"
#################################

CR='\r'
NL='\n'

for arg in $*
do
    [[ -f $arg ]] || continue

    aWc=($(tr -cd $CR  < $arg | wc -c)); crCount=${aWc[0]};
    aWc=($(tr -cd '\n' < $arg | wc -c)); nlCount=${aWc[0]};
    # echo crCount=$crCount nlCount=$nlCount input $arg - $bn
    valuesIn=$bn.$crCount.$nlCount.$arg
    printf "%s: %5d (cr) %5d (nl) %s\n" $bn $crCount $nlCount $arg

    # what's a newline? is it a blank? a space? 
    case $bn in 

        "tolower")
        {
            tr '[:upper:]' '[:lower:]' < $arg > ${logFile};
        };; 

        "ton") 
        {
            (( $nlCount == "0" )) &&
            {
                # translate CR to NL
                tr $CR $NL < $arg > ${logFile}
            } ||
            {
                cat $arg > ${logFile}
                # convert CR/NL to NL
                dos2unix ${logFile} 2> /dev/null
            }
        };; 

        "tor") 
        {
            (( $nlCount == "0" )) &&
            {
                cat $arg > ${logFile}
            } ||
            {
                cat $arg > ${logFile}.1
                dos2unix ${logFile}.1 2> /dev/null
                tr $NL $CR < ${logFile}.1 > ${logFile}
            }
        };; 

        "torn") 
        {
            (( $nlCount == "0" )) &&
            {
                # translate CR to NL
                tr $CR $NL < $arg > ${logFile}
                unix2dos ${logFile} 2> /dev/null
            } ||
            {
                cat $arg > ${logFile}
                unix2dos ${logFile} 2> /dev/null
            }
        };; 

        "toupper") 
        {
            tr '[:lower:]' '[:upper:]' < $arg > ${logFile};
        };; 


        "tocapitalize") 
        {
            sed -e "s;\(_\)\(.\);\U\2;g" < $arg > ${logFile};
        };; 

        "tox") 
        {
            # -e "s/[>]/&${NL}/g"
            # -e "s;'[[:space:]][[:space:]]*;' ;g" \

            # -e "s;[>][[:space:]][[:space:]]*[<];><;g" \
#            tr -d $CR < $arg | tr -d $NL \
#            | sed \
#            -e "s;[<][^/];${NL}&;g" \
#            -e "s;[>]  *;>;g" \
#            -e "s;'  *;' ;g" \
#            | grep -v '^$' \
#            | xmllint.exe --noblanks --format - \
#            > ${logFile}

            cat $arg \
            | dos2unix \
            | xmllint.exe --noblanks --format - \
            > ${logFile}
        };; 

        "to")
        {
            continue;
        };;

        "tograph") 
        {
            gawk --non-decimal-data ' {print gensub("[\342][\200][\223]","-", "g");}' \
            < $arg \
            | tr -c '[[:graph:][:space:]]' '?' \
            > ${logFile};
        };; 

        "to")
        {
            continue;
        };;

        *) 
        echo oops $bn unknown;; 
    esac 

    #    [[ "$bn" = "tolower" ]] && {
    #        echo "tr '[:upper:]' '[:lower:]' < $arg > ${logFile}"
    #        tr '[:upper:]' '[:lower:]' < $arg > ${logFile}
    #    } || {
    #        echo "tr '[:lower:]' '[:upper:]' < $arg > ${logFile}"
    #        tr '[:lower:]' '[:upper:]' < $arg > ${logFile}
    #    }
    #    cat ${logFile} > $arg

    #cmp $arg ${logFile}

    touch -r $arg ${logFile}
    cmp -s $arg ${logFile} || cat ${logFile} > $arg && touch -r ${logFile} $arg

    aWc=($(tr -cd $CR  < $arg | wc -c)); crCount=${aWc[0]};
    aWc=($(tr -cd '\n' < $arg | wc -c)); nlCount=${aWc[0]};
    # echo crCount=$crCount nlCount=$nlCount input $arg - $bn

    valuesOut=$bn.$crCount.$nlCount.$arg
    if [ $valuesIn != $valuesOut ] ; then
      printf "%s: %5d (cr) %5d (nl) %s\n" $bn $crCount $nlCount $arg
    fi
done

echo
rm -rf $logDir
rmdir $logDir > /dev/null 2>&1
