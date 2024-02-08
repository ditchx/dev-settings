local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

    -- Override plugin definition options
    {
        "nvim-telescope/telescope.nvim",
        opts = function()
            local select_one_or_multi = function(prompt_bufnr)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                    require("telescope.actions").close(prompt_bufnr)
                    for _, j in pairs(multi) do
                        if j.path ~= nil then
                            vim.cmd(string.format("%s %s", "edit", j.path))
                        end
                    end
                else
                    require("telescope.actions").select_default(prompt_bufnr)
                end
            end

            local conf = require "plugins.configs.telescope"
            conf.defaults.mappings.i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<CR>"] = select_one_or_multi,
            }
            conf.defaults.mappings.n = {
                ["<CR>"] = select_one_or_multi,
            }

            return conf
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        version = "2.20.7",
        init = function()
            require("core.utils").lazy_load "indent-blankline.nvim"
        end,
        opts = function()
            return overrides.blankline
        end,
        config = function(_, opts)
            require("core.utils").load_mappings "blankline"
            require("indent_blankline").setup(opts)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- format & linting
            {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require "custom.configs.null-ls"
                end,
            },
        },
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end, -- Override to setup mason-lspconfig
    },

    -- override plugin configs
    {
        "williamboman/mason.nvim",
        opts = overrides.mason,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
    },

    -- Install a plugin
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },

    {
        "tpope/vim-obsession",
        lazy = false,
    },
    {
        "mhinz/vim-signify",
        lazy = false,
        keys = {
            { "<leader>gp", "<cmd>SignifyHunkDiff<cr>" },
            { "<leader>gu", "<cmd>SignifyHunkUndo<cr>" },
        },
    },
    {
        "ludovicchabant/vim-gutentags",
        lazy = false,
        config = function()
            vim.cmd [[
        " Gutentags Settings
        " Mostly taken from https://www.programmersought.com/article/20324418095/
        let g:gutentags_trace = 0
        "gutentags searches for the logo of the project directory, and when these file/directory names are encountered, it stops recursing to the upper directory
        let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

        "The name of the generated data file
        let g:gutentags_ctags_tagfile = '.tags'

        "Put all the automatically generated tags files into the ~/.cache/tags directory to avoid polluting the project directory
        let s:vim_tags = expand('~/.cache/tags')
        let g:gutentags_cache_dir = s:vim_tags

        "Configure ctags parameters
        let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--exclude=*.js']
        let g:gutentags_ctags_extra_args += ['--exclude=*.sql']

        "Detect ~/.cache/tags does not exist and create a new one
        if !isdirectory(s:vim_tags)
            silent! call mkdir(s:vim_tags, 'p')
        endif
      ]]
        end,
    },
    {
        "stephpy/vim-php-cs-fixer",
        lazy = false,
        keys = {
            { "<silent><leader>pcf", "<cmd>call PhpCsFixerFixFile()<CR>" },
        },
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
    },
    {
        "fatih/vim-go",
        ft = "go",
    },
    {
        "kkoomen/vim-doge",
        lazy = false,
        init = function()
            vim.g.doge_enable_mappings = 0
            vim.g.doge_comment_interactive = 0
        end,
        build = ":call doge#install()",
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = false,
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<CR>" },
        },
    },

    -- To make a plugin not be loaded
    -- {
    --   "NvChad/nvim-colorizer.lua",
    --   enabled = false
    -- },

    -- All NvChad plugins are lazy-loaded by default
    -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
    -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
    -- {
    --   "mg979/vim-visual-multi",
    --   lazy = false,
    -- }
}

return plugins
