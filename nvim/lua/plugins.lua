vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/RRethy/base16-nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.cmp", -- 自动补全
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-lualine/lualine.nvim", -- 状态栏
	"https://github.com/goolord/alpha-nvim", -- greeter
	"https://github.com/norcalli/nvim-colorizer.lua",
})
vim.cmd.colorscheme("tokyonight-storm")
vim.pack.add({
	"https://github.com/catgoose/nvim-colorizer.lua",
})

require 'colorizer'.setup()

require("blink.cmp").setup()
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		json = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },

		-- kdl = { "kdlfmt" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		require("conform").format({
			bufnr = args.buf,
			lsp_fallback = true,
		})
	end,
})

require("blink.cmp").build():pwait()

require("alpha").setup(require("alpha.themes.dashboard").config)

require("lualine").setup({
	options = {
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
