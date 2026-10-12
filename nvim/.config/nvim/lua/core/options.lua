local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.signcolumn = "yes"
opt.autoindent = true

opt.wrap = false
opt.termguicolors = true
opt.cursorline = true

opt.clipboard = "unnamedplus"
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true

opt.fixendofline = true

opt.copyindent = true
opt.breakindent = true

opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.undofile = true
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

opt.hlsearch = true
opt.incsearch = true

opt.errorbells = false
opt.visualbell = false

-- Splits
opt.splitbelow = true
opt.splitright = true

opt.confirm = true

-- Encoding
vim.g.encoding = "utf-8"

vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		prefix = "●",
	},
	float = {
		border = "rounded",
		source = "always",
	},
})
