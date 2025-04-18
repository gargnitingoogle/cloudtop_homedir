" Welcome to Vim (http://GO/VIM).
"
" If you see this file, your homedir was just created on this workstation.
" That means either you are new to Google (in that case, welcome!) or you
" got yourself a faster machine.
" Either way, the main goal of this configuration is to help you be more
" productive; if you have ideas, praise or complaints, direct them to
" vi-users@google.com (http://g/vi-users). We'd especially like to hear from you
" if you can think of ways to make this configuration better for the next
" Noogler.
" If you want to learn more about Vim at Google, see http://go/vimintro.

" Enable modern Vim features not compatible with Vi spec.
set nocompatible
set history=5000
"set wildmenu
"set scrolloff=3
"set laststatus=2

" Allow launching upto 99 tabs at a time
set tabpagemax=99
" Always show status bar
set laststatus=2
" Show full file path in status bar
set statusline+=%F

" Set custom file-type mappings
" Make sure all types of requirements.txt files get syntax highlighting.
au BufNewFile,BufRead requirements*.txt set ft=python
" Make sure .aliases, .bash_aliases and similar files get syntax highlighting.
au BufNewFile,BufRead .*aliases,*.tmux.conf set ft=sh

" " save folds across vim restarts and buffer reopens
" Commented this out because this causes problem with
" saving and opening sessions.
" augroup remember_folds
" au!
" au BufWinLeave * mkview
" au BufWinEnter * silent! loadview
" augroup END

" trigger autoread when changing buffers inside while inside vim:
au FocusGained,BufEnter * :checktime

" show line numbers by default
set nu
" show relative line numbers
" set relativenumber
" show/hide line numbers on ll
:nnoremap ll :set invnumber<CR>
" " Go to line number using Ctrl-g
" :nnoremap <C-g> :
" :inoremap <C-g> <Esc>:
" highlight search results
set hlsearch
" Enable syntax highlighting
syntax on

" set color-scheme
colorscheme habamax

" do not wrap search back to head of file
set nowrapscan
" auto reload file
set autoread
au CursorHold * checktime
" show tabs and whitespaces
set list
set listchars=tab:>-
" noremap <Leader><Tab><Tab> :set invlist<CR>

" enable mouse in all modes
set mouse=a
" disable mouse-mode with 'm' and re-enable with 'M'
:nnoremap M :set mouse=a<CR>
:nnoremap m :set mouse=<CR>

"set formatoptions=croqlj
"set ruler
"set number
" set background=dark
"highlight default link TrailingWhitespace Error
" set paste

" change currentdir to directory of current file.
set autochdir
" highlight current line
set cursorline
" " Wrap lines after x chars.
" set tw=80
" Add shortcuts to comment out lines
au FileType go,c,cpp,java,javascript nnoremap <buffer> <C-c><C-c> <Esc>^i//<Esc><Down>
au FileType sh,make,python,yaml nnoremap <buffer> <C-c><C-c> <Esc>^i# <Esc><Down>
au FileType vim nnoremap <buffer> <C-c><C-c> <Esc>^i" <Esc><Down>
" Add shortcuts to uncomment lines
au FileType go,c,cpp,sh,make,python,yaml,java,javascript,vim nnoremap <buffer> <C-c><C-u> <Esc>^xx<Down>
" Delete line on Ctrl-d
:nnoremap <C-d> dd
:inoremap <C-d> <Esc>ddi
" Undo on Ctrl-z
:noremap <C-z> u
" Redo on Ctrl-y
:noremap <C-y> <C-r>
" Find in file\
:nnoremap <C-f> <Esc>:/


