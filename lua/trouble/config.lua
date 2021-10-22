local M = {}

M.namespace = vim.api.nvim_create_namespace("Trouble")

---@class TroubleOptions
---@field buf number|nil
---@field win number|nil
-- TODO: make some options configurable per mode
-- TODO: make it possible to have multiple trouble lists open at the same time
local defaults = {
  debug = false,
  cmd_options = {},
  group = true, -- group results by file
  padding = 1, -- padding to use inside results window
  position = "bottom", -- position of the list can be: bottom, top, left, right
  height = 10, -- height of the trouble list when position is top or bottom
  width = 50, -- width of the list when position is left or right
  icons = true, -- use devicons for filenames
  mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
  fold_open = "", -- icon used for open folds
  fold_closed = "", -- icon used for closed folds
  action_keys = { -- key mappings for actions in the trouble list
    close = "q", -- close the list
    cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
    refresh = "r", -- manually refresh
    jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
    open_split = { "<c-x>" }, -- open buffer in new split
    open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
    open_tab = { "<c-t>" }, -- open buffer in new tab
    jump_close = { "o" }, -- jump to the diagnostic and close the list
    toggle_mode = "m", -- toggle between "workspace" and "document" mode
    toggle_preview = "P", -- toggle auto_preview
    hover = "K", -- opens a small popup with the full multiline message
    preview = "p", -- preview the diagnostic location
    close_folds = { "zM", "zm" }, -- close all folds
    open_folds = { "zR", "zr" }, -- open all folds
    toggle_fold = { "zA", "za" }, -- toggle fold of current file
    previous = "k", -- preview item
    next = "j", -- next item
  },
  indent_lines = true, -- add an indent guide below the fold icons
  auto_open = false, -- automatically open the list when you have diagnostics
  auto_close = false, -- automatically close the list when you have no diagnostics
  auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
  auto_fold = false, -- automatically fold a file trouble list at creation
  auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
  signs = {
    -- icons / text used for a diagnostic
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "﫠",
  },
  use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
}

---@type TroubleOptions
M.options = {}
---@return TroubleOptions

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  M.fix_mode(M.options)
end

function M.fix_mode(opts)
  if opts.mode == "workspace" then
    opts.mode = "lsp_workspace_diagnostics"
  elseif opts.mode == "document" then
    opts.mode = "lsp_document_diagnostics"
  end
end

M.setup()

return M
