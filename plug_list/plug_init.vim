" ===
" === check the dein version
" ===
if has('nvim')
    if has('nvim-0.8')
        let s:osv_dein_version = 'master'
    elseif has('nvim-0.5')
        let s:osv_dein_version = '3.1'
    elseif has('nvim-0.2')
        let s:osv_dein_version = '2.2'
    else
        let s:osv_dein_version = '1.5'
    endif
else " vim
    if v:version >= 802
        let s:osv_dein_version = 'master'
    elseif v:version >= 800
        let s:osv_dein_version = '2.2'
    elseif v:version >= 704
        let s:osv_dein_version = '1.5'
    endif
endif

let s:dein_cache_dir = $CONF_PATH.'/dein'
let s:version_tail = s:osv_dein_version=='master' ? '' : '_'.s:osv_dein_version
let s:dein_src = $CONF_PATH.'/dein/repos/github.com/Shougo/dein.vim' . s:version_tail

" install dein for the first time
let s:osv_setup = 0
if empty(glob(s:dein_cache_dir))
    let s:osv_setup = 1
    " install dein.vim
    call osv_ultis#system#exec("git clone --branch ".s:osv_dein_version." https://github.com/Shougo/dein.vim " . s:dein_src)
    call osv_ultis#msg#info("Install dein ".s:osv_dein_version." to ".s:dein_src . '!')
    call input("Press any key to continue...")
endif
let &runtimepath.=','.s:dein_src

call dein#begin(s:dein_cache_dir)

" add dein.vim as a local plugin
call dein#add(s:dein_src)

if g:osv_plug_general == 1
    source $CONF_PATH/plug_list/lazy/plug_general.vim
endif

if g:osv_plug_advanced == 1
    source $CONF_PATH/plug_list/lazy/plug_advanced.vim
endif

source $CONF_PATH/plug_list/lazy/plug_finder.vim

source $CONF_PATH/plug_list/lazy/plug_file_explorer.vim

if g:osv_complete_engine == 'coc'
    source $CONF_PATH/plug_list/lazy/plug_coc.vim
endif

if g:osv_complete_engine == 'deoplete'
    source $CONF_PATH/plug_list/lazy/plug_deoplete.vim
endif

if g:osv_complete_engine == 'asyncomplete'
    source $CONF_PATH/plug_list/lazy/plug_asyncomplete.vim
endif

if g:osv_complete_engine == 'mucomplete'
    source $CONF_PATH/plug_list/lazy/plug_mucomplete.vim
endif

if g:osv_linter == 'ale'
    source $CONF_PATH/plug_list/lazy/plug_ale.vim
endif

if g:osv_lsp == 'vim-lsp'
    source $CONF_PATH/plug_list/lazy/plug_lsp.vim
endif

if g:osv_lsp == 'lcn'
    source $CONF_PATH/plug_list/lazy/plug_lcn.vim
endif

if g:osv_lsp == 'vim-lsc'
    source $CONF_PATH/plug_list/lazy/plug_lsc.vim
endif


call dein#end()

augroup DeinSetup
    autocmd!
    autocmd VimEnter * call dein#call_hook('source') | call dein#call_hook('post_source')
augroup END

if s:osv_setup == 1
    call dein#update()
    call osv_ultis#msg#info("Install the plugins with dein#update().")
    if has('nvim') && has('python3')
        execute "UpdateRemotePlugins"
    endif
    call input("Press any key to continue...")
endif

" Run update every day automatically when entering Vim.
if s:osv_setup == 0
    function! AutoUpdateVimPlug() abort
        let l:filename = $CONF_PATH.'/tmp/plug_update_time'
        if filereadable(l:filename) == 0
            call writefile([], l:filename)
        endif
        let l:today = strftime('%Y_%m_%d')
        let l:contents = readfile(l:filename)

        if index(l:contents, l:today) < 0

            " update the repo first
            let l:osv_update = input("Update old school vim with remote, [y/n]?\n")
            if l:osv_update == 'y'
                let l:git_clean = osv_ultis#system#exec(["cd ".$CONF_PATH, "git status -s"]) is# ''
                if l:git_clean == 1
                    call osv_ultis#system#exec(["cd ".$CONF_PATH, "git pull"])
                else
                    call osv_ultis#msg#err("git status is not clean!")
                    let l:force_update = input("Force update? [y/n]?\n")
                    if l:force_update == 'y'
                        call osv_ultis#system#exec(
                                    \["cd ".$CONF_PATH,
                                    \ "git fetch",
                                    \ "git reset --hard origin/master",
                                    \ "git pull"]
                                    \)
                    else
                        call osv_ultis#msg#info("Skip force updating!")
                    endif
                endif
            else " do not update
                call osv_ultis#msg#info("Skip updating old school vim!")
            endif

            " update the plugins
            let l:choice = input("Update vim plugins, [y/n]?\n")
            if l:choice == 'y'
                call dein#update()
                call dein#recache_runtimepath()
            else
                call osv_ultis#msg#info("Skip updating plugins!")
            endif

            call writefile([l:today], l:filename, 'a')
            if has('nvim') && has('python3')
                execute "UpdateRemotePlugins"
            endif
        endif
    endfunction

    augroup AutoUpdatePlugGroup
        autocmd!
        autocmd VimEnter * call AutoUpdateVimPlug()
    augroup END

endif