" code navigation
" Go to definition of symbol under cursor using gd
:nnoremap <> gd
" Navigate forward/back using Alt-Right/Left
:nnoremap <M-Left> <C-o>
:nnoremap <M-Right> <C-i>
" Go to next function using Ctrl-Down.
au FileType go nnoremap <buffer> <C-Down> <Esc>:/^\<func\><CR><Esc>:noh<CR>
au FileType python nnoremap <buffer> <C-Down> <Esc>:/^\<def\><CR><Esc>:noh<CR>
au FileType sh nnoremap <buffer> <C-Down> <Esc>:/^\<function\><CR><Esc>:noh<CR>
au FileType c,cpp,java nnoremap <buffer> <C-Down> <Esc>:/^[a-zA-Z]<CR><Esc>:noh<CR>
" Go to prev function using Ctrl-Up.
au FileType go nnoremap <buffer> <C-Up> <Esc>:?^\<func\><CR><Esc>:noh<CR>
au FileType python nnoremap <buffer> <C-Up> <Esc>:?^\<def\><CR><Esc>:noh<CR>
au FileType sh nnoremap <buffer> <C-Up> <Esc>:?^\<function\><CR><Esc>:noh<CR>
au FileType c,cpp,java nnoremap <buffer> <C-Up> <Esc>:?^[a-zA-Z]<CR><Esc>:noh<CR>

" insert a newline on pressing br
:nnoremap br <Esc>i<CR><Esc>
" stop highlighting search results
:nnoremap ,<space> :nohlsearch<cr>

" Tab navigation shortcuts
" discard everything and close current tab on Ctrl+q
:nnoremap <C-q> <Esc>:q<CR>
"Short cut to save the file on Ctrl+s
:inoremap <C-s> <Esc>:w<CR>i
:nnoremap <C-s> <Esc>:w<CR>
" Clone current tab with Ctrl+N
:nnoremap <C-n> <Esc>:tabnew %<CR>
" Open a new tab with file to pick from same directory, on Ctrl-O.
:nnoremap <C-o> <Esc>:tabe 
" Press Alt-Up to navigate the parent directory of the current directory.
:nnoremap <M-up> <Esc>:tabf ..<CR><Esc>
:nnoremap <M-down> <Esc>:tabe .<CR><Esc>
" Redraw tab bar on gt
:nnoremap gt gt:redraw<bar>file<cr>
" Go to next tab with Ctrl+Right-arrow
:nnoremap <C-Right> <Esc>:tabn<CR><Esc>
" Go to prev tab with Ctrl+Left-arrow
:nnoremap <C-Left> <Esc>:tabp<CR><Esc>
"Go to previous active tab using tt
:nnoremap tt <Esc>g<Tab>

" Reload file-content on F5
:nnoremap <F5> <Esc>:e<CR><Esc>
" Reload vim-config on ff
:nnoremap ff <Esc>:source ~/.vimrc<CR><Esc>

" Copy to the other side in a diff window using Ctrl+Shift+R
:nnoremap <C-S-R> yy<C-W><C-W>Pjddk<C-W><C-W><Esc>

" highlight trailing spaces
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

" find and replace in visual mode with Ctrl+R
:vnoremap <C-F> "hy/<C-r>h<CR>
:vnoremap <C-H> "hy:%s/<C-r>h/<C-r>h/gc<left><left><left>

" :nnoremap <expr> <C-PageDown> &diff ? ']c' : '<C-PageDown>'
" :nnoremap <expr> <C-PageUp>   &diff ? '[c' : '<C-PageUp>'

" " set mouse+=a
" if &term =~ '^screen'
"     " tmux knows the extended mouse mode
"     set ttymouse=xterm2
" endif

:nnoremap <space> i <Esc>
:nnoremap <backspace> i<backspace><right><Esc>

" Replace all $env with ${env}
fun! EnvDecorate()
  :%s/\$\([a-z0-9A-Z]\+\)/${\1}/gc
endfunction

" Replace [0-9]+[kmg] to [0-9]+[KMG]
fun!  UnitsCapitalize()
  :%s/\([0-9]\+\)\([kmg]\)/\1\U\2/gc
endfunction

fun! VimdiffHideContext()
  :set diffopt+=context:0
endfunction

fun! VimdiffShowContext()
  :set diffopt+=context:5
endfunction

:set wrap

" Remember cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
endif

" Turn off beeping sound when using vim.
set visualbell

