return {
  {
    'stevearc/conform.nvim',
    'RRethy/vim-illuminate',
    'nvimdev/indentmini.nvim',
    'lewis6991/satellite.nvim',
    'neovim/nvim-lspconfig',
    'saadparwaiz1/cmp_luasnip',
    'Bekaboo/deadcolumn.nvim',
	'xzbdmw/colorful-menu.nvim',
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'L3MON4D3/LuaSnip',
	'onsails/lspkind.nvim' ,
	'MagicDuck/grug-far.nvim'
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*"
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl"
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy"
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { 
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    'nvim-lualine/lualine.nvim',
	event = "BufReadPost",
    dependencies = { 'nvim-tree/nvim-web-devicons', 'RRethy/nvim-base16' }
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "goolord/alpha-nvim",
	lazy = false,
	priority = 9999,
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
  },
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "base16-tomorrow-night"
    end
  },
  { 
    "romgrk/barbar.nvim",
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    init = function() vim.g.barbar_auto_setup = false end
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
  },
  {
    "catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	priority = 50,
  }
}
