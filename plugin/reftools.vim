"==============================================================
"    file: reftools.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2019-11-15 17:15:07
"==============================================================

command! Fixplurals call reftools#fixplurals()
command! Fillstruct call reftools#fillstruct()
command! Fillswitch call reftools#fillswitch()

nnoremap <silent> <Plug>(reftools#fixplurals) :<c-u>Fixplurals<cr>
nnoremap <silent> <Plug>(reftools#fillstruct) :<c-u>Fillstruct<cr>
nnoremap <silent> <Plug>(reftools#fillswitch) :<c-u>Fillswitch<cr>
