

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
        [[<C-\><C-n>:lua _G.get_search_line()<CR>]],
        { noremap = true, silent = true}
    )
    vim.api.nvim_buf_set_keymap(
        input_var1,
        "i",
        "`",
        [[<C-\><C-n>:lua _G.off_light()<CR>]],
        { noremap = true, silent = true}
    )
    vim.cmd("startinsert")

end
function _G.off_light()
    vim.api.nvim_win_close(input_win_id, true)
    vim.fn.feedkeys(":noh\n","n")
end
function _G.get_search_line()
        local line = vim.api.nvim_get_current_line()
        local input = line:gsub("^Buscar:%s*", "")
        vim.api.nvim_win_close(input_win_id, true)
        vim.fn.feedkeys("/" .. vim.fn.escape(input,"/\\") .. "\n", "n")   
end

vim.api.nvim_set_keymap("n", "<Space>a", ":lua _G.input_buscador()<CR>" ,{ noremap = true, silent= true})

