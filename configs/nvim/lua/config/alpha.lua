local M = {}

M.setup = function()
	local status, alpha = pcall(require, "alpha")
	if status then
	    local dashboard = require("alpha.themes.dashboard")
	    
		-- Inside the alpha setup block of global.lua
	    dashboard.section.header.val = {
			[[	      ___           ___           ___                                      ___		 ]],
			[[	     /  /\         /  /\         /  /\          ___            ___        /  /\   	 ]],
			[[	    /  /::|       /  /::\       /  /::\        /  /\          /__/\      /  /::|  	 ]],
			[[	   /  /:|:|      /  /:/\:\     /  /:/\:\      /  /:/          \__\:\    /  /:|:|  	 ]],
			[[	  /  /:/|:|__   /  /::\ \:\   /  /:/  \:\    /  /:/           /  /::\  /  /:/|:|__	 ]],
			[[	 /__/:/ |:| /\ /__/:/\:\ \:\ /__/:/ \__\:\  /__/:/  ___    __/  /:/\/ /__/:/_|::::\  ]],
			[[	 \__\/  |:|/:/ \  \:\ \:\_\/ \  \:\ /  /:/  |  |:| /  /\  /__/\/:/--  \__\/  /--/:/  ]],
			[[	     |  |:/:/   \  \:\ \:\    \  \:\  /:/   |  |:|/  /:/  \  \::/           /  /:/   ]],
			[[	     |__|::/     \  \:\_\/     \  \:\/:/    |__|:|__/:/    \  \:\          /  /:/    ]],
			[[	     /__/:/       \  \:\        \  \::/      \__\::::/      \__\/         /__/:/     ]],
			[[	     \__\/         \__\/         \__\/           ----                     \__\/      ]],
	    }
	
	    -- color of the logo
	    dashboard.section.header.opts.hl = "Directory"
	
		-- Operations menu buttons layout with left border accent
	    local button_items = {
	        dashboard.button("e",       "	▌    New file",                 ":ene <BAR> startinsert <CR>"),
	        dashboard.button("f f",     "	▌  󰈞  Find file",                ":Telescope find_files<CR>"),
	        dashboard.button("f h",     "	▌  󰊄  Recently opened files",    ":Telescope oldfiles<CR>"),
	        dashboard.button("f r",     "	▌    Frecency/MRU",             ":Telescope frecency<CR>"),
	        dashboard.button("f g",     "	▌  󰈬  Find word",                ":Telescope live_grep<CR>"),
	        dashboard.button("f m",     "	▌    Jump to bookmarks",        ":Telescope marks<CR>"),
	        dashboard.button("q",       "	▌    Quit Neovim",              ":qa<CR>"),
	    }
	
	    -- Style the borders and shortcuts individually
	    for _, button in ipairs(button_items) do
	        button.opts.hl = "Directory" 
	        button.opts.hl_shortcut = "Type" 
	        button.opts.hl_text = "Comment" 
			button.opts.width = 44
	    end
		
		-- Apply buttons and strip line spacing between them
	    dashboard.section.buttons.val = button_items
	    dashboard.section.buttons.opts = {
	        spacing = 0
		}
	
	    -- Inject a custom thin divider line to act as a 0.5 space
	    dashboard.section.buttons.val = {}
	    for i, button in ipairs(button_items) do
	        table.insert(dashboard.section.buttons.val, button)
	        
	        -- If it's not the last button, add a thin, elegant separator row
	        if i < #button_items then
	            table.insert(dashboard.section.buttons.val, {
	                type = "text",
	                val = "  " .. string.rep("─", 40),
	                opts = { hl = "NonText", position = "center" }
	            })
	        end
	    end
	
	    -- Apply changes safely
	    alpha.setup(dashboard.config)
	end
end

return M
