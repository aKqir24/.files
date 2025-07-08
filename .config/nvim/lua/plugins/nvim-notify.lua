return {
  {
    "rcarriga/nvim-notify",
    lazy = true, -- load when required
    opts = {
      stages = "fade_in_slide_out", -- animation style
      timeout = 3000,               -- time before disappearing (ms)
      background_colour = "#000000", -- fallback if theme doesn't set it
      render = "default",
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify -- override default vim.notify
    end,
  },
}

