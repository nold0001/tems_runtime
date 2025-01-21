"-----------------------------------------------------------------------"
" Vundle 환경설정
"------------------------------------------------------------------------"
filetype off                   " required!
set shell=/bin/bash
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	" let Vundle manage Vundle
	" required! 
	Plugin 'VundleVim/Vundle.vim'

	" vim 하단에 파일 정보 띄우기
	Plugin 'vim-airline/vim-airline' 
	Plugin 'vim-airline/vim-airline-themes'
	" ...

	Plugin 'tpope/vim-fugitive'
call vundle#end()
filetype plugin indent on     " required!
	"
	" Brief help
	" :BundleList          - list configured bundles
	" :BundleInstall(!)    - install(update) bundles
	" :BundleSearch(!) foo - search(or refresh cache first) for foo
	" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
	"
	" see :h vundle for more details or wiki for FAQ
	" NOTE: comments after Bundle command are not allowed..


set tabstop=4		"Tab 을 눌렀을때 4칸 이동한다.
set	shiftwidth=4	"자동 들여쓰기를 할 때 4칸 들여 쓰도록 한다.
set	showmatch		"매치되는 괄호의 반대쪽을 보여준다.
set	title			"타이틀바에 현재 편집중인 파일을 표시한다.
set	autoindent		"자동으로 들여쓰기를 한다.
set	cindent			"C 프로그래밍을 할 때 자동으로 들여쓰기를 한다.
set	smartindent		"좀 더 똑똑한 들여쓰기를 위한 옵션이다.
set hlsearch		"검색어 강조기능을 사용한다.
"set	ignorecase		"찾기에서 대/소문자를 구별하지 않는다.
set number
set path=.,~/develop/inc,~/develop/inc/db,~/develop/inc/proto,/usr/include,/usr/local/include,/usr/include/i386-linux-gnu,/usr/include/x86_64-linux-gnu
set tags=./tags,~/.vim/tags

cs add ~/.vim/cscope.out
set cst

" if has('multi_byte_ime') 
highlight Cursor guibg=green guifg=NONE " 영문 
highlight CursorIM guibg=Yellow guifg=NONE " 한글
" endif

filetype plugin indent on

syntax enable
"let g:solarized_termcolors=256
set background=dark
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
let g:solarized_termtrans = 1
colorscheme solarized
"colorscheme delek	 " blue darkblue delek desert elflord evening industry koehler morning murphy pablo peachpuff ron shine slate torte zellner

imap fh <Esc>

set fileencodings=utf-8,euc-kr


