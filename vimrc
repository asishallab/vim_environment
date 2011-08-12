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
" No error-bell nor flash
set noerrorbells
set visualbell
set vb t_vb=
"set autochdir " always switch to the current file directory
set hlsearch
"set textwidth=80
colorscheme macvim
set gfn=Monospace\ 12

" autocmd BufNewFile,BufRead set nowrap
" Wraping and moving in wrapped lines:
set wrap linebreak nolist
set showbreak=…
vmap <C-j> gj
vmap <C-k> gk
vmap <C-4> g$
vmap <C-6> g^
vmap <C-0> g^
nmap <C-j> gj
nmap <C-k> gk
nmap <C-4> g$
nmap <C-6> g^
nmap <C-0> g^

" Surround for eruby:
autocmd FileType eruby let b:surround_37 = "<% \r %>"
autocmd FileType eruby let b:surround_61 = "<%= \r %>"
autocmd FileType eruby let b:surround_35 = "#{ \r }"

" Set an orange cursor in insert mode, and a red cursor otherwise.
" Works at least for xterm and rxvt terminals.
" Does not work for gnome terminal, konsole, xfce4-terminal.
if !has('gui_running') && &term =~ "xterm\\|rxvt"
  :silent !echo -ne "\033]12;red\007"
  let &t_SI = "\033]12;black\007"
  let &t_EI = "\033]12;red\007"
  autocmd VimLeave * :!echo -ne "\033]12;black\007"
endif

" Spellcheck:
set spell spelllang=en

" Supertab
let g:SuperTabDefaultCompletionType = "context"
" Enable Tag-Completion with Supertab
function MyTagContext()
  if !empty(&tags)
    return "\<C-x>\<C-]>"
  endif
  " no return will result in the evaluation of the next
  " configured context
endfunction
let g:SuperTabCompletionContexts =
      \ ['MyTagContext', 's:ContextText', 's:ContextDiscover']

" acp - with snipmate and ctags:
let g:acp_behaviorSnipmateLength = 1
let g:acp_ignorecaseOption = 1
let g:acp_behaviorKeywordLength = 1
let g:acp_completeOption = '.,w,b,u,t,i'

" preview
let g:PreviewBrowsers="open -a Chromium"
let g:PreviewCSSPath="/Users/ah/.vim/bundle/greyblake-vim-preview-2df4b44/my.css"

" Ruby-Rails
let g:ruby_debugger_progname = '/usr/bin/vim'
let g:rails_ctags_arguments='--c-kinds=+p --fields=+S --languages=-javascript $GEM_HOME/gems '

" Cscope:
com! CsRef !find . $GEM_HOME/gems -iname '*.rb' -o -iname '*.erb' -o -iname '*.rhtml' <bar> cscope -q -i - -b
:cs add ./cscope.out

" Taglist
map <LocalLeader>, :TlistToggle <CR>
map <LocalLeader>- :TlistUpdate <CR>
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1
let Tlist_Auto_Update = 1

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

" Command-T
map <Leader># :CommandT <CR>
map <Leader>+ :CommandTBuffer <CR>
" Fuzzy Finder:
map <Leader>, :FufFile **/<CR>
map <Leader>. :FufBuffer <CR>
" Flush CommandT and FuzzyFinder Cashes
map <Leader>- 
      \:silent :CommandTFlush <CR> <bar>
      \:silent :FufRenewCache <CR>

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
autocmd Filetype java set makeprg=ant\\ -f\\ build.xml 
autocmd Filetype java set efm=%A\\ %#[javac]\\ %f:%l:\\ %m,%-Z\\ %#[javac]\\ %p^,%-C%.%#
autocmd Filetype java set include=^#\\s*import 
autocmd Filetype java set includeexpr=substitute(v:fname,'\\\\.','/','g')
autocmd Filetype java map gc gdbf
command Jtags :exe ":! ctags -R --language-force=java -f.tags ./" 
autocmd FileType java set tags=.tags
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java call Add_java_dirs_to_path()

" Define Function to set path for Java-Development:
fun! Add_java_dirs_to_path() 
  ruby << RUBY_CODE
  require 'open3'
  require 'set'
  result = []
  Open3.popen3("find . -name '*.java'") { |stdin, stdout, stderr| result = stdout.readlines}
  VIM.set_option((result.map do |src_dir| "path+=#{src_dir.strip.sub(/^\\.\\//, '').sub(/\\/[^\\/]+\\.java$/, '/')}" end).to_set.to_a.join(','))
  VIM.evaluate("javacomplete#AddSourcePath('src')") if File.exist?('src') && File.directory?('src')
  VIM.evaluate("javacomplete#AddSourcePath('test')") if File.exist?('test') && File.directory?('test')
  Open3.popen3("find . -name '*.jar'") { |stdin, stdout, stderr| result = stdout.readlines}
  cp = ( result.map do |jar| "#{File.expand_path(jar.strip)}" end )
  VIM.command("let g:java_classpath='#{cp.join(':')}'")
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
