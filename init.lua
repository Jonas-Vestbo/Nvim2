-- SET --initlvim
vim.g.mapleader = " "
-- Makes it so that i can see the current linenumber
vim.opt.nu = true
-- Makes the linenumbers relative
vim.opt.relativenumber = true
-- Makes it so that the cursor blinks
vim.opt.confirm = true

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

--Makes it so that there is always min 8 lines between cursor and end of screen
vim.opt.updatetime = 50

-- Makes it so that yanked text is highlighted
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Highlight selection on yank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
})


vim.g.vimtex_complete_enabled = 1
vim.g.vimtex_complete_resolve = 1

vim.g.vimtex_complete_popup_position = "bottom"

-- SET DONE --

-- REMAPS --
vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<leader>pv", ":Neotree position=current<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>pv', ':Ex<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>popen_currentv', ':Ex<CR>', { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>S", vim.cmd.wa)
vim.keymap.set("t", "<leader>nn", vim.cmd.bd)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>gv", ":Neogit<CR>", { noremap = true, silent = true })
-- Toggle wrap function
local function toggle_wrap()
	vim.opt.wrap = not vim.opt.wrap:get() -- Toggle wrap
	vim.opt.linebreak = not vim.opt.linebreak:get() -- Toggle linebreak
	if vim.wo.signcolumn:get() == "no" then -- Toggle signcolumn
		vim.wo.signcolumn = "auto"
	else
		vim.wo.signcolumn = "no"
	end
end

-- Normal mode mapping (e.g., <leader>tw)
vim.keymap.set("n", "<leader>tw", toggle_wrap, { noremap = true, silent = true, desc = "Toggle line wrapping" })

-- vim.keymap.set("v", "<leader>gcc", "jkI//<esc>")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", '"_dp')
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "gb", ":b#<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-j>", ":cnext<CR>", {noremap = true, silent = true})
-- vim.keymap.set("n", "<C-k>", ":cprev<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-j>", "<cmd>Lspsaga diagnostic_jump_next<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-k>", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {noremap = true, silent = true})
			vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", {})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "Trouble",
	callback = function()
		local opts = { buffer = true, desc = "Trouble navigation" }

		vim.keymap.set("n", "<C-j>", function()
			require("trouble").next({ skip_groups = true, jump = true })
		end, opts)

		vim.keymap.set("n", "<C-k>", function()
			require("trouble").prev({ skip_groups = true, jump = true })
		end, opts)
	end,
})
-- vim.keymap.set('i', '<RIGHT>', 'copilot#Accept("\\<CR>")', {
--     expr = true,
--     replace_keycodes = false
-- })

-- REMAP DONE --
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#3B4252", fg = "#5E81AC" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#3B4252" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#3B4252" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#3B4252" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

--     -- Toggle wrap function
-- local function toggle_wrap()
--   vim.opt.wrap = not vim.opt.wrap:get()
-- end

vim.keymap.set("n", "<leader>ot", ":e ~/orgfiles/todo.org<CR>", { desc = "Open Org TODO file" })
vim.keymap.set("n", "<leader>op", ":e ~/orgfiles/project.org<CR>", { desc = "Open Org Project file" })
vim.keymap.set("n", "<leader>on", ":e ~/orgfiles/refile.org<CR>", { desc = "Open Org refile file" })

-- Normal mode mapping (e.g., <leader>tw)
vim.keymap.set("n", "<leader>tw", toggle_wrap, { noremap = true, silent = true, desc = "Toggle line wrapping" })
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		-- Set buffer-local keymaps for tex files
		vim.api.nvim_buf_set_keymap(0, "n", "j", "gj", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, "n", "k", "gk", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, "v", "j", "gj", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, "v", "k", "gk", { noremap = true, silent = true })
	end,
})

-- Auto-reload files changed outside of Neovim (e.g., via lazygit in another tmux pane)
vim.opt.autoread = true

-- When Neovim regains focus or you enter a buffer, ask Vim to check if files changed
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	pattern = "*",
	callback = function()
		-- Only check for normal listed, modifiable buffers
		if vim.api.nvim_buf_get_option(0, "buftype") == "" and vim.api.nvim_buf_get_option(0, "modifiable") then
			vim.cmd("checktime")
		end
	end,
})

-- Nice notice when a file was reloaded because it changed on disk
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*",
	callback = function()
		local name = vim.api.nvim_buf_get_name(0)
		pcall(vim.notify, ("File changed on disk. Reloaded: %s"):format(vim.fn.fnamemodify(name, ":.")))
	end,
})

vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "NONE", fg = "#cdd6f4" }) -- or your theme's fg
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "NONE", fg = "#89b4fa" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- local scheme = require("colorscheme_picker")
--
-- Load saved scheme on startup
-- scheme.init()

-- Keybindings
-- vim.keymap.set("n", "<leader>cs", scheme.toggle_next, { desc = "Toggle colorscheme" })
-- vim.keymap.set("n", "<leader>fs", scheme.pick_colorscheme, { desc = "Pick colorscheme" })

-- local file = vim.fn.stdpath("cache") .. "/last_colorscheme.txt"
--
-- local current = vim.fn.readfile(file)[1] or "nvim"
--
-- vim.cmd.colorscheme(current)
-- local scheme = require("cs_picker")
-- scheme.init()
