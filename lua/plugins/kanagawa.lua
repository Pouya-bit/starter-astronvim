if true then return {} end -- WARN: KANAGAWA THEME DISABLED, USING NORDIC INSTEAD

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
    -- Set the colorscheme after setup
    vim.cmd("colorscheme kanagawa")
  end,
}
