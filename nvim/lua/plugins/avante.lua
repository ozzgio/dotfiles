return {
  "yetone/avante.nvim",
  opts = {
    provider = "ollama", -- Use the native llama provider for better prompt handling
    providers = {
      ollama = {
        ["local"] = true,
        endpoint = "http://127.0.0.1:11434",
        model = "qwen2.5-coder:14b",
        -- THIS IS THE FIX: Stop the model from trying to be a JSON agent
        disable_tools = true,
        timeout = 30000,
      },
    },
    behaviour = {
      auto_suggestions = false,
      -- This stops the "Planning" phase which often triggers the JSON loops
      enable_cursor_planning_mode = false,
    },
  },
}
