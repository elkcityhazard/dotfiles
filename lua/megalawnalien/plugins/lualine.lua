return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	globals = { "vim" },
	config = function()
		require("lualine").setup()
	end,
}
