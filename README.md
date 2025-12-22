# partedit.vim

`partedit.vim` is a Vim plugin that allows you to open a specific part of a
file in a temporary buffer for editing.
This is particularly useful for editing embedded code blocks (e.g., JavaScript
or CSS inside HTML) with proper filetype support.

## Features

- Extract a selected range into a separate buffer and reflect changes back to
  the original file.
- Changes are automatically synchronized to the original buffer when you save
  (`:w`) the temporary buffer.
- Integration with `context_filetype.vim` to automatically detect the filetype
  based on the cursor position.

## USAGE

### COMMANDS

:[range]PartEdit {filetype}

: Opens the specified `[range]` in a new buffer with the given `{filetype}`.
If `{filetype}` is omitted, the current buffer's filetype is used.

:PartEditContext

: Automatically detects the context at the current cursor position (e.g., an
embedded code block) and opens that range in a temporary buffer with the
appropriate filetype.

> [!NOTE]
> This command requires [Shougo/context_filetype.vim](https://github.com/Shougo/context_filetype.vim).

### MAPPINGS

No default mappings are provided. You can configure your own using the
following `<Plug>` mappings:

```vim
" Start PartEdit in visual mode or by providing a range
xmap <Leader>pe <Plug>(partedit_start)
nmap <Leader>pe <Plug>(partedit_start)

" Start PartEdit with automatic context detection
nmap <Leader>pc <Plug>(partedit_start_context)
```

## Configuration

### `g:partedit_bufopen`

Specifies the command used to open the temporary editing buffer.

- Default: `'rightbelow vertical new'`

```vim
let g:partedit_bufopen = 'vnew'
```

### `PartEditGetContext()`

You can customize how `PartEditContext` retrieves the context.
For example, to use it with
[osyo-manga/vim-precious](https://github.com/osyo-manga/vim-precious),
you can override this function in your `.vimrc`:

```vim
function! PartEditGetContext()
  let l:con = context_filetype#get(precious#base_filetype())
  return {
        \ 'filetype': l:con.filetype,
        \ 'firstline': l:con.range[0][0],
        \ 'lastline': l:con.range[1][0],
        \}
endfunction
```

## Installation

Using a plugin manager like [vim-plug](https://github.com/junegunn/vim-plug):

```vim
" Highly recommended for automatic context detection with :PartEditContext
Plug 'Shougo/context_filetype.vim'
Plug 'yuys13/partedit.vim'
```

## License

[MIT License](./LICENSE)
