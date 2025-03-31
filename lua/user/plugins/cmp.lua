return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Add JS/TS snippets
      "rafamadriz/friendly-snippets",
      -- Add React specific sources
      "dsznajder/vscode-react-javascript-snippets",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      
      -- Improve source prioritization for JavaScript/React
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
      }))

      -- Add JavaScript specific filetype config
      opts.filetype_specific_config = opts.filetype_specific_config or {}
      
      -- Configure for JavaScript
      opts.filetype_specific_config.javascript = {
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
        }, {
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
      }
      
      -- Configure for React (JSX)
      opts.filetype_specific_config.javascriptreact = {
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 800 },  -- Higher priority for JSX
        }, {
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
      }
      
      -- Configure for TypeScript 
      opts.filetype_specific_config.typescript = opts.filetype_specific_config.javascript
      
      -- Configure for TSX (React with TypeScript)
      opts.filetype_specific_config.typescriptreact = opts.filetype_specific_config.javascriptreact
      
      -- Enhance completion behavior for React
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        autocomplete = {
          require("cmp.types").cmp.TriggerEvent.TextChanged,
        },
        completeopt = "menu,menuone,noselect",
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1,
      })

      return opts
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      -- Load JavaScript/React snippets
      require("luasnip.loaders.from_vscode").lazy_load({ 
        paths = { 
          "./snippets",  -- For custom snippets
          -- Make sure JavaScript/TypeScript/React snippets are loaded
          require("luasnip.loaders.from_vscode").get_lazy_load_paths() 
        }
      })
      
      -- Register JSX/TSX extensions as React
      require("luasnip").filetype_extend("javascriptreact", {"javascript"})
      require("luasnip").filetype_extend("typescriptreact", {"typescript"})
    end,
  },
} 