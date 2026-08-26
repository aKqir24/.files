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
        direction = 'tab',
		hide_numbers = true,
		start_in_insert = true,
        open_mapping = [[<c-\>]],
    })

	require("goose").setup({ 
		ui = {
			window_type = "float",
			display_goose_mode = false,
			display_model = true,
			fullscreen = true,
		},
		global = {
			toggle = '<leader>gg',                 -- Open goose. Close if opened
			open_input = '<leader>gi',             -- Opens and focuses on input window on insert mode
			open_input_new_session = '<leader>gsn', -- Opens and focuses on input window on insert mode. Creates a new session
			open_output = '<leader>go',            -- Opens and focuses on output window
			toggle_focus = '<leader>gt',           -- Toggle focus between goose and last window
			toggle_fullscreen = '<leader>gf',      -- Toggle between normal and fullscreen mode
			select_session = '<leader>gss',         -- Select and load a goose session
			goose_mode_chat = '<leader>gmc',       -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
			goose_mode_auto = '<leader>gma',       -- Set goose mode to `auto`. (Default mode with full agent capabilities)
			goose_mode_approve = '<leader>gmp',    -- Set goose mode to `approve`. (Manual approval for all tool usage)
			goose_mode_smart_approve = '<leader>gms', -- Set goose mode to `smart_approve`. (Risk-based tool usage approval)
			configure_provider = '<leader>gp',     -- Quick provider and model switch from predefined list
			open_config = '<leader>g.',            -- Open goose config file
			inspect_session = '<leader>g?',        -- Inspect current session as JSON
			diff_open = '<leader>gd',              -- Opens a diff tab of a modified file since the last goose prompt
			diff_next = '<leader>g]',              -- Navigate to next file diff
			diff_prev = '<leader>g[',              -- Navigate to previous file diff
			diff_close = '<leader>gc',             -- Close diff view tab and return to normal editing
			diff_revert_all = '<leader>gra',       -- Revert all file changes since the last goose prompt
			diff_revert_this = '<leader>grt',      -- Revert current file changes since the last goose prompt
		},
		providers = {
		  google = {
		    "gemini-3.5-flash-lite",
			"gemini-3.1-flash-lite",
			"gemini-3.7-flash",
		    "gemini-3.6-flash",
		    "gemini-2.5-flash",
		  },
		}
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
