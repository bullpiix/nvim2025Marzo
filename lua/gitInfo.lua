local path = "/home/manutip/Documents/test/getGitpy/dataGit.json"
local function read_file(p)
  local f = io.open(p, "r")
  if not f then error("No se pudo abrir el archivo") end
  local content = f:read("*a")
  f:close()
  return content
end

local function write_file(p, content)
  local f = io.open(p, "w")
  if not f then error("No se pudo escribir el archivo") end
  f:write(content)
  f:close()
end

local function update_index_commit(new_value)
  local json_content = read_file(path)
  local lua_table = vim.fn.json_decode(json_content)
  lua_table.indexCommit = new_value
  local new_json = vim.fn.json_encode(lua_table)
  write_file(path, new_json)
end

local win_info_id, buf_info_id
local options = {}
function _G.close_menu()
    if win_info_id and vim.api.nvim_win_is_valid(win_info_id) then
        vim.api.nvim_win_close(win_info_id, true)
        win_info_id = nil
        buf_info_id = nil
    end
end

-- Función que se ejecuta al seleccionar una opción
function _G.select_info_option()
    local line = vim.fn.line(".")
    local index = line - 1
    local option = options[line]
    update_index_commit(index)
    _G.close_menu()
    if option then
      local Path = "/home/manutip/Documents/test/getGitpy/dataCommit.py"
      local PythonPath = "/home/manutip/Documents/test/getGitpy/venv/bin/python"
      local handle = io.popen(PythonPath .. " " .. Path)
      if not handle then return end
      local result = handle:read("*a")
      handle:close()
      local msg = result

        vim.cmd("vsplit")
        local new_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, new_buf)
        local lines = vim.split(msg, "\n", { plain = true })
        vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, lines)

        -- Opcional: hacer que el buffer sea solo lectura
        vim.api.nvim_buf_set_option(new_buf, "modifiable", false)
        vim.api.nvim_buf_set_option(new_buf, "bufhidden", "wipe")
    end
end

-- Función para mostrar el menú
function _G.show_menu()
    -- Crear buffer
    buf_info_id = vim.api.nvim_create_buf(false, true)

    -- Crear ventana
    local width = 30
    local height = 4
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    win_info_id = vim.api.nvim_open_win(buf_info_id, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

  local Path = "/home/manutip/Documents/test/getGitpy/infoGit.py"
  local PythonPath = "/home/manutip/Documents/test/getGitpy/venv/bin/python"
  local handle = io.popen(PythonPath .. " " .. Path)
  if not handle then return end
  local result = handle:read("*a")
  handle:close()
  local str = result
    for line in str:gmatch("[^\r\n]+") do
        table.insert(options, line)
    end

    -- Poner las opciones en el buffer
    vim.api.nvim_buf_set_lines(buf_info_id, 0, -1, false, options)

    -- Hacer buffer no modificable
    vim.api.nvim_buf_set_option(buf_info_id, "modifiable", false)

    -- Mapear teclas
    vim.api.nvim_buf_set_keymap(buf_info_id, "n", "<CR>", ":lua _G.select_info_option()<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf_info_id, "n", "q", ":lua _G.close_menu()<CR>", { noremap = true, silent = true })
end

vim.api.nvim_set_keymap("n", "6", ":lua _G.show_menu()<CR>", { noremap = true, silent = true })
