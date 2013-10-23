#!/bin/bash
id='$Id: randu.sh,v 1.5 2006/10/02 14:26:52 fboller Exp $'
# cat <<EOF
# 
# #############################################################################
# # ${id}
# # 
# #############################################################################
# 
# EOF
# 
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

typeset -i E_OPTERR=0
typeset -i count=1       ;# -c:
typeset -i digits=16     ;# -d:
typeset -i endValue=1    ;# -e:
typeset -i precision=4   ;# -p:
typeset -i radix=16      ;# -r:
typeset -i startValue=0  ;# -s:

multiplier=1             ;# -m
normalize=true           ;# -n
zeroFill=false           ;# -z

options="c:d:e:hm:np:r:s:z"
while getopts $options Option
do
    case $Option in
        c) count=$OPTARG;;
        d) digits=$OPTARG;;
        e) endValue=$OPTARG;;
        h) E_OPTERR=65; break;;
        m) multiplier=$OPTARG;;
        n) normalize=false;;
        p) precision=$OPTARG;;
        r) radix=$OPTARG;;
        s) startValue=$OPTARG;;
        z) zeroFill=true;;
        *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
    esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

# endValue must be greater than startValue
(( endValue > startValue )) || {
echo "*** ERROR *** endValue must be greater than startValue"
E_OPTERR=-1;
}

if [ $E_OPTERR != 0 ]
then
    cat <<EOF

    #############################################################################
    # ${id}
    # 
    #############################################################################

    Usage $0 -[$options]
    h) displays (this) Usage

    c) $(printf "%11.11s = %-6s : [%s]\n" count      $count       '$OPTARG' )
    d) $(printf "%11.11s = %-6s : [%s]\n" digits     $digits      '$OPTARG' )
    e) $(printf "%11.11s = %-6s : [%s]\n" endValue   $endValue    '$OPTARG' )
    n) $(printf "%11.11s = %-6s : [%s]\n" normalize  $normalize    true    )
    p) $(printf "%11.11s = %-6s : [%s]\n" multiplier $multiplier  '$OPTARG' )
    p) $(printf "%11.11s = %-6s : [%s]\n" precision  $precision   '$OPTARG' )
    r) $(printf "%11.11s = %-6s : [%s]\n" radix      $radix       '$OPTARG' )
    s) $(printf "%11.11s = %-6s : [%s]\n" startValue $startValue  '$OPTARG' )
    z) $(printf "%11.11s = %-6s : [%s]\n" zeroFill   $zeroFill     false    )
EOF
    echo "failed: $E_OPTERR"
    exit $E_OPTERR
fi

#############################################################################

range=$( echo "${precision}k ${endValue} ${startValue} -f" | dc )
digits=$(( ++digits ))

for (( i=0; i<count; i++ )) ; do {
    x8Value=$(openssl.exe rand 8 | od -t x8 | head -1 | cut "-d " -f2 | tr '[[:lower:]]' '[[:upper:]]')

    $normalize &&
    {
        if [ "$multiplier" != "1" ] ; then
            value=$(echo "${precision} k 16i ${x8Value} FFFFFFFFFFFFFFFF/ ${multiplier} * f" | dc)
        else
            value=$(echo "${precision} k 16i ${x8Value} FFFFFFFFFFFFFFFF/ A i ${range} * ${startValue} +f" | dc)
        fi
    } || {
    if [ "$digits" != "17" ] ; then
        radix=10;
        mask=$( echo "10 ${digits}^f" | dc );
        leading=$(echo "16i ${x8Value} A i ${mask} % ${mask} +f" | dc);
        value=$( echo "${leading}" | cut -c3- );
    else
        value=$(echo "${radix}o 16i ${x8Value} A i ${multiplier} * f" | dc)
    fi
}

echo ${value}
} ; done
# rmdir $logDir > /dev/null 2>&1
