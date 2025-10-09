return {
  "stevearc/aerial.nvim",
  config = function()
    require("aerial").setup({
      on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    })
    -- Keymap to toggle aerial
    vim.keymap.set("n", "C-S-a", "<cmd>AerialToggle!<CR>")
  end,
}

