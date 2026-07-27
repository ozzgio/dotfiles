return {
  {
    "catppuccin/nvim",
    opts = {
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      custom_highlights = function(colors)
        return {
          FloatBorder = { fg = colors.blue },
          NormalFloat = { bg = colors.mantle },
          NeoTreeNormal = { bg = colors.mantle },
          NeoTreeNormalNC = { bg = colors.mantle },
          SnacksPickerBorder = { fg = colors.blue },
          SnacksPickerTitle = { fg = colors.mauve, style = { "bold" } },
          WhichKeyBorder = { fg = colors.blue },
        }
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
