set visualbell
" based on http://github.com/jferris/config_files/blob/master/vimrc
let g:python3_host_prog="/usr/local/bin"
" see https://github.com/dag/vim-fish#teach-a-vim-to-fish
if &shell =~# 'fish$'
   set shell=sh
endif
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set mouse=a
if !has('nvim')
  if has("mouse_sgr")
      set ttymouse=sgr
  else
      set ttymouse=xterm2
  end
endif
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" set clipboard=unnamed

set nowrap
set nobackup
set nowritebackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" set visualbell
set directory=~/tmp
set sidescroll=5

" Don't use Ex mode, use Q for formatting
map Q gq

" Comment out lines
vnoremap <C-n> :norm

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Switch wrap off for everything
" set nowrap

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  call pathogen#infect()
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Set File type to 'text' for files ending in .txt
  autocmd BufNewFile,BufRead *.txt setfiletype text

  " Enable soft-wrapping for text files
  autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist

  autocmd FileType html,xml,xsl,php,jsp,eruby let b:closetag_html_style=1
  autocmd FileType html,xml,xsl,php,jsp,eruby source ~/.vim/scripts/closetag.vim

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Automatically load .vimrc source when saved
  autocmd BufWritePost .vimrc source $MYVIMRC

  autocmd BufReadPre *
    \ let f=getfsize(expand("<afile>"))
    \ | if f > 100000 || f == -2
    \ | let b:copilot_enabled = v:false
    \ | endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Always display the status line
set laststatus=2

" \ is the leader character
let mapleader = ","

