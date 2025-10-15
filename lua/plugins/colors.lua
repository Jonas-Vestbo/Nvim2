-- Palettes are the base color defines of a colorscheme.
-- You can override these palettes for each colorscheme defined by github-theme.
local palettes = {
  -- Everything defined under all will be applied to each style.
  all = {
    -- Each palette defines these colors:
    --   blacj, gray, blue, green, magenta, pinj, red, white, yellow, cyan
    --
    -- These colors have 2 shades: base, and bright

    -- Passing a string sets the base
    red = '#ff0000',
  },
  github_dark_high_contrast = {
    -- Defining multiple shades is done by passing a table
    red = {
      base = '#8e1519',
      bright = '#ee0000',
    },
  },
  github_dark_dimmed = {
    -- A palette also defines the following:
    --   bg0, bg1, bg2, bg3, bg4, fg0, fg1, fg2, fg3, sel0, sel1, comment
    --
    -- These are the different foreground and background shades used by the theme.
    -- The base bg and fg is 1, 0 is normally the dark alternative. The others are
    -- incrementally lighter versions.
    bg1 = '#444c56',

    -- sel is different types of selection colors.
    sel0 = '#adbac7', -- Popup bg, visual selection bg
    sel1 = '#22272e', -- Popup sel bg, search bg

    -- comment is the definition of the comment color.
    comment = '#636e7b',
  },
}


-- Spec's (specifications) are a mapping of palettes to logical groups that will be
-- used by the groups. Some examples of the groups that specs map would be:
--   - syntax groups (functions, types, keywords, ...)
--   - diagnostic groups (error, warning, info, hints) - git groups (add, removed, changed)
--
-- You can override these just like palettes
local specs = {
  -- As with palettes, the values defined under all will be applied to every style.
  all = {
    syntax = {
      -- Specs allow you to define a value using either a color or template. If the string does
      -- start with # the string will be used as the path of the palette table. Defining just
      -- a color uses the base version of that color.
      keyword = 'magenta',

      -- Adding either .bright will change the value
      -- conditional = 'magenta.bright',
      number = 'orange',
    },
    git = {
      -- A color define can also be used
      changed = '#ffa261',
    },
  },
  github_dark = {
    syntax = {
      -- As with palettes, a specific style's value will be used over the all's value.
      operator = 'orange',
    },
  },
}

-- Groups are the highlight group definitions. The keys of this table are the name of the highlight
-- groups that will be overridden. The value is a table with the following keys:
--   - fg, bg, style, sp, link,
--
-- Just like spec groups support templates. This time the template is based on a spec object.
local groups = {
  -- As with specs and palettes, the values defined under all will be applied to every style.
  all = {
    -- If link is defined it will be applied over any other values defined
    Whitespace = { link = 'Comment' },

    -- Specs are used for the template. Specs have their palette's as a field that can be accessed
    IncSearch = { bg = 'palette.cyan' },
  },
  github_dark = {
    -- As with specs and palettes, a specific style's value will be used over the all's value.
    PmenuSel = { bg = '#73daca', fg = 'bg0' },
  },
}

local options = {
    transparent = true
}
function ColorMyPencils(color)
    color = color or "rose-pine"
    -- vim.cmd.colorscheme(color)
    vim.opt.guicursor = "n:block-CursorNormal,i:block-CursorInsert-blinkon1-blinkoff1"
    -- Definer highlight grupper
    vim.cmd([[
    highlight CursorNormal guibg=gray guifg=NONE blend=50
    ]])
end

