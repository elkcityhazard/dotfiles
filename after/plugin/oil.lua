require("oil").setup({
    default_file_explorer = false,
    view_options = {
        show_hidden = true
    },
    delete_to_trash = true,
    preview = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        win_options = {
            winblend = 0,
        },
    },
})
