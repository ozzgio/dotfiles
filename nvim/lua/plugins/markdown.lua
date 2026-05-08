return {
  -- Frontmatter visual highlighting for markdown/org files
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "markdown", "org", "norg" },
    opts = {
      markdown = {
        headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4" },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        dash_string = "─",
        quote_highlight = "Quote",
        quote_string = "┃",
        fat_headlines = true,
        fat_headline_upper_string = "▄",
        fat_headline_lower_string = "▀",
      },
    },
  },

  -- Fix markdownlint: always use the global config so rules are respected
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local config = vim.fn.expand("~/.markdownlint.json")
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = {
        args = { "--config", config, "-" },
      }
      return opts
    end,
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
