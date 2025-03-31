return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    config = function()
      -- Use the recommended setup from the warning message
      require('ts_context_commentstring').setup {}
      -- Set the global variable to skip the deprecated module
      vim.g.skip_ts_context_commentstring_module = true
    end,
  }
} 