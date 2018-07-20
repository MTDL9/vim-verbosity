

" Variable initialization
let s:verbosity_current_level = 9
let s:verbosity_current_file = ''
let s:verbosity_log_directory = ''

if exists('g:verbosity_default_level')
    let s:verbosity_current_level = g:verbosity_default_level
endif

if exists('g:verbosity_log_directory')
    let s:verbosity_log_directory = g:verbosity_log_directory

    if !isdirectory(s:verbosity_log_directory)
        call mkdir(s:verbosity_log_directory, 'p', 0700)
    endif
else
    let s:verbosity_log_directory = verbosity#getTemporaryDirectory()
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



function! verbosity#getTemporaryDirectory() abort
    let l:tmp_name = tempname()
    let l:dir_name = fnamemodify(l:tmp_name, ':h')
    return l:dir_name
endfunction

