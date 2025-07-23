return {
  -- Tokyo Night Color scheme with transparency
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,  -- Enable transparency!
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { bold = true },
          variables = {},
          sidebars = "transparent",  -- Transparent file tree
          floats = "transparent",    -- Transparent popups
        },
        sidebars = { "qf", "help", "NvimTree", "neo-tree", "Trouble" },
        
        on_highlights = function(highlights, colors)
          -- Make backgrounds transparent
          highlights.Normal = { fg = colors.fg, bg = "NONE" }
          highlights.NormalNC = { fg = colors.fg, bg = "NONE" }
          highlights.NormalFloat = { fg = colors.fg, bg = "NONE" }
          highlights.SignColumn = { fg = colors.fg_gutter, bg = "NONE" }
          highlights.NvimTreeNormal = { fg = colors.fg_sidebar, bg = "NONE" }
          
          -- Keep cursorline visible
          highlights.CursorLine = { bg = colors.bg_highlight }
          highlights.CursorLineNr = { fg = colors.orange, bold = true }
        end,
      })
      
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  
  -- File explorer (also update for transparency)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        filters = { dotfiles = false },
        git = { enable = true },
      })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },

-- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
    end,
  },

-- Status line (Python Data Science Focused)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup({
        options = { 
          theme = "tokyonight",
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function(str)
                local mode_map = {
                  ['NORMAL'] = '🐍 NORMAL',
                  ['INSERT'] = '✏️  INSERT',
                  ['VISUAL'] = '👁️  VISUAL',
                  ['V-LINE'] = '📄 V-LINE',
                  ['V-BLOCK'] = '🔲 V-BLOCK',
                  ['COMMAND'] = '⚡ COMMAND',
                  ['REPLACE'] = '🔄 REPLACE',
                }
                return mode_map[str] or str
              end,
            }
          },
          lualine_b = {
            {
              'branch',
              icon = '',
              color = { fg = '#7aa2f7', gui = 'bold' },
              cond = function()
                return vim.fn.isdirectory('.git') == 1
              end,
            },
            {
              'diagnostics',
              sources = { 'nvim_diagnostic', 'nvim_lsp' },
              symbols = { 
                error = ' ', 
                warn = ' ', 
                info = ' ',
                hint = '💡'
              },
              diagnostics_color = {
                error = { fg = '#f7768e' },
                warn = { fg = '#e0af68' },
                info = { fg = '#7aa2f7' },
                hint = { fg = '#1abc9c' },
              },
            }
          },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = true,
              path = 1,
              shorting_target = 40,
              symbols = {
                modified = ' [+]',
                readonly = ' [RO]',
                unnamed = '[No Name]',
                newfile = '[New] 📄',
              },
              color = { fg = '#c0caf5', gui = 'bold' },
            },
            {
              function()
                local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                return "📁 " .. cwd
              end,
              color = { fg = '#9ece6a' },
              cond = function()
                return vim.bo.filetype == "python" or vim.bo.filetype == "jupyter"
              end,
            }
          },
          lualine_x = {
            {
              function()
                local conda_env = vim.env.CONDA_DEFAULT_ENV
                if conda_env and conda_env ~= "base" then
                  return "🐍 " .. conda_env
                end
                
                local venv = vim.env.VIRTUAL_ENV
                if venv then
                  local env_name = vim.fn.fnamemodify(venv, ":t")
                  return "🐍 " .. env_name
                end
                
                local poetry_env = vim.fn.system("poetry env info --path 2>/dev/null"):gsub("\n", "")
                if vim.v.shell_error == 0 and poetry_env ~= "" then
                  local env_name = vim.fn.fnamemodify(poetry_env, ":t")
                  return "📜 " .. env_name
                end
                
                return "🐍 system"
              end,
              color = { fg = '#bb9af7', gui = 'bold' },
              cond = function()
                return vim.bo.filetype == "python" or vim.bo.filetype == "jupyter"
              end,
            },
            {
              function()
                if vim.bo.filetype == "python" then
                  local python_version = vim.fn.system("python --version 2>&1"):match("Python (%d+%.%d+)")
                  if python_version then
                    return "🐍 " .. python_version
                  end
                end
                return ""
              end,
              color = { fg = '#f7768e' },
              cond = function()
                return vim.bo.filetype == "python"
              end,
            },
            {
              function()
                local clients = vim.lsp.get_active_clients()
                if #clients == 0 then
                  return ""
                end
                local client_names = {}
                for _, client in ipairs(clients) do
                  if client.name == "pylsp" then
                    table.insert(client_names, "🔧 LSP")
                  elseif client.name == "pyright" then
                    table.insert(client_names, "⚡ Pyright")
                  else
                    table.insert(client_names, client.name)
                  end
                end
                return table.concat(client_names, " ")
              end,
              color = { fg = '#7dcfff' },
              cond = function()
                return vim.bo.filetype == "python"
              end,
            },
            {
              'filetype',
              colored = true,
              icon = { align = 'right' },
              fmt = function(str)
                local filetype_icons = {
                  python = '🐍 Python',
                  jupyter = '📊 Jupyter',
                  markdown = '📝 Markdown',
                  json = '📋 JSON',
                  yaml = '⚙️  YAML',
                  csv = '📊 CSV',
                  sql = '🗃️  SQL',
                }
                return filetype_icons[str] or str
              end,
            }
          },
          lualine_y = {
            {
              'filesize',
              cond = function()
                local ft = vim.bo.filetype
                return ft == "csv" or ft == "json" or ft == "python"
              end,
            },
            {
              'progress',
              fmt = function(str)
                return "📍 " .. str
              end,
            }
          },
          lualine_z = {
            {
              'location',
              fmt = function(str)
                return "📏 " .. str
              end,
              color = { fg = '#bb9af7', gui = 'bold' },
            }
          }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              path = 1,
              color = { fg = '#565f89' },
            }
          },
          lualine_x = {'filetype'},
          lualine_y = {},
          lualine_z = {'location'}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {'nvim-tree', 'quickfix'}
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "vim", "vimdoc", "query" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
