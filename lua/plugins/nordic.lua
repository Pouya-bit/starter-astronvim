return {
  "AlexvZyl/nordic.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('nordic').setup({
      -- Enable italic comments
      italic_comments = true,
      -- Disable background transparency
      transparent = {
        bg = false,
        float = false,
      },
      -- Enable bright float border
      bright_border = true,
      -- Use slightly reduced blue
      reduced_blue = true,
      -- Cursorline settings
      cursorline = {
        bold = false,
        bold_number = true,
        theme = 'dark',
        blend = 0.85,
      },
      -- Telescope style
      telescope = {
        style = 'flat',
      },
      -- Disable context background differences
      ts_context = {
        dark_background = true,
      }
    })
    -- Set the colorscheme after setup
    vim.cmd("colorscheme nordic")
  end,
} 