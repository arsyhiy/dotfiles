return{
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    denpendencies = {
        "williamboman/mason.nvim",
        "mfussenegger/nvim-dap",
        opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
        }

      }
    }
}
