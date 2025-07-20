-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

-- return {
--   {
--     'mfussenegger/nvim-dap',
--     dependencies = {
--       'leoluz/nvim-dap-go',
--       'rcarriga/nvim-dap-ui',
--       'theHamsta/nvim-dap-virtual-text',
--       'nvim-neotest/nvim-nio',
--       'williamboman/mason.nvim',
--     },
--     config = function()
--       local dap = require 'dap'
--       local ui = require 'dapui'
--
--       require('dapui').setup()
--       require('dap-go').setup()
--
--       dap.adapters.flutter = {
--         type = 'executable',
--         command = 'fvm',
--         dartAttachVmServiceUri = function()
--           -- Use the WebSocket URI explicitly for the correct app instance
--           return 'ws://127.0.0.1:56078/GIVoW4bjqLw=/ws'
--         end, -- command = '/opt/homebrew/bin/fvm',
--         -- args = { 'flutter', 'debug_adapter' },
--       }
--
--       dap.configurations.dart = {
--         {
--           type = 'flutter',
--           request = 'launch',
--           name = 'Launch Flutter app',
--           program = '${workspaceFolder}/lib/main_development.dart',
--         },
--         {
--           type = 'flutter',
--           request = 'attach',
--           name = 'Attach to running Flutter app',
--           cwd = '${workspaceFolder}',
--           dartAttachVmServiceUri = function()
--             return vim.fn.input 'Enter VM Service URI: '
--           end,
--         },
--       }
--       require('nvim-dap-virtual-text').setup {
--         -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
--         display_callback = function(variable)
--           local name = string.lower(variable.name)
--           local value = string.lower(variable.value)
--           if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
--             return '*****'
--           end
--
--           if #variable.value > 15 then
--             return ' ' .. string.sub(variable.value, 1, 15) .. '... '
--           end
--
--           return ' ' .. variable.value
--         end,
--
--         ensure_installed = {
--           -- Update this to ensure that you have the debuggers for the langs you want
--           'dart',
--           'delve',
--         },
--       }
--
--       -- Handled by nvim-dap-go
--       -- dap.adapters.go = {
--       --   type = "server",
--       --   port = "${port}",
--       --   executable = {
--       --     command = "dlv",
--       --     args = { "dap", "-l", "127.0.0.1:${port}" },
--       --   },
--       -- }
--       vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
--       vim.keymap.set('n', '<space>gb', dap.run_to_cursor)
--
--       -- Eval var under cursor
--       vim.keymap.set('n', '<space>?', function()
--         require('dapui').eval(nil, { enter = true })
--       end)
--
--       vim.keymap.set('n', '<F1>', dap.continue)
--       vim.keymap.set('n', '<F2>', dap.step_into)
--       vim.keymap.set('n', '<F3>', dap.step_over)
--       vim.keymap.set('n', '<F4>', dap.step_out)
--       vim.keymap.set('n', '<F5>', dap.step_back)
--       vim.keymap.set('n', '<F13>', dap.restart)
--
--       dap.listeners.before.attach.dapui_config = function()
--         ui.open()
--       end
--       dap.listeners.before.launch.dapui_config = function()
--         ui.open()
--       end
--       dap.listeners.before.event_terminated.dapui_config = function()
--         ui.close()
--       end
--       dap.listeners.before.event_exited.dapui_config = function()
--         ui.close()
--       end
--     end,
--   },
-- }
--
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    dap.set_log_level 'TRACE'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    dap.set_log_level 'DEBUG'
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'dart',
        'delve',
      },
    }

    dap.adapters.flutter = {
      type = 'executable',
      command = 'fvm',
      args = { 'flutter', 'debug_adapter' },
    }

    -- local function get_vm_service_uri()
    --   -- Use a shell command to fetch the WebSocket URI dynamically
    --   local handle = io.popen "ps aux | grep -E 'dart.*vm-service' | grep -o 'ws://[^ ]*'"
    --   local result = handle:read '*a'
    --   handle:close()
    --
    --   -- Clean and return the first valid WebSocket URI
    --   return result:match 'ws://[%w%.%-:%d_/=]+'
    -- end
    local function get_vm_service_uri()
      -- More specific grep pattern for the VM service URI
      local handle = io.popen "ps aux | grep -o 'VM Service.*ws://[^ ]*' | grep -o 'ws://[^ ]*'"
      local result = handle:read '*a'
      handle:close()

      local uri = result:match 'ws://[%w%.%-:%d_/=]+'
      if not uri then
        print 'No Flutter VM service URI found'
        return nil
      end
      print('Found VM service URI: ' .. uri) -- Debug output
      return uri
    end

    dap.configurations.dart = {
      {
        type = 'flutter',
        request = 'launch',
        name = 'Launch Flutter app',
        program = '${workspaceFolder}/lib/main_development.dart',
        deviceId = '${command:flutter.getTargetDeviceId}',
      },
      {
        type = 'flutter',
        request = 'attach',
        name = 'Attach to running Flutter app',
        cwd = '${workspaceFolder}',
        program = '${workspaceFolder}/lib/main_development.dart',
        deviceId = '${command:flutter.getTargetDeviceId}',
        -- dartAttachVmServiceUri = 'ws://127.0.0.1:54979/0eHc8S7_FUQ=/ws',
        -- dartAttachVmServiceUri = get_vm_service_uri,
        -- appId = 'com.urbanmetry.urby',
        -- vmServicePort = 54979,
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
