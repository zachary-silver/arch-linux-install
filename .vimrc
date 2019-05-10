" Zachary Silver's .vimrc

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-syntastic/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'prettier/vim-prettier', { 'do': 'yarn install' }
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" Syntastic plugin (second line enables descriptive error feedback at bottom of
" working window)
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
"let g:syntastic_mode_map = {
"    \ "mode": "active",
"    \ "passive_filetypes": ["java"] }
" disables implicit syntax checking for java files to avoid issues with YouCompleteMe

" YouCompleteMe compile flags file for C family language completion
let g:ycm_global_ycm_extra_conf = "$HOME/.vim/.ycm_extra_conf.py"

" Nerdtree (vim-based file explorer) plugin toggle with Ctrl-f
map <C-f> :NERDTreeToggle<CR>

" allows for automatic filetype detection and filetype specific features such
" as indentation and plugins
filetype plugin indent on
syntax on			" enable syntax highlighting
set hlsearch			" highlights searched values
set mouse=a			" enable use of the mouse

" Text width for different file types
autocmd FileType text setlocal textwidth=78
autocmd FileType python set tw=79 " width of document (used by gd)
"autocmd FileType python set colorcolumn=80 " highlights column you're code shouldn't pass
autocmd FileType java,c set tw=100 " width of document (used by gd)
"autocmd FileType java,c set colorcolumn=101 " highlights column you're code shouldn't pass

autocmd FileType java,python,c set fo-=t " don't automatically wrap text when typing
autocmd FileType sh,html,css,js,java,python,c set nowrap " don't automatically wrap on load

" Tabs/Spacing
autocmd FileType java,python,c set tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd FileType html,css,js set tabstop=4 expandtab shiftwidth=2 softtabstop=2
set backspace=indent,eol,start

" toggles autoindentation so pasting text doesn't get malformed
set pastetoggle=<F2>
" changes the mode to PASTE when enabled so it's easier to know if it is
nnoremap <F2> :set invpaste paste?<CR>

" Return to last known location in file
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Set directories for vim's swap, backup, and undo files
set directory=$HOME/.vim/.swap//
set backupdir=$HOME/.vim/.backup//
set undodir=$HOME/.vim/.undo//

set noruler			" don't show line and column numbers in bottom right
set laststatus=0		" never show status bar
set cmdheight=1			" height of the bottom command bar
set shortmess=F			" don't show garbage in command bar
set backspace=indent,eol,start 	" allow backspacing over everything in insert mode
set history=50			" keep 50 lines of command line history
set incsearch			" do incremental searching
set number			" displays line numbers on left side of the screen
set relativenumber		" changes absolute line numbers to relative to cursor
set scrolloff=5		" starts scrolling when cursor reaches this line number away from edge

" Search down into subdirectories with ':find '
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Removes excess white space at end of lines upon exiting file
autocmd BufWritePre * %s/\s\+$//e

nnoremap H 3b
nnoremap L 3w
nnoremap J 5j
nnoremap K 5k

" General hotkeys
let mapleader=","

" vim-commentary hotkeys
nmap cm <Plug>Commentary
vmap cm <Plug>Commentary

" Use v (visual selection) then > or < to shift text right or left
vnoremap < <gv
vnoremap > >gv

" Move current line up/down
nmap <C-k> [e
nmap <C-j> ]e

" Move multiple selected lines up/down
vmap <C-k> [egv
vmap <C-j> ]egv

" Language specific hotkeys (in insert mode, hit ',' and then letters directly after <leader> tag)
autocmd FileType c inoremap <leader>main int main(void)<enter>{<enter><enter>return 0;<enter>}<esc>2kO
autocmd FileType c inoremap <leader>emain int main(int argc, char *argv[])<enter>{<enter><enter>return 0;<enter>}<esc>2kO
autocmd FileType java inoremap <leader>For for (type val: collection)<enter>{<enter>}<esc>2k2w
autocmd FileType java inoremap <leader>sys System.out.println();<esc>hi
autocmd FileType java inoremap <leader>err System.err.println();<esc>hi
autocmd FileType java inoremap <leader>con console.log();<esc>hi
autocmd FileType java inoremap <leader>main public static void main (String [] args)<enter>{<enter>}<esc>O
autocmd FileType java,c inoremap <leader>for for (int i = 0; i < ; i++)<enter>{<enter>}<esc>2k9wi
autocmd FileType java,c inoremap <leader>if if ()<enter>{<enter>}<esc>2kwli
autocmd FileType java,c inoremap <leader>whi while ()<enter>{<enter>}<esc>2kwli
autocmd FileType java,c inoremap <leader>do do<enter>{<enter>} while ();<esc>hi
autocmd FileType java,c inoremap <leader>/ /*   */<esc>3hi
autocmd FileType python inoremap <leader>pr print()<esc>i
autocmd FileType python inoremap <leader>ini def __init__(self):<esc>
autocmd FileType python inoremap <leader>str def __str__(self):<esc>
autocmd FileType python inoremap <leader>dun def ____(self):<esc>8hi
autocmd FileType python inoremap <leader>'' '''<enter>'''<esc>O

" Highlight column color
"highlight ColorColumn ctermbg=0

" Highlight text past column 80
"autocmd FileType java,python,c let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Syntax highlighting colors
"highlight Normal ctermfg=11
highlight LineNr ctermfg=257
highlight CursorLineNr ctermfg=257
highlight Statement ctermfg=Yellow
highlight Operator ctermfg=Yellow
highlight Keyword ctermfg=Red
highlight Exception ctermfg=DarkRed
highlight Constant ctermfg=DarkMagenta
highlight Boolean ctermfg=Yellow
highlight String ctermfg=DarkBlue
highlight Function ctermfg=Red
highlight Type ctermfg=Red
highlight StorageClass ctermfg=Green
highlight Special ctermfg=DarkBlue
highlight Comment ctermfg=DarkBlue
highlight MatchParen ctermfg=0
highlight MatchParen ctermbg=15
highlight IncSearch ctermbg=12
highlight IncSearch ctermfg=0
highlight Search ctermbg=15
highlight Search ctermfg=0
highlight Visual ctermbg=4
highlight Visual ctermfg=15
highlight VisualNOS ctermbg=4
highlight VisualNOS ctermfg=15
