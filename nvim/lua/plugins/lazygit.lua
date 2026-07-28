return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        config = {
          os = {
            -- Send URLs over SSH to iTerm2 on the Mac instead of asking the
            -- headless NUC to open a local browser with xdg-open.
            openLink = "iterm-open-url {{link}}",
          },
        },
      },
    },
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
