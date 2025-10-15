local on_attach = function(client, bufnr)
	-- only set up formatting if the server advertises it
	if client.server_capabilities.documentFormattingProvider then
		-- <leader>ft to format
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
	{
		"rafamadriz/friendly-snippets",
		dependencies = { "L3MON4D3/LuaSnip" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })
		end,
	},
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
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- local lspconfig = require("lspconfig")
			local love_path = "/home/jonas/.local/share/nvim/mason/packages/lua-language-server/libexec/meta/3rd/love2d"

			vim.lsp.config("lua_ls",{
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

			vim.lsp.config("lspconfig.kotlin_language_server",{
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

			vim.lsp.config("rust_analyzer",{ capabilities = capabilities })
			-- lspconfig.svelte.setup({ capabilities = capabilities })
			-- lspconfig.sqlls.setup({ capabilities = capabilities })
			-- lspconfig.csharp_ls.setup({ capabilities = capabilities })
			-- lspconfig.sqls.setup({ capabilities = capabilities })
			-- lspconfig.cssls.setup({ capabilities = capabilities })
			-- lspconfig.intelephense.setup({ capabilities = capabilities })
			-- lspconfig.hls.setup({ capabilities = capabilities })
			-- require('lspconfig').omnisharp.setup({
			--     cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			--     root_dir = require('lspconfig.util').root_pattern("*.sln"),
			--     capabilities = require('cmp_nvim_lsp').default_capabilities(),
			-- })

			-- lspconfig.ltex.setup({
			--     capabilities = capabilities,
			--     filetypes = {"tex"},
			--     language = "en-GB",
			-- })
			-- lspconfig.texlab.setup({
			--     capabilities = capabilities,
			--     filetypes = {"tex"},
			-- })
			--
			-- lspconfig.ltex_plus.setup({
			--     capabilities = capabilities,
			--     filetypes = {"tex"},
			--     language = "en-GB",
			-- })

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = "/usr/local/lib/@vue/typescript-plugin",
							languages = { "vue" },
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})

			-- lspconfig.volar.setup({ filetypes = { "vue" }, capabilities = capabilities })
			vim.lsp.config("html",{ filetypes = { "html, cshtml" }, capabilities = capabilities })
			vim.lsp.config("htmx",{ capabilities = capabilities })
			-- lspconfig.jdtls.setup({ capabilities = capabilities })
			-- lspconfig.gopls.setup({ capabilities = capabilities })
			-- lspconfig.clangd.setup({ capabilities = capabilities })
			--
			-- lspconfig.pylsp.setup({
			-- 	settings = {
			-- 		pylsp = {
			-- 			plugins = {
			-- 				pycodestyle = {
			-- 					ignore = { "W391", "E501" },
			-- 					maxLineLength = 100,
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- 	capabilities = capabilities,
			-- })

			vim.lsp.config("bashls",{ capabilities = capabilities, filetypes = { "zsh", "sh" } })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_buf_set_option(args.buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
					end
				end,
			})

			vim.keymap.set("n", "<leader>mm", function()
				vim.diagnostic.open_float()
			end, {})
			vim.keymap.set("n", "K", '<cmd>Lspsaga hover_doc<CR>', {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, {})

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				max_width = 80,
				max_height = 20,
				border = "rounded",
				focusable = false,
			})

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

	-- Completion and hover documentation configuration
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				},
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
						max_width = 80,
						max_height = 15,
					},
					documentation = {
						border = "rounded",
						max_width = 80,
						max_height = 15,
						zindex = 50, -- Ensure it's not drawn over completion menu
					},
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "vimtex" },
				}),
			})
		end,
	},
}
