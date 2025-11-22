local on_attach = function(client, bufnr)
	-- only set up formatting if the server advertises it
	if client.server_capabilities.documentFormattingProvider then
		-- <leader>gf to format
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>gf",
			"<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
			{ noremap = true, silent = true }
		)
		-- (optional) format on save:
		-- vim.api.nvim_exec([[
		--   augroup LspFmt
		--     autocmd! * <buffer>
		--     autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })
		--   augroup END
		-- ]], false)
	end
end

return {
	-- Snippets
	{
		"rafamadriz/friendly-snippets",
		dependencies = { "L3MON4D3/LuaSnip" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })
		end,
	},

	-- Mason (LSP/DAP/Linters/Formatters manager)
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},

	-- Mason LSP bridge
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})
		end,
	},

	-- LSP setup
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp", -- ensure blink is loaded before we grab capabilities
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local love_path = "/home/jonas/.local/share/nvim/mason/packages/lua-language-server/libexec/meta/3rd/love2d"

			-- Lua
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								love_path,
							},
							maxPreload = 1000,
							preloadFileSize = 100,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- Kotlin
			vim.lsp.config("kotlin_language_server", {
				capabilities = capabilities,
				cmd = { "/home/jonas/.local/opt/kotlin-language-server/server/bin/kotlin-language-server" },
				settings = {
					kotlin = {
						format = {
							enable = true,
							ktlint = {
								path = "ktlint",
							},
						},
					},
				},
				on_attach = on_attach,
			})

			-- Rust
			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
			})

			-- TypeScript / JS / Vue via tsserver + vue plugin
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"typescript",
					"javascript",
					"javascriptreact",
					"typescriptreact",
				},
			})

			-- HTML (incl. cshtml)
			vim.lsp.config("html", {
				filetypes = { "html", "cshtml" },
				capabilities = capabilities,
			})

			-- HTMX
			vim.lsp.config("htmx", {
				capabilities = capabilities,
				filetypes = {
					"html",
					"cshtml",
					"aspnetcorerazor",
					"razor",
					-- add more templating types if you actually use them,
					-- but *do not* put javascript / typescript here
				},
			})

			-- Bash / sh / zsh
			vim.lsp.config("bashls", {
				capabilities = capabilities,
				filetypes = { "bash", "zsh", "sh" },
			})

			-- Formatexpr when server supports formatting
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_buf_set_option(args.buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
					end
				end,
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>mm", function()
				vim.diagnostic.open_float()
			end, {})

			vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", {})
			vim.keymap.set("n", "<leader>fr", "<cmd>Lspsaga finder<CR>", {})
			vim.keymap.set("n", "<leader>r", "<cmd>Lspsaga rename<CR>", {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, {})

			-- Hover window look
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				max_width = 80,
				max_height = 20,
				border = "rounded",
				focusable = false,
			})

			-- Diagnostics float look
			vim.diagnostic.config({
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					guibg = "none",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},

	-- Blink completion
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		opts = {
			keymap = {
				preset = "default",
				["<C-Space>"] = { "show" },
				["<CR>"] = { "accept", "fallback" },
			},
			completion = {
				menu = {
					border = "rounded",
					auto_show = true,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
						max_width = 80,
						max_height = 15,
					},
				},
				keyword = { range = "full" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},
}
