return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader>pu", vim.cmd.UndotreeToggle)
	end,
}
