function g:CJtrailingNum(s)
	let i=len(a:s)-1
	let n=0
	let p=1
	while i>=0 && a:s[i]>='0' && a:s[i]<='9'
		let n=str2nr(a:s[i])*p+n
		let p=p*10
		let i=i-1
	endwhile

	return [a:s[:i],n]
endfunction

function g:CJnextFileNo()
	let x=g:CJtrailingNum(expand("%:p:r"))
	:execute "e " . x[0] . (x[1]+1) . "." . expand("%:e")
endfunction

nnoremap <Leader>ne :enew<CR>
nnoremap <Leader>nn :call g:CJnextFileNo()<CR>

runtime ftplugin/man.vim
command! -nargs=1 EditReg call feedkeys(":let @" . <f-args> . "='" . execute("echo @" . <f-args> )[1:] . "'")
nnoremap <Leader>@ :EditReg 

nnoremap <Leader>sa gg0vG$
nnoremap ,, ,
nnoremap ,q :qa<CR>
nnoremap ,q :qa<CR>
nnoremap ,d *Ncgn
nnoremap ,h :%s//\0/g<left><left><left><left><left>
vnoremap ,l :s//\0/g<left><left><left><left><left>
vnoremap ,h "hy:let @h=escape(@h,'\\/')<CR>:%s/\M<C-r>h/\0/g<left><left><space><backspace>
vnoremap ,D "sy:let @/='\V'.escape(@s, '\\')<CR>cgn
vnoremap <Leader>d y`]p

nnoremap t<F4> gT
nnoremap t<F5> <C-w>T
nnoremap <F4>c :tabnew<CR>
nnoremap <F4>x :tabc<CR>


vnoremap <Leader>( "sdi(<C-r>s)
vnoremap <Leader>[ "sdi[<C-r>s]
vnoremap <Leader>{ "sdi{<C-r>s}

inoremap <C-Del> <C-o>dw
inoremap <C-h> <C-w>
inoremap <C-v> <C-r>"
inoremap <M-u> <C-o>u
inoremap <Home> <C-o>^
inoremap <C-s> <C-o>:w<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-S-right> :bn<CR>
nnoremap <C-S-left> :bp<CR>
nnoremap ,x :bd<CR>

function s:deleteCurrentBuffer()
  let b=winbufnr(0)
  let cw=win_getid()
  if getbufinfo(b)[0].changed
    echom 'unsaved changes'
    return
  endif
  let wins = win_findbuf(b)
  for w in wins
    call win_gotoid(w)
    bp
  endfor
  exec 'bd' . b
  call win_gotoid(cw)
endfunction
" nnoremap <Leader>x :call <SID>deleteCurrentBuffer()<CR>

nnoremap <M-h> <C-w><left>
nnoremap <M-l> <C-w><right>
nnoremap <M-j> <C-w><down>
nnoremap <M-k> <C-w><up>
nnoremap <M-S-j> :sp<CR>
nnoremap <M-S-l> :vs<CR>

tnoremap <M-e> <C-\><C-n>
tnoremap <M-k> <C-\><C-n><C-w><up>
tnoremap <M-j> <C-\><C-n><C-w><down>
tnoremap <M-h> <C-\><C-n><C-w><left>
tnoremap <M-l> <C-\><C-n><C-w><right>



set expandtab
set number relativenumber
set mouse=a
set tabstop=2
set shiftwidth=2
set termguicolors
set splitbelow
set splitright
set notimeout
set ww=<,>,[,],b,s

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set wildignore=*/node_modules/*,*/__pycache__/*

nnoremap <Leader>`n :e ~/.config/nvim/init.lua<CR>
nnoremap <Leader>`s :w \| source ~/.config/nvim/init.lua<CR>
nnoremap <Leader>`t :e ~/.config/nvim/snippets/

function s:copyFromFile(fnm)
  silent exec ":silent w | silent !cp " . a:fnm . " %"
endfunction

function s:loadTemplate()
  let x=expand("%:e")
  if x == "cpp" && getcwd() == expand('~/documents/dsal')
    call s:copyFromFile("~/github/dsal/c.cpp")
  elseif x == "java"
    silent exec ":w | !cat ~/templates/java.java | sed 's/java/%:t:r/' > %"
  else
    call s:copyFromFile("~/templates/" . x . "." . x)
  endif
endfunction

nnoremap <silent> <Leader>tm :call <SID>loadTemplate()<CR>

let $BASH_ENV = '~/github/configs/bash.bash'

inoremap <space> <C-g>u<space>
let undoBreakers = split(",.=+-*/:_#@",'\zs')
for ub in undoBreakers
  exec "inoremap " . ub . " <C-g>u" . ub
endfor

function s:InsertTime()
  let @t = trim(system('date +\%I:\%M\%p'))
endfunction

