local M = {}

M.setup = function() 
    require("todo-comments").setup({
		signs = true,
        keywords = {
			FIX = { icon = " ", color = "error" },
            TODO = { icon = " ", color = "info" },
			HACK = { icon = " ", color = "warning" },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			WARN = { icon = " ", color = "warning", alt = { "WARNING" } }, 
			PERF = { icon = " ", alt = { "PERFORMANCE", "OPTIMIZE" } }
		}
    })
end

return M
