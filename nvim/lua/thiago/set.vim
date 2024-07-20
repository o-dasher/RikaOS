" Number lines
set nu
set rnu

" Tab sizes
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Cursor
set cursorline

" Right column
set signcolumn=yes
set colorcolumn=80

" Search
set hlsearch
set incsearch
set smartcase
set ignorecase

" Scroll
set scrolloff=4

" Remaps --
let g:mapleader = " "

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y
vnoremap <leader>Y "+yg_
nnoremap  <leader>Y  "+yg_

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Move lines around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
