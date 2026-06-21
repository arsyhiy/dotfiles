return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      -- 👇 ТВОЙ SNIPPET REPO С GitHub
      {
        "arsyhiy/snippets",
      },

      "rafamadriz/friendly-snippets",
    },

    config = function()
      local vscode_loader = require("luasnip.loaders.from_vscode")

      -- стандартные снипеты
      vscode_loader.lazy_load()

      -- 👇 загрузка твоего GitHub snippets plugin
      vscode_loader.lazy_load({
        paths = {
          vim.fn.stdpath("data") .. "/lazy/snippets",
        },
      })
    end,
  },
}
