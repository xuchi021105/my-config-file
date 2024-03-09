-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.builtin.terminal.open_mapping = "<c-t>"
lvim.keys.insert_mode["jk"] = "<esc>"
lvim.transparent_window = true
lvim.keys.normal_mode["<leader>bk"] = ":BufferKill<CR>"

vim.o.cursorline = true
vim.o.cursorcolumn = true

-- lvim的默认锁进是2, 但是我这里改为4
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- 注意, 其中lsp有两个很有用的功能, 一个是<leader>lf 另一个是gr以及对应的gpr(可以预览)

lvim.keys.insert_mode["<C-A>"] = "<HOME>"
lvim.keys.insert_mode["<C-E>"] = "<END>"
lvim.keys.insert_mode["<C-B>"] = "<S-left>"
lvim.keys.insert_mode["<C-F>"] = "<S-right>"

lvim.keys.normal_mode["H"] = "^"
lvim.keys.normal_mode["L"] = "$"

lvim.keys.visual_mode["<leader>t"] = "<cmd>Translate<CR>" -- 这个<cmd>是标记后面的字符串是一个命令, 在普通的vim中是用:来指明命令的
lvim.keys.normal_mode["<leader>t"] = "<cmd>Translate<CR>" -- 这个<cmd>是标记后面的字符串是一个命令, 在普通的vim中是用:来指明命令的

lvim.builtin.alpha.dashboard.section.footer.val = "talk is cheap, show me the code"
lvim.builtin.lualine.style = "default" -- 这个用的是lualine.nvim这个状态栏插件, 这里可以配成lvim也可以配成default, 我这里更喜欢这个一点(default)
lvim.builtin.lualine.sections.lualine_c = {
    {
        "filename",
        path = 1, -- 设置为 1 或 "relative" 以显示相对于项目根的路径, 这样能够实现类似breadcrumbs的功能
    },
}

