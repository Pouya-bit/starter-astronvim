-- vague.nvim theme configuration
-- Based on: https://github.com/vague2k/vague.nvim

return {
  "vague2k/vague.nvim",
  priority = 1000, -- Make sure it loads first to prevent flickering
  config = function()
    require("vague").setup({
      transparent = false, -- Set to true if you want transparent background
      -- You can customize the theme here (these are the defaults)
      style = {
        boolean = "bold",
        number = "none",
        float = "none",
        error = "bold",
        comments = "italic",
        conditionals = "none",
        functions = "none",
        headings = "bold",
        operators = "none",
        strings = "italic",
        variables = "none",
        
        -- keywords
        keywords = "none",
        keyword_return = "italic",
        keywords_loop = "none",
        keywords_label = "none",
        keywords_exception = "none",
        
        -- builtin
        builtin_constants = "bold",
        builtin_functions = "none",
        builtin_types = "bold",
        builtin_variables = "none",
      },
      plugins = {
        cmp = {
          match = "bold",
          match_fuzzy = "bold",
        },
        dashboard = {
          footer = "italic",
        },
        lsp = {
          diagnostic_error = "bold",
          diagnostic_hint = "none",
          diagnostic_info = "italic",
          diagnostic_warn = "bold",
        },
        neotest = {
          focused = "bold",
          adapter_name = "bold",
        },
        telescope = {
          match = "bold",
        },
      },
    })
  end,
} 