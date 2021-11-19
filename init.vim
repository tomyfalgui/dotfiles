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
    Plug 'vim-airline/vim-airline'
    Plug 'sheerun/vim-polyglot'
    Plug 'mattn/emmet-vim'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-fugitive'
    Plug 'ryanoasis/vim-devicons'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'jparise/vim-graphql'
call plug#end()

colorscheme gruvbox

let g:completion_mathcing_strategy_list = ['exact', 'substring', 'fuzzy']
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" coc
let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-yank', 'coc-prettier']

imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")


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

" remaps
let mapleader = " "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for >")})<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<CR>

nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>

inoremap jk <ESC>

inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
