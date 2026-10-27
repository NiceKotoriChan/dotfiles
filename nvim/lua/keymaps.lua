vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>f", function()
	require("conform").format()
end)

vim.keymap.set("n", "zc", "za")
