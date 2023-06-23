return function(picker, preset, opts, extension)
  local function params(defaults)
    if opts then
      return vim.tbl_deep_extend("force", defaults, opts)
    end
    return defaults
  end

  local presets = {
    ivy = require("telescope.themes").get_ivy(params({
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "top",
      },
    })),

    dropdown = require("telescope.themes").get_dropdown(params({
      sorting_strategy = "ascending",
      previewer = false,
    })),

    tiny = require("telescope.themes").get_dropdown(params({
      sorting_strategy = "ascending",
      previewer = false,
      layout_config = {
        width = { padding = 0.4 },
      },
    })),

    vertical = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        prompt_position = "top",
        width = 0.9,
        height = 0.95,
        preview_height = 0.5,
      },
    },

    padded = params({
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
        width = { padding = 0.2 },
        preview_width = 0.6,
      },
    }),

    wide = params({
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
        width = 0.95,
        height = 0.85,
        preview_width = 0.6,
      },
    }),
  }

  if extension then
    return function()
      require("telescope").extensions[extension][picker](presets[preset])
    end
  end
  return function()
    require("telescope.builtin")[picker](presets[preset])
  end
end
