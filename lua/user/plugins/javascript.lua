return {
  -- Add JavaScript and React related plugins
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 
        "tsserver",
        "cssls",
        "html",
        "emmet_ls",
        "tailwindcss"
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 
        "prettierd", 
        "eslint",
        "stylelint",
        "jsonlint" 
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 
        "javascript", 
        "typescript", 
        "tsx", 
        "html", 
        "css", 
        "json",
        "jsdoc",
        "scss",
        "graphql",
        "regex" 
      })
      -- Auto-install missing parsers when entering buffer
      opts.auto_install = true
    end,
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                completeFunctionCalls = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                completeFunctionCalls = true,
              },
            },
          },
        },
        emmet_ls = {
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
        },
      },
      formatting = {
        format_on_save = {
          enabled = true,
          allow_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "css", "scss", "html" },
        },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        enable = true,
        filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "tsx", "jsx" },
      })
    end,
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = function() return { server = require("astrolsp").config.tsserver } end,
  },
} 
} 