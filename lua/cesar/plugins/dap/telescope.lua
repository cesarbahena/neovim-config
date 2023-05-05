return {
  'nvim-telescope/telescope-dap.nvim',
  keys = {
    { "<leader>dm", function() require 'telescope'.extensions.dap.commands(require'telescope.themes'.get_dropdown()) end,       desc =
    "Find debugger commands" },
    { "<leader>fdc", function() require 'telescope'.extensions.dap.configurations(require'telescope.themes'.get_dropdown()) end,
    desc =
    "Find debugger configurations" },
    { "<leader>fb",  function() require 'telescope'.extensions.dap.list_breakpoints {} end,
    desc =
    "Find breakpoints" },
    { "<leader>fv",  function() require 'telescope'extensions.dap.variables {} end,      desc = "Find variables" },
    { "<leader>fdf", function() require 'telescope'.extensions.dap.frames {} end,         desc = "Find frames" },
  },
  config = function ()
    require'telescope'.load_extension'dap'
  end
}
