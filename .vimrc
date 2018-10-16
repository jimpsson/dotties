"           ██                           
"          ░░                            
"  ██    ██ ██ ██████████  ██████  █████ 
" ░██   ░██░██░░██░░██░░██░░██░░█ ██░░░██
" ░░██ ░██ ░██ ░██ ░██ ░██ ░██ ░ ░██  ░░ 
"  ░░████  ░██ ░██ ░██ ░██ ░██   ░██   ██
"   ░░██   ░██ ███ ░██ ░██░███   ░░█████ 
"    ░░    ░░ ░░░  ░░  ░░ ░░░     ░░░░░ 
" Have fun!

if $TERM != "linux"         " if we are not in TTY
   set t_Co=256             " set 256 colors.
endif

set nocompatible            " be iMproved
set laststatus=2	    " show status 
filetype off		    " required
syntax on		    " enable syntax colors
colorscheme barrage         " colorscheme

" Bindings

" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e

" Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv

" Visually select the text that was last edited
nmap gV `[v`]

" Settings
set completeopt-=preview    " disable scratch buffer
set cursorline              " enable cursor highlight
set showcmd                 " show command information
set foldmethod=marker       " allow marking folds
set showmatch               " hilight search pattern
set incsearch               " incremental search
set scrolloff=1             " 1 line offset from top-bottom
set sidescrolloff=5         " 5 character offset from left-right
set nowrap                  " don't wrap lines
set virtualedit=all         " enable virtualedit (visual block)
set expandtab               " spaces not tabs
set softtabstop=2           " indents
set shiftwidth=2            " more indents
set number                  " show line numbers
set noswapfile              " no swap files
set updatecount=0           " we don't use swap files
set ignorecase              " ignore case in search
set smartcase               " if uppercase letter, don't ignore
set undolevels=1000         " undo levels
set lazyredraw              " don't redraw while executing macros
set noerrorbells            " disable bell
set showtabline=1           " show/hide tabs
set cmdheight=1             " cmd height
set modeline                " use modelines
set ttimeout                " key combination timeout
set ttimeoutlen=50          " lower statusline timeout
set autoindent              " indent to last identation
set listchars=tab:▏\ ,trail:~,eol:¬ " show unbroken lines

" vim: set ts=8 sw=3 tw=78 :
