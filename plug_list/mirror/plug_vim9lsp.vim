let s:vim_lsp_conf = {'lazy':1,
            \'on_event':['BufReadPre','BufNewFile'],
            \'depends':[],
            \'hook_source':'source $CONF_PATH/plug_conf/before/vim9_lsp_conf.vim',
            \'hook_post_source':'source $CONF_PATH/plug_conf/after/vim9_lsp_conf.vim',
            \}

call dein#add('old_school_vim/lsp',s:vim_lsp_conf)
