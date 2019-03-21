"=============================================================================
" FILE: partedit.vim
" AUTHOR:  yuys13 <yuys13@users.noreply.github.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_partedit')
  finish
endif
let g:loaded_partedit = 1

augroup PartEdit
  autocmd!
augroup END

if !exists('g:partedit_bufopen')
  let g:partedit_bufopen = 'rightbelow vertical new'
endif

if !exists('*PartEditGetContext')
  " PartEditGetContext return filetype, firstline and lastline.
  " This function use context_filetype#get().
  " If you use osyo-manga/vim-precious, overwrite this function in your .vimrc.
  " ex.)
  "  function! PartEditGetContext()
  "    let l:con = context_filetype#get(precious#base_filetype())
  "    let l:ret = {
  "          \ 'filetype': l:con.filetype,
  "          \ 'firstline': l:con.range[0][0],
  "          \ 'lastline': l:con.range[1][0],
  "          \}
  "    return l:ret
  "  endfunction
  function PartEditGetContext()
    " check context_filetype.vim
    if !context_filetype#version()
      echomsg 'PartEditContext depends Shougo/context_filetype.vim'
      return
    endif
    " get context
    let l:con = context_filetype#get()
    let l:ret = {
          \ 'filetype': l:con.filetype,
          \ 'firstline': l:con.range[0][0],
          \ 'lastline': l:con.range[1][0],
          \}
    return l:ret
  endfunction
endif

command! -range -nargs=? -complete=filetype PartEdit
      \ <line1>,<line2>call partedit#start(<q-args>)

command! PartEditContext
      \ call partedit#start_context()

nnoremap <silent> <Plug>(partedit_start) :PartEdit<CR>
xnoremap <silent> <Plug>(partedit_start) :PartEdit<CR>

nnoremap <silent> <Plug>(partedit_start_context) :<C-u>PartEditContext<CR>

