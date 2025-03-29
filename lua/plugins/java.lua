return {
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("java").setup()
    end,
    ft = { "java" }, -- Load only for Java files
  },
}
