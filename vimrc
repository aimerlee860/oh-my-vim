"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugin
filetype plugin on
filetype indent on

let mapleader = ","
let g:mapleader = ","

function! SwitchToBuf(filename)
  "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
  " find in current tab
  let bufwinnr = bufwinnr(a:filename)
  if bufwinnr != -1
    exec bufwinnr . "wincmd w"
    return
  else
    " find in each tab
    tabfirst
    let tab = 1
    while tab <= tabpagenr("$")
      let bufwinnr = bufwinnr(a:filename)
      if bufwinnr != -1
        exec "normal " . tab . "gt"
        exec bufwinnr . "wincmd w"
        return
      endif
      tabnext
      let tab = tab + 1
    endwhile
    " not exist, new tab
    exec "tabnew " . a:filename
  endif
endfunction

"Fast edit vimrc
"Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
"Fast editing of .vimrc
map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>
"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl

" Set font according to system
set gfn=Monospace\ 10
set shell=/bin/bash

if has("gui_running")
  set guioptions-=T
  set t_Co=256

  " set background=dark
  colorscheme peaksea

  set nonu
else
  " colorscheme zellner
  " colorscheme desert 
  " colorscheme murphy 
  " colorscheme elflord
  " colorscheme torte
  " colorscheme evening
  " colorscheme solarized 
  " colorscheme slate
  " colorscheme delek
  " colorscheme peachpuff
  " set background=dark
  " set nonu
  set nu
endif

if (match($LANG, 'utf') < 0 && match($LANG, 'UTF') < 0)
  set encoding=prc
else
  set encoding=utf-8
endif
set fileencodings=utf8,gb18030,gb2312,ucs-bom,latin1

try
  lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types


