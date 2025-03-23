--[[
Implementation approach:
This window zoom functionality is designed based on a "save-modify-restore" pattern, implemented through these steps:
1. State Preservation:
   - Before zooming, save references to all windows, current window, and tab page information
   - Use local table variables for storage, avoiding global namespace pollution
2. Window Zooming:
   - Maintain visibility of the current window
   - Temporarily hide all other windows (using the hide property rather than closing them)
   - Achieve a visual "maximization" effect while preserving all window states
3. Layout Restoration:
   - Perform multi-level safety checks to ensure operation validity
   - Restore visibility of all windows
   - Return focus to the original window
   - Clean up saved state data
Advantages: Non-destructive operation that preserves all window content and states, supporting perfect restoration to the pre-zoom layout.
Use cases: Scenarios requiring temporary focus on a single window for editing or viewing content.
]]
local M = {}

-- window state
local is_zoomed = false

-- Store the original window layout
local original_layout = {}

-- Default configuration
local default_config = {
  -- Key mappings
  mappings = {
    toggle = "<leader>z", -- Default mapping to toggle zoom
  },
  -- Appearance
  border = "none", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
}

-- deepcopy a new table for user's config
local config = vim.deepcopy(default_config)

-- Setup function to configure the plugin
function M.setup(user_config)
  config = vim.tbl_deep_extend("force", default_config, user_config or {})

  -- Set up keymappings if enabled
  if config.mappings.toggle then
    vim.keymap.set("n", config.mappings.toggle, M.toggle, { noremap = true, silent = true })
  end
end

-- Save the current window layout
local function save_layout()
  original_layout = {
    -- These three APIs create a complete "snapshot"
    wins = vim.api.nvim_list_wins(),
    current = vim.api.nvim_get_current_win(),
    tab = vim.api.nvim_get_current_tabpage(),
  }
end

-- Restore the original window layout
local function restore_layout()
  if original_layout.tab and vim.api.nvim_tabpage_is_valid(original_layout.tab) then
    -- Only restore if we're still in the same tab
    if original_layout.tab == vim.api.nvim_get_current_tabpage() then
      -- Restore all windows
      for _, win in ipairs(original_layout.wins) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_set_config(win, { hide = false })
        end
      end

      -- Focus the window that was focused before zooming
      if original_layout.current and vim.api.nvim_win_is_valid(original_layout.current) then
        vim.api.nvim_set_current_win(original_layout.current)
      end
    end
  end

  -- Clear the saved layout
  original_layout = {}
end

-- Zoom the current window
local function zoom_window()
  local current_win = vim.api.nvim_get_current_win()
  save_layout()

  -- Hide all windows except the current one
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= current_win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_config(win, { hide = true })
    end
  end
end

-- Toggle zoom state
function M.toggle()
  if is_zoomed then
    restore_layout()
    is_zoomed = false
    vim.notify("Window zoom disabled", vim.log.levels.INFO)
  else
    zoom_window()
    is_zoomed = true
    vim.notify("Window zoom enabled", vim.log.levels.INFO)
  end
end

-- Zoom in function
function M.zoom_in()
  if not is_zoomed then
    zoom_window()
    is_zoomed = true
    vim.notify("Window zoom enabled", vim.log.levels.INFO)
  end
end

-- Zoom out function
function M.zoom_out()
  if is_zoomed then
    restore_layout()
    is_zoomed = false
    vim.notify("Window zoom disabled", vim.log.levels.INFO)
  end
end

return M
