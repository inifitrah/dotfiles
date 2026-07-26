vim.g.mapleader = " "

local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<C-s>",  "<cmd>w<CR>", { desc = "Save file" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-ew>k", { desc = "Move to above window" })

map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<C-/>", "gc", { remap = true, desc = "Toggle comment (visual)" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<C-_>", "gc", { remap = true, desc = "Toggle comment (visual)" })
