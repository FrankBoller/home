#!/bin/bash
# $Id: nobak.sh,v 1.5 2006/02/27 18:03:00 fboller Exp $
#############################################################################

find \( \( -iname '*bk' \) -or \( -iname '*bak' \) -or \( -iname '*~' \) \) -type f -print0 | xargs -t0 rm
