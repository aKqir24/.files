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
          highlight = { enable = true }
        }
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
	  dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
		require("nvim-tree").setup()
      end,
    },
    { import = "plugins" },
    { import = "editor" },
    { import = "ui" }
  }
})

-- Keymappings
vim.keymap.set('', '<F12>', ':ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('', '<C-S-e>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set("", "<C-S-0>", ":BufferGoto 10<CR>", { noremap = true, silent = true })
for i = 1, 9 do
  vim.keymap.set("", string.format("<C-S-%d>", i), string.format(":BufferGoto %d<CR>", i), { noremap = true, silent = true })
end
