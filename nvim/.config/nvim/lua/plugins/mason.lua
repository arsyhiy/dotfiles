return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
          -- FIXME: i don't acutualy know if i need that but will keep for a while
				ensure_installed = { "lua_ls", "pyright" },
			})
		end,
	},
}
