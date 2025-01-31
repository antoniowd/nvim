return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
    -- git
    "tpope/vim-fugitive",
    -- utils
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "tpope/vim-sleuth",
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}, -- this is equalent to setup({}) function
    },
    "mbbill/undotree",
    "rbgrouleff/bclose.vim",
    "nvim-tree/nvim-web-devicons",
    { "numToStr/Comment.nvim", opts = {}, lazy = false },
    {
        -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        main = "ibl",
        opts = {},
    },
    "github/copilot.vim",
}
