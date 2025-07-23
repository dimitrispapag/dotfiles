-- Set leader key
vim.g.mapleader = " "

-- Basic mappings
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- File explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Quick save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Python execution with F5
vim.keymap.set("n", "<F5>", function()
  -- Save the file first
  vim.cmd("w")
  -- Get the current file path
  local file = vim.fn.expand("%:p")
  -- Check if it's a Python file
  if vim.bo.filetype == "python" then
    -- Run in a horizontal split terminal
    vim.cmd("split")
    vim.cmd("terminal python3 " .. vim.fn.shellescape(file))
    vim.cmd("startinsert")
  else
    print("Not a Python file!")
  end
end, { desc = "Run Python file with F5" })

-- Alternative F5 - simpler version (runs in background)
-- vim.keymap.set("n", "<F5>", ":w<CR>:!python3 %<CR>", { desc = "Run Python file" })

-- F6 for Python REPL
vim.keymap.set("n", "<F6>", function()
  vim.cmd("split")
  vim.cmd("terminal python3")
  vim.cmd("startinsert")
end, { desc = "Open Python REPL" })

-- Run selected Python code in visual mode
vim.keymap.set("v", "<F5>", ":w !python3<CR>", { desc = "Run selected Python code" })
