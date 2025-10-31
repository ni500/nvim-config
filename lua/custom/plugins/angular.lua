return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		-- This will be merged with your init.lua servers table
		return vim.tbl_deep_extend("force", opts, {
			servers = {
				angularls = {
					filetypes = { "typescript", "html", "typescriptangular", "typescript.tsx" },
					root_dir = require("lspconfig.util").root_pattern(
						"nx.json",
						"angular.json",
						"project.json",
						".git"
					),
				},
			},
		})
	end,
}
