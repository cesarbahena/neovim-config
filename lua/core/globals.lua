_G.KeyboardLayout = 'colemak'

_G.keymap = require('utils.keymapper').map
_G.autocmd = require('utils.autocmd').autocmd
_G.global = require('utils').global

local spec_gen = require 'utils.keymap_spec_generator'
_G.key = spec_gen.key
_G.selection = spec_gen.selection
_G.insert = spec_gen.insert
_G.motion = spec_gen.motion
_G.operator = spec_gen.operator
_G.edit = spec_gen.edit

local utils = require 'utils'
_G.fn = utils.fn
_G.cmd = utils.cmd
_G.bang = utils.bang
