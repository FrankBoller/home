#!/bin/bash
id='$Id: mkBookHtml.sh,v 1.20 2006/10/02 14:26:52 fboller Exp $'
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
# logFile="${logDir}/logFile.log"
#################################

bookDir=ebooks
export kount=0
q='"'
#
here=$(pwd)
cd $bookDir
eBooksHtml=${logDir}/e-books.$$.html

bg=("#eeffee" "#eeffff" "#ffffee")
idxBg=0

# <a href="ebooks/Database_Programming_with_JDBC_and_Java,_2nd_edition/Database_Programming_with_JDBC_and_Java,_2nd_edition.pdf">
#   <img src="ebooks/Database_Programming_with_JDBC_and_Java,_2nd_edition/Database_Programming_with_JDBC_and_Java,_2nd_edition.gif" />
#   <br /> Database Programming with JDBC and Java, 2nd edition.pdf
# </a>

cat >$eBooksHtml <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta name="generator"
	content=": mkBookHtml.sh,v 1.5 2005/04/04 21:49:14 fboller Exp $" />
<title>ebooks.html</title>
<style type="text/css">
      /*<![CDATA[*/
      td {width: 25%; text-align: center;vertical-align: top;}
      /*]]>*/
    </style>
<script type="text/javascript">function loadContent(elementId, url) { document.getElementById(elementId).src=url; }</script>
</head>
<body>
<center>
<table border="1" bgcolor=${q}${bg[2]}${q}>
	<tr>
		<th colspan="4"><br />
		Quick References</th>
	</tr>
	<tr>
		<td>
      from <a href="www.devguru.com">www.devguru.com</a> <br /><hr />
    </td>
		<td>
      <a href="www.devguru.com/ADO/index.html">ActiveX</a> <br /><hr />
      <a href="www.devguru.com/CSS/index.html">CSS</a> <br />
		</td>
		<td>
      <a href="www.devguru.com/ECMA/index.html">JavaScript</a> <br /><hr />
      <a href="www.devguru.com/HTML/index.html">HTML</a> <br />
		</td>
		<td>
      <a href="www.devguru.com/JETSQL/index.html">SQL</a> <br /><hr />
      <a href="www.devguru.com/XMLDOM/index.html">XMLDOM</a>
		</td>
	</tr>
	<tr>
		<th colspan="4"><br />E-Books</th>
	</tr>
EOF

for ext in pdf chm html; do
  for arg in */book.$ext; do
    # bn=$(basename $arg .$ext)
    dn=$(dirname $arg)
    # spacedName=$(echo $dn| sed 's/___*/_/g'|tr '_' ' ')
    # onlyUnder=$(echo $dn| tr -cd _)
    # wc=$(echo $onlyUnder|wc -c)

    (( kount%4==0 )) && ( (( $kount>0 )) && echo "  </tr>">> $eBooksHtml; echo "  <tr>">>$eBooksHtml )
    kount=$(( kount=$kount+1 ))

    if [ -f $dn/book.png ] ; then
      img=$dn/book.png;
    elif [ -f $dn/book.jpg ] ; then
      img=$dn/book.jpg;
    else
      img=$dn/book.gif;
    fi

    cat >>$eBooksHtml <<EOF
    <td bgcolor=${q}${bg[$idxBg]}${q}>
    <a href=${q}$bookDir/$dn/book.${ext}${q} >
    <img src=${q}$bookDir/${img}${q} />
    <br />$(cat $dn/title.txt) ($ext)
    </a>
    </td>
EOF
  done
  (( idxBg++ ))
done

# 	</tr>
# 	<tr>
# 		<th colspan="4"><br />OReilly-Bookshelf</th>
# 	</tr>
# 	<tr align="center">
# 		<td colspan="4" rowspan="4" align="center">
# 		<center>
#       <a href="file://t:/eBooks/Oreilly-Bookshelf/index.html">file://t:/eBooks/Oreilly-Bookshelf/index.html</a>
#       <br />
#         NOTE: Mozilla has problems processing a "file:" URL.  Cut and paste directly into "goto" window. <br />
#         or jump directly to local filesystem: T:\eBooks\Oreilly-Bookshelf\index.html <br />
#       <iframe align="middle" width="800" height="2708" scrolling="auto"
#         src="images/OReillyCdBookshelfC.jpg" /></center>        
# 		</td>
# 	</tr>

cat >>$eBooksHtml <<EOF
</table>
</center>
</body>
</html>
EOF

cd ..

echo "created $eBooksHtml"
cp $eBooksHtml $here
rmdir $logDir > /dev/null 2>&1
