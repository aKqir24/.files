return {
  {
    "uZer/pywal16.nvim",
    config = function()
		vim.cmd.colorscheme("pywal16")
    end,
  },
  {
	"goolord/alpha-nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
    config = function()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },
  {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "pywal16-nvim",
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "startup" }, -- disables lualine rendering
          winbar = {},
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
    end,
  },

}