lvim.plugins = {
    -- 这个好好用啊, 可以考虑不用s和S, 其中考虑用leader键盘, 是重写了easymotion的nvim版本
    {
        "phaazon/hop.nvim",
        event = "BufRead",
        config = function()
            require("hop").setup()
            -- leader键在第二个参数中用, 其中用K来查看注释
            vim.api.nvim_set_keymap("n", "s", ":HopWord<cr>", { silent = true })
            vim.api.nvim_set_keymap("n", "S", ":HopChar2<cr>", { silent = true })
        end,
    },

    -- 会标记当前cursor下的单词, 和ide中的一个功能很像
    {
        "itchyny/vim-cursorword",
        event = { "BufEnter", "BufNewFile" },
        config = function()
            vim.api.nvim_command("augroup user_plugin_cursorword")
            vim.api.nvim_command("autocmd!")
            vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
            vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
            vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
            vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
            vim.api.nvim_command("augroup END")
        end
    },

    -- 类似vsc下面的跳转预览, 但是我感觉这个强多了
    {
        "rmagatti/goto-preview",
        config = function()
            require('goto-preview').setup {
                width = 120,             -- Width of the floating window
                height = 25,             -- Height of the floating window
                default_mappings = true, -- Bind default mappings
                debug = false,           -- Print debug information
                opacity = nil,           -- 0-100 opacity level of the floating window where 100 is fully transparent.
                post_open_hook = nil     -- A function taking two arguments, a buffer and a window to be ran as a hook.
                -- You can use "default_mappings = true" setup option
                -- Or explicitly set keybindings
                -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
                -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
                -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
            }
        end
    },

    {
        "folke/todo-comments.nvim",
        event = "BufRead",
        config = function()
            require("todo-comments").setup()
        end,
    },

    -- Show current function at the top of the screen when function does not fit in screen
    -- 这个能够ide一样在head上面显示当前的函数, 当前的文件以及嵌套对象, 这个是通过解析抽象语法数得到的
    {
        "romgrk/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup {
                enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
                throttle = true, -- Throttles plugin updates (may improve performance)
                max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = {     -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    -- For all filetypes
                    -- Note that setting an entry here replaces all other patterns for this entry.
                    -- By setting the 'default' entry below, you can control which nodes you want to
                    -- appear in the context window.
                    default = {
                        'class',
                        'function',
                        'method',
                    },
                },
            }
        end
    },

    -- {
    --   "p00f/nvim-ts-rainbow",
    -- },
    {
        "tpope/vim-repeat"
    },
    {
        "tpope/vim-surround"
    },
    -- 貌似用不了, 有机会找下原因
    -- {
    --   'wfxr/minimap.vim',
    --   build = "cargo install --locked code-minimap",
    --   cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    --   config = function ()
    --     vim.cmd ("let g:minimap_width = 10")
    --     vim.cmd ("let g:minimap_auto_start = 1")
    --     vim.cmd ("let g:minimap_auto_start_win_enter = 1")
    --   end,
    -- },
    -- 这个能够实现用:{number}跳转的时候, 实现预览功能, 不过我一般跳转都是 {number}G 这样跳转的, 不过这两个效果等价
    {
        "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
            require("numb").setup {
                show_numbers = true,    -- Enable 'number' for the window while peeking
                show_cursorline = true, -- Enable 'cursorline' for the window while peeking
            }
        end,
    },
    -- 能够记住上次退出时cursor的位置, 这个可以考虑注释
    {
        "ethanholz/nvim-lastplace",
        event = "BufRead",
        config = function()
            require("nvim-lastplace").setup({
                lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                lastplace_ignore_filetype = {
                    "gitcommit", "gitrebase", "svn", "hgcommit",
                },
                lastplace_open_folds = true,
            })
        end,
    },
    -- 能够更平滑的移动,但是可以考虑注释了
    {
        "karb94/neoscroll.nvim",
        event = "WinScrolled",
        config = function()
            require('neoscroll').setup({
                -- All these keys will be mapped to their corresponding default scrolling animation
                mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
                    '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
                hide_cursor = true,          -- Hide cursor while scrolling
                stop_eof = true,             -- Stop at <EOF> when scrolling downwards
                use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
                respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                easing_function = nil,       -- Default easing function
                pre_hook = nil,              -- Function to run before the scrolling animation starts
                post_hook = nil,             -- Function to run after the scrolling animation ends
            })
        end
    },

    -- 这个copilot.lua是真正来补全的, 其中copilot.cmp是一个进行比较的源，
    -- 就是会给出多个然后让你选, 我觉得是应该只要copilot.lua就差不多了
    -- 这个到时候看是用可选(cmp)的版本还是类似ide中的版本
    {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            vim.defer_fn(function()
                require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
                require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
            end, 100)
        end,
    },
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        -- tag = "*",
        dependencies = { "nvim-lua/plenary.nvim" },
        fd = "norg", -- 设置只在ext(文件名后缀)为norg的时候启用
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},  -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.dirman"] = {      -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                },
            }
        end,
    },

    {
        "sindrets/diffview.nvim",
        event = "BufRead",
    },
    -- 这个是设置直接显式的显示出git commit的作者信息和时间, 其中lvim的gitsigns是隐式的, 要<leader>gl才行
    {
        "f-person/git-blame.nvim",
        event = "BufRead",
        config = function()
            vim.cmd "highlight default link gitblame SpecialComment"
            require("gitblame").setup {
                enabled = true,
                date_format = "%Y-%m-%d %X %r",
            } -- 这里设置为开启
        end,
    },
    -- 用VBox可以画图, 结合列可视模式就可以
    {
        "jbyuki/venn.nvim"
    },

    {
        "JuanZoran/Trans.nvim",
        build = function() require 'Trans'.install() end,
        dependencies = { 'kkharji/sqlite.lua', },
        config = function()
            require 'Trans'.setup {
                -- your configuration here
            }
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = "markdown",
        config = function()
            vim.g.mkdp_auto_start = 1
        end,
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require "headlines".setup {
                markdown = {
                    headline_highlights = { "Headline" },
                    codeblock_highlight = "CodeBlock",
                    dash_highlight = "Dash",
                    dash_string = "-",
                    quote_highlight = "Quote",
                    quote_string = "┃",
                    fat_headlines = true,
                    fat_headline_upper_string = "▃",
                    fat_headline_lower_string = "🬂",
                },
            }
        end
    },
    -- {
    --     "vimwiki/vimwiki"
    -- },
    -- {
    --   "p00f/nvim-ts-rainbow",
    -- },
    -- {
    --  'yamatsum/nvim-cursorline'
    -- }
}
