#!/bin/bash
id='$Id: mkLinks.sh,v 1.69 2007/08/30 17:22:58 fboller Exp $'
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

dirLinks=~/links                                            ;# define links dir
test -f $dirLinks/.gets && cp $dirLinks/{.dirs,.gets} ~/tmp ;# save .gets file
rm -rf $dirLinks                                            ;# remove old dir
mkdir -p $dirLinks                                          ;# recreate
cd $dirLinks                                                ;# cd to dir
test -f ${HOME}/tmp/.gets && mv ${HOME}/tmp/{.dirs,.gets} $dirLinks     ;# replace .gets file

# ln -s "${SYSTEMDRIVE}\\local\\util\\blat.exe" blat

ln -s '/.programFiles/Internet Explorer/iexplore.exe' .
ln -s "/.programFiles/Internet Explorer/iexplore.exe" ie
ln -s "/.programFiles/Mozilla Firefox/firefox.exe" .
#ln -s "/.programFiles/Mozilla Thunderbird/thunderbird.exe" .
ln -s $(cygpath -ams "${SYSTEMDRIVE}/PROGRA~1/Adobe/READER~1.0/Reader/AcroRd32.exe") .
ln -s $(cygpath -ams /PROGRA~1/WINDOW~1/ACCESS~1/wordpad.exe) .
#ln -s /.programFiles/Opera/Opera.exe* .
#ln -s /.programFiles/Subversion/bin/svn.exe .
#ln -s /.programFiles/TortoiseCVS/cvs.exe .
ln -s /.programFiles/Vim/vim73/gvim.exe .
ln -s /.programFiles/Vim/vim73/vim.exe .
# ln -s /.programFiles/WinMerge/WinMerge.exe* .
ln -s /.programFiles/WinMerge/WinMergeU.exe* .
ln -s /.programFiles/WinRAR/Rar.exe* .
ln -s /.programFiles/WinRAR/UnRAR.exe* .
ln -s /.windir/explorer.exe .
ln -s /.windir/explorer.exe e
ln -s /.windir/explorer.exe we
ln -s /.windir/system32/ping wping

for arg in Expr Http IcWord NakedException SQLException UrlPathLine Word; do ln -s ../scripts/findRefJavaExpr.sh findRefJava$arg; done
for arg in bld countTypes cvt cwd fifo gimp hl hman izCompile job lame mkIcons pump save wm; do ln -s ../scripts/$arg.sh $arg; done
for arg in dateRestore dateSave; do ln -s ../scripts/dateSave.sh $arg; done
for arg in dnsjava dns; do ln -s ../scripts/dnsjava.sh $arg; done
for arg in f2 fa fall fb fd fe ff ffd fff fh fhelp fimg fj fl fm fn fo fp fs ft ftl ftypef fw fx fz ; do ln -s ../scripts/fj.sh $arg; done
for arg in bat bmp class cmd doc dtd ear gif htm html inc jar java jpeg jpg ; do ln -s ../scripts/fj.sh f$arg; done
for arg in js jsp lst png properties sar sh sql tld txt war xml xsd zip ; do ln -s ../scripts/fj.sh f$arg; done
for arg in g; do ln -s ../scripts/gb.sh $arg; done
for arg in gt; do ln -s ../scripts/gb.sh $arg; done
for arg in sq sqq sqs sqt; do ln -s ../scripts/sq.sh $arg; done
for arg in hosts hosts.edmunds hosts.edmundsdl hosts.fboller hosts.stage; do ln -s ../scripts/hosts.sh $arg; done
for arg in lpr land land2; do ln -s ../scripts/lpr.sh $arg; done
for arg in nua nup nuq nus nuu; do ln -s ../scripts/nu.sh $arg; done
for arg in jdf.default jdf.full jdf.long jdf.medium jdf.short log.detail log.main nano now ts; do ln -s ../scripts/now.sh $arg; done
for arg in searchDomainpro searchDomainYahoo sp sy; do ln -s ../scripts/searchDomain.sh $arg; done
for arg in to tocapitalize tolower ton tor torn toupper tox; do ln -s ../scripts/tolower.sh $arg; done
for arg in dumpxsb inst2xsd scomp sdownload sfactor svalidate validate xpretty xsd2inst xsdtree xcomp xstc; do ln -s ../scripts/axis.sh $arg; done

# show all
ls -AbcFGl --full-time --color
# rmdir $logDir > /dev/null 2>&1
