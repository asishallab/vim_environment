""" align.vim
""" 2009-10-15
""" Johan Nylander
"""
hi MyA ctermfg=white ctermbg=red guifg=white guibg=red
hi MyC ctermfg=white ctermbg=blue guifg=white guibg=blue
hi MyG ctermfg=white ctermbg=black guifg=white guibg=black
hi MyT ctermfg=white ctermbg=green guifg=white guibg=green
hi MyGap ctermfg=white ctermbg=grey guifg=white guibg=grey
"""
""" Two alternatives for highlighting letters in alignments:
""" The first highlights letters anywhere
""" in the file (in taxon labels as well as in the sequences).
"""
syn match MyA "[Aa]"
syn match MyC "[Cc]"
syn match MyG "[Gg]"
syn match MyT "[Tt]"
syn match MyGap "-"
"""
""" The second tries to only match letters in the actual sequence.
""" Works best on a two string line, with no white space at
""" the beginning of the line.
""" The search pattern below is, however, painfully slow.
""" Can be good for viewing smaller alignments.
"""
"syn match MyA "\(\s\+\S*\)\@<=A\c"
"syn match MyC "\(\s\+\S*\)\@<=C\c"
"syn match MyG "\(\s\+\S*\)\@<=G\c"
"syn match MyT "\(\s\+\S*\)\@<=T\c"
"syn match MyGap "\(\s\+\S*\)\@<=-"

""" Uncomment if you want the wordwrapping to be autmatically toggled.
" set wrap!
