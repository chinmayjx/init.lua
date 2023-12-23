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

inoremap <C-Del> <C-o>dw
inoremap <C-h> <C-w>
inoremap <M-u> <C-o>u
inoremap <Home> <C-o>^
inoremap <C-s> <C-o>:w<CR>
nnoremap <C-s> :w<CR>
nnoremap ,x :bd<CR>

nnoremap <M-left> <C-w><left>
nnoremap <M-right> <C-w><right>
nnoremap <M-down> <C-w><down>
nnoremap <M-up> <C-w><up>

tnoremap <M-e> <C-\><C-n>
tnoremap <M-up> <C-\><C-n><C-w><up>
tnoremap <M-down> <C-\><C-n><C-w><down>
tnoremap <M-left> <C-\><C-n><C-w><left>
tnoremap <M-right> <C-\><C-n><C-w><right>

nnoremap <Leader>`n :e ~/.config/nvim/init.lua<CR>
nnoremap <Leader>`s :w \| source ~/.config/nvim/init.lua<CR>
nnoremap <Leader>`t :e ~/.config/nvim/snippets/

" store n{j,k} in jumplist
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

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

function s:CJFileTypeInit()
	let x = expand('%:e')
  if x == "md"
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

function s:CJWinEnterSetup()
	if bufname(winbufnr(0))[:6] == "term://"
		startinsert
  endif
endfunction

function s:CJTermSetup()
  setlocal nonumber norelativenumber
  setlocal winfixheight
endfunction

function s:CJCmdwinEnterSetup()
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
