vim.g.mapleader = " "
vim.keymap.set("n", "<leader>d", vim.cmd.Ex) --Ex command


-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
