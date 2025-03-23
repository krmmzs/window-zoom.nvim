# window-zoom.nvim

A simple Neovim plugin for zooming in and out of windows, allowing you to focus on a single window temporarily and then restore the original layout.

## Features

- Toggle zoom state of the current window
- Separate zoom in and zoom out functions
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
