set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

:set guifont=Courier_New:h12:cANSI


"source $VIMRUNTIME/plugin/EnhancedCommentify.vim

map <M-c> :call EnhancedCommentify('yes', 'guess')<CR>
"imap <M-c> <ESC>:call EnhancedCommentify('yes', 'guess')<CR>j 

"let g:EnhCommentifyUseAltKeys = 'yes'
"let g:EnhCommentifyTraditionalMode = 'Y'
"let g:EnhCommentifyUseBlockIndent = 'yes'
"let g:EnhCommentifyMultiPartBlocks = 'yes'
"let g:EnhCommentifyAlignRight = 'yes'
"let g:EnhCommentifyUseSyntax = 'yes'

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

runtime! synmenu.vim

" :set backupdir=C:\WINXP\Temp,C:\WINDOWS\Temp
" :set directory=C:\WINXP\Temp,C:\WINDOWS\Temp
" :set viewdir=C:\WINXP\Temp,C:\WINDOWS\Temp,.

:set backupdir=$TEMP,.
:set directory=$TEMP,.
:set viewdir=$TEMP,.

:set   autoindent
:set   backup
:set   columns=132
:set   expandtab
" :set   lines=35
:set   lines=64
:set   linebreak
:set   shiftwidth=2
:set   smarttab
:set   tabstop=2
:set   tags=./tags,tags,c:\util\tags\tags
:set   terse
" :set   textwidth=150
":set   textwidth=1024
:set   textwidth=0
:set   visualbell
:set noignorecase
:set nolist  " list disables linebreak
:set nonumber
:set nowarn
:set   wrap
:set   wrapmargin=0
:set nowrapscan
:au GUIEnter * simalt ~x

" fjb - 05/10/2011
":set shell=c:\cygwin\bin\bash.exe
":set shellcmdflag=-c 
":set shellslash 
:set shell=c:/cygwin/bin/bash.exe
:set shellcmdflag=-c 
:set shellslash 

:set nocp
" fjb + 05/10/2011
filetype plugin on 


  "*******************
  " AEG mods
  "*******************
  "
  " Gives the percentage of 'columns' to use for the length of the
  " window title. Preserves the end of filenames, and is useful to
  " shorten to see all of the local file name, e.g. with a vertical
  " Windows dock, can keep track of a lot of files.
  :set titlelen=30

  " for testing
  "highlight Cursor guibg=red

  "colo algates
  "colo murphy
  "*******************
  " End AEG mods
  "*******************
  "
  "
" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
" or not :) autocmd BufRead *.txt set tw=78

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gunzip")
  autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bunzip2")
  autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPre			*.gz call GZIP_appre("gunzip")
  autocmd FileAppendPre			*.bz2 call GZIP_appre("bunzip2")
  autocmd FileAppendPost		*.gz call GZIP_write("gzip")
  autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    " set 'cmdheight' to two, to avoid the hit-return prompt
    let ch_save = &ch
    set cmdheight=3
    " when filtering the whole buffer, it will become empty
    let empty = line("'[") == 1 && line("']") == line("$")
    let tmp = tempname()
    let tmpe = tmp . "." . expand("<afile>:e")
    " write the just read lines to a temp file "'[,']w tmp.gz"
    execute "'[,']w " . tmpe
    " uncompress the temp file "!gunzip tmp.gz"
    execute "!" . a:cmd . " " . tmpe
    " delete the compressed lines
    '[,']d
    " read in the uncompressed lines "'[-1r tmp"
    " fjb - set nobin
    execute "'[-1r " . tmp
    " if buffer became empty, delete trailing blank line
    if empty
      normal Gdd''
    endif
    " delete the temp file
    call delete(tmp)
    let &ch = ch_save
    " When uncompressed the whole buffer, do autocommands
    if empty
      execute ":doautocmd BufReadPost " . expand("%:r")
    endif
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      execute "!" . a:cmd . " <afile>:r"
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    execute "!" . a:cmd . " <afile>"
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

 augroup END

 " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
 " back to positions in previous files more than once.
 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

  "*******************
  " AEG mods
  "*******************

  " set textwidth=0 disables
  " set textwidth in this file apparently doesn't work (or is overridden
  " from config TBD) if loaded file has a .txt extension
  " set textwidth=0

  " Gives the percentage of 'columns' to use for the length of the
  " window title. Preserves the end of filenames, and is useful to
  " shorten to see all of the local file name, e.g. with a vertical
  " Windows dock, can keep track of a lot of files.
  set titlelen=30

  " JavaBrowser plugin settings
  let JavaBrowser_Ctags_Cmd = 'c:\util\ctags.exe'
  let JavaBrowser_Sort_Type = "name"
  let JavaBrowser_Auto_Open = 0
  let JavaBrowser_Display_Prototype = 1
  let JavaBrowser_Use_Horiz_Window = 0
  nnoremap <silent> <F8> :JavaBrowser<CR>

  "colo default
  "colo evening
  "*******************

endif " has("autocmd")

"
" :so $VIMRUNTIME/syntax/hitest.vim
"
"background:blue=darkBlue, darkblue=#000040, evening=grey20, others=black
"background:shine=White, peachpuff=PeachPuff, zellner=white, morning=grey90
"
":colorscheme blue      " 77 no CDATA hilight, searchBG=orange
":colorscheme koehler   " 64 no CDATA hilight, searchBG=red
":colorscheme darkblue  " 62 no CDATA hilight, searchBG=lightblue
":colorscheme torte     " 50 no CDATA hilight, searchBG=red
":colorscheme ron       " 43 no CDATA hilight, searchBG=purp
":colorscheme murphy    " 41 no CDATA hilight, searchBG=blue
":colorscheme pablo     " 26 no CDATA hilight, searchBG=tan
":colorscheme default   " 23 no CDATA hilight, searchBG=yellow
":colorscheme shine     " 60 ok CDATA hilight, searchBG=yellow
":colorscheme peachpuff " 59 no CDATA hilight, searchBG=brown
":colorscheme zellner   " 54 no CDATA hilight, searchBG=cyan
":colorscheme morning   " 54 ok CDATA hilight, searchBG=yellow
"
":colorscheme bw        "
":colorscheme desert    "
":colorscheme orceandeep "
":colorscheme ps_color  "
"
" good string display"
":colorscheme elflord   " 50 no CDATA hilight, searchBG=yellow
":colorscheme evening   " 54 ok CDATA hilight, searchBG=yellow
":colorscheme blackbeauty "
 :colorscheme cool      

" fjb: do not show ^M at end of line hack
:hi! link SpecialKey Ignore

