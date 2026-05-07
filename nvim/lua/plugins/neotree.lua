return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },
    },
  },
  keys = {
    -- This rebinds <leader>e to use the actual CWD instead of LazyVim's detected root
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ reveal = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree Reveal (cwd)",
    },
  },
}
