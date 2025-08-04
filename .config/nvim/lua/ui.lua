return {
  {
    "uZer/pywal16.nvim",
    config = function()
    vim.cmd.colorscheme("pywal16")
    end,
  },
  {
	"startup-nvim/startup.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
	config = function()
		require "startup".setup()
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

    -- Hide statusline when startup.nvim is opened
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "startup",
      callback = function()
        vim.opt.laststatus = 0 -- hide statusline completely
      end,
    })

    -- Restore statusline when leaving startup.nvim
    vim.api.nvim_create_autocmd("BufUnload", {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "startup" then
          vim.schedule(function()
            vim.opt.laststatus = 3 -- restore global statusline
          end)
        end
      end,
    })
  end,
  }
}

