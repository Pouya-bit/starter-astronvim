return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- More aggressively disable treesitter provider and add fallbacks
      provider_selector = function(bufnr, filetype, buftype)
        -- Skip special buffer types
        if buftype == 'terminal' or buftype == 'nofile' or buftype == 'quickfix' or buftype == 'help' then
          return ''
        end
        
        -- Always use LSP provider first, and fallback to indent if LSP is not available
        -- Completely exclude treesitter to avoid the error
        return {'lsp', 'indent'}
      end,
      
      -- Completely disable the built-in treesitter provider to prevent any calls to it
      providers = {
        treesitter = false,  -- Disable the built-in treesitter provider
        lsp = {
          enable = true,
        },
        indent = {
          enable = true,
        }
      },
      
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
      
      -- Set foldmethod to expr with ufo
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.require("ufo").foldexpr()'
      
      -- Using ufo provider need a reasonable updatetime
      vim.o.updatetime = 300
    end,
    config = function(_, opts)
      -- Add error handling around UFO setup
      local ok, ufo = pcall(require, 'ufo')
      if not ok then
        vim.notify("Failed to load UFO plugin", vim.log.levels.ERROR)
        return
      end
      
      -- Override the get_fold_virt_text function to prevent errors
      local original_provider = package.loaded["ufo.provider.treesitter"]
      if original_provider then
        -- Monkey patch the problematic function to prevent errors
        local old_exec = original_provider.exec
        original_provider.exec = function(...)
          local ok, result = pcall(old_exec, ...)
          if not ok then
            -- Return empty result on error
            return {}
          end
          return result
        end
      end
      
      -- Setup UFO with error handling
      pcall(ufo.setup, opts)
      
      -- Add some keymappings for folding
      vim.keymap.set('n', 'zR', function() pcall(ufo.openAllFolds) end, {desc = "Open all folds"})
      vim.keymap.set('n', 'zM', function() pcall(ufo.closeAllFolds) end, {desc = "Close all folds"})
      vim.keymap.set('n', 'zr', function() pcall(ufo.openFoldsExceptKinds) end, {desc = "Open folds except kinds"})
      vim.keymap.set('n', 'zm', function() pcall(ufo.closeFoldsWith) end, {desc = "Close folds with"})
      vim.keymap.set('n', 'zp', function() pcall(ufo.peekFoldedLinesUnderCursor) end, {desc = "Peek folded lines"})
    end,
  }
} 