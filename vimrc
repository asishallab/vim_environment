set nocompatible " Vim not vi

" Pathogen enables usage of bundle-directory.
" The following is needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Backup and Swap-Directories
set directory=~/.vim/tmp/swap
set backupdir=~/.vim/tmp/backup

" General settings
let mapleader = ","
let maplocalleader = "-"
map <Leader><Space> :copen <CR>
syntax enable
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set number
filetype plugin indent on 
set vb t_vb= " No error-bell nor flash
"set autochdir " always switch to the current file directory
set hlsearch
"set textwidth=80
colorscheme macvim
set gfn=Monospace\ 12
autocmd BufNewFile,BufRead set nowrap

" Spellcheck:
set spell spelllang=en

" Supertab
let g:SuperTabDefaultCompletionType = "context"

" preview
let g:PreviewBrowsers="open -a Chromium"
let g:PreviewCSSPath="/Users/ah/.vim/bundle/greyblake-vim-preview-2df4b44/my.css"

" Ruby-Rails
let g:ruby_debugger_progname = '/usr/bin/mvim'

" Taglist
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1

" Folding stuff
set foldmethod=indent
set foldlevelstart=1
set foldminlines=1
"hi Folded guibg=red guifg=Red cterm=bold ctermbg=DarkGrey ctermfg=lightblue
"hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
"set foldcolumn=2
"set foldclose=
"set foldnestmax=2
"set fillchars=vert:\|,fold:\

" Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" Latex-Plugin
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" Vim-R-Plugin-2
let g:hasrmenu = 0
let vimrplugin_never_unmake_menu = 1
" let vimrplugin_r_path = "/opt/share/local/development/R/R-2.11.1/bin"

" FuzzyFinder
map <Leader>, :FufFile **/<CR>
map <Leader>. :FufFile <CR>
map <Leader>- :FufBuffer <CR>
" Command-T
map <Leader># :CommandT <CR>
map <Leader>+ call FlushFufAndCommandT()

fun! FlushFufAndCommandT() 
  exec :CommandTFlush
  exec :FufRenewCache
endfun


" rsense
let g:rsenseHome = "/home/hallab/rsense-0.3/"
let g:rsenseUseOmniFunc = 1

" Enable vim-textobj-rubyblock
" which requires 'matchit':
:runtime macros/matchit.vim

" VimDebug 
map <LocalLeader>1  : DBGRstart<CR>
map <LocalLeader>s/ : DBGRstart
map <LocalLeader>2  : call DBGRstep()<CR>
map <LocalLeader>3  : call DBGRnext()<CR>
map <LocalLeader>4  : call DBGRcont()<CR>                   " continue
map <LocalLeader>b  : call DBGRsetBreakPoint()<CR>
map <LocalLeader>c  : call DBGRclearBreakPoint()<CR>
map <LocalLeader>ca : call DBGRclearAllBreakPoints()<CR>
map <LocalLeader>v/ : DBGRprint
map <LocalLeader>v  : DBGRprintExpand expand("<cWORD>")<CR> " print value under the cursor
map <LocalLeader>/  : DBGRcommand
map <LocalLeader>5  : call DBGRrestart()<CR>
map <LocalLeader>6  : call DBGRquit()<CR>

" Vim and Java:
" http://everything101.sourceforge.net/docs/papers/java_and_vim.html
" autocmd Filetype java set makeprg=ant\ -f\ build.xml 
" autocmd Filetype java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
" autocmd Filetype java set include=^#\s*import 
" autocmd Filetype java set includeexpr=substitute(v:fname,'\\.','/','g')
" autocmd Filetype java map gc gdbf
command Jtags :exe ":! ctags -R --language-force=java -f.tags ./" 
autocmd FileType java set tags=.tags
" autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java call Add_java_dirs_to_path()

" Define Function to set path for Java-Development:
fun! Add_java_dirs_to_path() 
  ruby << RUBY_CODE
  require 'open3'
  require 'set'
  result = []
  # Open3.popen3("find . -name '*.java'") { |stdin, stdout, stderr| result = stdout.readlines}
  # VIM.set_option((result.map do |src_dir| "path+=#{src_dir.strip.sub(/^\.\//, '').sub(/\/[^\/]+\.java$/, '/')}" end).to_set.to_a.join(','))
  # VIM.evaluate("javacomplete#AddSourcePath('src')") if File.exist?('src') && File.directory?('src')
  # VIM.evaluate("javacomplete#AddSourcePath('test')") if File.exist?('test') && File.directory?('test')
  Open3.popen3("find . -name '*.jar'") { |stdin, stdout, stderr| result = stdout.readlines}
  cp = ( result.map do |jar| "#{File.expand_path(jar.strip)}" end )
  # VIM.command("let g:java_classpath='#{cp.join(':')}'")
  VIM.command("let g:BeanShell_Cmd='java -Xms1024m -Xmx2048m -cp ~/bsh-2.0b4.jar:#{cp.join(':')}:classes bsh.Interpreter'")
RUBY_CODE
endfun

" Define Function Quick-Fix-List-Do:
fun! QuickfixLocationListDo(bang, command)
  let qflist={}
  if a:bang
    let tlist=map(getloclist(0), 'get(v:val, ''bufnr'')')
  else
    let tlist=map(getqflist(), 'get(v:val, ''bufnr'')')
  endif
  if empty(tlist)
    echomsg "Empty Quickfixlist. Aborting"
    return
  endif
  for nr in tlist
    let item=fnameescape(bufname(nr))
    if !get(qflist, item,0)
      let qflist[item]=1
    endif
  endfor
  :exe 'argl ' .join(keys(qflist))
  :exe 'argdo ' . a:command
endfunc

com! -nargs=+ -bang -bar Qldo :call QuickfixLocationListDo(<bang>0,<q-args>)


" AutocompletePopup claims, this is needed,
" though everything works fine without it.
" fun! GetSnipsInCurrentScope()
"   let snips = {}
"   for scope in [bufnr('%')] + split(&ft, '\\.') + ['_']
"     call extend(snips, get(s:snippets, scope, {}), 'keep')
"     call extend(snips, get(s:multi_snips, scope, {}), 'keep')
"   endfor
"   return snips
" endf
" let g:acp_behaviorSnipmateLength=1

" Enable JQuery-Syntax
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

"""""""""""""""""""""""""""""""""""
" Bram Moolenaar's .vimrc-example "
"""""""""""""""""""""""""""""""""""
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=1000	" keep 1000 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
map <Leader>o :DiffOrig <CR>

""""""""""""""""""""""""""""""""""""""""""
" End of Bram Moolenaar's .vimrc-example "
""""""""""""""""""""""""""""""""""""""""""

