-- Compatibility fix for deprecated vim.lsp.get_active_clients function
-- This file provides a backward compatibility layer for plugins using the deprecated function

-- Check if vim.lsp.get_clients exists (Neovim 0.10+)
if vim.lsp.get_clients then
  -- Create a compatibility wrapper
  vim.lsp.get_active_clients = vim.lsp.get_clients
end

-- Add compatibility for deprecated vim.str_utfindex function
if not vim.str_utfindex then
  vim.str_utfindex = function(str, index, start)
    return vim.str_utfindex8(str, index, start and 1 or 0, true)
  end
end

-- Return nil to properly load the module
return nil 