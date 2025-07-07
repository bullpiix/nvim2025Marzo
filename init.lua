--vim.api.nvim_set_keymap("i", "'", "<Plug>(emmet-expand-abbr)", {})
require('boxRun')
require('gitUI')
require('manuSetup')
require('treeExplorer')
require("my_cmp_config")  -- Tu archivo cmp.lua
require("lsp")
require("manuBuscar") 
require("busca_rempla")
require("gitInfo")

vim.cmd [[packadd packer.nvim]]
--vim.cmd('source /home/srrogu/Documentos/mymorning.vim')

require('packer').startup(function(use)
    use 'mattn/emmet-vim'
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
    }
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

    use {
      "ellisonleao/gruvbox.nvim",
      priority = 1000, -- asegúrate que se cargue antes de otras configuraciones
      config = function()
        vim.o.background = "light" -- usa "dark" para la versión oscura
        require("gruvbox").setup({
          contrast = "soft", -- puedes probar con "hard", "soft" o dejarlo por defecto
        })
        vim.cmd("colorscheme gruvbox")
      end
    }

    use {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- opcional, pero recomendado
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup({
            filesystem = {
                window = {
                  mappings = {
                    ["o"] = "open", -- asigna "i" a la acción de abrir archivo/carpeta
                  }
                }
              }
        })
      end
    }

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

