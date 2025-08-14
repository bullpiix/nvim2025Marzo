local win_id_master, buf_id_master, buf_id_commit, win_id_commit
local file_dir , file_name

local options = {
    { label = "git init", action = function() _G.git_init() end },
    { label = "git add current file", action = function() _G.add_current_file() end },
    { label = "add new commit", action = function() _G.set_new_commit() end },
    { label = "view commits", action = function() _G.view_commits() end },
    { label = "del git", action = function() _G.delete_git() end },
} 
function _G.delete_git()
    _G.execute_command("rm -rf .git", 1)
    _G.close_menu()   
end
function _G.view_commits()
    _G.show_menu()
    _G.close_menu()   
end
function _G.git_init()
    _G.execute_command("git init", 1)
    _G.close_menu()
end
function _G.add_current_file()
    print(string.format("archivo agregado %s", file_name))
    _G.execute_command(string.format("git add %s", file_name), 1)
    _G.close_menu()
end
function _G.close_menu()
    if win_id_master and vim.api.nvim_win_is_valid(win_id_master) then
        vim.api.nvim_win_close(win_id_master, true)
        win_id_master = nil
        buf_id_master = nil
    end
end
function _G.execute_command(command, terminal)
    if file_dir and file_dir ~= "" then
        if terminal == 1 then
            if prev_terminal_win_id and vim.api.nvim_win_is_valid(prev_terminal_win_id) then
                vim.api.nvim_win_close(prev_terminal_win_id, true)
            end

            vim.cmd("botright new")
            prev_terminal_win_id = vim.api.nvim_get_current_win()
            vim.cmd("terminal cd " .. file_dir .. " && " .. command)
        else
            vim.fn.jobstart("cd " .. file_dir .. " && " .. command, { detach = true })
        end
    else
        print("Error: No se pudo determinar la ruta del archivo.")
    end
end
function _G.set_new_commit()
    buf_id_commit = vim.api.nvim_create_buf(false, true)
    local width = 20
    local height = 1
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    win_id_commit = vim.api.nvim_open_win(buf_id_commit, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_option(buf_id_commit, "buftype", "prompt")
    vim.fn.prompt_setprompt(buf_id_commit, "-> ")
    vim.api.nvim_buf_set_keymap(
        buf_id_commit,
        "i",
        "<Space>",
        [[<C-\><C-n>:lua _G.run_new_commit()<CR>]],
        { noremap = true, silent = true}
    )
    vim.cmd("startinsert")
end

function _G.run_new_commit()
    local line = vim.api.nvim_get_current_line()
    local input = line:gsub("^->:%s*", "")
    _G.execute_command(string.format("git add %s", file_name), 1)
    _G.execute_command(string.format("git commit -m \"%s\"", input), 1)
    _G.close_menu()
    vim.api.nvim_win_close(win_id_commit, true)

end

-- actualizar path current en el json
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

local function update_index_commit()
  local json_content = read_file(path)
  local lua_table = vim.fn.json_decode(json_content)
  lua_table.file_current = file_dir
  lua_table.name_file = file_name
  local new_json = vim.fn.json_encode(lua_table)
  write_file(path, new_json)
end

-- ventana principal
function _G.show_menu_master()
    file_dir = vim.fn.expand("%:p:h")
    file_name = vim.fn.expand("%:t")
    update_index_commit()
    buf_id_master = vim.api.nvim_create_buf(false, true)
    local width = 30
    local height = #options
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    win_id_master = vim.api.nvim_open_win(buf_id_master, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    local labels = {}
    for i, opt in ipairs(options) do
        table.insert(labels, i .. ". " .. opt.label)
    end

    vim.api.nvim_buf_set_lines(buf_id_master, 0, -1, false, labels)
    vim.api.nvim_buf_set_option(buf_id_master, "modifiable", false)

    -- Cerrar con "q"
    vim.api.nvim_buf_set_keymap(buf_id_master, "n", "q", ":lua _G.close_menu()<CR>", { noremap = true, silent = true })

    -- Ejecutar opción con Enter
    vim.api.nvim_buf_set_keymap(buf_id_master, "n", "<CR>", [[:lua _G.execute_selected_option()<CR>]], { noremap = true, silent = true })
end

function _G.execute_selected_option()
    local cursor = vim.api.nvim_win_get_cursor(0) -- {line, col}
    local line = cursor[1]
    local option = options[line]
    if option and option.action then
        option.action()
    else
        print("Opción inválida")
    end
end

vim.api.nvim_set_keymap("n", "5", ":lua _G.show_menu_master()<CR>", { noremap = true, silent = true })
