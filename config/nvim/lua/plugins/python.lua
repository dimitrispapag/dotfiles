-- ~/.config/nvim/lua/plugins/python.lua
return {
  -- Debugging with proper dependencies
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- This was missing!
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Setup dap-python
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
      
      -- Setup dap-ui
      require("dapui").setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        }
      })
      
      -- Auto-open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      
      -- Key mappings
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Toggle UI" })
    end,
  },

  -- Updated venv-selector with proper configuration
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { 
      "neovim/nvim-lspconfig", 
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python"
    },
    opts = {
      settings = {
        search = {
          my_venvs = {
            command = "fd python$ ~/.virtualenvs --full-path --type executable",
            type = "virtualenvs"
          },
          anaconda_base = {
            command = "fd python$ ~/anaconda3/bin --full-path --type executable",
            type = "anaconda"
          },
          anaconda_envs = {
            command = "fd python$ ~/anaconda3/envs --full-path --type executable",
            type = "anaconda"
          },
          miniconda = {
            command = "fd python$ ~/miniconda3/envs --full-path --type executable", 
            type = "miniconda"
          },
          pyenv = {
            command = "fd python$ ~/.pyenv/versions --full-path --type executable",
            type = "pyenv"
          },
          pipenv = {
            command = "fd pyvenv.cfg . --full-path --type file",
            type = "pipenv"
          },
          venv = {
            command = "fd pyvenv.cfg . --full-path --type file",
            type = "venv"
          },
        },
      },
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)
      vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select VirtualEnv" })
    end,
  },

  -- Code formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "black", "isort" },
        lua = { "stylua" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      formatters = {
        black = {
          prepend_args = { "--fast" },
        },
        isort = {
          prepend_args = { "--profile", "black" },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Test runner with proper dependencies
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio", -- Required dependency
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { 
              justMyCode = false,
              console = "integratedTerminal",
            },
            args = {"--log-level", "DEBUG"},
            runner = "pytest",
          }),
        },
        discovery = {
          enabled = false,
        },
      })
      
      -- Key mappings for testing
      vim.keymap.set("n", "<leader>tt", function() 
        require("neotest").run.run() 
      end, { desc = "Run Test" })
      
      vim.keymap.set("n", "<leader>tf", function() 
        require("neotest").run.run(vim.fn.expand("%")) 
      end, { desc = "Run File" })
      
      vim.keymap.set("n", "<leader>to", function() 
        require("neotest").output.open({ enter = true, auto_close = true }) 
      end, { desc = "Show Output" })
      
      vim.keymap.set("n", "<leader>ts", function() 
        require("neotest").summary.toggle() 
      end, { desc = "Toggle Summary" })
      
      vim.keymap.set("n", "<leader>tp", function() 
        require("neotest").output_panel.toggle() 
      end, { desc = "Toggle Output Panel" })
    end,
  },
}
