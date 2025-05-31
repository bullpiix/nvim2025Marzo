-- Inicia Packer
require('boxRun')
require('gitUI')
require('nvim-cmp')
require('manuSetup')
require('treeUser')

--require('lsp')


vim.cmd [[packadd packer.nvim]]
--vim.cmd('source /home/srrogu/Documentos/mymorning.vim')

require('packer').startup(function(use)
  --use 'neovim/nvim-lspconfig' 
  use 'wbthomason/packer.nvim'
  use 'hrsh7th/nvim-cmp'         -- Plugin principal de autocompletado
  use 'hrsh7th/cmp-buffer'       -- Fuente para el buffer actual
  use({
      "rose-pine/neovim",
      as = "rose-pine",
      config = function()
        vim.cmd("colorscheme rose-pine-dawn") -- puedes probar también: rose-pine-dawn, rose-pine-moon
      end,
    })

  use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("ibl").setup({
          indent = { char = "│" },
          scope = { enabled = false },
          exclude = {
            filetypes = { "help", "terminal", "dashboard", "lazy" },
          },
        })
      end
    }
  use({
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "python","html", "css", "javascript" },  -- Asegura que el parser de Python esté instalado
          highlight = {
            enable = true,  -- Habilitar el resaltado de sintaxis
            additional_vim_regex_highlighting = false,  -- Desactiva resaltado adicional de Vim
          },
          indent = { enable = false},
        }
      end
    })
end)
