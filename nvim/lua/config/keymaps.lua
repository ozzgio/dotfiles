-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Exit terminal mode with Esc
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Terminal splits (snacks terminal — LazyVim already binds <C-/> for floating)
vim.keymap.set("n", "<leader>th", function()
  Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
end, { desc = "Terminal (horizontal split)" })
vim.keymap.set("n", "<leader>tv", function()
  Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
end, { desc = "Terminal (vertical split)" })
-- Keep the old buffer terminal for quick one-off commands
vim.keymap.set("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Terminal (buffer)" })
