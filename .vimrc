set nocompatible " Vim not vi

" The following is needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 
runtime bundle/vim-pathogen.git/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()

let g:solarized_termtrans = 1

" Backup and Swap-Directories
set directory=~/.vim/tmp/swap
set backupdir=~/.vim/tmp/backup
" persistent undo:
if(version >= 703)
  set undofile
  set undodir=~/.vim/tmp/undo
endif

" Use Shift + Cursor-Keys to visually select in insert mode and automatically
" copy the selection to the clipboard: 
" Uncommented, because it interferes with using the cursor keys in visual mode.
" set guioptions+=a keymodel=startsel,stopsel

" General settings
let mapleader = ","
let maplocalleader = "-"
set wildmenu
set wildmode=full
set ls=2
map <Leader><Space> :copen <CR>
set hidden
syntax enable
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set number
" set relativenumber
filetype plugin indent on 
" No error-bell nor flash
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
set cursorline
"set autochdir " always switch to the current file directory
set ignorecase
set smartcase
" set hlsearch
noremap <LocalLeader>n :nohl <CR>

" Formatting:
map Q gq
"Format a paragraph:
nnoremap <Leader>q :normal Qipg;g;<CR>
"set textwidth=80
"Closest to multiple cursors / multiple editing, is to aply the dot command
"where you click with the mouse while holding down the ALT-Key.
noremap <M-LeftMouse> <LeftMouse> :normal . <CR>
"Remap Arrows to navigate with prepended 'g',
"so one can navigate through wrapped lines:
noremap <up> gk
noremap <down> gj
noremap k gk
noremap j gj
inoremap <A-k> <esc>g<up>i
inoremap <A-j> <esc>g<down>i
"Colorscheme & Font:
if has("mac")
  set gfn=Monaco:h13
  if !has('gui_running')
    colorscheme solarized
  else
    colorscheme jellybeans
  endif
  set background=dark
else
  set gfn=Monospace\ 12
  if !has('gui_running')
    colorscheme default
  else
    colorscheme jellybeans
  endif
endif

" Yankstack has to be initialized as early as possible:
call yankstack#setup()
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" Make Y behave just like C and D:
noremap Y y$

" Wrapping:
command! -nargs=* Wrap set wrap linebreak nolist
" set showbreak=…

" Surround for eruby:
autocmd FileType eruby let b:surround_37 = "<% \r %>"
autocmd FileType eruby let b:surround_61 = "<%= \r %>"
autocmd FileType eruby let b:surround_35 = "#{ \r }"
autocmd FileType ruby let b:surround_35 = "#{ \r }"

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" Spellcheck:
com Se set spell spelllang=en
com Sd set spell spelllang=de
" Ctrl-Z in INSERT mode will correct last misspelled word before current
" cursor position:
inoremap <C-z> <Esc>[s1z=gi

" Delete range without moving cursor:
com! -range D <line1>,<line2>d | norm <C-o>

" Supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabDefaultCompletionType = "<c-n>"
" Enable Tag-Completion with Supertab
" function MyTagContext()
"   if !empty(&tags)
"     return "\\<C-x>\\<C-]>"
"   endif
"   " no return will result in the evaluation of the next
"   " configured context
" endfunction
" let g:SuperTabCompletionContexts =
"       \\ ['MyTagContext', 's:ContextText', 's:ContextDiscover']

" acp - with snipmate and ctags:
" let g:acp_behaviorSnipmateLength = 1
let g:acp_ignorecaseOption = 1
let g:acp_behaviorKeywordLength = 3
let g:acp_completeOption = '.,w,b,u,t,i'

" preview
let g:PreviewBrowsers="open"
let g:PreviewCSSPath="/Users/ah/.vim/bundle/greyblake-vim-preview-2df4b44/my.css"

" Ruby-Rails
if has("mac")
  let g:ruby_debugger_progname = 'mvim'
  " let g:ruby_debugger_debug_mode = 1
  let g:ruby_debugger_builtin_sender = 0
else
  let g:ruby_debugger_progname = '/usr/bin/vim'
endif

" rails-vim and ctags
" ctag the RVM-Environment and write those tags into ./tmp/rvm_env_tags
fun! RtagsEnvFunky() 
  !mkdir -p ./tmp && ctags -f ./tmp/rvm_env_tags -R --langmap="ruby:+.rake.builder.rjs" --c-kinds=+p --fields=+S --languages=-javascript $GEM_HOME/gems $MY_RUBY_HOME 
  set tags+=tmp/rvm_env_tags
endfun
com! RtagsEnv :call RtagsEnvFunky()
if(filereadable("tmp/rvm_env_tags"))
  set tags+=tmp/rvm_env_tags
endif

" Cscope for Ruby on current directory.
" (
" To add GEMs and Ruby add following between '.' and '-iname':
" $GEM_HOME $MY_RUBY_HOME
" )
com! Rscope !find . -iname '*.rb' -o -iname '*.erb' -o -iname '*.rhtml' <bar> cscope -q -i - -b

if has("cscope")
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
  set cscopequickfix=s-,c-,d-,i-,t-,e-,g-,f-
endif

nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>
" end Cscope

" Taglist
map <LocalLeader>, :TlistToggle <CR>
map <LocalLeader>- :TlistUpdate <CR>
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1
let Tlist_Auto_Update = 1
let Tlist_Sort_Type = "name"
" enable support for R / Splus:
let tlist_r_settings = 'Splus;r:object/function'

