syntax on 
set exrc
set noerrorbells
set tabstop=4 softtabstop=4
set expandtab
set nohlsearch
set scrolloff=8
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=200
set relativenumber
let mapleader = " "
set autowrite

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=NONE
set termguicolors
" Without this autocommands in metalz that deal with filetypes prohibit 
" messages from being shown... since we heavly realy in this, this must be set
set shortmess-=F

set clipboard+=unnamedplus
" abbreviation for inserting current date
iab <expr> dts strftime("%c")
" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
     augroup WSLYank
             autocmd!
             autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
     augroup END
endif

call plug#begin('~/.vim/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Themes
Plug 'rakr/vim-one'
Plug 'ayu-theme/ayu-vim'
Plug 'sjl/badwolf'
Plug 'gruvbox-community/gruvbox'
Plug 'tomasr/molokai'
Plug 'reewr/vim-monokai-phoenix'
Plug 'sickill/vim-monokai'
Plug 'vectorstorm/vim-chlordane'
Plug 'lokaltog/vim-monotone'
Plug 'gruvbox-community/gruvbox'
Plug 'mhartington/oceanic-next'
Plug 'huyvohcmc/atlas.vim'
Plug 'fxn/vim-monochrome'
Plug 'tomasr/molokai'

Plug 'rhysd/vim-gfm-syntax'
Plug 'cespare/vim-toml'
Plug 'preservim/nerdcommenter'

" Telescopic Johnson appears
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Galaxy???
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'
" Lsp gang
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'scalameta/nvim-metals'
" Sneaky snek time 
Plug 'ambv/black'
Plug 'ThePrimeagen/vim-be-good'

call plug#end()
lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}

colorscheme molokai

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif


:lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c" },  -- list of language that will be disabled
  },
}

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
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
