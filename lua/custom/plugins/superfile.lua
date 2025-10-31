return {
	{
		"anaypurohit0907/superfile.nvim",
		main = "superfile",
		opts = { key = false },
		keys = {
			{
				"<C-s>", --change this to any keybing you want
				function()
					require("superfile").open()
				end,
				mode = { "n", "t" },
				desc = "Open/Focus Superfile",
				silent = true,
			},
		},
	},
}
