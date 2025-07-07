require('telescope').setup{}

vim.keymap.set('n', '<Space>m', ':Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', '<Space>,', ':Telescope live_grep<CR>', { noremap = true })
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--configuracion para neo tree

vim.api.nvim_set_keymap('n', '<Space>s', ':Neotree toggle<CR>', { noremap = true, silent = true })
