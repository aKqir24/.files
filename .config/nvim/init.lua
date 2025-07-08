-- Basic settings configuration
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.termguicolors = true
vim.o.showtabline = 2

-- Setup lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins to install and use
require("lazy").setup({
  spec = {
    {'nvim-telescope/telescope.nvim', dependencies = {'nvim-lua/plenary.nvim'}},
	{ 'Bekaboo/deadcolumn.nvim' },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "lua", "vim", "bash", "python" },
          highlight = {
            enable = true,
          },
        }
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*", -- optional: use latest tag
      dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
      },
      config = function()
      require("nvim-tree").setup()
      end,
    },
	{
	  'stevearc/conform.nvim',
      opts = {},
    }, 
    { import = "plugins" }
  }
})
