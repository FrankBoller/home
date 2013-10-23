#!/bin/bash
id="$Id: pump.sh,v 1.10 2006/05/30 15:10:39 fboller Exp $"
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
# logDir="/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

browserFirefox=/.mozzila/firefox.exe
browserIexplore=/.internetExplorer/iexplore.exe
dirEtc="$(cygpath -am ${WINDIR}/system32/drivers/etc)";
dirWorking="$(cygpath -am $(pwd))";#      like: d:/Program Files/Internet Explorer/Explorer 
# urlPost="/new"

typeset -i E_OPTERR=0
typeset -i iHeight=550;# initial height of test display window
typeset -i iWidth=550;# initial width of test display window
typeset -i indexTmp=0

function showError() {
cat <<EOF

#############################################################################
# ERROR
#
$(for arg in "$@"; do echo "#   $arg"; done)
#############################################################################

EOF
}

declare -a aDashName
declare -a aHostFile=( $(cd $dirEtc; ls hosts*) )
declare -a aPathUri
declare -a aSites=( \
  about.edmunds.com \
  aol.edmunds.com \
  aolsvc.edmunds.com \
  cnn.edmunds.com \
  compuserve.edmunds.com \
  dl.edmunds.com \
  edmunds.nytimes.com \
  ign.edmunds.com \
  ivillage.edmunds.com \
  money.cnn.edmunds.com \
  netscape.edmunds.com \
  www.edmunds.com \
  )
declare -a aUrlPost=( \
"/new" \
"/new/2006/honda/accord/index.html"  \
"/new/2006/chrysler/ptcruiser/index.html" \
)

options="H:W:a:dfhijp:sw:"
while getopts $options Option
do
  case $Option in
    H) iHeight="$OPTARG";;
    W) iWidth="$OPTARG";;
    a) bnAliasHost="$OPTARG";;
    d) fDbg=true;;
    f) browser="${browserFirefox}";;
    h) E_OPTERR=65; break;;
    i) browser="${browserIexplore}";;
    j) fReplaceJs=true;;
    p) indexPath="$OPTARG";;
    s) browser="${browserIexplore}"; iHeight=2000; iWidth=550; bnAliasHost="edmunds"; indexPath=0;;
    w) dirWorking="$(cygpath -am ${OPTARG})"; test ! -d "$dirWorking" && E_OPTERR=-1 && showError "missing directory: $OPTARG" || cd "$dirWorking";;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

#############################################################################
# Move argument pointer to next.
#############################################################################

shift $(($OPTIND - 1))

aliasHostPath="${dirEtc}/${bnAliasHost}";
dirTest="${dirWorking}/dirTest.${bn}";

test ! ${bnAliasHost} || test -f "${aliasHostPath}" || bnAliasHost="hosts.${bnAliasHost}";
aliasHostPath="${dirEtc}/${bnAliasHost}";

if [ ! -f "${aliasHostPath}" ] ; then
  echo "select bnAliasHost to use from ${dirEtc}:"
  select bnAliasHost in ${aHostFile[@]}; do [ "x$bnAliasHost" == "x" ] && continue; break ; done
fi

aliasHostPath="${dirEtc}/${bnAliasHost}";
test -f "${aliasHostPath}" && cp ${aliasHostPath} ${dirEtc}/hosts || E_OPTERR=-1

test ${fDbg} && (
  echo "bnAliasHost: ${bnAliasHost}"
  echo "aliasHostPath: ${aliasHostPath}"
)

cat <<EOF

#############################################################################
# $id
#
# for host alias file use: ${dirEtc}/$bnAliasHost
#############################################################################

EOF

if [ ! -f "${dirEtc}/${bnAliasHost}" ] ; then
  E_OPTERR=-1; echo "cp ${dirEtc}/$bnAliasHost ${dirEtc}/hosts; # failed"
fi

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    H) Height(${iHeight})='$OPTARG';;
    W) Width(${iWidth})='$OPTARG';;
    a) bnAliasHost(${bnAliasHost})='$OPTARG';;
    d) debug(${fDbg})=true;;
    f) browser(${browser})='${browserFirefox}';;
    h) E_OPTERR=65; displays this Usage
    i) browser(${browser})='${browserIexplore}';;
    j) fReplaceJs(${fReplaceJs})=true;;
    p) indexPath(${indexPath})='$OPTARG';;
    s) browser(${browser})='${browserIexplore}'; iHeight=2000; iWidth=550; bnAliasHost='edmunds'; indexPath=0;;
    w) dirWorking(${dirWorking})='$OPTARG';;

    aHostFile=(${aHostFile[*]})
    aSites=(${aSites[*]})

    aUrlPost=(${aUrlPost[*]})
    aliasHostPath=(${aliasHostPath})
    bn=(${bn})
    bnAliasHost=(${bnAliasHost})
    dirEtc=(${dirEtc})
    dirTest=(${dirTest})
    dirWorking=(${dirWorking})
