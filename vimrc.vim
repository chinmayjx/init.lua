function g:CJIndex(ls,x)
	let i = 0
	while i<len(a:ls)
		if a:ls[i] == a:x
			return i
		endif
		let i = i+1
	endwhile
	return -1
endfunction

function g:CJLastIndex(ls,x)
	let i = len(a:ls) - 1
	while i>=0
		if a:ls[i] == a:x
			return i
		endif
		let i = i-1
	endwhile
	return -1
endfunction

function g:CJFindVimsesh(pth)
	let p = a:pth 
	while 1
		if filereadable(p . "/.sesh.vim")
			return p
		endif
		let li = g:CJLastIndex(p,'/')
		if li<=0
			break
		endif
		let p = p[:li-1] 
	endwhile
	return ""
endfunction

function g:CJIsWelcomeScreen()
	return len(filter(range(1, bufnr('$')), 'bufexists(v:val) && !empty(getbufinfo(v:val)[0].name)')) == 0
endfunction

function g:CJInitializeSession(p)
  let g:CJWinBuffs = {}
  let g:CJLoadedSeshName = ''
  silent exec "source " . a:p . "/.sesh.vim"
  let tmp = {}
  for k in keys(g:CJWinBuffs)
    let tmp[win_getid(k)] = g:CJWinBuffs[k]
  endfor
  let g:CJWinBuffs = tmp
endfunction

function g:CJLoadNearestSesh(prompt=1)
	if exists('g:CJLoadedSeshName') && !empty(g:CJLoadedSeshName)
		echoerr "you're already doing sesh in: " . g:CJLoadedSeshName
		return 
	endif
	let p = g:CJFindVimsesh(getcwd())
	if empty(p)
		echoerr "no sesh found"
		return
	endif
	if a:prompt == 1
		call inputsave()	
		let x = input("load: " . p . " (y/n) ? ", "y")
		call inputrestore()
	endif
	if a:prompt != 1 || x == "y"
    call g:CJInitializeSession(p)
	endif
endfunction

function g:CJSaveVimsesh()
	if !exists('g:CJLoadedSeshName') || empty(g:CJLoadedSeshName)
		call inputsave()	
		let sf = input("dir: ", getcwd())
		call inputrestore()	
		if empty(sf)
			return
		endif
		if sf[-1:] == "/"
			let sf = sf[:-2]
		endif
		let g:CJLoadedSeshName = sf
	else
		let sf = g:CJLoadedSeshName
	endif
	silent exec "!echo " . sf . " >> ~/.vimprojects"
  :NvimTreeClose
  let tmp = {}
  for k in keys(g:CJWinBuffs)
    let  tmp[win_id2win(k)] = g:CJWinBuffs[k]
  endfor
	silent exec "mks! " . sf . "/.sesh.vim"
	silent exec "!echo \"let g:CJWinBuffs = " . escape(string(tmp), "\\") . "\" >> " . sf . "/.sesh.vim"
	silent exec "!echo \"let g:CJLoadedSeshName = '" . sf . "'\" >> " . sf . "/.sesh.vim"
endfunction


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

command! -nargs=? LoadSesh call g:CJLoadNearestSesh(<f-args>)
command! SaveSesh call g:CJSaveVimsesh()


runtime ftplugin/man.vim
nnoremap <Leader>= <C-w>=
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>p "0p
nnoremap <Leader>P "0P
nnoremap <Leader>oh :vert help 
nnoremap <Leader>om :vert Man 
nnoremap <Leader><F4> :call g:CJSaveVimsesh() \| qa<CR>
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
inoremap <M-z> <C-o>u
inoremap <M-Z> <C-o><C-r>
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
nnoremap <Leader>x :call <SID>deleteCurrentBuffer()<CR>

nnoremap <M-h> <C-w><left>
nnoremap <M-l> <C-w><right>
nnoremap <M-j> <C-w><down>
nnoremap <M-k> <C-w><up>
nnoremap <M-S-j> :sp<CR>
nnoremap <M-S-l> :vs<CR>

