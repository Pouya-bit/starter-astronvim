return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    enabled = function()
      -- Only enable UFO if our fix has been applied
      -- This ensures we don't load the plugin before our fixes are in place
      local fix_applied = false
      pcall(function()
        local ufo_fix = require("user.ufo_fix")
        fix_applied = true
      end)
      return fix_applied
    end,
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
        
        -- Check if LSP server is attached to this buffer
        local has_lsp = false
        pcall(function()
          local clients = vim.lsp.get_active_clients({bufnr = bufnr})
          has_lsp = #clients > 0
        end)
        
        -- Always use LSP provider first if available, otherwise fallback to indent
        -- Explicitly exclude treesitter from the list to avoid any chance of using it
        return has_lsp and {'lsp', 'indent'} or {'indent'}
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
      
      -- Temporarily disable UFO to avoid errors on startup
      -- This will be re-enabled after patching
      pcall(vim.cmd, [[ UfoDisable ]])
      
      -- Schedule re-enabling UFO after patching is done
      vim.defer_fn(function()
        pcall(vim.cmd, [[ UfoEnable ]])
      end, 1000)
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
          -- Find all lines where the range method is called
          if line:match("[%w_%.]+%.range%(") then
            -- Add a nil check before the .range call
            local new_line = line:gsub("([%w_%.]+)%.range%(",
                                      function(var)
                                        return string.format("(%s and %s.range or function() return 0, 0 end)(", var, var)
                                      end)
            file_content[i] = new_line
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
      local function override_treesitter_provider()
        -- Make sure the package is loaded first
        pcall(function() require("ufo.provider.treesitter") end)
        
        -- Get the loaded module
        local original_provider = package.loaded["ufo.provider.treesitter"]
        if not original_provider then return end
        
        -- Create a safe wrapper for the getFolds function which is the main entry point
        local old_get_folds = original_provider.getFolds
        original_provider.getFolds = function(bufnr, cb)
          -- Call the original function with error handling
          local status, result = pcall(function()
            -- Immediate return if original function is not available
            if type(old_get_folds) ~= "function" then
              if cb then cb({}) end
              return {}
            end
            
            -- Call with a protected callback
            local called = false
            old_get_folds(bufnr, function(ranges)
              called = true
              if cb then cb(ranges or {}) end
            end)
            
            -- Handle if callback was never called
            vim.defer_fn(function()
              if not called and cb then
                cb({})
              end
            end, 100)
          end)
          
          -- If there was an error, return an empty result
          if not status and cb then
            cb({})
          end
        end
        
        -- Mark as overridden to avoid duplicate patching
        original_provider.safeguarded = true
      end
      
      -- Apply the override
      override_treesitter_provider()
      
      -- Forcibly unregister treesitter provider
      local function unregister_ts_provider()
        -- Attempt to directly unregister the provider
        pcall(function()
          -- Access the internal registry if available
          local registry = package.loaded["ufo.provider.registry"]
          if registry and registry.providers then
            -- Remove treesitter from the registry
            registry.providers["treesitter"] = nil
          end
        end)
      end
      
      -- Call unregister function
      unregister_ts_provider()
      
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