nnoremap <leader>r :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>r :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[y`]
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
	redraw!
    copen 23

    let @@ = saved_unnamed_register
endfunction