function s:toggleCheckBox()
  let cases = [ ' ', 'x', ' '] " extra space to help cycling
  exec 'keeppatterns s#^\s*- \[\zs['.join(cases,'').']\ze\]#\=cases[index(cases, submatch(0))+1]#'
endfunction

function s:checkboxSetup()
  nnoremap <buffer> <M-a> :call <SID>toggleCheckBox()<CR>
endfunction

function s:CJFileTypeInit()
  " let autoClose = "()[]{}"
	" let autoCloseSolo = "`"
	let b:CJCommentChar = '#'
	let x = expand('%:e')
	if index(["c","cpp","java","js","jsx","ts","tsx","h"],x) >= 0
		let b:CJCommentChar = '\/\/'
	elseif x == "vim"
		let b:CJCommentChar = '"'
	elseif x == "lua"
		let b:CJCommentChar = '--'
	elseif x == "tex"
		let b:CJCommentChar = '%'
    let autoCloseSolo=autoCloseSolo . "$"
    nmap <buffer> ,co vie:s/  / /g<CR><C-l>gv<
  elseif x == "md"
    call s:checkboxSetup()
    inoremap <buffer><M-i> **<left>
    inoremap <buffer><F4>3 ###<space>
    inoremap <buffer><F4>4 ####<space>
    inoremap <buffer><F4>5 #####<space>
    inoremap <buffer><F4>6 ######<space>
		nnoremap <buffer> <M-w> :exec 'Toch' \| call <SID>CJWinEnterSetup()<CR>
		inoremap <buffer><silent> <M-t> <esc>:call <SID>InsertTime()<CR>a<C-r>t
		nnoremap <buffer> ,tt :TableFormat<CR>
		vnoremap <buffer> ., :s/^##/#/<CR>:noh<CR>gv
		vnoremap <buffer> ,. :s/^#/##/<CR>:noh<CR>gv
  elseif x == "man"
    set filetype=man
	endif

  let spellCheckTypes = ["md","tex"]
  if index(spellCheckTypes, x) >= 0
    setlocal spell
    inoremap <buffer> <M-s> <Esc>[s1z=ga
  endif
endfunction

nnoremap <silent><expr> ,/ match(getline("."),"^\\s*" . b:CJCommentChar) == -1 ? ':exec "s/^\\(\\s*\\)/\\1" . b:CJCommentChar . " /" \| noh<CR>j' : ':exec "s/^\\(\\s*\\)" . b:CJCommentChar . " /\\1/" \| noh<CR>'
vnoremap <silent><expr> ,/ match(getline("."),"^\\s*" . b:CJCommentChar) == -1 ? '<esc>:exec "'."'".'<,'."'".'>s/^\\(\\s*\\)/\\1" . b:CJCommentChar . " /" \| noh<CR>' : '<esc>:exec "'."'".'<,'."'".'>s/^\\(\\s*\\)" . b:CJCommentChar . " /\\1/" \| noh<CR>'

let g:CJIsInsert = 1
function g:CJpaste(s)
  let @y=a:s
  call feedkeys('"yp'  . (g:CJIsInsert?'a':''))
  let g:CJIsInsert=0
endfunction
function g:CJClipboardItems()
  let clip = [trim(execute("echo @\""))]
  for i in range(10)
    let tmp = trim(execute("echo @" . i))
    if !empty(tmp)
      call add(clip,tmp)
    endif
  endfor
  call add(clip,trim(execute("echo @:")))
  call add(clip,trim(execute("echo @/")))
  return clip
endfunction

function s:closeUselessBuffers()
	for b in filter(range(1,bufnr('$')), 'bufexists(v:val)')
    let bi = getbufinfo(b)[0]
		let nm = bi.name
		if nm[:6] == "term://" || (empty(nm) && bi.changed == 0)
			silent! exec "bd! " . b
		endif
	endfor
endfunction
nnoremap ,k :call <SID>closeUselessBuffers()<CR>

function s:CJWinEnterSetup()
	if bufname(winbufnr(0))[:6] == "term://"
		startinsert
  elseif win_gettype() == "quickfix" || win_gettype() == "loclist"
    noremap <buffer> <CR> <CR>
	endif
endfunction

function s:CJTermSetup()
  setlocal nonumber norelativenumber
  setlocal winfixheight
endfunction

function s:CJCmdwinEnterSetup()
	noremap <buffer> <CR> <CR>
	inoremap <buffer> <CR> <CR>
	map <buffer> <F5> <CR>q:
endfunction

augroup CJaucmd
	autocmd!
	autocmd BufReadPre * call s:CJFileTypeInit()
	autocmd BufNewFile * call s:CJFileTypeInit()
	autocmd TermOpen * call s:CJTermSetup()
	autocmd WinEnter * call s:CJWinEnterSetup()
	autocmd WinNew * call s:CJWinEnterSetup()
	autocmd CmdwinEnter * call s:CJCmdwinEnterSetup()
augroup END
