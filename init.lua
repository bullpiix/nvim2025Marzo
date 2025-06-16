-- Inicia Packer

--vim.cmd("colorscheme shine") -- puedes probar también: rose-pine-dawn, rose-pine-moon

vim.api.nvim_set_keymap("n", "<Space>+", "<Plug>(emmet-expand-abbr)", {})
require('boxRun')
require('gitUI')
require('nvim-cmp')
require('manuSetup')
require('treeExplorer')
require("my_cmp_config")  -- Tu archivo cmp.lua
require("lsp")


vim.cmd [[packadd packer.nvim]]
--vim.cmd('source /home/srrogu/Documentos/mymorning.vim')

require('packer').startup(function(use)
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
    }
    use 'mattn/emmet-vim'
    use {
      'L3MON4D3/LuaSnip',
      requires = { 'rafamadriz/friendly-snippets' },
    }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'neovim/nvim-lspconfig' 
    use {
        'andymass/vim-matchup',
        setup = function()
          vim.g.matchup_matchparen_offscreen = { method = "popup" } -- opcional
        end
    }
    use 'wbthomason/packer.nvim'
    use 'hrsh7th/nvim-cmp'         -- Plugin principal de autocompletado
    use 'hrsh7th/cmp-buffer'       -- Fuente para el buffer actual
    use({
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "python","html", "css", "javascript" },  -- Asegura que el parser de Python esté instalado
          matchup = {
            enable = true
          },
          highlight = {
            enable = true,  -- Habilitar el resaltado de sintaxis
            additional_vim_regex_highlighting = false,  -- Desactiva resaltado adicional de Vim
          },
          indent = { enable = false},
        }
      end
    })


    use({
      'projekt0n/github-nvim-theme',
      config = function()
        require('github-theme').setup({
          -- Configuración adicional del tema
        })

        vim.cmd('colorscheme github_light')

        -- Modificar el grupo de resaltado de Folded manualmente
        vim.api.nvim_set_hl(0, 'Folded', { fg = '#0077cc', bg = '#dddddd', italic = true }) 
      end
    })

    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        -- Cambia el color de la línea vertical
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#5c6370" })

        require("ibl").setup({
          indent = { char = "│" },
          scope = { enabled = false },
          exclude = {
            filetypes = { "help", "terminal", "dashboard", "lazy" },
          },
        })
      end
    }
end)

