syntax on
filetype plugin on
set encoding=UTF-8
set exrc
set guicursor=
set nu
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect,menuone
set signcolumn=yes
set colorcolumn=80

" More space for displaying images
set cmdheight=2

" better user experience
set updatetime=50

call plug#begin('~/.vim/plugged')
    Plug 'preservim/nerdcommenter'
    Plug 'jiangmiao/auto-pairs'
    Plug 'fatih/vim-go'
    Plug 'morhetz/gruvbox'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'mhartington/formatter.nvim'
    Plug 'vim-airline/vim-airline'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-fugitive'
    Plug 'ryanoasis/vim-devicons'
call plug#end()

colorscheme gruvbox

let g:completion_mathcing_strategy_list = ['exact', 'substring', 'fuzzy']




" Telescope Setup

lua << EOF

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,

        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')
EOF

" Formatter.nvim

lua << EOF
require('formatter').setup({
    filetype = {
        python = {
            -- Config for black
            function()
                return {
                    exe = "black",
                    args = {'-'},
                    stdin = true,
                }
            end
        },
    }
})
EOF

" Format on save
lua << EOF
vim.api.nvim_exec([[
    augroup FormatAutogroup
        autocmd!
        autocmd BufWritePost *.py FormatWrite
    augroup END
]], true)
EOF


" NVIM-CMP Setup
lua << EOF
    -- Setup nvim-cmp
    local cmp = require'cmp'

    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,

        },
        mapping = {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'buffer'},
        }
    })

    require'lspconfig'.hls.setup {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }

    require'lspconfig'.pyright.setup {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }

    require'lspconfig'.gopls.setup {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }
EOF


" remaps
let mapleader = " "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for >")})<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<CR>

nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>

nnoremap <silent> <leader>f :Format<CR>
inoremap jk <ESC>
