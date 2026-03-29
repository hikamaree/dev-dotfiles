vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/hikamaree/wave.nvim" },
})

require("wave").setup({})

require("lualine").setup({
	options = {
		globalstatus = true,
		component_separators = "",
		section_separators = "",
		theme = vim.tbl_deep_extend("force", require("lualine.themes.auto"), {
			normal = { c = { bg = "NONE" } },
			insert = { c = { bg = "NONE" } },
			visual = { c = { bg = "NONE" } },
			replace = { c = { bg = "NONE" } },
			command = { c = { bg = "NONE" } },
			terminal = { c = { bg = "NONE" } },
		})
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "diagnostics" },
		lualine_c = {{
			"buffers",
			symbols = { modified = " #", alternate_file = "" },
			buffers_color = {
				active = { fg = "#E0E2EA" },
				inactive = { fg = "#4F5258" }
			}
		}},
		lualine_x = { "lsp_status" },
		lualine_y = {
			"searchcount",
			function()
				return vim.fn.reg_recording():gsub("^(.+)$", "recording @%1")
			end
		},
		lualine_z = { "location" }
	},
})

require("fzf-lua").setup({
	winopts = {
		border = "none",
		preview = { border = "single" }
	},
})

require("blink.cmp").setup({
	keymap = { preset = "enter" },
	fuzzy = { implementation = "lua" },
	completion = {
		menu = { winhighlight = "FloatBorder:FloatBorder" },
		documentation = {
			auto_show = true,
			window = { winhighlight = "FloatBorder:FloatBorder" }
		},
	},
})

vim.lsp.enable({ "clangd", "rust_analyzer", "lua_ls", "wgsl_analyzer", "pylsp" })
vim.lsp.config( "*", { root_markers = { ".git" }})
vim.diagnostic.config { virtual_text = true, update_in_insert = true }

vim.keymap.set({ "n", "v", "i", "t" }, "<C-Q>", function() vim.cmd.wall({ bang = true }); vim.cmd.qall({ bang = true }) end)
vim.keymap.set("n", "<C-c>", function() pcall(vim.cmd.write, { bang = true }); vim.cmd.bdelete({ bang = true }) end)
vim.keymap.set("n", "<Esc>", function() vim.cmd.nohlsearch() end)
vim.keymap.set("x", "p", function() vim.api.nvim_feedkeys('"_dP', "n", false) end)
vim.keymap.set("n", "<C-h>", function() vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr("h"))) end)
vim.keymap.set("n", "<C-j>", function() vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr("j"))) end)
vim.keymap.set("n", "<C-k>", function() vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr("k"))) end)
vim.keymap.set("n", "<C-l>", function() vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr("l"))) end)
vim.keymap.set("n", "<C-\\>", function() vim.diagnostic.open_float() end)
vim.keymap.set("n", "==", function() vim.lsp.buf.format({ async = true }) end)
vim.keymap.set("n", "<C-F>", function() require("fzf-lua").builtin() end)
vim.keymap.set("n", "<C- >", function() require("fzf-lua").files() end)
vim.keymap.set("n", "<C-G>", function() require("fzf-lua").live_grep() end)
vim.keymap.set("n", "grr", function() require("fzf-lua").lsp_references() end)
vim.keymap.set("n", "wd", function() require("fzf-lua").lsp_workspace_diagnostics() end)
vim.keymap.set("n", "gra", function() require("fzf-lua").lsp_code_actions() end)
vim.keymap.set("n", "gd", function() require("fzf-lua").lsp_definitions() end)
vim.keymap.set("n", "gs", function() require("fzf-lua").git_status() end)
vim.keymap.set("n", "<C-P>", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<C-P>", [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><Left>]])

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.cino = "N-s,l1,g0,(0,W4,p0"
vim.opt.shiftround = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.fillchars = "eob: "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cmdheight = 0
vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.shortmess:append("I")
vim.opt.winborder = "single"
vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4F5258", bg = "NONE" })
vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#4F5258", bg = "NONE" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#4F5258", bg = "NONE" })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#4F5258", bg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
