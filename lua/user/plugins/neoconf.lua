-- Plugin spec for neoconf and jsonls support
return {
  {
    "folke/neoconf.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    opts = {
      -- Make sure jsonls is enabled
      plugins = {
        lspconfig = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      -- Setup neoconf
      require("neoconf").setup(opts)
      
      -- Make sure jsonls is installed
      vim.defer_fn(function()
        -- Use mason to install jsonls if it exists
        local has_mason, mason_registry = pcall(require, "mason-registry")
        if has_mason then
          -- Install jsonls if not already installed
          if not mason_registry.is_installed("json-lsp") then
            vim.notify("Installing json-lsp for better JSON completion", vim.log.levels.INFO)
            vim.cmd("MasonInstall json-lsp")
          end
        end
      end, 2000)
    end,
  },
} 