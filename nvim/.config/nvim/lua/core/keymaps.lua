local keymap = vim.keymap
local builtin = require("telescope.builtin")
local map = vim.keymap.set
vim.g.mapleader = " "

-- neotree
vim.keymap.set("n", "<leader>t", ":Neotree filesystem reveal toggle<CR>", { noremap = true, silent = true })

-- rebind Ex
vim.keymap.set("n", "<leader>ex", ":Ex<CR>", { noremap = true, silent = true })

-- telescope
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>frg", builtin.live_grep, { desc = "Telescope live Ripgrep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fl", builtin.current_buffer_fuzzy_find, { desc = "Search buffer" })

-- diagnostics
vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { noremap = true, silent = true })

-- lsp
vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", opts)
vim.keymap.set("n", "gr", ":lua vim.lsp.buf.references()<CR>", opts)
vim.keymap.set("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", opts)
vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", opts)

vim.keymap.set("n", "lp", ":lua vim.diagnostic.goto_prev()<CR>", opts)
vim.keymap.set("n", "ln", ":lua vim.diagnostic.goto_next()<CR>", opts)
vim.keymap.set("n", "<leader>ld", ":lua vim.diagnostic.open_float()<CR>", opts)

-- haproon 2
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-t>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-n>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-s>", function()
	harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end)
