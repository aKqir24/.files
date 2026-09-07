local M = {}
M.setup = function()
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
	
	-- Setup nvim-cmp
	local cmp = require("cmp")
	local colorful_menu = require("colorful-menu")
	
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
	        fields = { "abbr" },
	        format = function(entry, vim_item)
	            local highlights_info = colorful_menu.cmp_highlights(entry)
	            if highlights_info then
	                vim_item.abbr = highlights_info.text
	                vim_item.abbr_hl_group = highlights_info.highlights
	            end
	            return vim_item
	        end,
	    },
	})
end

return M
