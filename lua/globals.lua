-- Global variable and function setup
local M = {}

function M.setup()
  _G.KeyboardLayout = "colemak"

  _G.try = require 'utils.error_handler'.try
  _G.keymap = require 'utils.keymapper'.map
  _G.autocmd = require 'utils.autocmd'.autocmd
  _G.global = require 'utils'.global

  local spec_gen = require 'utils.keymap_spec_generator'
  _G.normal = spec_gen.normal
  _G.visual = spec_gen.visual
  _G.pending = spec_gen.pending
  _G.insert = spec_gen.insert
  _G.command = spec_gen.command
  _G.motion = spec_gen.motion
  _G.operator = spec_gen.operator
  _G.edit = spec_gen.edit

  local utils = require 'utils'
  _G.fn = utils.fn
  _G.cmd = utils.cmd
end

return M