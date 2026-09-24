return {
  {
    "stevearc/conform.nvim",

    opts = {
      formatters_by_ft = {
        lua = { "stylua" },

        python = {
          "ruff_format",
        },

        javascript = {
          "prettier",
        },

        typescript = {
          "prettier",
        },

        javascriptreact = {
          "prettier",
        },

        typescriptreact = {
          "prettier",
        },

        json = {
          "prettier",
        },

        markdown = {
          "prettier",
        },

        rust = {
          "rustfmt",
        },

        go = {
          "gofmt",
        },
      },

      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },
}
