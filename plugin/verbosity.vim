

" Enable verbose mode printing output on a file
function! verbosity#enable(...) abort
    if v:count > 0
        let l:verbosity_level = v:count
    elseif a:0 > 0
        let l:verbosity_level = a:1
    else
        let l:verbosity_level = s:verbosity_current_level
    endif

    let s:verbosity_current_level = l:verbosity_level
    let s:verbosity_current_file = verbosity#getNewFileName()
    let &verbosefile = s:verbosity_current_file
    let &verbose = l:verbosity_level
endfunction


" Disable verbose mode
function! verbosity#disable() abort
    let &verbose = 0
    let &verbosefile = ''
endfunction


" Open the current verbosity log file
function! verbosity#open() abort
    execute 'edit ' . s:verbosity_current_file
endfunction


function! verbosity#getTemporaryDirectory() abort
    let l:tmp_name = tempname()
    let l:dir_name = fnamemodify(l:tmp_name, ':h')
    return l:dir_name
endfunction

function! verbosity#getNewFileName() abort
    return s:verbosity_log_directory . '/vim-verbosity.log'
endfunction



" Variable definitions
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

