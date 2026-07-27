return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          -- Mason's Ruby LSP wrapper cannot expose its package-local gems to
          -- the Snap Ruby runtime. Use Ruby LSP installed in that runtime's
          -- user gem home so it matches Ruby projects using Snap Ruby.
          cmd = { "/home/ozzo/.gem/bin/ruby-lsp" },
        },
        rubocop = {
          -- Keep RuboCop on the same Snap Ruby user-gem runtime as Ruby LSP;
          -- Mason's package-local wrapper uses an outdated gem environment.
          cmd = { "/home/ozzo/.gem/bin/rubocop", "--lsp" },
        },
      },
    },
  },
}
