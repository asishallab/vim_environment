set nocompatible " Vim not vi

" The following is needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 

" Vim-Plug
call plug#begin('~/.vim/plugged')
Plug 'kien/ctrlp.vim'
Plug 'sjl/gundo.vim'
Plug 'hoxnox/indexer.vim'
Plug 'vim-syntastic/syntastic'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'jpalardy/vim-slime'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-surround'
Plug 'jelera/vim-javascript-syntax'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-scripts/Vim-R-plugin'
Plug 'derekwyatt/vim-scala'
" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'vim-scripts/DfrankUtil' | Plug 'vim-scripts/vimprj'
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Add plugins to &runtimepath
call plug#end()

" Make Y behave just like C and D:
noremap Y y$

" See :help 'guicursor'
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" Backup and Swap-Directories
set directory=~/.vim/tmp/swap
set backupdir=~/.vim/tmp/backup
" persistent undo:
if(version >= 703)
  set undofile
  set undodir=~/.vim/tmp/undo
endif

" General settings
let mapleader = "\<space>"
let maplocalleader = "\\"
set wildmenu
set wildmode=full
set ls=2
set hidden
syntax enable
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set number
set relativenumber
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

" Toggle NERDTree:
nnoremap <Leader>n :NERDTreeToggle<CR>

" Close all Buffers except the current one:
com! -nargs=0 BufOnly :%bd | e#


" Formatting:
map Q gq
"Format a paragraph:
nnoremap <Leader>q :normal Qipg;g;<CR>
"set textwidth=80

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
  colorscheme jellybeans
  set background=dark
else
  set gfn=Monospace\ 12
  if !has('gui_running')
    colorscheme jellybeans
  else
    colorscheme jellybeans
  endif
endif

" Yankstack:
nmap <Leader>p <Plug>yankstack_substitute_older_paste
nmap <Leader>P <Plug>yankstack_substitute_newer_paste

" Wrapping:
command! -nargs=* Wrap set wrap linebreak nolist
" set showbreak=…

" vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_default_config = {"socket_name": "default", "target_pane": "2"}

" Surround for eruby:
" autocmd FileType eruby let b:surround_37 = "<% \r %>"
" autocmd FileType eruby let b:surround_61 = "<%= \r %>"
" autocmd FileType eruby let b:surround_35 = "#{ \r }"
" autocmd FileType ruby let b:surround_35 = "#{ \r }"

" Spellcheck:
com Se set spell spelllang=en
com Sd set spell spelllang=de
" Ctrl-Z in INSERT mode will correct last misspelled word before current
" cursor position:
inoremap <C-z> <Esc>[s1z=gi

" Format Javascript Code-File:
autocmd FileType javascript setlocal equalprg=js-beautify\ --stdin\ -s\ 2\ -w\ 80
augroup filetypedetect
  " associate *.ejs with javascript filetype
  au BufRead,BufNewFile *.ejs setfiletype javascript
  au BufRead,BufNewFile *.vue setfiletype javascript
augroup END

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
" set foldmethod=indent
" set foldlevelstart=1
" set foldminlines=1
" set foldignore=''
"hi Folded guibg=red guifg=Red cterm=bold ctermbg=DarkGrey ctermfg=lightblue
"hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
"set foldcolumn=2
"set foldclose=
"set foldnestmax=2
"set fillchars=vert:\|,fold:\

" Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" CtrlP:
map <Leader><space> :CtrlP<CR>
map <Leader>, :CtrlPBuffer<CR>
map <Leader>. :CtrlPTag<CR>
map <Leader>\\ :CtrlPBufTag<CR>
let g:ctrlp_match_window_bottom=0
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_last_entered=1
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript']

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
set nohlsearch " No highlighting of search terms

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
