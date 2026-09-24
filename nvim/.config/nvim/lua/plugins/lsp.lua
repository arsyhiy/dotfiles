return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local default = {
				capabilities = capabilities,
				on_attach = on_attach,
			}

			vim.lsp.config("lua_ls", default)
			vim.lsp.config("pyright", default)
			vim.lsp.config("ts_ls", default)

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("ts_ls")
		end,
	},
}
