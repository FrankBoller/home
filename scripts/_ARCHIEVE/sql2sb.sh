#!/bin/bash
# $Id: sql2sb.sh,v 1.1 2005/02/04 01:56:57 fboller Exp $
#############################################################################

dateSecs=$(date +%s)
d='$'
bn=$(basename $1 .sql);

tmpJava=$bn.java

cat > $tmpJava <<EOF 
/* ${d}Id$ */
package com.eicjis.da.dao; 
import com.eicjis.core.util.Str; 
import com.eicjis.da.dao.IcjisResult;
import com.eicjis.da.util.ServiceLocatorException;
import java.sql.SQLException; 
import org.apache.log4j.Logger;
public class $bn extends IcjisResult {
  protected static final Logger LOGGER = Logger.getLogger($bn.class);
  public $bn() throws ServiceLocatorException, SQLException {
    super ();
    LOGGER.debug ("$bn()");
  }
  public void formatById(String sId)
      throws ServiceLocatorException, SQLException {

    // force the query
    selectById(sId);

    LOGGER.debug(Str.getInBanner(null, null, "formatById after super"));

    // cast into String all instanceof: BigDecimal, null
    // format Date types into String: "mm/dd/yyyy"
    formatResult();

    LOGGER.debug(Str.getInBanner(null, null, "finished  formatById"));
  }
  public void selectById(String sId) throws ServiceLocatorException, SQLException {

    if ((sId == null) || (sId.trim().length() <1) ) {
      throw new SQLException("selectById input is null/empty");
    }

    LOGGER.debug ("${bn}() " + new StringBuffer ()   // 
      .append ("" + this)                   // 
      .append (" selectById(")              // 
      .append ("   sId:" + sId)             // 
      .append (")"))
    ;
EOF

#############################################################################
# input looks like:
#############################################################################
#    select   c.COUNT_NUMBER as "Count", 
#             cr.CRIMINAL_CHARGE_TYPE as "Type", 

#############################################################################
# output looks like:
#############################################################################
#    StringBuffer sb = new StringBuffer ()           // 
#        .append ("\n select")                              // 
#        .append ("\n cr.COUNT_NUMBER as \"Count\")         // 
#        .append ("\n ,cr.CRIMINAL_CHARGE_TYPE as \"Type\") // 
#    ;

# define StringBuffer
echo "    StringBuffer sb = new StringBuffer() // " >> $tmpJava

# remove semi-colon (;)
# trim white space
# delete empty lines
# delete comments
# compress space at begining of line
# escape every double-quote (") into (\")
# create .append with embedded new-line for each line in sql
#    -e 's/^[[:space:]][[:space:]]*//' \
sed -e 's/;//g' \
    -e 's/WOODSC\.//' \
    -e 's/[[:space:]]*$//' \
    -e '/^$/d' \
    -e '/^\//d' \
    -e '/^--/d' \
    -e 's/"/\\"/g' \
    -e 's/.*/ .append("\\n &") \/\//' \
    < $1 \
    >> $tmpJava

cat >> $tmpJava <<EOF 
    ;
    LOGGER.debug ("${bn}() sb: " + sb);

    setQuery ("" + sb);
  }
}
EOF

jin $tmpJava
ls -lad $tmpJava
wc $tmpJava