#############################################################################
    failed E_OPTERR=(${E_OPTERR})
EOF
  exit $E_OPTERR
fi

#############################################################################
ipEdmunds=$(ping edmunds.com | head -1 | sed 's;.*[(]\(.*\)[)].*;\1;')

dirTestHtml="${dirTest}";
dirTestPages="${dirTest}/pages";
dirTestImages="${dirTest}/images";
dirTestScripts="${dirTest}/scripts";

pathJavascript="${dirTestScripts}/${bn}.js";
fileJavascript="file:///${pathJavascript}"
strTitle="$(date +'%x %X'); ping edmunds.com:(${ipEdmunds});   use ${dirEtc}/$bnAliasHost";

# create directory structure
mkdir -p "${dirTestHtml}" "${dirTestPages}" "${dirTestImages}" "${dirTestScripts}"
touch "${dirTestHtml}/blank.html"
test -f ${pathJavascript} || fReplaceJs=true;

test ${fDbg} && (
  printf "%20.20s: %s\n" iWidth "$iWidth";
  printf "%20.20s: %s\n" iHeight "$iHeight";
  printf "%20.20s: %s\n" strTitle "$strTitle";
  printf "\n";
)

for site in ${aSites[@]}; do
  for urlPost in ${aUrlPost[@]}; do
    uri="${site}${urlPost}"
    bnDash="${uri//[^[:alnum:].]/_}"

    pathUrlBase="${dirTestHtml}/url.${bnDash}.html";
    pathUrlImg="${dirTestPages}/${bnDash}.html";
    pathPng="${dirTestImages}/${bnDash}.png";

    aDashName[$indexTmp]="${bnDash}";
    aPathUri[$indexTmp]="${uri}";
    indexTmp=$((indexTmp=$indexTmp+1));

    urlLeft="http://${uri}";
    urlRight="file:///${pathUrlImg}";

    test ${fDbg} && (
      printf "%20.20s: %s\n" urlLeft "$urlLeft";
      printf "%20.20s: %s\n" urlRight "$urlRight";
      printf "\n";
    )

    cat <<EOF > "${pathUrlImg}"
<html>
  <head> <title>image ${bnDash}</title></head>
  <body>
  <img src="file:///${pathPng}" width="800" />
  </body>
</html>
EOF

  cat <<EOF > ${pathUrlBase}
<html>
  <head>
    <title>dom.html</title>
    <script type="text/javascript" language='javascript' src="${fileJavascript}" > </script>
  </head>

  <body id="body">
    <big id="bodyTitleText">dom.html</big>
    <hr>
    <table>
      <tr>
        <td>
          <button id="bnSizeH" >global height</button>:
          <input id="inHeight" size="3" /> <button id="bnPlusH" >+</button> <button id="bnMinusH" >-</button>&nbsp;&nbsp;

          <button id="bnSizeW" >global width</button>:
          <input id="inLeftWidth" size="3" /> <button id="bnPlusLw" >+</button> <button id="bnMinusLw" >-</button>
        </td>
        <td>
          right side width: <input id="inRightWidth" size="3" /> <button id="bnPlusRw" >+</button> <button id="bnMinusRw" >-</button>
        </td>
      </tr>
      <tr>
        <td id="tdLeft" >
          <a id="aLeft" href="${urlLeft}">${urlLeft}</a>
        </td>
        <td id="tdRight" >
          <a id="aRight" href="${urlRight}">${urlRight}</a>
        </td>
      </tr>
    </table>
    <iframe id="ifLeft" src="blank.html" align="top" marginwidth="0" marginheight="0" > </iframe>
    <iframe id="ifRight" src="blank.html" align="top" marginwidth="0" marginheight="0" > </iframe>
    <br>
  </body>
  <script type="text/javascript" language='javascript'>
    init("${urlLeft}", "${urlRight}", "${strTitle}", "${iWidth}", "${iHeight}");
  </script>
</html>
EOF

  done
done
#############################################################################

