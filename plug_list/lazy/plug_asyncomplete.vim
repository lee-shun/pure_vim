call dein#add('prabirshrestha/asyncomplete-buffer.vim', {'lazy':1,
            \})

if executable('look')
call dein#add('htlsne/asyncomplete-look', {'lazy':1,
            \})
endif

call dein#add('prabirshrestha/asyncomplete-file.vim', {'lazy':1,
            \})

call dein#add('prabirshrestha/asyncomplete-emoji.vim', {'lazy':1,
            \})

" tabnine
if g:os_architect != 'aarch64'
    if g:os_name == 'Linux'
        call dein#add('kitagry/asyncomplete-tabnine.vim', { 'lazy':1,
                    \'build': './install.sh' })
    elseif g:os_name == 'Windows'
        call dein#add('kitagry/asyncomplete-tabnine.vim', { 'lazy':1,
                    \'build': 'powershell.exe .\install.ps1' })
    endif
endif

" snip
if has('python3') && dein#tap('ultisnips')
    call dein#add('prabirshrestha/asyncomplete-ultisnips.vim', {'lazy':1,
                \})
endif

" lsp
if g:osv_vim_lsp == 1
    call dein#add('prabirshrestha/asyncomplete-lsp.vim', {'lazy':1,
                \})
    call dein#add('andreypopp/asyncomplete-ale.vim', {'lazy':1
                \})
endif

" ===
" === setting
" ===
let g:asyncomplete_conf = { 'lazy':1,
            \'depends': ['asyncomplete-buffer.vim', 'asyncomplete-file.vim', 'asyncomplete-emoji.vim'],
            \'on_event': ['BufReadPre'],
            \'hook_source':'source $CONF_PATH/plug_conf/before/asyncomplete_conf.vim',
            \'hook_post_source':'source $CONF_PATH/plug_conf/after/asyncomplete_conf.vim'}

if dein#tap('asyncomplete-look.vim')
    call add(g:asyncomplete_conf.depends, 'asyncomplete-look.vim')
endif

if dein#tap('asyncomplete-lsp.vim')
    call add(g:asyncomplete_conf.depends, 'asyncomplete-lsp.vim')
endif

if dein#tap('asyncomplete-ale.vim')
    call add(g:asyncomplete_conf.depends, 'asyncomplete-ale.vim')
endif

if dein#tap('asyncomplete-tabnine.vim')
    call add(g:asyncomplete_conf.depends, 'asyncomplete-tabnine.vim')
endif

if dein#tap('asyncomplete-ultisnips.vim')
    call add(g:asyncomplete_conf.depends, 'asyncomplete-ultisnips.vim')
endif

if has('nvim')
    let g:asyncomplete_conf.hook_done_update = 'UpdateRemotePlugins'
endif

call dein#add('prabirshrestha/asyncomplete.vim', g:asyncomplete_conf)
