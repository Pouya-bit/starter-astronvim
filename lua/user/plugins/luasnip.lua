-- Plugin spec for LuaSnip and jsregexp support
return {
  {
    "L3MON4D3/LuaSnip",
    build = vim.fn.has "win32" == 1 and 
      "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp" or
      "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "nvim-cmp",
    },
    config = function(_, opts)
      -- Load standard VS Code style snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Load snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = vim.fn.stdpath "data" .. "/lazy/friendly-snippets",
      }
      
      -- Load the jsregexp module if available
      pcall(require, "luasnip.loaders.from_vscode._jsregexp")
      
      -- Add filetype extensions for JSX/TSX
      require("luasnip").filetype_extend("javascriptreact", { "javascript" })
      require("luasnip").filetype_extend("typescriptreact", { "typescript" })
    end,
  },
} 