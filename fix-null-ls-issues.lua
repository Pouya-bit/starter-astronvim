local function fix() vim.notify('Fixing null-ls issues...') local f = io.open('lua/plugins/none-ls.lua', 'w') if f then f:write([[ return { 'nvimtools/none-ls.nvim', opts = function(_, opts) return opts end, } ]]) f:close() vim.notify('✓ Fixed! Restart Neovim') else vim.notify('Failed to fix') end end fix()
