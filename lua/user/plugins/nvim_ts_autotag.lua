return {
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      -- Use the recommended direct setup instead of Treesitter module
      require("nvim-ts-autotag").setup({
        enable = true,
        filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "tsx", "jsx" },
      })
    end,
  }
} 