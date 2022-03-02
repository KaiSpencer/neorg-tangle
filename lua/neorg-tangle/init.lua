local queries = require("vim.treesitter.query")
local context_manager = require("plenary.context_manager")
local open = context_manager.open
local with = context_manager.with
local lua_code_query = queries.get_query("norg", "lua-code")

local M = {}

--- Parse a buffer and return a list of tables containing the start and end line of each block
---@param bufnr string
---@return table
local get_all_lua_blocks = function(bufnr)
  local blocks = {}

  local parser = vim.treesitter.get_parser(bufnr, "lua")
  local tstree = parser:parse()[1] -- Hard coded 1 may be an issue here?
  local root_node = tstree:root()

  for id, node, _ in lua_code_query:iter_captures(root_node, 0) do
    local name = lua_code_query.captures[id]
    local row1, _, row2, _ = node:range() -- range of the capture

    if name == "capture" then
      table.insert(blocks, {row1 + 1, row2})
    end
  end
  return blocks
end

local get_buf_lines_from_range_blocks = function(bufnr, blocks)
  local lines = {}
  for _, value in ipairs(blocks) do
    local lines_from_range = vim.api.nvim_buf_get_lines(bufnr, value[1], value[2], true)
    table.insert(lines, lines_from_range)
  end
  return lines
end

local write_lua_lines_to_file = function(bufnr, lines)
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  local out_file_name = string.gsub(buf_name, ".norg", ".lua")
  with(
    open(out_file_name, "w"),
    function(writer)
      for _, line_group in ipairs(lines) do
        for _, line in ipairs(line_group) do
          writer:write(line)
          writer:write("\n")
        end
        writer:write("\n\n")
      end
    end
  )
end

--- Tangle the current buffer into a lua file in the same directory
M.tangle_file = function()
  local blocks = get_all_lua_blocks(0)
  local lines_from_blocks = get_buf_lines_from_range_blocks(0, blocks)
  write_lua_lines_to_file(0, lines_from_blocks)
end

return M
