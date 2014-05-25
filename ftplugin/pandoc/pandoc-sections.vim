"Pandoc-Sections.vim
"Based on Steve Losh's Learn Vimscript the Hard Way
"esp. http://learnvimscriptthehardway.stevelosh.com/chapters/51.html
"and also
"http://vim.wikia.com/wiki/Creating_new_text_objects
"Blake Gardner
"WTFPL 2014

"Motions    ]]  [[  ][  []"{{{
"{{{
function! s:PandocSectionMovement(type, backwards, mode, cnt)
        "Ensure visual mode works as expected
        if a:mode == 1
                normal! gv
        endif

        "Regex for section types
        if a:type == 1
                let l:pattern = '^.*\n^[=]\+$\|^\s*#\a.*\n'
        elseif a:type == 2
                let l:pattern = '^.*\n^[-]\+$\|^\s*#\{2,6}.*\n'
        endif

        "Set backwardness and boundaries
        "'W' for not wrapping around file
        if a:backwards
                let l:sflag = 'bW'
        else
                let l:sflag = 'W'
        endif

        "Loop for [count] number of sections or until top/bottom
        let i = 0
        while i < a:cnt
                call search(l:pattern, l:sflag)
                let i = i + 1
        endwhile
endfunction

"}}}
"Motion mappings"{{{
"undo mappings for sections and set them to new section function
"Normal
nnoremap <script> <buffer> <silent> ]]
        \ :call <SID>PandocSectionMovement(1, 0, 0, v:count1)<cr>

nnoremap <script> <buffer> <silent> [[
        \ :call <SID>PandocSectionMovement(1, 1, 0, v:count1)<cr>

nnoremap <script> <buffer> <silent> ][
        \ :call <SID>PandocSectionMovement(2, 0, 0, v:count1)<cr>

nnoremap <script> <buffer> <silent> []
        \ :call <SID>PandocSectionMovement(2, 1, 0, v:count1)<cr>

"Visual
xnoremap <script> <buffer> <silent> ]]
        \ :<c-u>call <SID>PandocSectionMovement(1, 0, 1, v:count1)<cr>

xnoremap <script> <buffer> <silent> [[
        \ :<c-u>call <SID>PandocSectionMovement(1, 1, 1, v:count1)<cr>

xnoremap <script> <buffer> <silent> ][
        \ :<c-u>call <SID>PandocSectionMovement(2, 0, 1, v:count1)<cr>

xnoremap <script> <buffer> <silent> []
        \ :<c-u>call <SID>PandocSectionMovement(2, 1, 1, v:count1)<cr>

"Operator-pending
omap <script> <buffer> <silent> ]]
        \ :call <SID>PandocSectionMovement(1, 0, 2, v:count1)<cr>

omap <script> <buffer> <silent> [[
        \ :call <SID>PandocSectionMovement(1, 1, 2, v:count1)<cr>

omap <script> <buffer> <silent> ][
        \ :call <SID>PandocSectionMovement(2, 0, 2, v:count1)<cr>

omap <script> <buffer> <silent> []
        \ :call <SID>PandocSectionMovement(2, 1, 2, v:count1)<cr>
"}}}
"}}}

"Text Objects i]]    i][     a]]     a]["{{{
"secondary sections text objects are unsophisticated and should probably  
"behave with reference to the hierarchy
"
function! s:PandocSectionObject(inout, headerlevel) "{{{
        "Check if cursor is on heading and move into it if so
        let l:curline = getline(".")
        let l:nexline = getline(line(".") + 1)
        if l:nexline =~  '^[=-]\+$'
                       call cursor(line(".") + 2, 1)
        elseif l:curline =~ '^[=-]\+$\|^\s*#\{1,6}.*$'
                       call cursor(line(".") + 1, 1)
        endif
        
        "Move to top of section
        call <SID>PandocSectionMovement(a:headerlevel, 1, 0, 1)

       let l:curline = getline(".")
       let l:nexline = getline(line(".") + 1)

       "inside section i]] i][
       if a:inout == 0

               "Move down for 'inner' movement
                if l:nexline =~ '^[=-]\+$'
                       call cursor(line(".") + 2, 1)
                elseif l:curline =~ '^[=-]\+$\|^\s*#\{1,6}.*$'
                       call cursor(line(".") + 1, 1)
                endif

               "Check header level to determine regexes
               "Check if last section
               if a:headerlevel == 1
                       let l:srchbottom = search('^.*\n^[=]\+$\|^\s*#\a.*$', 'Wn')
                       if l:srchbottom == 0
                               execute 'silent normal VGG'
                       else
                               execute  'silent normal V/^.*\n^[=]\+$\|^\s*#\a.*$'."\r" . 'kk'
                       endif
               elseif a:headerlevel == 2
                       let l:srchbottom = search('^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n', 'Wn')
                       if l:srchbottom == 0
                               execute 'silent normal VGG'
                       else
                               execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r" . 'kk'
                       endif
               endif
     endif

     "all of section: a]] a][
       if a:inout == 1
               "Check header level to determine regexes
               "Check if last section
               if a:headerlevel == 1
                       let l:srchbottom = search('^.*\n^[=]\+$\|^\s*#\a.*$', 'Wn')
                       if l:srchbottom == 0
                               execute 'silent normal VGG'
                       else
                               execute  'silent normal V/^.*\n^[=]\+$\|^\s*#\a.*\n'."\r" . 'k'
                       endif
               elseif a:headerlevel == 2
                       let l:srchbottom = search('^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n', 'Wn')
                       if l:srchbottom == 0
                               execute 'silent normal VGG'
                       else
                               execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r" . 'k'
                       endif
               endif
     endif
endfunction
"}}}

"Text-Object mappings"{{{
"Visual
xnoremap <script> <buffer> <silent> i]]
                        \ :call <SID>PandocSectionObject(0,1)<cr>

xnoremap <script> <buffer> <silent> i][
                        \ :call <SID>PandocSectionObject(0,2)<cr>

xnoremap <script> <buffer> <silent> a]]
                        \ :call <SID>PandocSectionObject(1,1)<cr>

xnoremap <script> <buffer> <silent> a][
                        \ :call <SID>PandocSectionObject(1,2)<cr>

"Operator-pending 
omap <script> <buffer> <silent> a]] :normal Va]]<CR>
omap <script> <buffer> <silent> a][ :normal Va][<CR>
omap <script> <buffer> <silent> i]] :normal Vi]]<CR>
omap <script> <buffer> <silent> i][ :normal Vi][<CR>
"}}}
"}}}
