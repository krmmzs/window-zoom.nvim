-- window-zoom.nvim plugin entry point
if vim.fn.has("nvim-0.7.0") == 0 then
    vim.api.nvim_err_writeln("window-zoom.nvim requires at least Neovim 0.7.0")
    return
end

-- Prevent loading the plugin multiple times
if vim.g.loaded_window_zoom then
    return
end
vim.g.loaded_window_zoom = true

-- Load the plugin with default configuration
require("window-zoom").setup({})
