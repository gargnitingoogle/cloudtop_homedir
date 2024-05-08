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

" show line numbers
se nu
" show relative line numbers
se relativenumber
"
" highlight search results
set hlsearch
" Enable syntax highlighting
syntax on

colorscheme habamax

" do not wrap search back to head of file
set nowrapscan

" auto reload file
set autoread

" show tabs
set list
set listchars=tab:>-
noremap <Leader><Tab><Tab> :set invlist<CR>

" enable mouse in all modes
set mouse=a

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

" autocmd FileType c,cpp,go 
nnoremap <C-k><C-c> <Esc>i<Home>//<Esc>
noremap <C-d> dd
noremap <C-z> u
noremap <C-y> <C-r>

" Shortcut to discard everything and close all files on Ctrl+q 
:noremap <C-q> <Esc>:qa<CR>
"Short cut to save the file on Ctrl+s
:inoremap <C-s> <Esc>:w<CR>i
:nnoremap <C-s> <ESC>:w<CR>

" Open a new unnamed tab on Ctrl+N
:nnoremap <C-n> <Esc>:tabnew<CR>
" Open a new tab on Ctrl+o
:nnoremap <C-o> <Esc>:tabe  
" Close the current tab on Ctrl+w
:nnoremap <C-w> <Esc>:q!<CR>  

" insert a newline on pressing br
:nnoremap br <Esc>i<CR><Esc>

" Use the 'google' package by default (see http://go/vim/packages).
source /usr/share/vim/google/google.vim
" Glug g4
Glug g4
Glug codefmt
Glug codefmt-google
augroup autoformat_settings
  autocmd FileType borg,gcl,patchpanel AutoFormatBuffer gclfmt
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,javascript,typescript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType jslayout AutoFormatBuffer jslfmt
  autocmd FileType markdown AutoFormatBuffer mdformat
  autocmd FileType ncl AutoFormatBuffer nclfmt
  autocmd FileType python AutoFormatBuffer pyformat
  autocmd FileType soy AutoFormatBuffer soyfmt
  autocmd FileType textpb AutoFormatBuffer text-proto-format
  autocmd FileType proto AutoFormatBuffer protofmt
  autocmd FileType sql AutoFormatBuffer format_sql
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
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
"  autocmd FileType bzl AutoFormatBuffer buildifier
"  autocmd FileType go AutoFormatBuffer gofmt
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
