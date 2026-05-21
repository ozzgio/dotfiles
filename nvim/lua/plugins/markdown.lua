return {
  -- Fix markdownlint: always use the global config so rules are respected
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local config = vim.fn.expand("~/.markdownlint.json")
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = {
        args = { "--config", config, "-" },
      }
      return opts
    end,
  },

  -- Keep markdown editing quiet: spellcheck only, no LSP diagnostics.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = { enabled = false },
      },
    },
  },

  -- Keep browser preview easy to reach from terminal Neovim sessions.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },

  -- render-markdown: make Obsidian notes look great
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        sign = false,
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked   = { icon = "󰱒 " },
        custom = {
          todo      = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          cancelled = { raw = "[~]", rendered = "󰜺 ", highlight = "RenderMarkdownError" },
        },
      },
      code = {
        sign = false,
        width = "block",
        left_pad = 2,
        right_pad = 4,
        border = "thick",
      },
      dash = { width = 60 },
      pipe_table = { preset = "round" },
      quote = { icon = "▌" },
      link = {
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        wiki = { icon = "󱗖 " },
      },
    },
  },
}
