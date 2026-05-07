-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Exit terminal mode with Esc (easier than Ctrl+\ Ctrl+N)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate buffers with Tab / Shift+Tab
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Open a terminal in a new buffer
vim.keymap.set("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Open terminal" })
