return {
  { "stevearc/conform.nvim" },
  { "RRethy/vim-illuminate" },
  { "nvimdev/indentmini.nvim" }, 
  {
    "akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require('toggleterm').setup{
			direction = 'float',
			open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] }
		}
	end
  },
  {
	"petertriho/nvim-scrollbar",
    opts = {
      marks = {
        Cursor = { text = "•" },
        Search = { text = { "-", "=" } },
        Error = { text = { "" } },
        Warn = { text = { "" } },
        Info = { text = { "" } },
        Hint = { text = { "" } },
        Misc = { text = { "󰠠" } },
      },
    },
    config = function(_, opts)
      require("scrollbar").setup(opts)
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
	},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl"
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require("scrollbar.handlers.search").setup({})
    end,
  },
  { "romgrk/barbar.nvim",
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation = true,
      insert_at_start = true,
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
    -- configurations go here
    },
	config = function()
		require("barbecue.ui").toggle(false)
		require("barbecue.ui").toggle(true)
		require("barbecue.ui").toggle()
	end,
  },
  {
    "Djancyp/better-comments.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("better-comment").Setup({
        tags = {
          { name = "?", fg = "white", bg = "#0a7aca", bold = true },
          { name = "!", fg = "white", bg = "#f44747", bold = true },
          { name = "*", fg = "black", bg = "#b1c900", bold = true },
        }
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        keywords = {
          FIX = { color = "error" },
          TODO = { color = "info" },
          HACK = { color = "warning" },
        },
      })
    end,
  },
  {
  'neovim/nvim-lspconfig', -- LSP config
  'hrsh7th/nvim-cmp',       -- Completion plugin
  'hrsh7th/cmp-nvim-lsp',   -- LSP source for nvim-cmp
  'L3MON4D3/LuaSnip',       -- Snippet engine
  'saadparwaiz1/cmp_luasnip'-- Snippet completions
  }
}
