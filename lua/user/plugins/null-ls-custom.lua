-- Custom null-ls configuration for React development
-- This provides fallbacks when the standard null-ls integration fails

return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Safely require null-ls
    local ok, null_ls = pcall(require, "null-ls")
    if not ok then
      vim.notify("null-ls not found. Make sure it's installed.", vim.log.levels.ERROR)
      return
    end
    
    -- Clean source setup without errors
    local sources = {}
    
    -- Helper function to safely add sources
    local function add_if_available(source_fn)
      local src_ok, source = pcall(source_fn)
      if src_ok and source then
        table.insert(sources, source)
      end
    end
    
    -- Try to add prettier formatting
    if null_ls.builtins and null_ls.builtins.formatting and null_ls.builtins.formatting.prettier then
      add_if_available(function()
        return null_ls.builtins.formatting.prettier.with({
          filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "json",
            "html",
            "css"
          },
        })
      end)
    end
    
    -- Set up null-ls with all available sources
    if #sources > 0 then
      null_ls.setup({
        debug = false,
        sources = sources,
      })
    end
  end,
} 