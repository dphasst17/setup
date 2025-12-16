-- Plugin manager: Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
local lazy = require("lazy")
require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nvim-lualine/lualine.nvim" },
	{ "romgrk/barbar.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "Exafunction/codeium.vim", lazy = false },
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", lazy = false },
		lazy = false,
		cmd = "Telescope",
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git/" },
				},
			})
		end,
	},
	{
		"neoclide/coc.nvim",
		branch = "release",
	},
	{
		"windwp/nvim-ts-autotag",
	},
	-- Plugin: ts-context-commentstring
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("ts_context_commentstring").setup({})
			vim.g.skip_ts_context_commentstring_module = true
		end,
	},

	-- Plugin: Comment.nvim
	-- press key g + b or g + c to comment code
  {
		"numToStr/Comment.nvim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	-- Plugin: Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "javascript", "typescript", "tsx", "html", "css" },
				highlight = { enable = true },
				-- KHÔNG cần context_commentstring ở đây nữa!
			})
		end,
	},
	-- Format on save
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 500,
				},
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					lua = { "stylua" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					sh = { "shfmt" },
				},
			})
		end,
	},
})

-- Theme setup
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = false,
})
vim.cmd.colorscheme("catppuccin")
-- nvim-tree config
require("nvim-tree").setup({
	view = {
		width = 30,
		side = "left",
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
				folder = true,
				file = true,
				folder_arrow = true,
			},
		},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true, -- bật tính năng git
		ignore = false, -- ✨ KHÔNG ẩn file bị ignore như .env
	},
})

-- Auto open tree on launch
local function open_nvim_tree()
	require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- lualine setup
require("lualine").setup({
	options = {
		theme = "catppuccin",
	},
})

-- treesitter config
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"

local terminal_id = 1 -- Biến lưu số lượng terminal

function CreateNewTerminal()
	vim.cmd("ToggleTerm " .. terminal_id)
	terminal_id = terminal_id + 1
end
require("keymaps.format")

-- Keymaps for file tree and tab bar
-- vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<A-l>", "<Cmd>BufferNext<CR>", {})
-- vim.keymap.set("n", "<A-h>", "<Cmd>BufferPrevious<CR>", {})
-- vim.api.nvim_set_keymap("i", "<C-g>", "codeium#Accept()", { expr = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Tìm chuỗi trong project" })
-- vim.api.nvim_set_keymap("n", "<C-s>", ":w!<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w!<CR>a", { noremap = true, silent = true })
--
-- -- Clear any existing Ctrl+C mappings
-- vim.keymap.set({ "n", "v" }, "<C-c>", "<Nop>", { noremap = true, silent = true })
-- -- Set Ctrl+C to yank to system clipboard
-- vim.keymap.set({ "n", "v" }, "<C-c>", [["+y]], { noremap = true, silent = true, desc = "Copy to system clipboard" })
-- vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })
--
-- vim.api.nvim_set_keymap("n", "<C-x>", "x", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-Del>", "dd", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-Home>", "v^", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-End>", "v$", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<A-t>", ":lua CreateNewTerminal()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<A-w>",
-- 	":lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>",
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap(
-- 	"i",
-- 	"<Tab>",
-- 	'coc#pum#visible() ? coc#pum#confirm() : "\\<Tab>"',
-- 	{ expr = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap("i", "<C-Space>", "coc#refresh()", { expr = true, noremap = true })
--
-- -- Set modifiable to true for all files
-- vim.api.nvim_create_autocmd("BufReadPost", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.opt.modifiable = true
-- 	end,
-- })
-- vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })
--
require("toggleterm").setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 4,
	start_in_insert = true,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	persist_mode = false,
	direction = "horizontal", -- hoặc 'vertical' | 'float' | 'tab'
	close_on_exit = true,
	shell = vim.o.shell,
})