" Folding stuff
set foldmethod=indent
set foldlevelstart=1
set foldminlines=1
set foldignore=''
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
" I prefer a snippet to convert '_<Tab>' into ' <- ':
let vimrplugin_assign = 0
if( filereadable( "/opt/share/software/packages/R-3.0.2/bin/R" ) )
  let vimrplugin_r_path = "/opt/share/software/packages/R-3.0.2/bin/R"
  " let vimrplugin_term_cmd = "tmux new-window '$DR'"
endif

" CtrlP:
map <Leader>, :CtrlP<CR>
map <Leader>. :CtrlPBuffer<CR>
map <Leader>- :CtrlPBufTag<CR>
map <Leader># :CtrlPTag<CR>
let g:ctrlp_match_window_bottom=0
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_last_entered=1
let g:ctrlp_open_new_file = 'r'
" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript']

" GotoSymbol:
nmap <LocalLeader># :GotoSymbol

" Enable vim-textobj-rubyblock
" which requires 'matchit':
:runtime macros/matchit.vim
" Add function object for R:
call textobj#user#plugin('f', {
      \   'code': {
      \     'pattern': ['^\s*\S\+\s*<-\s*function', '^\s*}'],
      \     'select-a': 'af',
      \     'select-i': 'if',
      \   },
      \ })

" Compile latex (for PhD-Thesis):
"================================
function! CompileLatex( ltxFile )
  call system( 'pdflatex -interaction=nonstopmode ' . a:ltxFile )
  call system( 'cd ' . fnamemodify( a:ltxFile, ':p:h') . ' && bibtex *.aux' )
  call system( 'pdflatex -interaction=nonstopmode ' . a:ltxFile )
  call system( 'pdflatex -interaction=nonstopmode ' . a:ltxFile )
  call system( 'open ' . fnamemodify( a:ltxFile, ':p:h' ) . '/' . fnamemodify( a:ltxFile, ':r' ) . '.pdf' )
endfunction
command! LC call CompileLatex( expand( '%' ) )


" VimDebug 
map <LocalLeader>1  : DBGRstart<CR>
map <LocalLeader>s/ : DBGRstart
map <LocalLeader>2  : call DBGRstep()<CR>
map <LocalLeader>3  : call DBGRnext()<CR>
map <LocalLeader>4  : call DBGRcont()<CR>                   " continue
map <LocalLeader>b  : call DBGRsetBreakPoint()<CR>
map <LocalLeader>d  : call DBGRclearBreakPoint()<CR>
map <LocalLeader>ca : call DBGRclearAllBreakPoints()<CR>
map <LocalLeader>v/ : DBGRprint
map <LocalLeader>v  : DBGRprintExpand expand("<cWORD>")<CR> " print value under the cursor
map <LocalLeader>/  : DBGRcommand
map <LocalLeader>5  : call DBGRrestart()<CR>
map <LocalLeader>6  : call DBGRquit()<CR>

" Define Function Quick-Fix-List-Do:
fun! QFDo(bang, command) 
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

com! -nargs=1 -bang Qfdo :call QFDo(<bang>0,<q-args>)

" Indexer enables automatic update of your exuberant-ctags generated
" tags-file, every time you save any of your project's code-containing files.
" Set it up to index any Ruby and RubyOnRails-Project in ~/projects:
" --------------------- example ~/.indexer_files ----------------------- 
" [PROJECTS_PARENT filter="**/*.rb **/*.erb **/*.rake"]
" ~/projects
" ------------------------------------------------------------------------------- 
" autocmd Filetype ruby let g:indexer_ctagsCommandLineOptions='--langmap="ruby:+.rake.builder.rjs" --languages=-javascript'
" autocmd Filetype java let g:indexer_ctagsCommandLineOptions='--language-force=java'
"
" Disable warning, if ctags does not match requirements:
let g:indexer_disableCtagsWarning=1 

" Vim and Java:
" http://everything101.sourceforge.net/docs/papers/java_and_vim.html
autocmd Filetype java set makeprg=ant\ -f\ build.xml 
autocmd Filetype java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
autocmd Filetype java set include=^#\s*import 
autocmd Filetype java set includeexpr=substitute(v:fname,'\\.','/','g')
autocmd Filetype java map gc gdbf
command Jtags :exe ":! ctags -R --language-force=java -f.tags ./" 
com! Jscope !find . -iname '*.java' <bar> cscope -q -i - -b
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
  VIM.set_option((result.map do |src_dir| "path+=#{src_dir.strip.sub(/^\.\//, '').sub(/\/[^\/]+\.java$/, '/')}" end).to_set.to_a.join(','))
  VIM.evaluate("javacomplete#AddSourcePath('src')") if File.exist?('src') && File.directory?('src')
  VIM.evaluate("javacomplete#AddSourcePath('test')") if File.exist?('test') && File.directory?('test')
  Open3.popen3("find . -name '*.jar'") { |stdin, stdout, stderr| result = stdout.readlines}
  cp = ( result.map do |jar| "#{File.expand_path(jar.strip)}" end )
  VIM.command("let g:java_classpath='#{cp.join(':')}'")
  VIM.command("let g:BeanShell_Cmd='java -Xms1024m -Xmx2048m -cp ~/bsh-2.0b4.jar:#{cp.join(':')}:classes bsh.Interpreter'")
RUBY_CODE
endfunc

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
