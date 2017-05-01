#!/usr/bin/bash
id='$Id: mkLinks.sh,v 1.69 2007/08/30 17:22:58 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

rm -f /.${USER}   && ln -s "C:/users/$USER"         /.${USER}

rm -f /.${USER}.f && ln -s "F:/users/$USER"         /.${USER}.f
rm -f /.desktop.f && ln -s "F:/users/$USER/desktop" /.desktop.f
rm -f /.mydocs.f  && ln -s "F:/users/$USER/docs"    /.mydocs.f

for arg in desktop homeroot mydocs smprograms sysdir windir; do
  eval $(printf 'rm -f /.%s && ln -s "$(cygpath --%s)" /.%s;\n' $arg $arg $arg)
done

# following have --allusers versions
for arg in desktop mydocs smprograms ; do
  eval $(printf 'rm -f /.%s.p && ln -s "$(cygpath --allusers --%s)" /.%s.p;\n' $arg $arg $arg)
done

# workarounds for dir paths with spaces
( IFS=;
  declare -A map
  map[acrobatReader]='C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader'
  map[internetExplorer]='C:\Program Files\Internet Explorer'
  map[mozillaFirefox]='C:\Program Files (x86)\Mozilla Firefox'
  map[programFiles]='C:\Program Files'
  map[programFilesX86]='C:\Program Files (x86)'
  map[windowsLiveShared]='C:\Program Files (x86)\Windows Live\Shared'
  map[x86]='C:\Program Files (x86)'

  for arg in ${!map[@]}; do
    eval $(printf "rm -f /.%s && ln -s '%s' /.%s\n" "$arg" "${map[$arg]}" "$arg")
  done
)

dirLinks=~/links                                            ;# define links dir
test -f $dirLinks/.gets && cp $dirLinks/{.dirs,.gets} ~/tmp ;# save .gets file
rm -rf $dirLinks                                            ;# remove old dir
mkdir -p $dirLinks                                          ;# recreate
cd $dirLinks                                                ;# cd to dir
test -f ${HOME}/tmp/.gets && mv ${HOME}/tmp/{.dirs,.gets} $dirLinks     ;# replace .gets file

# following are .exe links for paths with spaces
(
  declare -A map
  map[acroRd32]='/.acrobatReader/AcroRd32.exe'
  map[e]='/.sysdir/explorer.exe'
  map[firefox]='/.mozillaFirefox/firefox.exe'
  map[git]='/.programFiles/Git/bin/git.exe'
  map[ping]='/.sysdir/PING.exe'
  map[rar]='/.programFiles/WinRAR/Rar.exe'
  map[unRar]='/.programFiles/WinRAR/UnRar.exe'

  for arg in ${!map[@]}; do
    eval $(printf 'rm -f %s && ln -s %s %s\n' "$arg" "$s${map[$arg]}$s" "$arg")
  done
)

# ln -s "${SYSTEMDRIVE}\\local\\util\\blat.exe" blat

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
