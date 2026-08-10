-- INFO: port of vim-herdr-navigation/editor/nvim.lua, inlined instead of dofile'd —
-- the plugin lives under a content-hashed path that changes on every reinstall.
local function navigate(wincmd, herdr_direction, tmux_suffix)
  local origin = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)

  if vim.api.nvim_get_current_win() ~= origin then
    return
  end

  local pane = vim.env.HERDR_PANE_ID

  if pane and pane ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    -- INFO: --pane is mandatory here; --current resolves to the server's focused pane, not this one
    vim.system({
      herdr ~= nil and herdr ~= "" and herdr or "herdr",
      "pane",
      "focus",
      "--direction",
      herdr_direction,
      "--pane",
      pane,
    })
    return
  end

  if vim.env.TMUX and vim.env.TMUX ~= "" then
    vim.cmd("TmuxNavigate" .. tmux_suffix)
  end
end

local function navigation_key(lhs, wincmd, herdr_direction, tmux_suffix, desc)
  return {
    lhs,
    function()
      navigate(wincmd, herdr_direction, tmux_suffix)
    end,
    desc = desc,
  }
end

return {
  "christoomey/vim-tmux-navigator",
  -- INFO: kept for the tmux fallback only — inside herdr the handoff above replaces it
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    navigation_key("<c-h>", "h", "left", "Left", "Navigate left (nvim/herdr)"),
    navigation_key("<c-j>", "j", "down", "Down", "Navigate down (nvim/herdr)"),
    navigation_key("<c-k>", "k", "up", "Up", "Navigate up (nvim/herdr)"),
    navigation_key("<c-l>", "l", "right", "Right", "Navigate right (nvim/herdr)"),
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
  },
}
