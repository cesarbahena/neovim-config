local M = {}

local function should_tw_values(ft)
  ft = ft or vim.bo.filetype
  if not vim.tbl_contains({
    'typescript',
    'vue',
    'html',
    'templ',
  }, ft) then return false end
  local clients = vim.lsp.get_clients { name = 'tailwindcss' }
  if not clients[1] then return false end
  local ft_query = [[
    (attribute
      (attribute_name) @attr_name
        (quoted_attribute_value (attribute_value) @attr_val)
        (#match? @attr_name "class")
    )
    ]]
  local ok, query = pcall(vim.treesitter.query.parse, ft, ft_query)
  if not ok or not query then return end
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.treesitter.get_node {
    bufnr = bufnr,
    ignore_injections = false,
  }
  if cursor == nil then return false end
  local parent = cursor:parent()
  if not parent then return false end
  local isclass_attr = vim.treesitter.get_node_text(cursor, bufnr) == 'class'
  for id, _ in query:iter_captures(parent, bufnr, 0, -1) do
    return isclass_attr and #query.captures[id] > 0
  end
  parent = parent:parent()
  if not parent then return false end
  isclass_attr = vim.treesitter.get_node_text(parent, bufnr):match '^class='
  for id, _ in query:iter_captures(parent, bufnr, 0, -1) do
    return isclass_attr and #query.captures[id] > 0
  end
end

local function is_diag_for_cur_pos()
  local diagnostics = vim.diagnostic.get(0)
  local pos = vim.api.nvim_win_get_cursor(0)
  if #diagnostics == 0 then return false end
  local message = vim.tbl_filter(function(d) return d.col == pos[2] and d.lnum == pos[1] - 1 end, diagnostics)
  return #message > 0
end

local function is_diag_neotest()
  local diagnostics = vim.diagnostic.get(0)
  local found = false
  for _, d in ipairs(diagnostics) do
    if d.source and d.source:match 'neotest' then
      found = true
      break
    end
  end
  return found
end

function M.hover_handler()
  local dap_ok, dap = pcall(require, 'dap')
  if dap_ok and dap.session() ~= nil then
    local dapui_ok, dapui = pcall(require, 'dap.ui.widgets')
    if dapui_ok and vim.bo.filetype ~= 'dap-float' then dapui.hover(nil, { border = 'rounded' }) end
  end
  local ft = vim.bo.filetype
  if vim.tbl_contains({ 'vim', 'help' }, ft) then
    vim.cmd('silent! h ' .. fn.expand '<cword>')
  elseif should_tw_values(ft) then
    vim.cmd 'TWValues'
  elseif vim.tbl_contains({ 'man' }, ft) then
    vim.cmd('silent! Man ' .. fn.expand '<cword>')
  elseif is_diag_for_cur_pos() then
    if is_diag_neotest() then
      local nt_ok, nt = pcall(require, 'neotest')
      if nt_ok then nt.output.open {
        enter = true,
        auto_close = true,
      } end
    else
      vim.diagnostic.open_float()
    end
  else
    vim.lsp.buf.hover {
      border = 'rounded',
      silent = true,
      winopts = {
        conceallevel = 3,
      },
    }
  end
end

return M