return {
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "hard", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = true,
            })
        end,
    },
    {
        "eldritch-theme/eldritch.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function ()
            require("eldritch").setup({
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent"
                }
            })
        end
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function ()
            require("cyberdream").setup({
                -- Set light or dark variant
                -- variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

                -- Enable transparent background
                transparent = true,

                -- Reduce the overall saturation of colours for a more muted look
                saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

                -- Enable italics comments
                italic_comments = true,

                -- Replace all fillchars with ' ' for the ultimate clean look
                hide_fillchars = false,

                -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
                borderless_pickers = true,

                -- Set terminal colors used in `:terminal`
                terminal_colors = true,

                -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
                cache = false,

                -- Override highlight groups with your own colour values
                highlights = {
                    -- Highlight groups to override, adding new groups is also possible
                    -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

                    -- Example:
                    Comment = { fg = "#696969", bg = "NONE", italic = true },

                    -- More examples can be found in `lua/cyberdream/extensions/*.lua`
                },

                -- Override a highlight group entirely using the built-in colour palette
                overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
                    -- Example:
                    return {
                        Comment = { fg = colors.green, bg = "NONE", italic = true },
                        ["@property"] = { fg = colors.magenta, bold = true },
                    }
                end,

                -- Override a color entirely
                colors = {
                    -- For a list of colors see `lua/cyberdream/colours.lua`
                    -- Example:
                    bg = "#000000",
                    green = "#00ff00",
                    magenta = "#ff00ff",
                },

                -- Disable or enable colorscheme extensions
                extensions = {
                    telescope = true,
                    notify = true,
                    mini = true,
                },
            })
        end
    },

    {
        "catppuccin/nvim",
        name = "catppuccin", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        config = function()
            require('catppuccin').setup({
                flavour = "macchiato", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = true, -- disables setting the background color.
                show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
                term_colors = false, -- sets terminal colors (e.g. g:terminal_color_0)
                dim_inactive = {
                    enabled = false, -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                no_underline = false, -- Force no underline
                styles = { -- Handles the styles of general hi groups (see :h highlight-args):
                    comments = { "italic" }, -- Change the style of comments
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                    -- miscs = {}, -- Uncomment to turn off hard-coded styles
                },
                color_overrides = {},
                custom_highlights = {},
                default_integrations = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = false,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            })
        end
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                variant = "moon",
                styles = {
                    italic = false,
                },
            })
        end
    },

    {
        'marko-cerovac/material.nvim',
        name="material",
        config = function()
            require('material').setup({
                contrast = {
                    terminal = false, -- Enable contrast for the built-in terminal
                    sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
                    floating_windows = false, -- Enable contrast for floating windows
                    cursor_line = false, -- Enable darker background for the cursor line
                    lsp_virtual_text = false, -- Enable contrasted background for lsp virtual text
                    non_current_windows = false, -- Enable contrasted background for non-current windows
                    filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
                },

                styles = { -- Give comments style such as bold, italic, underline etc.
                    comments = { --[[ italic = true ]] },
                    strings = { --[[ bold = true ]] },
                    keywords = { --[[ underline = true ]] },
                    functions = { --[[ bold = true, undercurl = true ]] },
                    variables = {},
                    operators = {},
                    types = {},
                },

                plugins = { -- Uncomment the plugins that you use to highlight them
                    -- Available plugins:
                    -- "coc",
                    -- "colorful-winsep",
                    -- "dap",
                    -- "dashboard",
                    -- "eyeliner",
                    -- "fidget",
                    -- "flash",
                    -- "gitsigns",
                    "harpoon",
                    -- "hop",
                    -- "illuminate",
                    -- "indent-blankline",
                    -- "lspsaga",
                    -- "mini",
                    -- "neogit",
                    -- "neotest",
                    "neo-tree",
                    -- "neorg",
                    -- "noice",
                    -- "nvim-cmp",
                    -- "nvim-navic",
                    -- "nvim-tree",
                    -- "nvim-web-devicons",
                    -- "rainbow-delimiters",
                    -- "sneak",
                    "telescope",
                    -- "trouble",
                    -- "which-key",
                    -- "nvim-notify",
                },

                disable = {
                    colored_cursor = false, -- Disable the colored cursor
                    borders = false, -- Disable borders between vertically split windows
                    background = true, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
                    term_colors = false, -- Prevent the theme from setting terminal colors
                    eob_lines = false -- Hide the end-of-buffer lines
                },

                high_visibility = {
                    lighter = false, -- Enable higher contrast text for lighter style
                    darker = true -- Enable higher contrast text for darker style
                },

                lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )

                async_loading = true, -- Load parts of the theme asynchronously for faster startup (turned on by default)

                custom_colors = nil, -- If you want to override the default colors, set this to a function

                custom_highlights = {}, -- Overwrite highlights with your own
            })
        end

    },

    {
        'projekt0n/github-nvim-theme',
        name = 'github_theme',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({ palettes = palettes, specs = specs, groups = groups , options = options})
            vim.cmd('colorscheme github_dark')
        end,
    },
    -- Using Lazy
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        config = function()
            require("onedarkpro").setup({
                options = {
                    transparency = true
                }
            })
        end
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
        end
    },
}
