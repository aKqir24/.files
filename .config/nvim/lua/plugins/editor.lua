return {
  {
	"stevearc/conform.nvim",
    opts = {},
  },
  { "RRethy/vim-illuminate" },
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
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  { "nvimdev/indentmini.nvim" },
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
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    }
  }
}

