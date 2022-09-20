" 版本配置 保证neovim >= 0.7.0,能够运行lua

" 也可以用lua这种编程语言进行配置管理，因为lua的语法可能对我更加友好
" 但现在还是暂定用vimscirpt进行配置,以后再改用lua进行配置

" 使用vim-plug进行插件管理
" 用:PlugInstall命令下载插件
" 调用位于~/.config/nvim/plugged目录下的插件
call plug#begin('~/.config/nvim/plugged')

" easymotion插件，按住两下先导键和对应键在屏幕中进行跳跃
Plug 'easymotion/vim-easymotion'

" nvim-tree插件，进行文件树的管理
Plug 'kyazdani42/nvim-tree.lua'

" 给nvim-tree打开的文件树加上图标(用在nerd fonts下的jetbrain-font)
Plug 'kyazdani42/nvim-web-devicons'

" lsp插件 language server provider,代码提供插件，也可以用COC插件
" 代码规范校验,查找函数定义，实现，文档，说明
" 但不能进行代码自动补全
Plug 'prabirshrestha/vim-lsp'

" easily setup language servers using vim-lsp automatically
" 用:LspInstallServer命令自动下载对应语言的语言服务器
Plug 'mattn/vim-lsp-settings' 

" 实现代码自动补全，和vim-lsp配套使用
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Insert or delete brackets, parens, quotes in pair.
" 成对插入或删除括号、括号、引号
Plug 'jiangmiao/auto-pairs'

" 结束插件导入 
call plug#end() 

" mapleader变量代表<leader>的值,设置<leader>值为空格键
" <leader> -> ' '
let mapleader = ' '

" 执行lua语句，直到输入EOF（End Of File)结束,类似python3 << EOF; EOF 用其来执行需要lua语言进行配置的插件 
lua << EOF

-- nvim_tree插件配置

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- 进行nvim-tree插件的设置
require("nvim-tree").setup({
  sort_by = "case_sensitive",
	
  -- 文件树的view（视图）
  view = {

    -- 设置窗口大小自动适应
    adaptive_size = true,

    -- 在文件树窗口下的键位映射
    mappings = {

      -- 进行自定义键位映射
      list = {

	-- navigate up to the parent directory of the current file/directory
	-- 导航到当前游标所在的父文件夹并收起所有文件夹
        -- u -> dir_up
        { key = "u", action = "dir_up" },

	-- cd in the directory under the cursor
	-- 进入游标所指的文件夹并使其为根目录
	-- <c-o> -> cd
	-- <c-cr> -> cd
	{ key = "<leader>o", action = "cd"},
	{ key = "<leader><cr>",action = "cd"},
      },
    },
  },
  renderer = {
    group_empty = true,
  },

  -- 判断文件树下什么类型的文件要不要显示
  filters = {

    -- 设置dot(.文件)显示
    dotfiles = false,
  },
})

-- lua语句结束的标志
EOF

" nvim-tree命令的映射

" Open or close the tree. Takes an optional path argument.
" 打开或关闭一个文件树,若未给出参数，默认打开缓冲区文件中的文件夹
" 若给出路径参数,则打开对应路径文件的文件夹
" 在此设置中，只考虑默认值
nnoremap <leader>t :NvimTreeToggle<cr> 

" Collapses the nvim-tree recursively.
" 递归摧毁一个nvim-tree,即收起文件夹直到根文件夹
nnoremap <leader>c :NvimTreeCollapse<cr>

" 针对lsp在窗口的补全

" 定义函数on_lsp_buffer_enabled，当有使用lsp的buffer（文件页面),使用函数中的键位映射
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    	" <buffer>关键字表仅在当前缓冲区生效,对于每个用到lsp的缓冲区文件起效是通过条件判断语句

	" 从函数调用处查找到函数定义处
	nmap <buffer> gd <plug>(lsp-definition)
	" 从函数定义处，找到调用处，并提供跳转选项 
	nmap <buffer> gr <plug>(lsp-references)
	" 查看函数的注释，文档，用法(实现hover效果,即jetbrain家中的悬停效果）
	" vim原生K就是用man命令打开光标所在单词的手册页
	nmap <buffer> K <plug>(lsp-hover)

	nmap <buffer> gs <plug>(lsp-document-symbol-search)
	nmap <buffer> gS <plug>(lsp-workspace-symbol-search)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!

    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    " 当lsp服务被启用(语言服务已经被注册)_，调用on_lsp_buffer_enabled函数,只在这个局部有用(<buffer>关键词的作用)
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" easymotion的映射，按两次<leader>键触发使用

" 查找两个字符 
" 由于感觉用的不舒服，所以注释了
" map <leader><leader>s2 <plug>(easymotion-s2) 

" 用于寻找任意长度的字符，按<tab>键进行跨页寻找
map <leader><leader>/ <plug>(easymotion-sn)

" 向后寻找
map <leader><leader>n <plug>(easymotion-next)

" 向前寻找
map <leader><leader>N <plug>(easymotion-prev)

" 在插入模式下使用非递归映射映射jk为退出键
" jk -> <esc>
inoremap jk <esc>

" 对插入模式下的向前删除键<del>进行重映射到<c-d>
" <del> -> <c-d>
inoremap <c-d> <del> 

" 在normal模式下用于去除set hlsearch搜索产生的高亮部分
" <c-n>s -> :nohlsearch<cr>
nnoremap <c-n>s :nohlsearch<CR>

" 设置语法高亮提示，按照文件的后缀名(*.py,*.cpp)带来不同的语法提示，如果关闭将没有任何提示
syntax on 

" 显示行号
set number 

" 设置相对行号
set relativenumber

" 高亮光标所在行
set cursorline

" 设置vim的自动折行，将超出屏幕范围内的文本打断并显示在在下一行,如果
" 不设置，超出范围的文本将被隐藏，需要向句末移动光标，以使屏幕水平滚动，查看一行的完整内容
set wrap

" 显示还没有输入完整的命令，例如yy命令，输入第一个y时会在右下角显示y
set showcmd

" 在命令模式，输入前半部分，使用tab键补全时，在命令行的状态栏显示
" 所有符合匹配的命令对象
set wildmenu

" 高亮显示所有用/或?搜索到的内容
" 搜索完成后不会自动去除高亮，所以映射<c-n>s用于消除高亮
set hlsearch 

" 光标立刻跳转到搜索到内容
set incsearch

" vim默认是区分大小写进行搜索，现设置在搜索模式下，忽略大小写进行搜索
set ignorecase

" 只能在ignorecase模式开启下开启，只能判断用户是否要忽略大小写
" 如果用户输入字符串为全小写,那么忽略大小写搜索
" 如果用户输入的字符串中有大写字母,那么不忽视大小写进行搜索
set smartcase
