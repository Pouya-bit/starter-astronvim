return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Add JS/TS snippets
      "rafamadriz/friendly-snippets",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      
      -- Improve source prioritization for JavaScript
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
      }))

      -- Add JavaScript specific filetype config
      opts.filetype_specific_config = opts.filetype_specific_config or {}
      opts.filetype_specific_config.javascript = {
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
        }, {
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
      }
      
      -- Also configure for TypeScript, JSX, and TSX
      opts.filetype_specific_config.typescript = opts.filetype_specific_config.javascript
      opts.filetype_specific_config.javascriptreact = opts.filetype_specific_config.javascript
      opts.filetype_specific_config.typescriptreact = opts.filetype_specific_config.javascript

      return opts
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      -- Load JavaScript snippets
      require("luasnip.loaders.from_vscode").lazy_load({ 
        paths = { 
          "./snippets",  -- For custom snippets
          -- Make sure JavaScript/TypeScript snippets are loaded
          require("luasnip.loaders.from_vscode").get_lazy_load_paths() 
        }
      })
    end,
  },
} 