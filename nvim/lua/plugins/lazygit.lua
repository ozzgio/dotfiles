return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit({ cwd = LazyVim.root.git() })
        end,
        desc = "Lazygit (Root Dir)",
      },
    },
  },
}
