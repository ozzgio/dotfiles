return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            -- Tell Snacks to look in these top-level directories for .git folders
            dev = { "/Volumes/P3 1/repo", "~/Documents/code" },
            confirm = "load_session", -- Optional: auto-load session when entering
            patterns = { ".git", "Makefile", "package.json" }, -- Root markers
          },
        },
      },
    },
  },
}
