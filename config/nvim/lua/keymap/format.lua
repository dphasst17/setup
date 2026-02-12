-- Keymaps for file tree and tab bar
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "<Cmd>BufferNext<CR>", {})
vim.keymap.set("n", "<A-h>", "<Cmd>BufferPrevious<CR>", {})
vim.api.nvim_set_keymap("i", "<C-g>", "codeium#Accept()", { expr = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Find character in project" })
vim.api.nvim_set_keymap("n", "<C-s>", ":w!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w!<CR>a", { noremap = true, silent = true })

-- Clear any existing Ctrl+C mappings
vim.keymap.set({ "n", "v" }, "<C-c>", "<Nop>", { noremap = true, silent = true })
-- Set Ctrl+C to yank to system clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", [["+y]], { noremap = true, silent = true, desc = "Copy to system clipboard" })
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-x>", "x", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Del>", "dd", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Home>", "v^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-End>", "v$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-t>", ":lua CreateNewTerminal()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<A-w>",
	":lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"i",
	"<Tab>",
	'coc#pum#visible() ? coc#pum#confirm() : "\\<Tab>"',
	{ expr = true, noremap = true }
)
vim.api.nvim_set_keymap("i", "<C-Space>", "coc#refresh()", { expr = true, noremap = true })

-- Set modifiable to true for all files
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		vim.opt.modifiable = true
	end,
})
vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })