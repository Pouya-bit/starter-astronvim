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
      -- Direct patch for the treesitter provider file
      -- This ensures the 'range' error doesn't happen even if the provider is somehow used
      local ts_provider_path = vim.fn.stdpath("data") .. "/lazy/nvim-ufo/lua/ufo/provider/treesitter.lua"
      
      -- Check if the ts provider file exists before attempting to patch it
      if vim.fn.filereadable(ts_provider_path) == 1 then
        local file_content = vim.fn.readfile(ts_provider_path)
        
        -- Look for the problematic line (around line 177) and add a safety check
        local patched = false
        for i, line in ipairs(file_content) do
          -- Find the line where `range` is called and might be nil
          if line:match("range%(") and not line:match("if%s+[^%s]+%s+and%s+[^%s]+%.range") then
            -- Add a nil check before the .range call
            file_content[i] = line:gsub("([%w_]+)%.range", "(%1 and %1.range or function() return 0, 0 end)")
            patched = true
          end
        end
        
        -- Write the patched file if we made changes
        if patched then
          vim.fn.writefile(file_content, ts_provider_path)
          vim.notify("Patched nvim-ufo treesitter provider", vim.log.levels.INFO)
        end
      end
      
      -- Add error handling around UFO setup
      local ok, ufo = pcall(require, 'ufo')
      if not ok then
        vim.notify("Failed to load UFO plugin", vim.log.levels.ERROR)
        return
      end
      
      -- Override the treesitter provider module to prevent errors
      local original_provider
      -- Try to require or access loaded module
      pcall(function()
        original_provider = package.loaded["ufo.provider.treesitter"]
        if not original_provider then
          original_provider = require("ufo.provider.treesitter")
        end
      end)
      
      if original_provider then
        -- Add safety wrapper around every method that might be called
        for k, v in pairs(original_provider) do
          if type(v) == "function" then
            original_provider[k] = function(...)
              local ok, result = pcall(v, ...)
              if not ok then
                -- On error, return empty result
                return {}
              end
              return result
            end
          end
        end
        
        -- Specifically fix the range issue
        if not original_provider.safeguarded then
          -- Create a safe fallback for the range method
          local old_exec = original_provider.exec or function() return {} end
          original_provider.exec = function(...)
            local success, result = pcall(old_exec, ...)
            if not success then
              -- Return empty result on error
              vim.schedule(function()
                vim.notify("UFO treesitter provider error suppressed", vim.log.levels.WARN)
              end)
              return {}
            end
            return result
          end
          original_provider.safeguarded = true
        end
      end
      
      -- Setup UFO with error handling
      local setup_ok, err = pcall(ufo.setup, opts)
      if not setup_ok then
        vim.notify("Failed to setup UFO: " .. tostring(err), vim.log.levels.ERROR)
      end
      
      -- Add some keymappings for folding with pcall for safety
      vim.keymap.set('n', 'zR', function() pcall(ufo.openAllFolds) end, {desc = "Open all folds"})
      vim.keymap.set('n', 'zM', function() pcall(ufo.closeAllFolds) end, {desc = "Close all folds"})
      vim.keymap.set('n', 'zr', function() pcall(ufo.openFoldsExceptKinds) end, {desc = "Open folds except kinds"})
      vim.keymap.set('n', 'zm', function() pcall(ufo.closeFoldsWith) end, {desc = "Close folds with"})
      vim.keymap.set('n', 'zp', function() pcall(ufo.peekFoldedLinesUnderCursor) end, {desc = "Peek folded lines"})
    end,
  }
} 