tnoremap <M-x> <C-\><C-n>
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

function g:CJrunInTerm(cmd)
	let term_height = 15
	let pre = term_height . "sp "
	if str2float(&lines)/&columns < 0.3
		let pre = "vs "
	endif
	exec  pre . "term://" . a:cmd . " | startinsert"
endfunction

function g:CJrun()
	let run_cmd_fn = ".run_cmd"
	if file_readable(run_cmd_fn)
		:w
		call g:CJrunInTerm('source ' . run_cmd_fn)
		return
	endif

	let CJhome = expand("~")
	let x = expand('%:e')
	let fbn = expand('%:t:r')
	let fn = expand('%:t')
	let owd = getcwd()
	let wd = expand('%:h')
	exec "w | cd " . wd
	if index(["c","cpp"],x) >= 0
		if getcwd() == CJhome . '/documents/dsal'
			call g:CJrunInTerm("./run " . fbn)
		else
			call g:CJrunInTerm("g++ -o " . fbn . " " .  fn . "; ./" . fbn)
		endif
	elseif index(["js","mjs"],x) >= 0
		call g:CJrunInTerm("node " . fn)
	elseif index(["sh","bash"],x) >= 0
		call g:CJrunInTerm("bash " . fn)
	elseif x == "py"
		call g:CJrunInTerm("python3 " . fn)
	elseif x == "ts"
		call g:CJrunInTerm("npx ts-node " . fn)
	elseif x == "rs"
			call g:CJrunInTerm("rustc -o " . fbn . " " .  fn . "; ./" . fbn)
	elseif x == "java"
		call g:CJrunInTerm("javac " . fn . " && java " . fbn)
	elseif x == "lua"
		call g:CJrunInTerm("lua " . fn)
	elseif x == "sha256"
		exec 'w !tr -d "\\n" | sha256sum'
	elseif fn == "termux.properties"
		w | !termux-reload-settings
	elseif x == "curl"
		:w | w !python3 ~/github/python/curl.py
	elseif x == "sql"
    call g:CJrunInTerm('sqlite3 -init ' . fbn . '.sql ' . fbn . '.db')
	elseif x == "tex"
		:w | VimtexCompile
	endif
	exec "cd " . owd
endfunction

noremap <M-b> :call g:CJrun()<CR>
inoremap <M-b> <C-o>:call g:CJrun()<CR>

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

" inoremap <expr>" ("<C-g>u" . (getline(".")[col(".")-1] == "\"" ? "<right>" : "\"\"<left>"))
" inoremap <expr>' ("<C-g>u" . (getline(".")[col(".")-1] == "'" ? "<right>" : (match(getline(".")[col(".")-2], '\w') >= 0 ? "'" : "''<left>")))

inoremap <space> <C-g>u<space>
let undoBreakers = split(",.=+-*/:_#@",'\zs')
for ub in undoBreakers
  exec "inoremap " . ub . " <C-g>u" . ub
endfor

function s:InsertTime()
  let @t = trim(system('date +\%I:\%M\%p'))
endfunction

