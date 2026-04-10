local WIDTHS = {
  compact = 0.3,
  expanded = 0.8,
}

local state = {
  side_terminal = {
    buf = -1,
    win = -1,
    width_ratio = WIDTHS.compact,
  },
}

local function desired_width()
  return math.max(20, math.floor(vim.o.columns * state.side_terminal.width_ratio))
end

local function resize_side_terminal()
  if vim.api.nvim_win_is_valid(state.side_terminal.win) then
    vim.api.nvim_win_set_width(state.side_terminal.win, desired_width())
  end
end

local function open_side_terminal()
  vim.cmd 'topleft vsplit'
  local win = vim.api.nvim_get_current_win()

  if vim.api.nvim_buf_is_valid(state.side_terminal.buf) then
    vim.api.nvim_win_set_buf(win, state.side_terminal.buf)
  else
    local buf = vim.api.nvim_create_buf(false, true)
    state.side_terminal.buf = buf
    vim.api.nvim_win_set_buf(win, buf)

    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].filetype = 'terminal'

    vim.fn.termopen(vim.o.shell)
  end

  state.side_terminal.win = win
  vim.wo[win].winfixwidth = true
  resize_side_terminal()
  vim.cmd 'startinsert'
end

local function ensure_side_terminal_open()
  if not vim.api.nvim_win_is_valid(state.side_terminal.win) then
    open_side_terminal()
  end
end

local function set_side_terminal_width(width_ratio)
  state.side_terminal.width_ratio = width_ratio
  ensure_side_terminal_open()
  resize_side_terminal()
end

local function toggle_side_terminal()
  if vim.api.nvim_win_is_valid(state.side_terminal.win) then
    vim.api.nvim_win_hide(state.side_terminal.win)
    state.side_terminal.win = -1
    return
  end

  open_side_terminal()
end

local function toggle_side_terminal_mode()
  if state.side_terminal.width_ratio == WIDTHS.compact then
    set_side_terminal_width(WIDTHS.expanded)
  else
    set_side_terminal_width(WIDTHS.compact)
  end
end

vim.api.nvim_create_autocmd('VimResized', {
  callback = resize_side_terminal,
})

vim.api.nvim_create_user_command('SideTerminal', toggle_side_terminal, {})
vim.api.nvim_create_user_command('SideTerminalCompact', function()
  set_side_terminal_width(WIDTHS.compact)
end, {})
vim.api.nvim_create_user_command('SideTerminalExpanded', function()
  set_side_terminal_width(WIDTHS.expanded)
end, {})
vim.api.nvim_create_user_command('SideTerminalToggleWidth', toggle_side_terminal_mode, {})

vim.keymap.set('n', '<leader>s3', '<cmd>SideTerminalCompact<CR>', { desc = '[S]ide terminal 30%' })
vim.keymap.set('n', '<leader>s8', '<cmd>SideTerminalExpanded<CR>', { desc = '[S]ide terminal 80%' })
vim.keymap.set('n', '<leader>se', '<cmd>SideTerminalToggleWidth<CR>', { desc = '[S]ide terminal [E]xpand toggle' })
