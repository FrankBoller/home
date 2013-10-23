BEGIN   \
        { lastNl = 0; }

# begining // comments need newline before and after
/^[[:space:]]*[/][/].*/  \
        {
          if ( lastNl == 0 ) { print ""; }
          print; lastNl = 1; next;
        }

# inline // comments need newline only after
/.*[/][/].*/      \
        { print; lastNl = 1; next; }

# remove copyright header
/^[[:space:]][*][[:space:]][$]Workfile/,/Copyright 2001 Deluxe. All Rights Reserved./ \
        { next; }

# skip patterns like /** */
/^[[:space:]]*[/][*][*].*[*][/][[:space:]]*$/	\
	{ next; }

# skip patterns like /**, */
/^[[:space:]]*[/][*][*]/,/.*[*][/][[:space:]]*$/	\
	{ next; }

# skip blank lines
/^[[:space:]]*$/        \
        { next; }

# any line with a } gets a newline
#/.*[}].*/       \
#        { print; next; }

/.*/	\
	{ printf "%s\n", $0; lastNl = 0; }

END     \
        { printf "\n"; }
