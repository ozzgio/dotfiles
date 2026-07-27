return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
      },
      on_highlights = function(highlights, colors)
        highlights.FloatBorder = { fg = colors.blue }
        highlights.NormalFloat = { bg = colors.bg_dark }
        highlights.NeoTreeNormal = { bg = colors.bg_dark }
        highlights.NeoTreeNormalNC = { bg = colors.bg_dark }
        highlights.SnacksPickerBorder = { fg = colors.blue }
        highlights.SnacksPickerTitle = { fg = colors.magenta, bold = true }
        highlights.WhichKeyBorder = { fg = colors.blue }
      end,
    },
  },
  {
    "nvim-mini/mini.animate",
    event = "VeryLazy",
    opts = function()
      local animate = require("mini.animate")
      return {
        cursor = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        scroll = {
          enable = true,
          timing = animate.gen_timing.cubic({ easing = "out", duration = 160, unit = "total" }),
        },
        resize = {
          enable = true,
          timing = animate.gen_timing.cubic({ easing = "out", duration = 120, unit = "total" }),
        },
        open = {
          enable = true,
          timing = animate.gen_timing.cubic({ easing = "out", duration = 120, unit = "total" }),
        },
        close = {
          enable = true,
          timing = animate.gen_timing.cubic({ easing = "out", duration = 100, unit = "total" }),
        },
      }
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        animate = {
          enabled = true,
        },
      },
      scroll = {
        enabled = true,
      },
    },
  },
}
