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
  call <SID>fill('fillstruct', 'fillstruct: no struct literal found at selection')
endfunction

function! reftools#fillswitch()
  call <SID>fill('fillswitch', 'fillswitch: no switch statement found')
endfunction

function! s:checkcommand(command)
  if !executable(a:command)
    echom printf('reftools: Please install %s first use command `go get -u github.com/davidrjenni/reftools/cmd/%s`', a:command, a:command)
    return 0
  endif
  return 1
endfunction

function! s:fill(command, errmsg)
  if !<SID>checkcommand(a:command)
    return
  endif

  let file = expand('%:p')
  let line = line('.')
  silent let str = trim(system(printf('%s -file=%s -line=%d', a:command, file, line)))
  if str ==# a:errmsg
    echo str
    return
  endif

  let result = json_decode(str)[0]
  exec printf('goto %d', result.start+1)
  exec printf('normal %dxx', result.end-result.start-1)
  let curpos = getcurpos()
  call <SID>insert(result.code)
  call setpos('.', curpos)
endfunction

function! s:insert(text)
  let lines = split(a:text, '\n')
  exec printf('normal! a%s', lines[0])
  call append(line('.'), lines[1:])
  exec printf('normal %d==', len(lines))
endfunction

