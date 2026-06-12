local opt = vim.opt

opt.number = true
--hopt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.termguicolors = true
opt.cursorline = true

opt.clipboard = "unnamedplus"

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true

opt.copyindent = true
opt.breakindent = true

opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.undofile = true
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

opt.hlsearch = true
opt.incsearch = true

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
