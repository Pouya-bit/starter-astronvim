-- compat.lua - Handle deprecated Neovim API functions
-- This file provides compatibility functions for deprecated Neovim APIs

-- Handle deprecated vim.str_utfindex
-- The new API requires encoding, index, and strict_indexing parameters
local original_str_utfindex = vim.str_utfindex
vim.str_utfindex = function(s, ...)
  local args = {...}
  if #args == 1 then
    -- Old usage: vim.str_utfindex(s, idx)
    return original_str_utfindex(s, "utf-16", args[1], false)
  else
    -- Pass through to new API
    return original_str_utfindex(s, ...)
  end
end

-- Handle deprecated vim.validate
-- The new API requires name, value, validator, optional_or_msg
local original_validate = vim.validate
vim.validate = function(tbl)
  if type(tbl) == "table" then
    -- This is the old style validation table
    for param_name, spec in pairs(tbl) do
      local value = spec[1]
      local type_name = spec[2]
      local optional = spec[3] or false
      local msg = spec[4]
      
      if type_name == "table" and type(spec[2]) == "table" then
        -- Handle nested table validation
        if not optional or value ~= nil then
          original_validate(param_name, value, type_name, msg or optional)
        end
      else
        -- Basic type validation
        if type(type_name) == "string" then
          -- Type check validation
          if not optional or value ~= nil then
            -- For string type validation, we need to check the type directly
            if type_name == "string" and type(value) == "string" then
              -- Type matches, do nothing
            elseif type_name == "number" and type(value) == "number" then
              -- Type matches, do nothing
            elseif type_name == "boolean" and type(value) == "boolean" then
              -- Type matches, do nothing
            elseif type_name == "table" and type(value) == "table" then
              -- Type matches, do nothing
            elseif type_name == "function" and type(value) == "function" then
              -- Type matches, do nothing
            else
              -- Type doesn't match, raise error
              error(string.format("%s: expected %s, got %s", param_name, type_name, type(value)))
            end
          end
        elseif type(type_name) == "function" then
          -- Function validation
          if not optional or value ~= nil then
            local ok = type_name(value)
            if not ok then
              error(string.format("%s: validation function failed", param_name))
            end
          end
        end
      end
    end
    return true
  else
    -- Pass through to new API for non-table arguments
    return original_validate(tbl)
  end
end

return {} 