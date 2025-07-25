-- Basic settings configuration
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.termguicolors = true
vim.o.showtabline = 2
vim.opt.updatetime = 200
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

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
      "mistricky/codesnap.nvim",
      build = "make build_generator",
      opts = {
		save_path = "~/Pictures/Screenshots",
		watermark = "",
		has_breadcrumbs = true,
		bg_theme = "dusk",
      }
    },
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
	{ "nvimdev/lspsaga.nvim" },
    { import = "plugins" }
  }
})

-- Keymappings
vim.keymap.set('n', '<C-S-e>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-1>', ':BufferGoto 1<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-2>', ':BufferGoto 2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-3>', ':BufferGoto 3<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-4>', ':BufferGoto 4<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-5>', ':BufferGoto 5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-6>', ':BufferGoto 6<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-7>', ':BufferGoto 7<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-8>', ':BufferGoto 8<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-9>', ':BufferGoto 9<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-0>', ':BufferGoto 10<CR>', { noremap = true, silent = true })
