#!/bin/bash

cat <<EOF
    # $# $Id: movePackageToTop.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
EOF

#############################################################################
# copyright notices look like this:
#############################################################################

# /*
#  * $RCSfile: movePackageToTop.sh,v $
#  * $Revision: 1.2 $ $Date: 2005/09/01 17:31:13 $ $Author: fboller $
#  *
#  * Copyright 2001 Deluxe. All Rights Reserved.
#  */

#  /*--- Formatted in Deluxe/Sun Java Convention Style on Tue, Jul 24, '01 ---*/

here=$PWD
kount=0

d='$'
slashes='////////////////////////////////////////////////////////////////////////'
tmp=$here/$$
touch $tmp

hereFiles=($*); [[ -f $hereFiles ]] && (
	for arg in "${hereFiles[@]}"
	do
        kount=$((kount=$kount+1))
		copyright=$(grep -i ' Copyright' $arg)
		package=$(grep '^package' $arg)
		formatted=$(grep '/*--- Formatted in ' $arg)

        printf "    # %3d package:%3d, copyright:%3d, %s\n" \
                  $kount ${#package} ${#copyright} $arg
#		echo "    # $arg, package:${#package}, copyright:${#copyright}"

		# remove tabs, ending spaces and blank comments: /* */
		# set ////////////// strings to exactly 75 slashes
	#??  -e 's/[/][*][[:space:]]*[*][/]//g' \
	    sed \
		    -e 's/\([a-zA-Z*]\)[[:space:]]*\*\/[[:space:]]*$/\1 *\//g' \
			-e 's/[[:space:]]*$//g' \
	        -e "s,//////////*//////////,$slashes,g" \
	        $arg | \
			expand > $tmp

		# replace old file
		cat $tmp > $arg

		# if missing copyright, add it
		if [ "$copyright" == "" ]; then
		    cat > $tmp <<EOF

	/*
	 * ${d}RCSfile: $arg ${d}
	 * ${d}Revision: ${d} ${d}Date: ${d} ${d}Author: ${d}
	 *
	 * Copyright 2001-2002 Deluxe. All Rights Reserved.
	 */
EOF
		    # append old file
	#          cat $arg >> $tmp
		    expand $arg >> $tmp

		    # replace old file
		    cat $tmp > $arg
		    echo "    ### added copyright"
		fi
			
		# if package found, move it
		if [ "$package" != "" ]; then
		    sed '/^package/d' < $arg > $tmp
			echo $package > $arg
			cat $tmp >> $arg
		fi

		# reduce size of formatted
		if [ "$formatted" != "" ]; then
            sed 's,--- Formatted in Deluxe.*Style on.*---,--- Formatted in Deluxe/Sun Java Convention Style ---,' < $arg > $tmp
            cat $tmp > $arg
        fi
	done
)
rm -f $tmp
