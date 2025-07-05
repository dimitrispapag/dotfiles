return {
  -- Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
        close_on_exit = true,
        shell = vim.o.shell,
      })

      -- Python-specific terminal functions
      local Terminal = require("toggleterm.terminal").Terminal

      -- Python REPL
      local python_repl = Terminal:new({
        cmd = "python3",
        hidden = true,
        direction = "horizontal",
        close_on_exit = false,
      })

      function _PYTHON_TOGGLE()
        python_repl:toggle()
      end

      -- IPython REPL (if installed)
      local ipython_repl = Terminal:new({
        cmd = "ipython",
        hidden = true,
        direction = "horizontal",
        close_on_exit = false,
      })

      function _IPYTHON_TOGGLE()
        ipython_repl:toggle()
      end

      -- Key mappings
      vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python REPL" })
      vim.keymap.set("n", "<leader>ti", "<cmd>lua _IPYTHON_TOGGLE()<CR>", { desc = "Toggle IPython REPL" })
      
      -- Run current file in terminal
      vim.keymap.set("n", "<leader>rf", function()
        local file = vim.fn.expand("%:p")
        local term = Terminal:new({
          cmd = "python3 " .. file,
          hidden = true,
          direction = "horizontal",
        })
        term:toggle()
      end, { desc = "Run current file in terminal" })
    end,
  },
}
