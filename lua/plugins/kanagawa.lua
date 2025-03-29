return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      theme = "dragon",
      background = {
        dark = "dragon",
        light = "lotus",
      },
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = { bold = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = { bold = true },
      transparent = false,
      dimInactive = true,
      terminalColors = true,
    })
  end,
}
