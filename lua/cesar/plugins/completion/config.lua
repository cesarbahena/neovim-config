local cmp = require "cmp"

cmp.setup {
  sources = cmp.config.sources({
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "copilot" },
  }, {
    { name = "path" },
    { name = "buffer", keyword_length = 5 },
  }, {
  }),

  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0

        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

-- cmp.setup.cmdline("/", {
--   completion = {
--     -- Might allow this later, but I don't like it right now really.
--     -- Although, perhaps if it just triggers w/ @ then we could.
--     --
--     -- I will have to come back to this.
--     autocomplete = false,
--   },
--   sources = cmp.config.sources({
--     { name = "nvim_lsp_document_symbol" },
--   }, {
--     -- { name = "buffer", keyword_length = 5 },
--   }),

-- })

-- cmp.setup.cmdline(":", {

--   completion = {
--     autocomplete = false,
--   },
--
--   sources = cmp.config.sources({
--     {
--       name = "path",
--     },
--   }, {
--     {
--       name = "cmdline",
--       max_item_count = 20,
--       keyword_length = 4,
--     },
--   }),

-- })

--[[
" Setup buffer configuration (nvim-lua source only enables in Lua filetype).

"
" ON YOUTUBE I SAID: This only _adds_ sources for a filetype, not removes the global ones.
"
" BUT I WAS WRONG! This will override the global setup. Sorry for any confusion.
autocmd FileType lua lua require'cmp'.setup.buffer {
\   sources = {
\     { name = 'nvim_lua' },
\     { name = 'buffer' },
\   },
\ }
--]]

-- -- Add vim-dadbod-completion in sql files
-- _ = vim.cmd [[
--   augroup DadbodSql
--     au!
--
--     autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
--   augroup END
-- ]]
--
-- _ = vim.cmd [[
--   augroup CmpZsh
--
--     au!
--     autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
--   augroup END
-- ]]

--[[
" Disable cmp for a buffer
autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
--]]

local Group = require("colorbuddy.group").Group
local g = require("colorbuddy.group").groups
local s = require("colorbuddy.style").styles

Group.new("CmpItemAbbr", g.Comment)
Group.new("CmpItemAbbrDeprecated", g.Error)
Group.new("CmpItemAbbrMatchFuzzy", g.CmpItemAbbr.fg:dark(), nil, s.italic)
Group.new("CmpItemKind", g.Special)
Group.new("CmpItemMenu", g.NonText)
