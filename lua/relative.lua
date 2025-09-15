
vim.opt.number = true
vim.opt.relativenumber = true
local input_var1
local input_win_id

function _G.input_buscador()
    input_var1 = vim.api.nvim_create_buf(false, true)

    local width, height = 20, 1
    local row, col = 0, vim.o.columns - width

    input_win_id = vim.api.nvim_open_win(input_var1, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
    vim.api.nvim_buf_set_option(input_var1, "buftype", "prompt")
    vim.fn.prompt_setprompt(input_var1, "Buscar: ")
    vim.api.nvim_buf_set_keymap(
        input_var1,
        "i",
        "<Space>",
        [[<C-\><C-n>:lua _G.set_down_line()<CR>]],
        { noremap = true, silent = true}
    )
    vim.api.nvim_buf_set_keymap(
        input_var1,
        "i",
        "<BackSpace>",
        [[<C-\><C-n>:lua _G.set_up_line()<CR>]],
        { noremap = true, silent = true}
    )
    vim.api.nvim_buf_set_keymap(input_var1,"i","h","1",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","j","2",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","k","3",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","y","4",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","u","5",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","i","6",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","o","7",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","p","8",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","l","9",{ noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(input_var1,"i","q","0",{ noremap = true, silent = true})

    vim.cmd("startinsert")

end

function _G.set_up_line()
    local line = vim.api.nvim_get_current_line()
    local input = line:gsub("^Buscar:%s*", "")  -- lo que el usuario escribió
    vim.api.nvim_win_close(input_win_id, true)

    -- borra el buffer temporal
    if input_var1 and vim.api.nvim_buf_is_valid(input_var1) then
        vim.api.nvim_buf_delete(input_var1, { force = true })
    end
    local n = tonumber(input)  -- convierte a número
    if n then
        -- mueve hacia abajo n líneas
        vim.fn.feedkeys(tostring(n) .. "k", "n")
    else
        print("⚠️ Entrada inválida: " .. input)
    end
end


function _G.set_down_line()
    local line = vim.api.nvim_get_current_line()
    local input = line:gsub("^Buscar:%s*", "")  -- lo que el usuario escribió
    vim.api.nvim_win_close(input_win_id, true)
    if input_var1 and vim.api.nvim_buf_is_valid(input_var1) then
        vim.api.nvim_buf_delete(input_var1, { force = true })
    end
    local n = tonumber(input)  -- convierte a número
    if n then
        -- mueve hacia abajo n líneas
        vim.fn.feedkeys(tostring(n) .. "j", "n")
    else
        print("⚠️ Entrada inválida: " .. input)
    end
end

vim.api.nvim_set_keymap("n", "b", ":lua _G.input_buscador()<CR>" ,{ noremap = true, silent= true})


function _G.auto_search_line()
  local palabra = vim.fn.expand("<cword>")  -- obtiene la palabra bajo el cursor
  vim.fn.feedkeys("/" .. palabra .. "\n", "n")
end

