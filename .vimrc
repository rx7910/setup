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
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

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

" The React syntax highlighting and indenting plugin for vim. Also supports the typescript tsx file.
Plug 'maxmellon/vim-jsx-pretty'

" You Complete Me
Plug 'Valloric/YouCompleteMe'

" auto pairs
Plug 'jiangmiao/auto-pairs'

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

" nerftree
DTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
"Making it prettier
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1


""""""""""""""""""""""""""""""
" key binding
""""""""""""""""""""""""""""""
map <C-f> :NERDTreeToggle<CR>
'