""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c\ \ \ %{strftime(\"20%y/%m/%d\ \%H:%M\")}
if version >= 700
  hi StatusLine term=reverse ctermbg=0 guisp=Magenta
  au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
  au InsertLeave * hi StatusLine term=reverse ctermbg=0 gui=bold,reverse guisp=Magenta
endif


function! CurDir()
  let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
  return curdir
endfunction

function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  else
    return ''
  endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set tabstop=2
set smarttab

set wrap "Wrap lines
set autoindent "Auto indent
set smartindent "Smart indet

map <TAB> gt
map \ gT

set hls
set nocompatible
set backspace=indent,eol,start

set showmatch
set linebreak

" set autochdir
set cursorline ""高亮显示当前行
set completeopt=menuone,longest


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

let g:tagbar_left=1
nmap <F8> :TagbarToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ctags & Cscope Tool
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags=tags;
if has("cscope")
  " set cscopetag   " 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳来跳去
  " check cscope for definition of a symbol before checking ctags:
  " set to 1 if you want the reverse search order.
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any cscope database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
  " else add the database pointed to by environment variable
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  else
    let cscope_file=findfile("cscope.out", ".;")
    let cscope_pre=matchstr(cscope_file, ".*/")
    if !empty(cscope_file) && filereadable(cscope_file)
      exe "cs add" cscope_file cscope_pre
    endif
  endif
  set csverb
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => BufExplorer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 30  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => WinManager Tool
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout='FileExplorer,BufExplorer|TagList'   " 这里可以设置为多个窗口, 如'FileExplorer|BufExplorer|TagList'
let g:persistentBehaviour=0              " 只剩一个窗口时, 退出vim.
let g:winManagerWidth=20
let g:defaultExplorer=1
nmap <silent> <leader>fir :FirstExplorerWindow<cr>
nmap <silent> <leader>bot :BottomExplorerWindow<cr>
nmap <silent> wm :WMToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => C.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:C_Ctrl_j = 'off'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FileType & Signature
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype on
augroup filetype
  autocmd! BufNewFile,BufRead,BufReadPre,BufReadPost *.proto setfiletype proto
  autocmd! BufNewFile,BufRead,BufReadPre,BufReadPost *.thrift setfiletype thrift
augroup end

autocmd BufNewFile *.cpp,*.[ch],*.cc,*.java,*.py,*.sh,*.proto,*.thrift,*.go exec ":call SignName()"
function! SignName()
  if &filetype == 'sh'
    call setline(1,          "\#!/usr/bin/env bash")
    call append(line("."),   "\# Copyright CodeFarmer Inc. All Rights Reserved.")
    call append(line(".")+1, "\# Author:aimerlee860@gmail.com(JingJie Li)")
    call append(line(".")+2, "\# Created Time: ".strftime("%c"))
    call append(line(".")+3, "\# ==============================================================================")
                                                                                                                                                                                         
    map ` I# <ESC>
    map ~ A # <ESC>
  elseif &filetype == 'cpp' || &filetype == 'cc' || &filetype == 'c' || &filetype == 'java' || &filetype == 'go'
    call setline(1,          "\// Copyright CodeFarmer Inc. All Rights Reserved.")
    call append(line("."),   "\// Author: aimerlee860@gmail.com(JingJie Li)")
    call append(line(".")+1, "\// Created Time: ".strftime("%c"))

    map ` I// <ESC>
    map ~ A // <ESC>
  elseif &filetype == 'python'
    call setline(1,          "\#!/usr/bin/env python")
    call append(line("."),   "\# Copyright CodeFarmer Inc. All Rights Reserved.")
    call append(line(".")+1, "\# Created Time: ".strftime("%c"))
    call append(line(".")+2, "")
    call append(line(".")+3, "\__auth__ = \'aimerlee860@gmail.com (Jingjie Li)\'")

    set foldlevel=10

    map ` I# <ESC>
    map ~ A # <ESC>
  elseif &filetype == 'proto'
    source ~/.vim/syntax/proto.vim

    call setline(1,           "\// Copyright CodeFarmer Inc. All Rights Reserved.")
    call append(line("."),    "\// Author: aimerlee860@gmail.com(JingJie Li)")
    call append(line(".")+1,  "\// Created Time: ".strftime("%c"))

    " Auto close pair.
    inoremap ( ()<ESC>i
    inoremap [ []<ESC>i
    inoremap { {}<ESC>i

    map ` I// <ESC>
    map ~ A // <ESC>
  elseif &filetype == 'thrift'
    source ~/.vim/syntax/thrift.vim

    call setline(1,           "\// Copyright CodeFarmer Inc. All Rights Reserved.")
    call append(line("."),    "\// Author: aimerlee860@gmail.com(JingJie Li)")
    call append(line(".")+1,  "\// Created Time: ".strftime("%c"))

    " Auto close pair.
    inoremap ( ()<ESC>i
    inoremap [ []<ESC>i
    inoremap { {}<ESC>i

    map ` I// <ESC>
    map ~ A // <ESC>
  endif
endfunction
autocmd BufNewFile * normal G

autocmd BufRead,BufReadPre,BufReadPost,BufEnter *.cpp,*.[ch],*.cc,*.java,*.py,*.sh,*.proto,*.thrift,*.go exec ":call SmartComment()"
function! SmartComment()
  if &filetype == 'sh' || &filetype == 'python'
    set foldlevel=10
    map ` I# <ESC>
    map ~ A # <ESC>
  elseif &filetype == 'cpp' || &filetype == 'cc' || &filetype == 'c' || &filetype == 'java' || &filetype == 'go'
    map ` I// <ESC>
    map ~ A // <ESC>
  elseif &filetype == 'proto'
    source ~/.vim/syntax/proto.vim

    " Auto close pair.
    inoremap ( ()<ESC>i
    inoremap [ []<ESC>i
    inoremap { {}<ESC>i

    map ` I// <ESC>
    map ~ A // <ESC>
  elseif &filetype == 'thrift'
    source ~/.vim/syntax/thrift.vim

    " Auto close pair.
    inoremap ( ()<ESC>i
    inoremap [ []<ESC>i
    inoremap { {}<ESC>i

    map ` I// <ESC>
    map ~ A // <ESC>
  endif
endfunction

" Automatically format golang source code before writing to file
autocmd BufWritePre *.go Fmt
