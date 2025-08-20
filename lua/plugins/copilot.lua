return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {},
  },
  {
    'saghen/blink.cmp',
    optional = true,
    dependencies = { 'giuxtaposition/blink-cmp-copilot' },
    opts = {
      sources = {
        default = { 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            kind = 'Copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
