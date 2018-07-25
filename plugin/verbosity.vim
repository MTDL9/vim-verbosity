"--------------------------------------------------------------------------
" Verbosity
" VIM Plugin for toggling verbose mode and viewing the output
"--------------------------------------------------------------------------

" Functions
"--------------------------------------------------------------------------
function! verbosity#enable(...) abort
    if s:verbosity_enabled is 0
        call verbosity#addTimestamp(substitute('E-N-D', '-', '', 'g'))
    endif

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
    call verbosity#addTimestamp(substitute('S-T-A-R-T', '-', '', 'g'))
    let s:verbosity_enabled = 1
    call verbosity#echoMessage('Enabled verbose logging at level ' . l:verbosity_level . ' on file ' . s:verbosity_current_file)
endfunction


function! verbosity#disable() abort
    let l:verbosity_was_enabled = s:verbosity_enabled
    let s:verbosity_enabled = 0
    call verbosity#echoMessage('Disabled verbose logging')

    if l:verbosity_was_enabled is 1
        call verbosity#addTimestamp(substitute('E-N-D', '-', '', 'g'))
    endif

    let &verbose = 0
    let &verbosefile = ''
endfunction


function! verbosity#toggle() abort
    if s:verbosity_enabled is 1
        call verbosity#disable()
    else
        call verbosity#enable()
    endif
endfunction


function! verbosity#addTimestamp(label) abort
    if s:verbosity_current_file ==# ''
        return
    endif

    let l:black_hole = ''
    redir => l:black_hole
    silent echo repeat('=', 10) . ' ' . strftime('%F %T') . ' ' .
        \repeat('=', 10) . substitute(' V-E-R-B-O-S-E', '-', '', 'g') .
        \' ' . a:label .
        \' L' . s:verbosity_current_level .
        \' ' . repeat('=', 10)
    redir END
endfunction


function! verbosity#echoMessage(message) abort
    echohl Label
    echo a:message
    echohl None
endfunction


function! verbosity#openLastFile() abort
    if s:verbosity_current_file ==# ''
        echohl ErrorMsg
        echo 'No current verbose log file found'
        echohl None
        return
    end

    execute 'vsplit ' . s:verbosity_current_file
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
"--------------------------------------------------------------------------
nnoremap <silent> <Plug>(verbosity-enable) :<c-u>call verbosity#enable()<CR>
nnoremap <silent> <Plug>(verbosity-disable) :call verbosity#disable()<CR>
nnoremap <silent> <Plug>(verbosity-toggle) :<c-u>call verbosity#toggle()<CR>
nnoremap <silent> <Plug>(verbosity-open-last) :<c-u>call verbosity#openLastFile()<CR>


" Default key bindings
"--------------------------------------------------------------------------
nmap <silent> [oV <Plug>(verbosity-enable)
nmap <silent> ]oV <Plug>(verbosity-disable)
nmap <silent> =oV <Plug>(verbosity-toggle)
nmap <silent> goV <Plug>(verbosity-open-last)


" Commands
"--------------------------------------------------------------------------
command! VerbosityEnable :call verbosity#enable()
command! VerbosityDisable :call verbosity#disable()
command! VerbosityToggle :call verbosity#toggle()
command! VerbosityOpenLast :call verbosity#openLastFile()

