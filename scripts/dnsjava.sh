#!/bin/bash
Id='$Id: dnsjava.sh,v 1.9 2007/08/30 17:20:03 fboller Exp $'
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

# dnsjava="i:/local/.m2/repo/dnsjava/dnsjava/2.0.1/dnsjava-2.0.1.jar"
dnsjava="c:/local/m2/repo/dnsjava/dnsjava/2.1.1/dnsjava-2.1.1.jar"
javaClass=lookup
javaCmdline=
fEcho=1;# true

typeset -i E_OPTERR=0

options="dhjlux:"
while getopts $options Option
do
  case $Option in
    d) javaClass=dig;;
    e) (( fEcho = fEcho?0:1 ));;
    h) E_OPTERR=65; break;;
    j) javaClass=jnamed;;
    l) javaClass=lookup;;
    u) javaClass=update;;
    x) javaClass=dig; javaCmdline="-x $OPTARG";;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ "x${javaCmdline}" = "x" ] ; then javaCmdline="$*"; fi

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options] -- program options
    d) javaClass=dig
    e   toggle boolean flag fEcho = ${fEcho} $( (( fEcho )) && echo "(true)" || echo "(false)" )
        if true then echo command
    h) E_OPTERR=65; displays (this) Usage
    j) javaClass=jnamed
    l) javaClass=lookup
    u) javaClass=update
    x) javaClass=dig

    javaClass  : ${javaClass}
    javaCmdline: ${javaCmdline}

  Example(s)
    dnsjava.sh -d -- -x 172.16.2.104
    dnsjava.sh -l fboller
    dnsjava.sh -l pnatrajan

#############################################################################
# USAGE dnsjava v2.0
#############################################################################

dnsjava provides several command line programs, which are documented here.
For examples of API usage, see examples.html.

- dig:
	A clone of dig (as distributed with BIND)
	dig @server [-x] name type [class] [-p port] [-k name/secret] [-t] \
	[-i] [-e n] [-d]
		-x  : reverse lookup, name must be a dotted quad
		-k  : use TSIG transaction security
		-t  : use TCP by default
		-i  : ignore truncation errors
		-e n: Use EDNS level n (only 0 is defined)
		-d  : Set the DNSSEC OK bit

- update:
	A dynamic update client with some extra functionality.  This can be
	used either interactively or by specifying a file containing commands
	to be executed.  Running 'help' lists all other commands.
	update [file]


- jnamed:
	A basic authoritative only (non-caching, non-recursive) server.  It's
	not very good, but it's also a whole lot better than it used to be.

	The config file (jnamed.conf by default) supports the following
	directives:
		primary <zonename> <masterfile>
		secondary <zonename> <IP address>
		cache <hintfile>
		key <name> <base 64 encoded secret>
		address <IP address>
		port <port number>

	If no addresses are specified, jnamed will listen on all addresses,
	using a wildcard socket.  If no ports are specified, jnamed will
	listen on port 53.

	The following is an example:
		primary internal /etc/namedb/internal.db
		secondary xbill.org 127.0.0.1
		cache /etc/namedb/cache.db
		key xbill.org 1234
		address 127.0.0.1
		port 12345

	To run:
		jnamed [config_file]

	jnamed should not be used for production, and should probably
	not be used for testing.  If the above documentation is not enough,
	please do not ask for more, because it really should not be used.

- lookup:
	A simple program that looks up records associated with names.
	If no type is specified, address lookups are done.

	lookup [-t type] name ...
EOF
  echo "failed: E_OPTERR=$E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

cd /c/java/sourceforge/

(( $fEcho )) && cat <<EOF
#############################################################################
# $Id
#############################################################################
# javaClass=${javaClass}
# javaCmdline=${javaCmdline}

java -cp ${dnsjava} ${javaClass} ${javaCmdline}
EOF

java -cp ${dnsjava} ${javaClass} ${javaCmdline}

if [ ${javaClass} = lookup ] ; then
  cat <<EOF
  
  ping ${javaCmdline} | head -1 2>&1
  $(ping ${javaCmdline} | head -1 2>&1 )
EOF
fi
# rmdir $logDir > /dev/null 2>&1
