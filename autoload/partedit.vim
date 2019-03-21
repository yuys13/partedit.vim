"=============================================================================
" FILE: partedit.vim
" AUTHOR:  yuys13 <yuys13@users.noreply.github.com>
" License: MIT license
"=============================================================================

function! partedit#start(ft) range
  let l:lines = getbufline(bufnr('%'), a:firstline, a:lastline)
  let l:filetype = a:ft !=# '' ? a:ft : &filetype

  let l:org_buf = bufnr('%')
  let l:org_filename = expand('%:t')

  let l:temp_file = tempname()
  call writefile(l:lines, l:temp_file)

  " create edit buffer
  silent execute g:partedit_bufopen . ' ' . temp_file
  set bufhidden=wipe
  silent execute 'setl filetype=' . l:filetype
  let b:partedit = {
        \ 'bufn': l:org_buf,
        \ 'filename': l:org_filename,
        \ 'firstline': a:firstline,
        \ 'lastline': a:lastline,
        \}

  autocmd PartEdit BufWritePost <buffer> call partedit#put()
endfunction

function! partedit#start_context()
  let l:con = PartEditGetContext()

  silent execute l:con.firstline . ',' . l:con.lastline .
        \ 'call partedit#start(''' . l:con.filetype . ''')'
endfunction

function! partedit#put()
  " get edit buffer info
  let l:pe = b:partedit
  let l:editbuf = bufnr('%')

  let winview = winsaveview()
  let new_lines = getbufline('%', 0, '$')

  " switch to the orginal buffer
  set bufhidden=hide
  silent execute 'buffer ' . l:pe.bufn
  " delete original lines
  call cursor(l:pe.firstline, 1)
  execute 'silent! '.(l:pe.lastline - l:pe.firstline + 1).'foldopen!'
  execute l:pe.firstline . ',' . l:pe.lastline . 'delete_'
  " write new lines
  call append(l:pe.firstline - 1, new_lines)
  " return edit buffer
  silent execute 'buffer ' . l:editbuf
  set bufhidden=wipe

  " update lastline
  let b:partedit.lastline = l:pe.firstline + len(new_lines) - 1

  call winrestview(winview)
endfunction

