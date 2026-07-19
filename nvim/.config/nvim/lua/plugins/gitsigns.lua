return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#3fb950" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#d29922" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f85149" })

      require("gitsigns").setup({
        signs = {
          add = { text = "┃", hl = "GitSignsAdd" },
          change = { text = "┃", hl = "GitSignsChange" },
          delete = { text = "▁", hl = "GitSignsDelete" },
          topdelete = { text = "▔", hl = "GitSignsDelete" },
          changedelete = { text = "┃", hl = "GitSignsChange" },
        },

        signcolumn = true,
        numhl = false,
        linehl = false,
      })
    end,
  },
}
