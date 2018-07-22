"--------------------------------------------------------------------------
" Verbosity
" VIM Plugin for toggling verbose mode and viewing the output
"--------------------------------------------------------------------------

" Functions
"--------------------------------------------------------------------------
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
    let l:date_time = strftime('%Y%m%d-%H%M%S')
    return s:verbosity_log_directory . '/vim-verbosity-' . l:date_time . '.log'
endfunction




function! verbosity#getDefaultLogLevel() abort
    if exists('g:verbosity_default_level')
        return g:verbosity_default_level
    endif

    return 10
endfunction


function! verbosity#getLogDirectory() abort
    if exists('g:verbosity_log_directory')
        let l:dir_path = g:verbosity_log_directory

        if !isdirectory(l:dir_path)
            call mkdir(l:dir_path, 'p', 0700)
        endif
    else
        let l:tmp_name = tempname()
        let l:dir_path = fnamemodify(l:tmp_name, ':h')
    endif

    return l:dir_path
endfunction


function! verbosity#getNewFileName() abort
    let l:date_time = strftime('%Y%m%d-%H%M%S')
    return s:verbosity_log_directory . '/vim-verbosity-' . l:date_time . '.log'
endfunction


" Variable definitions
"--------------------------------------------------------------------------
let s:verbosity_enabled = 0
let s:verbosity_current_level = verbosity#getDefaultLogLevel()
let s:verbosity_current_file = ''
let s:verbosity_log_directory = verbosity#getLogDirectory()


" Plug mappings
nnoremap <unique> <Plug>(verbosity-enable) :<c-u>call verbosity#enable()<CR>
nnoremap <unique> <Plug>(verbosity-disable) :call verbosity#disable()<CR>
nnoremap <unique> <Plug>(verbosity-toggle) :<c-u>call verbosity#toggle()<CR>
nnoremap <unique> <Plug>(verbosity-open-current-file) :<c-u>call verbosity#openCurrentFile()<CR>


" Default key bindings
nmap <unique> [oV <Plug>(verbosity-enable)
nmap <unique> ]oV <Plug>(verbosity-disable)
nmap <unique> =oV <Plug>(verbosity-toggle)
nmap <unique> goV <Plug>(verbosity-open-current-file)

