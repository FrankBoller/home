#!/bin/bash
id='$Id: orderJava.sh,v 1.8 2006/04/22 19:11:00 fboller Exp $'
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

bn=$(basename $0 .sh)
logDir="/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

here=$(PWD)

tmpSed=${logDir}.sed
tmpPackage=$logDir/package.txt
tmpImports=$logDir/imports.txt
tmpJava=$logDir/java.txt
tmpFile=$logDir/file.txt

kount=0

(( $# == 0 )) && myArgs='*' || myArgs=$*;

# process java files
unixFiles=($(find $myArgs -type f -iname '*.java' | sort -u));
#javaFiles=($(for arg in ${unixFiles[@]}; do cygpath -w $arg | sed -e 's/\\/\\\\/g'; done));

[[ -f $unixFiles ]] && (

    cat <<EOF
    #############################################################################
    # here: $here
    # logDir: $logDir
    # 
    # unixFiles:
    # ${unixFiles[@]}
    #############################################################################
EOF

    cat > $tmpSed <<EOF
s/java.awt.\([A-Z]\)/\1/g
s/java.awt.event.\([A-Z]\)/\1/g
s/java.awt.print.\([A-Z]\)/\1/g
s/java.lang.\([A-Z]\)/\1/g
s/java.lang.reflect.\([A-Z]\)/\1/g
s/java.util.Map[.]/Map./g
s/java.util.\([A-LN-Z]\)/\1/g
s/javax.swing.UIManager.\([A-Z]\)/\1/g
s/javax.swing.border.\([A-Z]\)/\1/g
s/javax.swing.event.\([A-Z]\)/\1/g
s/javax.swing.filechooser.\([A-Z]\)/\1/g
s/javax.swing.table.\([A-Z]\)/\1/g
s/javax.swing.tree.\([A-Z]\)/\1/g
s/javax.swing[.]\([A-TV-Z]\)/\1/g
EOF

    for arg in ${unixFiles[@]}; do
        kount=$((kount=$kount+1))

        cat <<EOF

        # $arg $kount
EOF

        big $arg
        sed 's/[.]p1[.]dev/.p1_2.dev.frank/g' < $arg > $tmpJava

        #############################################################################
        # save ^package into $tmpPackage
        # save ^import into $tmpImports
        # save rest into $tmpJava
        #############################################################################

        grep '^package' $tmpJava > $tmpPackage
        grep '^import' $tmpJava | sort -u > $tmpImports

        #############################################################################
        # go into logDir
        #############################################################################
        (
            cd $logDir
            grep -v '^package' $tmpJava \
                | grep -v '^import' \
                | csplit.exe -skf java. - '/Deluxe. All Rights Reserved./+2'

            # remove some patterns from imports
#                | grep -v '^import[[:space:]]*com\.deluxe\.' \
            cat $tmpImports \
                | grep -v '^import[[:space:]]*java.awt' \
                | grep -v '^import[[:space:]]*java.lang' \
                | grep -v '^import[[:space:]]*java.util.[*]' \
                | grep -v '^import[[:space:]]*javax.swing' \
                > $tmpFile

            grep -qs 'java.awt.[A-Z*]'          $tmpJava && echo 'import java.awt.*;' >> $tmpFile
            grep -qs 'java.awt.color'           $tmpJava && echo 'import java.awt.color.*;' >> $tmpFile
            grep -qs 'java.awt.datatransfer'    $tmpJava && echo 'import java.awt.datatransfer.*;' >> $tmpFile
            grep -qs 'java.awt.dnd'             $tmpJava && echo 'import java.awt.dnd.*;' >> $tmpFile
            grep -qs 'java.awt.event'           $tmpJava && echo 'import java.awt.event.*;' >> $tmpFile
            grep -qs 'java.awt.font'            $tmpJava && echo 'import java.awt.font.*;' >> $tmpFile
            grep -qs 'java.awt.geom'            $tmpJava && echo 'import java.awt.geom.*;' >> $tmpFile
            grep -qs 'java.awt.im[.]'           $tmpJava && echo 'import java.awt.im.*;' >> $tmpFile
            grep -qs 'java.awt.image'           $tmpJava && echo 'import java.awt.image.*;' >> $tmpFile
            grep -qs 'java.awt.image.rend'      $tmpJava && echo 'import java.awt.image.renderable.*;' >> $tmpFile
            grep -qs 'java.awt.event'           $tmpJava && echo 'import java.awt.event.*;' >> $tmpFile
            grep -qs 'java.awt.print'           $tmpJava && echo 'import java.awt.print.*;' >> $tmpFile
            grep -qs 'java.lang.ref[.]'         $tmpJava && echo 'import java.lang.ref.*;' >> $tmpFile
            grep -qs 'java.lang.reflect'        $tmpJava && echo 'import java.lang.reflect.*;' >> $tmpFile
            grep -qs 'java.util.Map[.]'         $tmpJava && echo 'import java.util.Map.*;' >> $tmpFile
            grep -qs 'java.util.jar'            $tmpJava && echo 'import java.util.jar.*;' >> $tmpFile
            grep -qs 'java.util.zip'            $tmpJava && echo 'import java.util.zip.*;' >> $tmpFile
            grep -qs 'javax.swing.UIManager'    $tmpJava && echo 'import javax.swing.UIManager.*;' >> $tmpFile
            grep -qs 'javax.swing.[A-TV-Z]*'    $tmpJava && echo 'import javax.swing.*;' >> $tmpFile
            grep -qs 'javax.swing.border'       $tmpJava && echo 'import javax.swing.border.*;' >> $tmpFile
            grep -qs 'javax.swing.colorchooser' $tmpJava && echo 'import javax.swing.colorchooser.*;' >> $tmpFile
            grep -qs 'javax.swing.event'        $tmpJava && echo 'import javax.swing.event.*;' >> $tmpFile
            grep -qs 'javax.swing.plaf.basic'   $tmpJava && echo 'import javax.swing.plaf.basic.*;' >> $tmpFile
            grep -qs 'javax.swing.plaf.metal'   $tmpJava && echo 'import javax.swing.plaf.metal.*;' >> $tmpFile
            grep -qs 'javax.swing.plaf.multi'   $tmpJava && echo 'import javax.swing.plaf.multi.*;' >> $tmpFile
            grep -qs 'javax.swing.plaf'         $tmpJava && echo 'import javax.swing.plaf.*;' >> $tmpFile
            grep -qs 'javax.swing.filechooser'  $tmpJava && echo 'import javax.swing.filechooser.*;' >> $tmpFile
            grep -qs 'javax.swing.table'        $tmpJava && echo 'import javax.swing.table.*;' >> $tmpFile
            grep -qs 'javax.swing.text.html'    $tmpJava && echo 'import javax.swing.text.html.*;' >> $tmpFile
            grep -qs 'javax.swing.text.html.parser'    $tmpJava && echo 'import javax.swing.text.html.parser.*;' >> $tmpFile
            grep -qs 'javax.swing.text'         $tmpJava && echo 'import javax.swing.text.*;' >> $tmpFile
            grep -qs 'javax.swing.tree'         $tmpJava && echo 'import javax.swing.tree.*;' >> $tmpFile
            grep -qs 'javax.swing.undo'         $tmpJava && echo 'import javax.swing.undo.*;' >> $tmpFile

            # make sure import exists for each com.deluxe. reference
            sed -n 's/.*\(com\.deluxe\.[[:alnum:]._]*\).*/import \1;/p' \
                < java.01 \
                >> $tmpFile

            sort -u $tmpFile > $tmpImports

            # compress com.duluxe.* references in code block
            sed -f $tmpSed \
                < java.01 \
                | sed 's/\(com\.deluxe\.[[:alnum:]._]*\.\)\([[:alnum:]_]*\)/\2/' \
                > $tmpJava

            cat $tmpPackage java.00 $tmpImports $tmpJava > $here/$arg
        )

        jin $arg
        rm -f $logDir/*
    done

rm -rf ${logDir}*
)
rmdir $logDir > /dev/null 2>&1
