-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Disable spell check in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mdx" },
  callback = function(args)
    vim.opt_local.spell = true
    pcall(vim.diagnostic.enable, false, { bufnr = args.buf })
  end,
})

vim.api.nvim_create_user_command("RenameFile", function()
  local old = vim.fn.expand("%:p")
  local new = vim.fn.input("New name: ", vim.fn.expand("%:p"), "file")

  if new == "" or new == old then
    return
  end

  vim.cmd("saveas " .. vim.fn.fnameescape(new))
  vim.fn.delete(old)
  vim.cmd("bwipeout " .. vim.fn.fnameescape(old))
end, {})
