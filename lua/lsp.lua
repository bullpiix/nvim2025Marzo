

local lspconfig = require("lspconfig")

-- Capabilities para nvim-cmp + lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

-- Configuración de cssls
lspconfig.cssls.setup({
  capabilities = capabilities,
})
-- HTML
lspconfig.html.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

lspconfig.ts_ls.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.api.nvim_set_hl(0, "MatchWordCur", { fg = "#000000", bg = "#b1c4bb", underline = true })
vim.api.nvim_set_hl(0, "MatchParenCur", { fg = "#ffaa00", bg = "#1e1e1e", bold = true })
vim.api.nvim_set_hl(0, "MatchWord", { fg = "#000000", underline = true })
