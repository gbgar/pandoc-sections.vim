"Pandoc-Sections.vim
"Based on Steve Losh's Learn Vimscript the Hard Way
"Potions section movement tutorial
"http://learnvimscriptthehardway.stevelosh.com/chapters/51.html
"Blake Gardner
"WTFPL 2014

"Motions    ]]  [[  ][  []"{{{
function! s:PandocSectionMovement(type, backwards, mode)"{{{
        let linejmp ='0'
        if a:mode == 1
                normal! gv
                "if a:backwards
                        "let linejmp = 2
                "endif
        endif
        if a:mode == 2 && a:backwards
                "let linejmp = 2
        endif

        if a:type == 1
                let pattern = '^.*\n^[=]\+$\|^\s*#\a.*\n'
        elseif a:type == 2
                let pattern = '^.*\n^[-]\+$\|^\s*#\{2,6}.*\n'
        endif
        if a:backwards
                let dir = '?' 
        else
                let dir = '/'
        endif
        execute 'silent normal! ' . dir . pattern . dir . linejmp . "\r"
        nohlsearch
endfunction
"}}}
"mappings"{{{
"undo mappings for sections and set them to new section function
nnoremap <script> <buffer> <silent> ]]
        \ PandocSectionMovement(1, 0, 0)<cr>

nnoremap <script> <buffer> <silent> [[
        \ PandocSectionMovement(1, 1, 0)<cr>

nnoremap <script> <buffer> <silent> ][
        \ PandocSectionMovement(2, 0, 0)<cr>

nnoremap <script> <buffer> <silent> []
        \ PandocSectionMovement(2, 1, 0)<cr>

xnoremap <script> <buffer> <silent> ]]
        \ :<c-u>call <SID>PandocSectionMovement(1, 0, 1)<cr>

xnoremap <script> <buffer> <silent> [[
        \ :<c-u>call <SID>PandocSectionMovement(1, 1, 1)<cr>

xnoremap <script> <buffer> <silent> ][
        \ :<c-u>call <SID>PandocSectionMovement(2, 0, 1)<cr>

xnoremap <script> <buffer> <silent> []
        \ :<c-u>call <SID>PandocSectionMovement(2, 1, 1)<cr>

omap <script> <buffer> <silent> ]]
        \ PandocSectionMovement(1, 0, 2)<cr>

omap <script> <buffer> <silent> [[
        \ PandocSectionMovement(1, 1, 2)<cr>

omap <script> <buffer> <silent> ][
        \ PandocSectionMovement(2, 0, 2)<cr>

omap <script> <buffer> <silent> []
        \ PandocSectionMovement(2, 1, 2)<cr>
"}}}
"}}}

"Text Objects i]]    i][     a]]     a]["{{{
"based on based on http://vim.wikia.com/wiki/Creating_new_text_objects 
"secondary sections text objects  are unsophisticated and need to behave 
"with reference to the hierarchy

function! s:PandocSectionObject(inout, headerlevel)
        "check starting position; move down if on section header
        let l:curstartpos = getline(".") . "\n" .  getline(line(".") + 1)
        if l:curstartpos =~ '^.*\n^[=-]\+$\|\s*#\{1,6}.*\n.*$\|^[=-]\{3,}$\n.*$'
               if  l:curstartpos =~ '^\s*#\{1,6}.*$\n.*'
                       call cursor(line(".") + 1, 0)
               elseif l:curstartpos =~ '^.*\n[=-]\+$'
                       let l:curstwo = getline(".")
                       if l:curstwo !~ '^[=-]\+$'
                               call cursor(line(".") + 2, 0)
                       else 
                               call cursor(line(".") + 1, 0)
                       endif

               endif
       endif
                
        "move to top of section
               call <SID>PandocSectionMovement(a:headerlevel,1,0)
               "inside section
       if a:inout == 0
               let l:sectkind = getline(".")
               if  l:sectkind !~ '^\s*#\{1,6}.*$\|^[=-]\{3,}$'
                       call cursor(line(".") + 2, 0)
               else
                       call cursor(line(".") + 1, 0)
               endif
               if a:headerlevel == 1
                       execute  'silent normal V/^.*\n^[=]\+$\|^\s*#\a.*$'."\r" . 'kk'
               elseif a:headerlevel == 2
                        execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r" . 'kk'
               endif
     endif
       if a:inout == 1
               if a:headerlevel == 1
                       execute  'silent normal V/^.*\n^[=]\+$\|^\s*#\a.*\n'."\r" . 'k'
               elseif a:headerlevel == 2
                        execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r" . 'k'
               endif
     endif
endfunction

"mappings"{{{
"Visual
xnoremap <script> <buffer> <silent> i]]
                        \ :call <SID>PandocSectionObject(0,1)<cr>

xnoremap <script> <buffer> <silent> i][
                        \ :call <SID>PandocSectionObject(0,2)<cr>

xnoremap <script> <buffer> <silent> a]]
                        \ :call <SID>PandocSectionObject(1,1)<cr>

xnoremap <script> <buffer> <silent> a][
                        \ :call <SID>PandocSectionObject(1,2)<cr>

"Operator 
omap <script> <buffer> <silent> a]] :normal Va]]<CR>
omap <script> <buffer> <silent> a][ :normal Va][<CR>
omap <script> <buffer> <silent> i]] :normal Vi]]<CR>
omap <script> <buffer> <silent> i][ :normal Vi][<CR>
"}}}
"}}}
