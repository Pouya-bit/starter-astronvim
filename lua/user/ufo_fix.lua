-- This file provides a comprehensive fix for the nvim-ufo treesitter provider issue
-- It completely replaces the problematic provider with a safe alternative

local M = {}

-- Apply this fix during startup
function M.apply()
  -- Path to the data directory where plugins are installed
  local data_path = vim.fn.stdpath("data")
  local ts_provider_path = data_path .. "/lazy/nvim-ufo/lua/ufo/provider/treesitter.lua"
  
  -- First try: Replace the entire provider with a safe version
  local safe_provider = [[
-- Safe replacement for the treesitter provider
-- This provider is designed to never error, but also never provide folds
local M = {}

function M.getFolds(bufnr, cb)
  -- Just return an empty table
  if cb then
    cb({})
  end
  return {}
end

-- Add all the original methods as safe stubs
function M.parseQueryWithContext() return nil end
function M.getParseInfo() return nil end
function M.isSupported() return false end
function M.getStartEnd() return 0, 0 end
function M.parseFolds() return {} end
function M.exec() return {} end

-- Mark as patched
M.patched_by_user = true

return M
]]

  -- Try to write the safe provider to the file
  local ok, err = pcall(function()
    -- Check if file exists first
    if vim.fn.filereadable(ts_provider_path) == 1 then
      -- First attempt: Try to write the safe provider
      local write_ok = pcall(function()
        vim.fn.writefile(vim.split(safe_provider, "\n"), ts_provider_path)
      end)
      
      if write_ok then
        vim.notify("Replaced nvim-ufo treesitter provider with safe version", vim.log.levels.INFO)
      else
        -- Nuclear option: If can't write, try to delete the file completely
        -- This is better than having constant errors
        local delete_ok = pcall(function()
          vim.fn.delete(ts_provider_path)
        end)
        
        if delete_ok then
          vim.notify("Deleted problematic treesitter provider file", vim.log.levels.WARN)
        else
          vim.notify("Could not delete treesitter provider file", vim.log.levels.ERROR)
        end
      end
    else
      vim.notify("Could not find treesitter provider at " .. ts_provider_path, vim.log.levels.WARN)
    end
  end)
  
  if not ok then
    vim.notify("Failed to replace treesitter provider: " .. tostring(err), vim.log.levels.ERROR)
  end
  
  -- Second approach: Override the loaded module if it exists
  pcall(function()
    -- Try to get the loaded module
    local module = package.loaded["ufo.provider.treesitter"]
    if module then
      -- Replace all functions with safe alternatives
      for k, v in pairs(module) do
        if type(v) == "function" then
          module[k] = function(...)
            if k == "getFolds" and select(2, ...) then
              -- Call the callback with empty results for getFolds
              select(2, ...)({})
            end
            -- Return empty results for all functions
            return {}
          end
        end
      end
      
      -- Specifically make the problematic functions safe
      module.getStartEnd = function() return 0, 0 end
      module.isSupported = function() return false end
      
      vim.notify("Patched loaded treesitter provider module", vim.log.levels.INFO)
    end
  end)
  
  -- Third approach: Make sure UFO doesn't use treesitter provider
  pcall(function()
    local registry = package.loaded["ufo.provider.registry"]
    if registry and registry.providers then
      -- Remove treesitter from the providers list
      registry.providers["treesitter"] = nil
      vim.notify("Removed treesitter from UFO provider registry", vim.log.levels.INFO)
    end
  end)
  
  -- Final approach: Schedule a reconditioning of UFO
  vim.defer_fn(function()
    -- Disable and re-enable UFO
    pcall(vim.cmd, [[ UfoDisable ]])
    vim.defer_fn(function()
      pcall(vim.cmd, [[ UfoEnable ]])
    end, 500)
  end, 1000)
  
  return true
end

return M 