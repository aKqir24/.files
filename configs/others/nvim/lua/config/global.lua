-- Lazy Load
_G.init_load_plugin_and_config = function()    
	pcall(function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = { "lua", "vim", "bash", "python" },
            highlight = { enable = true }
        })
    end)
    
	require('barbar').setup({
        animation = true,
        insert_at_start = true,
    })

    require('toggleterm').setup({
        direction = 'float',
        open_mapping = [[<c-\>]],
    })

	require("nvim-tree").setup()
    require("barbecue").setup()
end

-- Normal Load
require("colorizer").setup({
	user_default_options = {
		RGB = true,          
		RRGGBB = true,       
		names = true,       
		RRGGBBAA = true,     
 	 	rgb_fn = true,       
 	 	hsl_fn = true,       
 	 	css = true,          
 	 	css_fn = true,       
 	 	mode = "background"
	},
	options = { filetypes = { "*" } }
})
require("config/todo-comments").setup()
require("config.colorfulmenu").setup()
require("config.alpha").setup()
