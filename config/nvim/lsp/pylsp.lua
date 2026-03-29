return {
  cmd = { "pylsp" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  filetypes = { "python" },
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pycodestyle = { enabled = false },
        yapf = { enabled = false },
        mccabe = { enabled = false },
        pylint = { enabled = false },
      },
    },
  },
}
