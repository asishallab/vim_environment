set bg=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let colors_name = "amber"

hi Spell	ctermfg=yellow gui=underline cterm=underline term=underline guifg=#adbf94
hi SpellErrors	gui=underline cterm=underline term=underline

hi Normal	guifg=#bfad94 guibg=#000000	ctermfg=gray ctermbg=black
hi ErrorMsg	guifg=#ffffff guibg=#287eff	ctermfg=white ctermbg=lightblue
hi Visual	guifg=#8080ff guibg=fg	gui=reverse	ctermfg=lightblue ctermbg=fg cterm=reverse
hi VisualNOS	guifg=#8080ff guibg=fg	gui=reverse,underline	ctermfg=lightblue ctermbg=fg cterm=reverse,underline

hi SpecialKey	guifg=cyan	ctermfg=darkcyan
hi Directory	guifg=cyan	ctermfg=cyan
hi Title	guifg=magenta gui=none ctermfg=magenta cterm=bold
hi WarningMsg	guifg=red	ctermfg=red
hi WildMenu	guifg=yellow guibg=black ctermfg=yellow ctermbg=black cterm=none term=none
hi ModeMsg	guifg=#22cce2	ctermfg=lightblue
hi MoreMsg	ctermfg=darkgreen	ctermfg=darkgreen
hi Question	guifg=green gui=none ctermfg=green cterm=none
hi NonText	guifg=#0030ff	ctermfg=darkblue

hi StatusLine	guifg=blue guibg=darkgray gui=none	ctermfg=blue ctermbg=gray term=none cterm=none
hi StatusLineNC	guifg=black guibg=darkgray gui=none	ctermfg=black ctermbg=gray term=none cterm=none
hi VertSplit	guifg=black guibg=darkgray gui=none	ctermfg=black ctermbg=gray term=none cterm=none

hi Folded	guifg=#808080 guibg=#000040	ctermfg=darkgrey ctermbg=black cterm=bold term=bold
hi FoldColumn	guifg=#808080 guibg=#000040	ctermfg=darkgrey ctermbg=black cterm=bold term=bold
hi LineNr	guifg=#90f020	ctermfg=green cterm=none

hi DiffAdd	guibg=darkblue	ctermbg=darkblue term=none cterm=none
hi DiffChange	guibg=darkmagenta ctermbg=magenta cterm=none
hi DiffDelete	ctermfg=blue ctermbg=cyan gui=bold guifg=Blue guibg=DarkCyan
hi DiffText	cterm=bold ctermbg=red gui=bold guibg=Red

hi Cursor	guifg=#000020 guibg=#ffaf38 ctermfg=bg ctermbg=brown
hi lCursor	guifg=#ffffff guibg=#000000 ctermfg=bg ctermbg=darkgreen

hi Underlined	cterm=underline term=underline
hi Ignore	guifg=bg ctermfg=bg

hi Comment	guifg=#6ed645 guibg=#131c02 gui=italic          ctermfg=darkgreen
hi CodeComment	guibg=#131c02 guifg=#63b7ff                     ctermfg=lightgreen
hi Todo		guifg=#90ff00 guibg=#4c622f gui=bold            ctermbg=darkblue    ctermfg=yellow

hi Statement	guifg=#b1ffef gui=bold                          ctermfg=lightcyan
hi Type		guifg=#72bfb7                                   ctermfg=darkcyan
hi Operator	guifg=#00d4c8                                   ctermfg=white
hi Identifier	guifg=#ffc659                                   ctermfg=darkyellow
hi Label	guifg=#8f8f9b                                   ctermfg=lightblue

hi String	guifg=#ff8400 guibg=#2a1703 gui=italic          ctermfg=yellow
hi Character	guibg=#2a1703 guifg=#ff5400                     ctermfg=yellow
hi Number	guifg=#ff8400                                   ctermfg=yellow
hi Special	guifg=#ff8400 guibg=#2a1703 gui=bold            ctermfg=lightcyan
hi Constant	guifg=#ff5400                                   ctermfg=lightred

hi PreProc	guifg=#8f8f9b guibg=#212126                     ctermfg=lightblue
hi Macro	guifg=#a4a4b3 guibg=#212126                     ctermfg=lightblue

hi Search	guifg=#90fff0 guibg=#2050d0	ctermfg=lightgreen ctermbg=darkgreen term=underline
hi IncSearch	guifg=#b0ffff guibg=#2050d0	ctermfg=lightgreen ctermbg=darkgreen
hi MatchParen   ctermfg=white cterm=bold guifg=#ffffff ctermbg=bg guibg=bg
