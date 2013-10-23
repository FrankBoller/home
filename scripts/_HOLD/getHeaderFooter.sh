#!/bin/bash
id='$Id: '
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
here=$(pwd)
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir

headerHtml="${logDir}/header.html"
footerHtml="${logDir}/footer.html"
cssFile="000.css"
#################################

footer="http://www.pioneerelectronics.com/pna/v3/pg/b2c/footer/0,,2076_310069575,00.html"
header="http://www.pioneerelectronics.com/pna/v3/pg/b2c/header/0,,2076_310069581,00.html"

echo -n "press enter, then when web page appears, save as: $(cygpath -w ${logDir}/header).html"
read
firefox "${header}"

#############################################################################
# process header_files
#############################################################################

cd ${logDir}/header_files
sed -e 's;/pna/v3[[:alnum:]/_.]*;\n&\n;g' 000.css | fgrep '/pna/v3' > ${logDir}/img.lst

save ${cssFile}
sed -e 's;/pna/v3[[:alnum:]/_.]*/;/b2c_ei/b2c/mimes/images/vig_files/;g' < ${cssFile}.* > ${cssFile}

echo -n "press enter, then when web page appears, save as: $(cygpath -w ${logDir}/footer).html"
read
firefox "${footer}"

#############################################################################
# process footer_files
#############################################################################

cd ${logDir}/footer_files
sed -e 's;/pna/v3[[:alnum:]/_.]*;\n&\n;g' 000.css | fgrep '/pna/v3' >> ${logDir}/img.lst
save ${cssFile}
sed -e 's;/pna/v3[[:alnum:]/_.]*/;/b2c_ei/b2c/mimes/images/vig_files/;g' < ${cssFile}.* > ${cssFile}

#############################################################################
# localize images for html files
#############################################################################

cd ${logDir}

# grab gifs from html
sed -e 's;/vgn/[[:alnum:]/_.]*;\n&\n;g' *.html | fgrep '/vgn' >> ${logDir}/img.lst


save header.html
sed -e 's;/vgn/[[:alnum:]/_.]*/;/b2c_ei/b2c/mimes/images/vig_files/;g' < header.html.* | sed -e 's;<head>;\n&\n<base target="_top">\n;' > header.html
save footer.html
sed -e 's;/vgn/[[:alnum:]/_.]*/;/b2c_ei/b2c/mimes/images/vig_files/;g' < footer.html.* > footer.html

cat > ${logDir}/img.html <<EOF
<html>
  <head>
    <title>img.html</title>
  </head>
  <body>
  $(sort -u ${logDir}/img.lst | sed -e 's;.*;    <img src="http://www.pioneerelectronics.com&" />;')
  </body>
</html>
EOF

echo -n "press enter, then when web page appears, save as: $(cygpath -w ${logDir}/vig).html"
read

cd ${logDir}
firefox img.html
mkdir -p mimes/images
cp -r vig_files mimes/images
