

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