" Use the 'google' package by default (see http://go/vim/packages).
source /usr/share/vim/google/google.vim
" Glug g4
Glug g4
Glug codefmt
Glug codefmt-google
augroup autoformat_settings
  au FileType borg,gcl,patchpanel AutoFormatBuffer gclfmt
  au FileType bzl AutoFormatBuffer buildifier
  au FileType c,cpp,javascript,typescript AutoFormatBuffer clang-format
  au FileType dart AutoFormatBuffer dartfmt
  au FileType go AutoFormatBuffer gofmt
  au FileType java AutoFormatBuffer google-java-format
  au FileType jslayout AutoFormatBuffer jslfmt
  au FileType markdown AutoFormatBuffer mdformat
  au FileType ncl AutoFormatBuffer nclfmt
  au FileType python AutoFormatBuffer pyformat
  au FileType soy AutoFormatBuffer soyfmt
  au FileType textpb AutoFormatBuffer text-proto-format
  au FileType proto AutoFormatBuffer protofmt
  au FileType sql AutoFormatBuffer format_sql
"  au FileType html,css,json AutoFormatBuffer js-beautify
  au FileType html,css AutoFormatBuffer js-beautify
augroup END

Glug whitespace !highlight

" Plugin configuration.
" See http://google3/devtools/editors/vim/examples/ for example configurations
" and http://go/vim/plugins for more information about vim plugins at Google.

" Plugin loading is commented out below - uncomment the plugins you'd like to
" load.

" Load google's formatting plugins (http://go/vim/plugins/codefmt-google).
" The default mapping is \= (or <leader>= if g:mapleader has a custom value),
" with
" - \== formatting the current line or selected lines in visual mode
"   (:FormatLines).
" - \=b formatting the full buffer (:FormatCode).
"
" To bind :FormatLines to the same key in insert and normal mode, add:
"   noremap <C-K> :FormatLines<CR>
"   inoremap <C-K> <C-O>:FormatLines<CR>
Glug codefmt plugin[mappings] gofmt_executable="goimports"
Glug codefmt-google

" Enable autoformatting on save for the languages at Google that enforce
" formatting, and for which all checked-in code is already conforming (thus,
" autoformatting will never change unrelated lines in a file).
" Note formatting changed lines only isn't supported yet
" (see https://github.com/google/vim-codefmt/issues/9).
augroup autoformat_settings
"  au FileType bzl AutoFormatBuffer buildifier
"  au FileType go AutoFormatBuffer gofmt
"  See go/vim/plugins/codefmt-google, :help codefmt-google and :help codefmt
"  for details about other available formatters.
augroup END

" Load YCM (http://go/ycm) for semantic auto-completion and quick syntax
" error checking. Pulls in a google3-enabled version of YCM itself and
" a google3-specific default configuration.
Glug youcompleteme-google

" Load the automated blaze dependency integration for Go.
" Note: for Go, blazedeps uses the Go team's glaze tool, which is fully
" supported by the Go team. The plugin is currently unsupported for other
" languages.
Glug blazedeps auto_filetypes=`['go']`

" Load piper integration (http://go/VimPerforce).
Glug piper plugin[mappings]

" Load Critique integration. Use :h critique for more details.
Glug critique plugin[mappings]

" Load blaze integration (http://go/blazevim).
Glug blaze plugin[mappings]

" Load the syntastic plugin (http://go/vim/plugins/syntastic-google).
" Note: this requires installing the upstream syntastic plugin from
" https://github.com/vim-syntastic/syntastic.
Glug syntastic-google

" Load the ultisnips plugin (http://go/ultisnips).
" Note: this requires installing the upstream ultisnips plugin from
" https://github.com/SirVer/ultisnips.
Glug ultisnips-google

" All of your plugins must be added before the following line.
" See go/vim-plugin-manager if you need help picking a plugin manager and
" setting it up.

" Enable file type based indent configuration and syntax highlighting.
" Note that when code is pasted via the terminal, vim by default does not detect
" that the code is pasted (as opposed to when using vim's paste mappings), which
" leads to incorrect indentation when indent mode is on.
" To work around this, use ":set paste" / ":set nopaste" to toggle paste mode.
" You can also use a plugin to:
" - enter insert mode with paste (https://github.com/tpope/vim-unimpaired)
" - auto-detect pasting (https://github.com/ConradIrwin/vim-bracketed-paste)
filetype plugin indent on

" enable the relatedfiles plugin,
Glug relatedfiles
Glug relatedfiles plugin[mappings]=',f'

Glug libgit
Glug refactorer
Glug refactorer plugin[mappings]='F2'
Glug add_usings
Glug colorscheme-primary
set guitablabel=%t
Glug outline-window
