return {
  -- Configure AstroVim features
  features = {
    autopairs = true,
    cmp = true,
    highlighturl = true,
    notifications = true,
  },
  -- Configure language specific options
  lsp = {
    -- enable servers that you already have installed without Mason
    servers = {
      -- "pyright"
    },
    -- easily add or disable built-in mappings added during LSP attachment
    mappings = {
      n = {
        -- ["<leader>lf"] = false -- disable formatting keymap
      },
    },
    -- add to the global LSP on_attach function
    -- @type fun(client, bufnr)
    on_attach = function(client, bufnr)
      -- Enable inlay hints for JavaScript/TypeScript files
      if client.name == "tsserver" and vim.fn.has("nvim-0.10") == 1 then
        vim.lsp.inlay_hint.enable(bufnr, true)
      end
    end,
    -- override the LSP setup handler function based on server name
    setup_handlers = {
      -- add custom handler
      -- tsserver = function(_, opts) require("typescript").setup { server = opts } end
    },
    -- Configure null-ls sources
    formatting = {
      -- Set up default formatting tools
      format_on_save = {
        enabled = true, -- Enable format on save globally
        allow_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "html", "css" },
      },
    },
  },
}
  