"==============================================================
"    file: reftools.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2019-11-15 19:27:12
"==============================================================

function! reftools#fixplurals()
  if !<SID>checkcommand('fixplurals')
    return
  endif
  wa
  let curdir = getcwd()
  let filedir = expand('%:p:h')
  exec printf('cd %s', filedir)
  call system('fixplurals .')
  e!
  exec printf('cd %s', curdir)
endfunction

function! reftools#fillstruct()
  call <SID>fill('fillstruct')
endfunction

function! reftools#fillswitch()
  call <SID>fill('fillswitch')
endfunction

function! s:checkcommand(command)
  if !executable(a:command)
    echom printf('reftools: Please install %s first use command `go get -u github.com/davidrjenni/reftools/cmd/%s`', a:command, a:command)
    return 0
  endif
  return 1
endfunction

function! s:fill(command)
  if !<SID>checkcommand(a:command)
    return
  endif
  wa

  let file = expand('%:p')
  let line = line('.')
  let str = trim(system(printf('%s -file=%s -line=%d 2>/dev/null', a:command, file, line)))
  if str ==# ''
    echom printf('reftools: %s no result', a:command)
    return
  endif

  let json = json_decode(str)
  if len(json) == 0
    echom printf('reftools: %s no result', a:command)
    return
  endif

  let result = json[0]
  let curpos = getcurpos()
  exec printf('goto %d', result.start+1)
  exec printf('normal! %ds%s', result.end-result.start, result.code)
  call <SID>format(result.code, curpos)
  call setpos('.', curpos)
endfunction

function! s:format(text, lastpos)
  let lines = split(a:text, '\n')
  if len(lines) > 1 
    call setpos('.', a:lastpos)
    exec printf('normal j%d==', len(lines)-1)
  endif
endfunction

