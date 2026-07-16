-- Core Settings & Variables (Must run before plugins load)
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.mouse = "a"
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.showtabline = 2
vim.opt.updatetime = 200
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.laststatus = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load the plugins and its config
require("lazy").setup("plugins")
require("config.global")
require("matugen") -- Loads the matugen colorsheme
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local status, err = pcall(_G.init_load_plugin_and_config)
    if not status then
      vim.notify("Error initializing custom plugins: " .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})

-- Keymappings
vim.keymap.set('', '<C-S-e>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('', '<C-`>', ':ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('', '<C-f>', ':GrugFarWithin<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Tab>', '<C-w>p', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Dynamic Buffer Goto bindings
for i = 1, 9 do
  vim.keymap.set("", string.format("<C-S-%d>", i), string.format(":BufferGoto %d<CR>", i), { noremap = true, silent = true })
end
