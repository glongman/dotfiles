" based on http://github.com/jferris/config_files/blob/master/vimrc
"
" see https://github.com/dag/vim-fish#teach-a-vim-to-fish
if &shell =~# 'fish$'
   set shell=sh
endif
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set clipboard=unnamed

set nowrap
set nobackup
set nowritebackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set visualbell
set directory=~/tmp
:set sidescroll=5

" Don't use Ex mode, use Q for formatting
map Q gq

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

  augroup END

  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'

  let g:ctrlp_working_path_mode = 'ra'

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" if has("folding")
  " set foldenable
  " set foldmethod=syntax
  " set foldlevel=1
  " set foldnestmax=2
  " set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
" endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Always display the status line
set laststatus=2

" \ is the leader character
let mapleader = ","

" Leader shortcuts for Rails commands
" map <Leader>m :Rmodel 
" map <Leader>c :Rcontroller 
" map <Leader>v :Rview 
" map <Leader>u :Runittest 
" map <Leader>f :Rfunctionaltest 
" map <Leader>tm :RTmodel 
" map <Leader>tc :RTcontroller 
" map <Leader>tv :RTview 
" map <Leader>tu :RTunittest 
" map <Leader>tf :RTfunctionaltest 
" map <Leader>sm :RSmodel 
" map <Leader>sc :RScontroller 
" map <Leader>sv :RSview 
" map <Leader>su :RSunittest 
" map <Leader>sf :RSfunctionaltest 

map <F6> :NERDTreeToggle<cr>
map ` :NERDTreeToggle<cr>

let NERDTreeIgnore = ['\.sock$','\.zeus\.sock$']

" https://wincent.com/blog/2-hours-with-vim
function! AckGrep(command)
  cexpr system("ack " . a:command)
  cw " show quickfix window already
endfunction

command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
map <leader>f :Ack<space>
" previous ack result
map <leader>[ :cp<CR>
" next ack result
map <leader>] :cn<CR>

map <leader>c "+y
map <leader>v "+p
map <leader>u :u<CR>

map <leader>c :Autoformat 

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
let g:CommandTSelectPrevMap=['<C-p>', '<C-k>', '<Esc>OA', '<Up>']
map <leader>r :CommandTFlush<CR>

" Hide search highlighting
map <Leader>h :set invhls <CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

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
" set list listchars=tab:»·,trail:·

" Edit routes
command! Rroutes :e config/routes.rb
command! Rschema :e db/schema.rb

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
 
set guifont=Menlo:h16

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

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" case only matters with mixed case expressions
set ignorecase
set smartcase

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
set tags=./tags;

" allow per project .vimrc files
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files


" au BufWrite * :Autoformat

" strip trailing spaces on save
autocmd BufWritePre *.rb :%s/\s\+$//e

" fun! RunRubocop()
"     if &ft =~ 'ruby\|rake\' ||  expand('%:r') == 'Gemfile'
"         silent execute "!bundle exec rubocop-git -a" | redraw!
"     endif
" endfun
" set autoread
" autocmd BufWritePost * call RunRubocop()
"
" Code Folding with space bar
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

