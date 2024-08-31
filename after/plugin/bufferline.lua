-- wsl and this plugin aren't getting along,
-- don't setup bufferline if wsl is true

local in_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if in_wsl then
	return
end

require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
})
