call dein#add('lee-shun/vim-lsc', { 'lazy':1,
            \'on_event':['BufNewFile', 'BufReadPre'],
            \'hook_source':'source $CONF_PATH/plug_conf/before/vim_lsc_conf.vim'
            \})
