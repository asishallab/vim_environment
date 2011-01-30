" Johans nexus filetype file
if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	au! BufRead,BufNewFile *.nex		setfiletype nexus
	au! BufRead,BufNewFile *.nexus		setfiletype nexus
	au! BufRead,BufNewFile *.nxs		setfiletype nexus
	au! BufRead,BufNewFile *.nx		    setfiletype nexus
augroup END
