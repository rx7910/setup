" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" JavaScript bundle for vim, this bundle provides syntax highlighting and
Plug 'https://github.com/pangloss/vim-javascript.git'

" TypeScript syntax
Plug 'leafgarland/typescript-vim' 

" TypeScript Completation. 
Plug 'Quramy/tsuquyomi'

" syntax checking plugin
Plug 'vim-syntastic/syntastic'

" The React syntax highlighting and indenting plugin for vim. Also supports the typescript tsx file.
Plug 'maxmellon/vim-jsx-pretty'

" A Vim plugin to highlight JavaScript's Template Strings contents in other FileType syntax rule which you want.
Plug 'Quramy/vim-js-pretty-template'

" You Complete Me
Plug 'Valloric/YouCompleteMe'

" auto pairs
Plug 'jiangmiao/auto-pairs'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" vim开始页 https://github.com/mhinz/vim-startify#installation-and-documentation
Plug 'mhinz/vim-startify'

" 垂直对其线 https://github.com/Yggdroot/indentLine
Plug 'Yggdroot/indentLine'

" 图标颜色 https://github.com/tiagofumo/vim-nerdtree-syntax-highlight
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" file icons see: https://github.com/ryanoasis/vim-devicons
" brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
" see: https://github.com/ryanoasis/nerd-fonts#font-installation
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()



""""""""""""""""""""""""""""""""
" indent
""""""""""""""""""""""""""""""""

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction



""""""""""""""""""""""""""""""
" plugin config
""""""""""""""""""""""""""""""

" ycm
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers =  {
            \   'c' : ['->', '.'],
            \   'objc' : ['->', '.'],
            \   'ocaml' : ['.', '#'],
            \   'cpp,objcpp' : ['->', '.', '::'],
            \   'perl' : ['->'],
            \   'php' : ['->', '::', '"', "'", 'use ', 'namespace ', '\'],
            \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
            \   'html': ['<', '"', '</', ' '],
            \   'vim' : ['re![_a-za-z]+[_\w]*\.'],
            \   'ruby' : ['.', '::'],
            \   'lua' : ['.', ':'],
            \   'erlang' : [':'],
            \   'haskell' : ['.', 're!.']
            \ }


" syntastic
" Syntastic has numerous options that can be configured, and the defaults are not particularly well suitable for new users. It is recommended that you start by adding the following lines to your vimrc file, and return to them after reading the manual (see :help syntastic in Vim)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" tsuquyomi
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.

" Rename symbols.  Using the command :TsuRenameSymbol, you can rename the identifier under the cursor to a new name.
" autocmd FileType typescript nmap <buffer> <Leader>e <Plug>(TsuquyomiRenameSymbol)
" autocmd FileType typescript nmap <buffer> <Leader>E <Plug>(TsuquyomiRenameSymbolC)

" Tooltip. Tsuquyomi can display tooltip window about symbol under the mouse cursor. 
" set ballooneval
" autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()


" vim-js-pretty-template
" Register tag name associated the filetype
" call jspretmpl#register_tag('gql', 'graphql')

autocmd FileType javascript JsPreTmpl
autocmd FileType javascript.jsx JsPreTmpl
autocmd FileType typescript JsPreTmpl
autocmd FileType typescript syn clear foldBraces " For leafgarland/typescript-vim users only. Please see #1 for details.
autocmd FileType dart JsPreTmpl


" airline theme
" see: https://github.com/vim-airline/vim-airline/wiki/Screenshots
let g:airline_theme='deus'

" devicons
let g:airline_powerline_fonts = 1
let g:webdevicons_enable_nerdtree = 1


" nerftree
let NERDTreeShowHidden=1 " 显示隐藏文件
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
map <C-f> :NERDTreeToggle<CR>

"Making it prettier
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1


""""""""""""""""""""""""""""""
" key binding
""""""""""""""""""""""""""""""

set backspace=indent,eol,start
set number
set encoding=UTF-8

" set <leader>
let mapleader = ","

" set file pos using frequently
let $FP_V2RAY_PAC="~/Library/Application Support/V2RayX/pac/pac.js"
let $FP_CLASH_PAC="/Users/rx/.config/clash/Clash_1644215449.yaml"

" mapping edit vimrc file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" mapping edit file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>pac :vsplit $FP_V2RAY_PAC<cr>
nnoremap <leader>cla :vsplit $FP_CLASH_PAC<cr>

" mapping source vimrc file
nnoremap <leader>sv :source $MYVIMRC<cr>