map <F6> :NERDTreeToggle<cr>
map ` :NERDTreeToggle<cr>

let NERDTreeIgnore = ['\.sock$','\.zeus\.sock$']

if has('nvim')
  call plug#begin('~/.vim/plugged')
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  Plug 'sbdchd/neoformat'
  let g:neoformat_enabled_ruby = ['rubocop']
 "  let g:neoformat_verbose = 1
  map <leader>c :Neoformat 

  call plug#end()

  set clipboard+=unnamedplus
endif

  " https://wincent.com/blog/2-hours-with-vim
  function! AckGrep(command)
    cexpr system("ack " . a:command)
    cw " show quickfix window already
  endfunction

  command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
  map <leader>f :Ack<space>
if !has('nvim')

  map <leader>c :Autoformat 

  autocmd FileType vim,rb,rake let g:autoformat_autoindent = 0
  autocmd FileType vim,rb,rake let g:autoformat_retab = 0
  autocmd FileType vim,rb,rake let g:autoformat_remove_trailing_spaces = 0
endif

" Command-t settings
let g:CommandTFileScanner = 'git'
let g:CommandTMatchWindowAtTop=1
let g:CommandTCancelMap='<Esc>'
let g:CommandTWildIgnore = &wildignore
let g:CommandTWildIgnore .= ',**/.git/*'
let g:CommandTWildIgnore .= ',**/coverage/*'
let g:CommandTWildIgnore .= ',**/bower_components/*'
let g:CommandTWildIgnore .= ',**/node_modules/*'
let g:CommandTWildIgnore .= ',**/tmp/*'
"let g:CommandTSelectNextMap='<Down>'
"let g:CommandTSelectPrevMap=['<C-p>', '<C-k>', '<Esc>OA', '<Up>']
" map <leader>r :CommandTFlush<CR>

" Hide search highlighting
map <Leader>h :set invhls <CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vmap P p :call setreg('"', getreg('0')) <CR>

" No Help, please
nmap <F1> <Esc>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Maps autocomplete to tab
"imap <Tab> <C-N>

imap <C-L> <Space>=><Space>

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor\ --ignore-dir=tmp\ --ignore-dir=coverage
endif

" Color scheme
 set t_Co=256 " Lets you use 256 colors
 let g:solarized_termcolors=256
 if has('gui_running')
   let g:solarized_style="light"
   set background=light
 else
   let g:solarized_style="dark"
   set background=dark
 end


colorscheme solarized
let g:solarized_contrast="high"
 
 set guifont=Input:h16

 function! ToggleBackground()
   if (g:solarized_style=="dark")
     let g:solarized_style="light"
     colorscheme solarized
   else
     let g:solarized_style="dark"
     colorscheme solarized
   endif
 endfunction
 command! Togbg call ToggleBackground()
 nnoremap <F5> :call ToggleBackground()<CR>
 inoremap <F5> <ESC>:call ToggleBackground()<CR>a
 vnoremap <F5> <ESC>:call ToggleBackground()<CR>

 function! ToggleContrast()
   if (g:solarized_contrast=="normal")
     let g:solarized_contrast="high"
     colorscheme solarized
   else
     let g:solarized_contrast="normal"
     colorscheme solarized
   endif
 endfunction
 command! Togctrst call ToggleContrast()
 nnoremap <F4> :call ToggleContrast()<CR>
 inoremap <F4> <ESC>:call ToggleContrast()<CR>a
 vnoremap <F4> <ESC>:call ToggleContrast()<CR>



" colorscheme railscasts
" colorscheme vividchalk
" highlight NonText guibg=#060606
" highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Numbers
set number
set numberwidth=5

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" case only matters with mixed case expressions
set ignorecase
set smartcase

if !has('nvim')
" Tags
  let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
  set tags=./tags;
endif

" allow per project .vimrc files
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files


" au BufWrite * :Autoformat

" strip trailing spaces on save
autocmd BufWritePre *.rb :%s/\s\+$//e
autocmd BufWritePre
" set ttimeout ttimeoutlen=10 
" silent! execute "set <M-Right>=\<Esc>[1;9C"
" imap <C-Right> <Plug>(copilot-accept-word)
" Copilot
imap <M-CR> <M-Right>

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf


" set path+=apps/**/services
" set path+=apps/**/models
" set path+=apps/**/presenters
" set path+=apps/**/spec
" set path+=apps/**/controllers
" set path+=apps/**/views
" set path+=apps/**/graphql
" set path+=apps/**/policies
" set path+=apps/**/jobs
" set path+=apps/**/mailers
" set path+=lib/tasks

" --- FZF / CMD-P CONFIGURATION ---


" Use ripgrep to find files, including hidden ones, but ignoring the .git folder
" The --follow flag ensures it follows symlinks (common in monorepos)
set rtp+=/opt/homebrew/opt/fzf
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*" --glob "!*.js"' 
  " This links the :Files command to use the Ripgrep settings above
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
endif

" Force Ctrl-p to trigger the :Files command in Normal Mode
" We use 'unmap' first to clear any legacy baggage if it exists
silent! nunmap <C-p>
nnoremap <C-p> :Files<CR>
" The 'CMD-P' equivalent (Standard file search)
" The 'Git-only' search (Even faster for Rails projects)
nnoremap <leader>p :GFiles<CR>

" Aesthetics: Floating window with a preview on the right
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }

" Enable the preview window (requires 'bat' for syntax highlighting)
" brew install bat
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" 1. Kill any existing mappings for Ctrl-P in all modes
silent! nunmap <C-p>
silent! iunmap <C-p>
silent! cunmap <C-p>
silent! vunmap <C-p>

" 2. Re-bind it purely to the command you like
nnoremap <C-p> :Files<CR>
" --- Specialized FZF Shortcuts ---

" CMD-B (Buffers): Search through open files (VSCode-style buffer switching)
nnoremap <C-b> :Buffers<CR>

" Leader-h (History): Search through Most Recently Used (MRU) files
nnoremap <leader>h :History<CR>

" Leader-l (Lines): Search for text within all open buffers
nnoremap <leader>l :Lines<CR>

" Leader-g (Git Commits): Search through commit history
nnoremap <leader>g :Commits<CR>
" 3. Ensure the layout is global
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }

