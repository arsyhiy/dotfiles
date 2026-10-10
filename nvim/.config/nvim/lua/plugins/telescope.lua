return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},

		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						preview_width = 0.55,
					},
					sorting_strategy = "ascending",
					prompt_prefix = "❯ ",
					selection_caret = "➜ ",
				},
			})

			telescope.load_extension("fzf")
		end,
	},
}
