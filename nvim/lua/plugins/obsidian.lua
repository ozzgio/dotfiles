return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/obsidian-vault",
        },
      },
      daily_notes = {
        folder = "daily",
        -- matches your vault's DD-MM-YY filenames (e.g. 07-05-26.md)
        date_format = "%d-%m-%y",
        -- plain template (no Templater); Templater version is "Daily Note.md" for the Obsidian app
        template = "templates/Daily Note (nvim).md",
      },
      completion = {
        nvim_cmp = false,
        blink = { enabled = true },
        min_chars = 2,
      },
      mappings = {
        -- follow links with gf
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- toggle checkboxes / follow links with Enter
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      preferred_link_style = "wiki",
      new_notes_location = "current_dir",
      wiki_link_func = "use_alias_only",
      -- disable obsidian's own markdown rendering since render-markdown.nvim handles it
      ui = { enable = false },
    },
    keys = {
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Daily note (today)" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Daily note (yesterday)" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
      { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search vault" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links in note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
    },
  },
}
