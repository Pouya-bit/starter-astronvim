return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- This is the fix: disable the treesitter provider that's causing the error
      -- and only use the lsp provider for folding
      provider_selector = function(_, _, _)
        -- Disabling treesitter provider which is causing issues
        -- Only use lsp as the folding provider
        return { 'lsp' }
      end,
      -- Configure fold display
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, 'UfoFoldedEllipsis'})
        return newVirtText
      end,
      -- Enable fold previews
      preview = {
        win_config = {
          border = "rounded",
          winhighlight = "Normal:Normal",
          winblend = 0,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
        },
      },
    },
    init = function()
      -- Set folding options
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      
      -- Set foldmethod to expr with treesitter via ufo
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.require("ufo").foldexpr()'
      
      -- Using ufo provider need a large value for vim.ufo.lsp
      vim.o.updatetime = 300
    end,
    config = function(_, opts)
      -- Require and setup UFO
      require('ufo').setup(opts)
      
      -- Add some keymappings for folding
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, {desc = "Open all folds"})
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, {desc = "Close all folds"})
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, {desc = "Open folds except kinds"})
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, {desc = "Close folds with"})
      vim.keymap.set('n', 'zp', require('ufo').peekFoldedLinesUnderCursor, {desc = "Peek folded lines"})
    end,
  }
} 