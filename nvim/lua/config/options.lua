-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Add any additional options here

local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.spell = true
opt.spelllang = { "en_us", "it" }
opt.number = true -- Show line numbers
opt.relativenumber = false
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.smartindent = true -- Insert indents automatically
opt.mouse = "a" -- Enable mouse mode
opt.clipboard = "unnamedplus" -- Sync with system clipboard
