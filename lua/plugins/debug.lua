---@diagnostic disable: missing-fields, undefined-field
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Debuggers
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging (Visual Studio style)
      { '<F5>',    dap.continue,          desc = 'Debug: Start/Continue' },
      { '<F11>',   dap.step_into,         desc = 'Debug: Step Into' },
      { '<F10>',   dap.step_over,         desc = 'Debug: Step Over' },
      { '<S-F11>', dap.step_out,          desc = 'Debug: Step Out' },
      { '<F9>',    dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
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
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'coreclr', 'python' },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- .NET debugging
    local netcoredbg_path = vim.fn.stdpath('data') .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg'
    dap.adapters.coreclr = {
      type = 'executable',
      command = netcoredbg_path,
      args = { '--interpreter=vscode' },
    }

    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        console = 'integratedTerminal',
        program = function()
          os.execute('dotnet build -c Debug')
          local dir = vim.loop.cwd() .. '/' .. vim.fn.glob 'bin/Debug/net*/'
          local name = dir .. vim.fn.glob('*.csproj'):gsub('%.csproj$', '.dll')
          return name
        end,
      },
    }
  end,
}
