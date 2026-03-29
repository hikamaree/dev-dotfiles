return {
	cmd = { "lua-language-server" },
	root_markers = { ".luarc.jsonc", "init.lua", ".git" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "hl" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
		}
	}
}
