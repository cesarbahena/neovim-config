return {
  {
    "theprimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local ui = require("harpoon.ui")
      local custom_add_mark = require(User .. ".nav.add_mark")
      local keymaps = require(User .. ".config.keymaps")
      local autocmd = require(User .. ".config.autocmd")

      local nmap = {
        { "Mark file",           "<leader>aa", custom_add_mark },
        { "Toggle Harpoon menu", "<leader>am", ui.toggle_quick_menu },
        {
          "Mark file",
          "<leader>aa",
          function()
            custom_add_mark()
          end,
        },
      }

      local nkeys = { "n", "e", "i", "o" }
      for i, key in ipairs(nkeys) do
        table.insert(nmap, {
          string.format("Navigate to file %d", i),
          string.format("<C-%s>", key),
          function()
            ui.nav_file(i)
          end,
        })
      end

      for i, key in ipairs(nkeys) do
        table.insert(nmap, {
          string.format("Mark as file %d", i),
          string.format("<leader>a%s", key),
          function()
            custom_add_mark(i)
          end,
        })
      end

      keymaps({ n = nmap })

      autocmd({
        "FileType",
        "HarpoonQuickMenu",
        function()
          local menu_map = {
            { "Disabled", "<C-n>", "<nop>" },
            { "Close",    "<C-e>", ui.toggle_quick_menu },
            { "Disabled", "<C-i>", "<nop>" },
            { "Disabled", "<C-o>", "<nop>" },
          }

          for i = 1, 9 do
            table.insert(menu_map, {
              string.format("Navigate to file %d", i),
              string.format("%d", i),
              function()
                ui.nav_file(i)
              end,
            })
          end

          keymaps({ n = menu_map }, { buffer = true })
        end,
        pattern = "harpoon",
      })
    end,
  },
}