test ${fReplaceJs} && (
  cat <<EOF > ${pathJavascript}
// $Id: pump.sh,v 1.10 2006/05/30 15:10:39 fboller Exp $

var m_StrTitle="Mon Dec 12 13:33:17 PST 2005";
var m_UriLeft="http://java.sun.com";
var m_UriRight="http://google.com";
var m_fDbg=false;

function setNodeText(a_Id,a_StrText) {
  var parentNode = document.getElementById(a_Id);
  if ( parentNode == null ) { return; }

  var innerText=parentNode.innerText;
  var textNode=document.createTextNode(a_StrText);
  var wasChild;

  textNode=document.createTextNode(a_StrText);
  if ( parentNode.firstChild == null ) {
    parentNode.appendChild( textNode );
  } else {
    wasChild=parentNode.replaceChild( textNode, parentNode.firstChild );
  }
}

function replaceIframeSrc(a_Id,a_Uri) {
  var ifElm = document.getElementById(a_Id);
  ifElm.src=("" + a_Uri);
}

function replaceAll(a_UriLeft, a_UriRight) {
  //  alert("a_UriLeft" + a_UriLeft + ", a_UriRight" + a_UriRight);

  // setNodeText("tdLeft",a_UriLeft);
  replaceIframeSrc("ifLeft",a_UriLeft);

  // setNodeText("tdRight",a_UriRight);
  replaceIframeSrc("ifRight",a_UriRight);
}

function setStyle(a_Id, a_Prop, a_Value) {
  a_Value="" + a_Value;
  var elm = document.getElementById(a_Id);
  elm.style[a_Prop]=a_Value;

  if (a_Prop=="height") {
    elm = document.getElementById("inHeight");
    elm.value=a_Value;
  }

  if (a_Prop=="width") {
    elm=document.getElementById("inRightWidth");
    elm.value=a_Value;
    if (a_Id=="ifLeft") {
      elm.focus();
      elm.blur();
      elm=document.getElementById("inLeftWidth");
      elm.value=a_Value;
    }
  }
}

function addStyle(a_Id, a_Prop, a_Value) {
  a_Prop = "" + a_Prop;
  a_Value = "" + a_Value;

  var elm = document.getElementById(a_Id);
  var oldProp="" + elm.style[a_Prop];
  var oldValue=parseInt(oldProp);
  var newValue=parseInt(a_Value);

  var s="addStyle\n\t";
  s += " id(" + a_Id + ")";
  s += ", prop(" + a_Prop + ")";
  s += ", value(" + a_Value + ")";
  s  = "  oldProp(" + oldProp + ")";
  s += ", oldValue(" + oldValue + ")";
  s += ", newValue(" + newValue + ")";

  if( ("" + newValue) == "NaN" ) { newValue=Number(135); }
  if( ("" + oldValue) == "NaN" ) { oldValue=Number(321); }
  if( newValue == 0 ) { newValue=Number(100); }

  s += "\n\t";
  s += "  oldValue(" + oldValue + ")";
  s += ", newValue(" + newValue + ")";
  // if(m_fDbg) {alert(s);}

  // elm.style[a_Prop]=(""+(oldValue+newValue));
  setStyle( a_Id, a_Prop, ""+(oldValue+newValue) );
}

function init(a_UriLeft, a_UriRight, a_StrTitle, a_defaultWidth, a_defaultHeight ) {
  if ( a_UriLeft != null ) { m_UriLeft = a_UriLeft; }
  if ( a_UriRight != null ) { m_UriRight = a_UriRight; }
  if ( a_StrTitle != null ) { m_StrTitle = a_StrTitle; }
  if ( a_defaultWidth == null ) { a_defaultWidth = "${iWidth}"; }
  if ( a_defaultHeight == null ) { a_defaultHeight = "${iHeight}"; }

  var s="m_UriLeft=(" + m_UriLeft + ")";
  s+=", m_UriRight=(" + m_UriRight + ")";
  s+=", m_StrTitle=(" + m_StrTitle + ")";
  s+=", a_defaultWidth=(" + a_defaultWidth + ")";
  s+=", a_defaultHeight=(" + a_defaultHeight + ")";
  if(m_fDbg) alert(s);

  // setStyle("ifRight", "marginWidth", "0");

  elm = document.getElementById("inHeight"); elm.value=a_defaultHeight;
  elm.onblur=function() { setStyle("ifLeft", "height", this.value); setStyle("ifRight", "height", this.value); }
  elm.focus(); elm.blur();

  elm = document.getElementById("inLeftWidth"); elm.value=a_defaultWidth;
  elm.onblur=function() { setStyle("tdLeft", "width", this.value); setStyle("ifLeft", "width", this.value); }
  elm.focus(); elm.blur();

  elm = document.getElementById("inRightWidth");
  elm.onblur=function() { setStyle("tdRight", "width", this.value); setStyle("ifRight", "width", this.value); }
  elm.focus(); elm.blur();

  elm = document.getElementById("bnMinusH");  elm.onclick=function() { addStyle("ifLeft", "height", "-100"); addStyle("ifRight", "height", "-100");  }
  elm = document.getElementById("bnPlusH");   elm.onclick=function() { addStyle("ifLeft", "height", "100");  addStyle("ifRight", "height", "100");  }
  elm = document.getElementById("bnSizeH");   elm.onclick=function() { setStyle("ifLeft", "height", "2000"); setStyle("ifRight", "height", "2000");  }

  elm = document.getElementById("bnMinusLw"); elm.onclick=function() { addStyle("tdLeft", "width", "-100");  addStyle("ifLeft", "width", "-100");  }
  elm = document.getElementById("bnMinusRw"); elm.onclick=function() { addStyle("tdRight", "width", "-100"); addStyle("ifRight", "width", "-100");  }
  elm = document.getElementById("bnPlusLw");  elm.onclick=function() { addStyle("tdLeft", "width", "100");   addStyle("ifLeft", "width", "100");  }
  elm = document.getElementById("bnPlusRw");  elm.onclick=function() { addStyle("tdRight", "width", "100");  addStyle("ifRight", "width", "100");  }
  elm = document.getElementById("bnSizeW");   elm.onclick=function() { setStyle("tdLeft", "width", "800");   setStyle("ifLeft", "width", "800"); 
                                                                       setStyle("tdRight", "width", "800");  setStyle("ifRight", "width", "800");  }

  replaceAll(m_UriLeft, m_UriRight);

  setNodeText("bodyTitleText",m_StrTitle);
}

EOF
)