function s:toggleCheckBox()
  " let states = ["y", "x"]
  " for i in range(0, len(states)-1)
    " let status = execute('keeppatterns s/\(-\s*\)\[' . states[i] . '\]/\1[' . states[(i+1)%len(states)] . ']/')
    " if status==0
      " break
    " endif
    " echom i . status
  " endfor
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
	if index(["c","cpp","java","js","ts","h"],x) >= 0
		let b:CJCommentChar = '\/\/'
	elseif x == "vim"
		let b:CJCommentChar = '"'
	elseif x == "lua"
		let b:CJCommentChar = '--'
	elseif x == "tex"
		let b:CJCommentChar = '%'
    let autoCloseSolo=autoCloseSolo . "$"
		nnoremap <buffer><silent> ,. :VimtexView<CR>
		nnoremap <buffer><silent> <M-w> :VimtexTocToggle<CR>
		nnoremap <buffer><silent> ,er :VimtexErrors<CR>
    nmap <buffer> ,co vie:s/  / /g<CR><C-l>gv<
  elseif x == "md"
    call s:checkboxSetup()
    inoremap <buffer><M-i> __<left>
    inoremap <buffer><F4>3 ###<space>
    inoremap <buffer><F4>4 ####<space>
    inoremap <buffer><F4>5 #####<space>
    inoremap <buffer><F4>6 ######<space>
		nnoremap <buffer> <M-w> :exec 'Toch' \| call <SID>CJWinEnterSetup()<CR>
		inoremap <buffer><silent> <M-t> <esc>:call <SID>InsertTime()<CR>a<C-r>t
		nnoremap <buffer> ,tt :TableFormat<CR>
		vnoremap <buffer> ., :s/^##/#/<CR>:noh<CR>gv
		vnoremap <buffer> ,. :s/^#/##/<CR>:noh<CR>gv
	endif

  " for i in range(0,len(autoClose)-1,2)
    " let c1=":inoremap <buffer> " . autoClose[i] . " <C-g>u" . autoClose[i] . autoClose[i+1] . "<left>"
    " let c2=':inoremap <buffer> <expr>' . autoClose[i+1] . ' getline(".")[col(".")-1] == "' . autoClose[i+1] . '"' . ' ? "<right>" : "' . autoClose[i+1] . '"'
    " call execute(c1)
    " call execute(c2)
  " endfor
  " for i in range(0,len(autoCloseSolo)-1)
    " let c1='inoremap <buffer> <expr>' . autoCloseSolo[i] . ' getline(".")[col(".")-1] == "' . autoCloseSolo[i] . '" ? "<right>" : "' . autoCloseSolo[i] .  autoCloseSolo[i] . '<left>"'
		" call execute(c1)
  " endfor

  let spellCheckTypes = ["md","tex"]
  if index(spellCheckTypes, x) >= 0
    setlocal spell
    inoremap <buffer> <M-s> <Esc>[s1z=ga
  endif
endfunction

nnoremap <silent><expr> ,/ match(getline("."),"^\\s*" . b:CJCommentChar) == -1 ? ':exec "s/^\\(\\s*\\)/\\1" . b:CJCommentChar . " /" \| noh<CR>j' : ':exec "s/^\\(\\s*\\)" . b:CJCommentChar . " /\\1/" \| noh<CR>'
vnoremap <silent><expr> ,/ match(getline("."),"^\\s*" . b:CJCommentChar) == -1 ? '<esc>:exec "'."'".'<,'."'".'>s/^\\(\\s*\\)/\\1" . b:CJCommentChar . " /" \| noh<CR>' : '<esc>:exec "'."'".'<,'."'".'>s/^\\(\\s*\\)" . b:CJCommentChar . " /\\1/" \| noh<CR>'

function g:CJOptimizeProjectHistoryFile()
	let ls = readfile(expand('~/.vimprojects'))
	echom ls
endfunction

function g:CJGetProjects()
	let ls = reverse(readfile(expand('~/.vimprojects')))
	let tmp = {}
	let fil = []
	for p in ls
		if !has_key(tmp, p)
			let tmp[p] = 1
			call add(fil, p)
		endif
	endfor
	call writefile(reverse(fil), expand('~/.vimprojects'))
	call reverse(fil)
	for i in range(len(fil))
		let tail = ""
		let j=len(fil[i])-1
		while j>=0 && fil[i][j]!='/'
			let tail = fil[i][j] . tail
			let j=j-1
		endwhile
		let fil[i] = tail . "::" . fil[i][:j]
	endfor
	return fil
endfunction
 
function g:CJProjectSelect(p)
	let sel = a:p
	let i = g:CJIndex(sel, ':')
	let sel = sel[i+2:] . sel[:i-1]
	if g:CJIsWelcomeScreen() != 1
		if len(filter(range(1, bufnr('$')), 'bufexists(v:val) && getbufinfo(v:val)[0].changed')) > 0
			echoerr "save all buffers first"
			return 
		endif
		if !exists('g:CJLoadedSeshName') || empty(g:CJLoadedSeshName)
			call inputsave()	
			let x = input("project won't be saved, continue? (y/n/s): ", "y")
			call inputrestore()	
			if x == "s"
				call g:CJSaveVimsesh()
			elseif x != "y"
				return
			endif
		else
			call g:CJSaveVimsesh()
		endif
	endif
	silent bufdo bw!
  call feedkeys(':call g:CJInitializeSession("' . sel . "\")\<CR>")
endfunction

if !exists("g:CJWinBuffs")
	let g:CJWinBuffs = {}
endif

function g:CJAllBuffNames()
	let bf = []
	for bid in filter(range(1, bufnr('$')), 'bufexists(v:val) && buflisted(v:val)')
		let nm=bufname(bid)
		if empty(nm)
			let nm=bid
		endif
		call add(bf, nm)
	endfor
	return bf
endfunction

function g:CJUpdateWinBuffs()
	if win_gettype() == "popup"
		return
	endif
	let win_id = win_getid() 
	let buf_id = winbufnr(win_getid())
	let buf_nm = bufname(buf_id)
	if empty(buf_nm)
		let buf_nm=buf_id
	endif
	if has_key(g:CJWinBuffs, win_id) == 0
		let g:CJWinBuffs[win_id] = []
	endif
	if len(g:CJWinBuffs[win_id]) > 0 && g:CJWinBuffs[win_id][0] == buf_nm
		return
	endif
	call insert(g:CJWinBuffs[win_id], buf_nm, 0)
endfunction

function g:CJBuffSelect(arg)
	let arc = a:arg
	let i = g:CJIndex(arc, ':')
	if i>0
		let arc = arc[i+2:] . arc[:i-1]
	endif
	execute("b " . arc)
endfunction

function g:CJBuffs()
	let win_id = win_getid()
	let tmp = {}
	let fil = []
	if !has_key(g:CJWinBuffs, win_id)
		let g:CJWinBuffs[win_id] = []
	endif
	call extend(g:CJWinBuffs[win_id], g:CJAllBuffNames())
	for buf in g:CJWinBuffs[win_id]
		let bid = bufnr(buf)
		if !has_key(tmp, bid)
			call add(fil, buf)
			let tmp[bid] = 1
		endif
	endfor
	let g:CJWinBuffs[win_id] = deepcopy(fil)
	for i in range(len(fil))
		let tail = ""
		let j=len(fil[i])-1
		while j>=0 && fil[i][j]!='/'
			let tail = fil[i][j] . tail
			let j=j-1
		endwhile
		let fil[i] = tail . (j > 0 ? "::" . fil[i][:j] : "")
	endfor
  return fil[1:]
	" call fzf#run({'source': fil, 'sink': function('g:CJBuffSelect'), 'options': "--header-lines 1 ", 'window': {'relative': 1, 'width': 0.8, 'height': 0.4, 'xoffset': 0.5, 'yoffset': 0}})
endfunction

nnoremap <silent> <CR> :call g:CJBuffs()<CR>

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

function s:saveAction()
	let x=expand('%:e')
endfunction

augroup CJaucmd
	autocmd!
	autocmd BufWrite * call s:saveAction()
	autocmd BufEnter * call g:CJUpdateWinBuffs()
	autocmd WinEnter * call g:CJUpdateWinBuffs()
	autocmd BufReadPre * call s:CJFileTypeInit()
	autocmd BufNewFile * call s:CJFileTypeInit()
	autocmd TermOpen * call s:CJTermSetup()
	autocmd WinEnter * call s:CJWinEnterSetup()
	autocmd CmdwinEnter * call s:CJCmdwinEnterSetup()
augroup END

