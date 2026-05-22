return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "rubocop",
        "black",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        mdx = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        ruby = { "rubocop" },
        python = { "black" },
      },
    },
  },
}
