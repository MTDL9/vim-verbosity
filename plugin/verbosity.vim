

" Variable initialization
let s:verbosity_current_level = 9
let s:verbosity_current_file = ''

if exists('g:verbosity_default_level')
    let s:verbosity_current_level = g:verbosity_default_level
endif


" Enable verbose mode printing output on a file
function! verbosity#enable(...) abort
    if a:0 > 0
        let l:verbosity_level = a:1
        let s:verbosity_current_level = l:verbosity_level
    else
        let l:verbosity_level = s:verbosity_current_level
    endif

    if has('unix')
        let l:filepath = '/tmp/'
    else
        let l:filepath = 'C:\Temp\'
    endif

    let &verbosefile = l:filepath . '/vim-verbosity.log'
    let &verbose = l:verbosity_level
endfunction




