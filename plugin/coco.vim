" Coco Code Commenter <coco.vim>
"
" Copyright:    Copyright (C) 2015 Cyker Way
"
" Description:  Coco is a simple, lightweight vim code commenter.
"
" Maintainer:   Cyker Way <cykerway at gmail dot com>
"
" Version:      1.0
"
" Install:      Install coco.vim at `&runtimepath/plugin/coco.vim`.
"
" Usage:        Simply call functions: `CocoComment`, `CocoUncomment` and `CocoToggle`.
"
"               You can also map them in vimrc. For example:
"
"                   map <C-c> :call CocoComment()<CR>
"                   map <C-u> :call CocoUncomment()<CR>
"                   map <C-t> :call CocoToggle()<CR>
"
"               You can redefine `g:cocoTokenDict` and `g:cocoDefaultToken` in vimrc.
"
"               Currently only line comments are supported.

" Token dictionary.
if !exists('g:cocoTokenDict')
    let g:cocoTokenDict = {
\       'c'         :   '//',
\       'cpp'       :   '//',
\       'java'      :   '//',
\       'javascript':   '//',
\       'vim'       :   '"',
\   }
endif

" Default token.
if !exists('g:cocoDefaultToken')
    let g:cocoDefaultToken = '#'
endif

" Set filetype-based comment token.
function CocoSetToken()
    let b:cocoToken = get(g:cocoTokenDict, &filetype, g:cocoDefaultToken)
    let b:cocoTokenLen = strlen(b:cocoToken)
endfunction

" Comment a line.
function CocoComment()
    let l:currentLine = line('.')
    let l:currentColumn = col('.')
    :exe "normal" "0i" . b:cocoToken
    :call cursor(l:currentLine, l:currentColumn + b:cocoTokenLen)
endfunction

" Uncomment a line.
function CocoUncomment()
    let l:currentLine = line('.')
    let l:currentColumn = col('.')
    let l:headChars = getline(l:currentLine)[0:b:cocoTokenLen - 1]
    if l:headChars == b:cocoToken
        :exe "normal" "0" . b:cocoTokenLen . "x"
        :call cursor(l:currentLine, l:currentColumn - b:cocoTokenLen)
    endif
endfunction

" Toggle a line comment.
function CocoToggle()
    let l:currentLine = line('.')
    let l:currentColumn = col('.')
    let l:headChars = getline(l:currentLine)[0:b:cocoTokenLen - 1]
    if l:headChars == b:cocoToken
        :call CocoUncomment()
    else
        :call CocoComment()
    endif
endfunction

" Set comment token on FileType event.
autocmd BufEnter,FileType * :call CocoSetToken()
