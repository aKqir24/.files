return {
    -- colorful-menu.nvim
    {
        "xzbdmw/colorful-menu.nvim",
        config = function()
            require("colorful-menu").setup({
                ls = {
                    lua_ls = { arguments_hl = "@comment" },
                    gopls = {
                        align_type_to_right = true,
                        add_colon_before_type = false,
                        preserve_type_when_truncate = true,
                    },
                    ts_ls = { extra_info_hl = "@comment" },
                    vtsls = { extra_info_hl = "@comment" },
                    ["rust-analyzer"] = {
                        extra_info_hl = "@comment",
                        align_type_to_right = true,
                        preserve_type_when_truncate = true,
                    },
                    clangd = {
                        extra_info_hl = "@comment",
                        align_type_to_right = true,
                        import_dot_hl = "@comment",
                        preserve_type_when_truncate = true,
                    },
                    zls = { align_type_to_right = true },
                    roslyn = { extra_info_hl = "@comment" },
                    dartls = { extra_info_hl = "@comment" },
                    basedpyright = { extra_info_hl = "@comment" },
                    pylsp = {
                        extra_info_hl = "@comment",
                        arguments_hl = "@comment",
                    },
                    fallback = true,
                    fallback_extra_info_hl = "@comment",
                },
                fallback_highlight = "@variable",
                max_width = 60,
            })
        end,
    },

    -- nvim-cmp with LSP + icons + source name
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "xzbdmw/colorful-menu.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip", -- snippets
            "onsails/lspkind.nvim", -- icons
        },
        config = function()
            local cmp = require("cmp")
            local colorful_menu = require("colorful-menu")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        -- 🎨 apply colorful-menu highlights
                        local highlights_info = colorful_menu.cmp_highlights(entry)
                        if highlights_info then
                            vim_item.abbr = highlights_info.text
                            vim_item.abbr_hl_group = highlights_info.highlights
                        end

                        -- 🎨 add icon with lspkind
                        vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol_text" })

                        -- 🎨 show LSP source name in dropdown
                        local source_names = {
                            nvim_lsp = "[LSP]",
                            buffer = "[Buf]",
                            path = "[Path]",
                            luasnip = "[Snip]",
                        }
                        vim_item.menu = source_names[entry.source.name] or ("[" .. entry.source.name .. "]")

                        return vim_item
                    end,
                },
            })
        end,
    },
}

