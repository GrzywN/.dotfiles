require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		typescriptreact = {
			require("formatter.filetypes.typescript").prettier,
		},
		dart = {
			require("formatter.filetypes.dart").dartformat,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
