local state = {
  terminal = {
    buf = -1,
    win = -1,
  },
}

local function open_left_terminal()
  local current_win = vim.api.nvim_get_current_win()

  vim.cmd 'topleft vsplit'
  local win = vim.api.nvim_get_current_win()
  vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.5))

  if vim.api.nvim_buf_is_valid(state.terminal.buf) then
    vim.api.nvim_win_set_buf(win, state.terminal.buf)
  else
    local buf = vim.api.nvim_create_buf(false, true)
    state.terminal.buf = buf
    vim.api.nvim_win_set_buf(win, buf)

    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].filetype = 'terminal'

    vim.fn.termopen(vim.o.shell)
  end

  state.terminal.win = win

  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(win)
  end
  vim.cmd 'startinsert'
end

local function toggle_terminal()
  if vim.api.nvim_win_is_valid(state.terminal.win) then
    vim.api.nvim_win_hide(state.terminal.win)
    state.terminal.win = -1
    return
  end

  open_left_terminal()
end

vim.api.nvim_create_user_command('SideTerminal', toggle_terminal, {})
-- Backward-compatible alias while the old floating terminal is disabled.
vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
