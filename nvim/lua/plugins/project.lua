local function existing_paths(paths)
  local uv = vim.uv or vim.loop
  local dirs = {}

  for _, path in ipairs(paths) do
    local expanded = vim.fn.expand(path)
    if uv.fs_stat(expanded) then
      table.insert(dirs, expanded)
    end
  end

  return dirs
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            -- Search whichever code roots exist on this host.
            dev = existing_paths({
              "~/code",
              "~/Documents/code",
              "/Volumes/P3 1/repo",
            }),
            confirm = "load_session",
            patterns = { ".git", "Makefile", "package.json" },
          },
        },
      },
    },
  },
}
