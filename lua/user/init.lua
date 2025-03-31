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
      tsserver = function(_, opts) require("typescript").setup { server = opts } end
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
  
  -- Set up autocommands
  autocmds = {
    -- Auto format on save
    format_on_save = {
      {
        event = "BufWritePre",
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.scss", "*.html", "*.json" },
        desc = "Auto format JavaScript/TypeScript/React files before saving",
        callback = function() vim.lsp.buf.format() end,
      },
    },
    -- React syntax highlighting improvements
    react_filetype = {
      {
        event = "BufRead",
        pattern = { "*.jsx", "*.tsx" },
        callback = function()
          vim.bo.filetype = vim.bo.filetype == "javascriptreact" and "javascriptreact" or "typescriptreact"
        end,
      },
    },
  },

  -- Custom mappings
  mappings = {
    n = {
      -- React component generation
      ["<leader>rc"] = { 
        "<cmd>lua require('typescript').actions.addMissingImports()<CR>", 
        desc = "Add missing imports" 
      },
      ["<leader>rf"] = { 
        "<cmd>lua require('typescript').actions.fixAll()<CR>", 
        desc = "Fix all TypeScript diagnostics" 
      },
      ["<leader>ro"] = { 
        "<cmd>lua require('typescript').actions.organizeImports()<CR>", 
        desc = "Organize imports"
      },
    },
  },
}
  