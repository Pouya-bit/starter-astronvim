-- customize none-ls to your liking
-- Full list of built-in sources: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- Empty configuration that won't cause errors
    return opts
  end,
}
