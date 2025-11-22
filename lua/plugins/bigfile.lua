return {
  { "folke/lazy.nvim", lazy = false, opts = {
      performance = {
        disable_events = "FileReadPre",
        rtp = {
          disabled_plugins = { "bigfile" },
        },
      },
  }},
}
