
local M = {}

-- Estados globales
local input_win_id, input_buf_id, btn_win_id, btn_buf_id
local nameRama
local files_to_add = {}
local prev_terminal_win_id = nil
local file_dir = nil

-- =====================
-- Utilidades
-- =====================
local function get_file_dir()
    local dir = vim.fn.expand("%:p:h")
    if dir == "" then
        dir = vim.fn.getcwd()
    end
    return dir
end

local function run_in_terminal(command, open_terminal)
    file_dir = get_file_dir()
    vim.notify("📂 Ruta: " .. file_dir, vim.log.levels.INFO)

    if open_terminal == 1 then
        if prev_terminal_win_id and vim.api.nvim_win_is_valid(prev_terminal_win_id) then
            vim.api.nvim_win_close(prev_terminal_win_id, true)
        end
        vim.cmd("botright new")
        prev_terminal_win_id = vim.api.nvim_get_current_win()
        vim.cmd("terminal cd " .. file_dir .. " && " .. command)
    else
        vim.fn.jobstart("cd " .. file_dir .. " && " .. command, { detach = true })
    end
end

local function create_input_window()
    input_buf_id = vim.api.nvim_create_buf(false, true)
    local width, height = 40, 1
    local row, col = math.floor((vim.o.lines - height) / 2), math.floor((vim.o.columns - width) / 2)

    input_win_id = vim.api.nvim_open_win(input_buf_id, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_option(input_buf_id, "modifiable", true)
    vim.api.nvim_buf_set_keymap(input_buf_id, "i", "<CR>", "<Esc>:lua require'mygit'.focus_button()<CR>", { noremap = true, silent = true })
end

local function create_confirm_button(label, callback)
    btn_buf_id = vim.api.nvim_create_buf(false, true)
    local row, col = math.floor((vim.o.lines - 1) / 2) + 2, math.floor((vim.o.columns - 20) / 2)

    btn_win_id = vim.api.nvim_open_win(btn_buf_id, true, {
        relative = "editor",
        width = 20,
        height = 1,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_lines(btn_buf_id, 0, -1, false, { "[ " .. label .. " ]" })
    vim.api.nvim_buf_set_option(btn_buf_id, "modifiable", false)
    vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", "", {
        noremap = true,
        silent = true,
        callback = callback,
    })
end

-- =====================
-- Acciones Git
-- =====================
function M.focus_button()
    if btn_win_id and vim.api.nvim_win_is_valid(btn_win_id) then
        vim.api.nvim_set_current_win(btn_win_id)
    end
end

function M.git_init()
    vim.notify("🚀 git init", vim.log.levels.INFO)
    run_in_terminal("git init", 1)
    vim.api.nvim_win_close(btn_win_id, true)
    create_input_window()
    create_confirm_button("link GitHub", M.set_remote)
end

function M.set_remote()
    local url = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    run_in_terminal("git remote add origin " .. url .. ".git", 1)
    vim.api.nvim_win_close(btn_win_id, true)
    create_confirm_button("name Rama", M.create_branch)
end

function M.create_branch()
    local branch = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    nameRama = branch
    run_in_terminal("git checkout -b " .. branch, 1)
    vim.api.nvim_win_close(btn_win_id, true)
    create_confirm_button("name File", M.add_file)
    vim.api.nvim_set_current_win(input_win_id)
    vim.api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { "archivo.txt o 'done'" })
end

function M.add_file()
    local file = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    if file == "done" then
        if #files_to_add > 0 then
            local all_files = table.concat(files_to_add, " ")
            run_in_terminal("git add " .. all_files, 1)
            files_to_add = {}
            vim.api.nvim_win_close(btn_win_id, true)
            create_confirm_button("go Commit", M.commit)
        else
            vim.notify("⚠️ No se han agregado archivos.", vim.log.levels.WARN)
        end
        return
    end
    table.insert(files_to_add, file)
    vim.notify("➕ Archivo agregado: " .. file, vim.log.levels.INFO)
    vim.api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { "" })
end

function M.commit()
    local msg = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    run_in_terminal("git commit -m '" .. msg .. "'", 1)
    vim.api.nvim_win_close(btn_win_id, true)
    create_confirm_button("go Push", M.push)
end

function M.push()
    run_in_terminal("git push -u origin " .. nameRama, 1)
    vim.api.nvim_win_close(btn_win_id, true)
    create_confirm_button("del .Git", M.delete_git)
end

function M.delete_git()
    run_in_terminal("rm -rf .git", 1)
    vim.api.nvim_win_close(btn_win_id, true)
    vim.notify("🗑️ Repositorio eliminado.", vim.log.levels.INFO)
end

-- =====================
-- Inicio
-- =====================
function M.start()
    files_to_add = {}
    create_confirm_button("Git init", M.git_init)
end

vim.api.nvim_set_keymap("n", "th", ":lua require'mygit'.start()<CR>", { noremap = true, silent = true })

return M