#############################################################################

if [ ! -f "${browser}" ] ; then
  echo "enter browser: "
  select browser in "${browserFirefox}" "${browserIexplore}"
  do
    break
  done
fi

#############################################################################

test ${fDbg} && (
  printf "%20.20s: %s\n" browser "$browser";
  printf "%20.20s: %s\n" indexPath "$indexPath";
)

unset bnDash
unset pathUrlBase

while ( true ); do
  if [ "x${indexPath}" == "x" ] ; then
    test ${onceOnly} && exit
    echo "enter number of uri to use: "
    select uri in ${aPathUri[@]} exit
    do
      printf "%20.20s: %s\n" uri "$uri";
      [ "$uri" == "" ] && exit
      [ "$uri" == "exit" ] && exit

      # assumes that aDashName and aDashName are syncronized
      indexPath=$(( (REPLY<1||REPLY>${#aDashName[@]})?0:(--REPLY) ));
      bnDash="${aDashName[${indexPath}]}"

      pathUrlBase="${dirTestHtml}/url.${bnDash}.html";#   like: "d:/tmp/test/dirHtml/edmunds.nytimes.com-new.html"

      test ${fDbg} && (
        printf "%20.20s: %s\n" uri "$uri";
        printf "%20.20s: %s\n" REPLY "$REPLY";
      )

      break 
    done
  else
    onceOnly=true;
    indexPath=$(( (indexPath<1||indexPath>${#aDashName[@]})?0:(--indexPath) ));
    bnDash="${aDashName[${indexPath}]}"
    pathUrlBase="${dirTestHtml}/url.${bnDash}.html";#   like: "d:/tmp/test/dirHtml/edmunds.nytimes.com-new.html"
  fi

  if [ "x${indexPath}" == "x" ] ; then exit; fi

  test ${fDbg} && (
    printf "%20.20s: %s\n" bnDash "$bnDash";
    printf "%20.20s: %s\n" indexPath "$indexPath";
    printf "%20.20s: %s\n" onceOnly "$onceOnly";
    printf "%20.20s: %s\n" pathUrlBase "$pathUrlBase";
  )

  unset indexPath

#############################################################################

  test -e "${pathUrlBase}" && (
    fileUrlBase="file:///${pathUrlBase}";
    
    printf "%20.20s: %s\n" "$browser"  "${fileUrlBase}";
    ${browser} "${fileUrlBase}" &
  )
done
# rmdir $logDir > /dev/null 2>&1
