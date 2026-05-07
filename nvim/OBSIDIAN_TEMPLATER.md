# Templater & obsidian.nvim — Compatibility Notes

## tl;dr

Use **obsidian.nvim for daily workflow** (open, search, navigate, daily notes).
Use the **Obsidian app for structured templates** that need Templater (expenses, income, monthly summaries).
They coexist perfectly — the vault is just files.

---

## What Templater does that obsidian.nvim cannot

| Feature | Templates that use it | Replicable in nvim? |
|---|---|---|
| `tp.file.title` | Book Note, Real Estate, Travel Plan | ✅ use `{{title}}` |
| `tp.date.now("YYYY-MM-DD")` | most templates | ✅ use `{{date:YYYY-MM-DD}}` |
| `tp.date.now("YYYY-[W]WW")` | Weekly Review | ⚠️ partial (no ISO week in obsidian.nvim) |
| Filename → date parsing | Daily Note | ✅ workaround below |
| `tp.file.move(path)` | NewExpense, NewIncome, NewMonthlySummary | ❌ not replicable — keep in Obsidian app |

## Workaround: nvim-friendly Daily Note template

obsidian.nvim supports `{{date}}` / `{{title}}` substitution. The file
`templates/Daily Note (nvim).md` is a Templater-free version that obsidian.nvim
can process when you run `:ObsidianToday`.

Set it as default in `obsidian.lua`:
```lua
daily_notes = {
  folder = "daily",
  date_format = "%d-%m-%y",
  template = "templates/Daily Note (nvim).md",
},
```

## Workflows to keep in Obsidian app

- Creating expense/income records → `NewExpense.md`, `NewIncome.md` use `tp.file.move()` to auto-file
- Monthly summaries → `NewMonthlySummary.md` computes next month and moves the file
- Weekly reviews → ISO week number formatting is complex

## What obsidian.nvim handles well

- Daily notes (`:ObsidianToday`, `:ObsidianYesterday`)
- Quick note creation (`:ObsidianNew`)
- Full-text vault search (`:ObsidianSearch`)
- Wiki-link following (`gf`, `<Enter>`)
- Backlinks (`:ObsidianBacklinks`)
- Tag completion, link completion
- Opening any note from anywhere
