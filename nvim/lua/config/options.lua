local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 250
opt.clipboard = "unnamedplus" -- sync sama system clipboard
opt.splitright = true
opt.splitbelow = true
opt.undofile = true -- persistent undo

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.colorcolumn = "80"
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true

        vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
        vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
    end,
})
