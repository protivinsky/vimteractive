"Vimteractive
"
" A vim plugin to send line(s) from the current buffer to a terminal bufffer
"
"  author : Will Handley <williamjameshandley@cam.ac.uk>
"    date : 2018-06-20
" licence : GPL 3.0

" Plugin variables
" ================

" The name of the vimteractive terminal buffer
let g:vimteractive_buffer_name = "Vimteractive"

" User commands
" =============

" Commands to start a session
command!  Iipython :call Vimteractive_session('ipython --simple-prompt') 
command!  Ipython  :call Vimteractive_session('python')  
command!  Ibash    :call Vimteractive_session('bash')
command!  Imaple   :call Vimteractive_session('maple -c "interface(errorcursor=false);"')

" Control-S in normal mode to send current line
noremap  <silent> <C-s>      :call Vimteractive_send(getline('.')."\n")<CR>

" Control-S in insert mode to send current line
inoremap <silent> <C-s> <Esc>:call Vimteractive_send(getline('.')."\n")<CR>a

" Control-S in visual mode to send multiple lines
vnoremap <silent> <C-s> <Esc>:call Vimteractive_send(getreg('*'))<CR>



" Plugin commands
" ===============

" Send a general command to the terminal buffer
function! Vimteractive_send(expr)
    call term_sendkeys(g:vimteractive_buffer_name, a:expr)
endfunction

" Start a vimteractive session
function! Vimteractive_session(terminal)
    if has('terminal') 
        if bufnr(g:vimteractive_buffer_name) == -1
            " If no vimteractive buffer exists:
            " Start the terminal
            let job = term_start(a:terminal, {"term_name":g:vimteractive_buffer_name})
            " Unlist the buffer
            set nobuflisted
            " Return to the previous window
            wincmd p
        elseif bufwinnr(g:vimteractive_buffer_name) == -1
            " Else if vimteractive buffer not open:
            " Split the window
            split
            " switch the top window to the vimteractive buffer
            execute ":b " . g:vimteractive_buffer_name
            " Return to the previous window
            wincmd p
        else
            " Else if throw error
            echoerr "vimteractive already open. Quit before opening a new buffer"
        endif
    else
        echoerr "Your version of vim is not compiled with +terminal. Cannot use vimteractive"
    endif
endfunction


" Plugin Behaviour
" ================

" Switch to normal mode when entering terminal window
autocmd BufEnter * if &buftype == 'terminal' | call feedkeys("\<C-W>N")  | endif

" Switch back to terminal mode when exiting
autocmd BufLeave * if &buftype == 'terminal' | silent! normal! i  | endif
