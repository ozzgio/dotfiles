-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Exit terminal mode with Esc
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Navigate windows without the <C-w> prefix
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Go to right window" })

-- Resize windows with Alt-h/j/k/l
vim.keymap.set("n", "<M-h>", "<cmd>vertical resize -4<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<M-l>", "<cmd>vertical resize +4<cr>", { desc = "Increase window width" })
vim.keymap.set("n", "<M-j>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<M-k>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("t", "<M-h>", [[<C-\><C-n><cmd>vertical resize -4<cr>]], { desc = "Decrease window width" })
vim.keymap.set("t", "<M-l>", [[<C-\><C-n><cmd>vertical resize +4<cr>]], { desc = "Increase window width" })
vim.keymap.set("t", "<M-j>", [[<C-\><C-n><cmd>resize +2<cr>]], { desc = "Increase window height" })
vim.keymap.set("t", "<M-k>", [[<C-\><C-n><cmd>resize -2<cr>]], { desc = "Decrease window height" })

-- Terminal splits (snacks terminal — LazyVim already binds <C-/> for floating)
vim.keymap.set("n", "<leader>th", function()
  Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
end, { desc = "Terminal (horizontal split)" })
vim.keymap.set("n", "<leader>tv", function()
  Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
end, { desc = "Terminal (vertical split)" })
-- Keep the old buffer terminal for quick one-off commands
vim.keymap.set("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Terminal (buffer)" })
