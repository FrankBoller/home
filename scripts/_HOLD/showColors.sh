#!/bin/bash
# $Id: showColors.sh,v 1.1 2005/09/01 17:23:13 fboller Exp $
#   This file echoes a bunch of color codes to the 
#   terminal to demonstrate what's available.  Each 
#   line is the color code of one forground color,
#   out of 17 (default + 16 escapes), followed by a 
#   test use of that color on all nine background 
#   colors (default + 8 escapes).
#

T='gYw'   # The test text

echo -e "\n                 40m     41m     42m     43m\
44m     45m     46m     47m";

for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
  '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
  '  36m' '1;36m' '  37m' '1;37m';
do FG=${FGs// /}
echo -en " $FGs \033[$FG  $T  "
for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
done
echo;
done
echo

function elite
{
  local ANSI_ST='\e[';       # start of seq of ANSI escape sequence indicator
  local ANSI_END='m';         # end of seq of ANSI escape indicator

  local RED_GREEN="${ANSI_ST}1;4;41;32${ANSI_END}"
  local GREEN_RED="${ANSI_ST}1;4;42;31${ANSI_END}"

  local TITLE="\e]2;\w\a"

  local GRAY="\[\033[1;30m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local CYAN="\[\033[0;36m\]"
  local LIGHT_CYAN="\[\033[1;36m\]"
  local NO_COLOUR="\[\033[0m\]"
  local SOME_COLOUR="\[\033[1;36;42m\]"
  local TITLEBAR='\[\033]0;\u@\h:\w\007\]'
  local temp=$(tty)
  local GRAD1=${temp:5}
  PS1="$TITLEBAR\
  $GRAY-$CYAN-$LIGHT_CYAN(\
  $CYAN\u$GRAY@$CYAN\h\
  $LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
  $CYAN\#$GRAY/$CYAN$GRAD1\
  $LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
  $CYAN\$(date +%H%M)$GRAY/$CYAN\$(date +%d-%b-%y)\
  $LIGHT_CYAN)$CYAN-$GRAY-\
  $LIGHT_GRAY\n\
  $GRAY-$CYAN-$LIGHT_CYAN(\
  $CYAN\$$GRAY:$CYAN\w\
  $LIGHT_CYAN)$CYAN-$GRAY-$LIGHT_GRAY$SOME_COLOUR\
  ${TITLE}\
  " 
  PS2="$LIGHT_CYAN-$CYAN-$GRAY-$SOME_COLOUR "
}

