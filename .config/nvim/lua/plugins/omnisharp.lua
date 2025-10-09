
return {
  {
    "iabdelkareem/csharp.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim",
    },
    config = function()
      require("mason").setup()
      require("csharp").setup({
        lsp = {
          omnisharp = {
            enable = true,
            cmd_path = nil,
            default_timeout = 1000,
            enable_editor_config_support = true,
            organize_imports = true,
            load_projects_on_demand = false,
            enable_analyzers_support = true,
            enable_import_completion = true,
            include_prerelease_sdks = true,
            analyze_open_documents_only = false,
            enable_package_auto_restore = true,
            debug = false,
          },
        },
        logging = {
          level = "INFO",
        },
        dap = {
          adapter_name = nil,
        },
      })
    end,
  },
}

