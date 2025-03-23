# window-zoom.nvim

A simple Neovim plugin for zooming in and out of windows, allowing you to focus on a single window temporarily and then restore the original layout.

## Features

- Toggle zoom state of the current window
- Separate zoom in and zoom out functions
- Two zoom methods:
  - Tab-based zooming (default): Opens the current window in a new tab
  - Window hiding: Hides all windows except the current one
- Customizable key mappings
- Simple and lightweight implementation

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'mouzaisi/window-zoom.nvim',
    config = function()
        require('window-zoom').setup()
    end
}

## Config


```lua
require('window-zoom').setup({
    -- Key mappings
    mappings = {
        toggle = "<leader>z", -- Default mapping to toggle zoom
    },
    -- Appearance
    border = "none", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    -- Zoom method
    use_tab_zoom = true, -- Use tab-based zooming instead of window hiding
})
```

## Usage

you can call

```lua
-- Toggle zoom state
require('window-zoom').toggle()

-- Zoom in
require('window-zoom').zoom_in()

-- Zoom out
require('window-zoom').zoom_out()
```
