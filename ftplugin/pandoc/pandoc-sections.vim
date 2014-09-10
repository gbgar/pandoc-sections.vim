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
                let s:movpattern = '^.*\n^[=]\+$\|^\s*#\a.*\n'
        elseif a:type == 2
                let s:movpattern = '^.*\n^[-]\+$\|^\s*#\{2,6}.*\n'
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
                call search(s:movpattern, l:sflag)
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
"Text objects for low-level sections now behave with 
"reference to the hierarchy: I][ and A][
function! s:PandocSectionObjectInitialize(inall, headerlevel, advanced) "{{{
        "Set cursor start position in order to return if ][ called in primary
        "section
        let curstart = getpos(".")
        "If cursor starting poition is on a header, move it to top/left.
        let l:curline = getline(".")
        let l:nexline = getline(line(".") + 1)
        if l:nexline =~  '^[=-]\+$'
                call cursor(line(".") + 2, 1)
        elseif l:curline =~ '^[=-]\+$\|^\s*#\{1,6}.*$'
                call cursor(line(".") + 1, 1)
        endif
        "Move to top of section
        call <SID>PandocSectionMovement(a:headerlevel,1,0,1)
        let l:curline = getline(".")
        let l:nexline = getline(line(".") + 1)
        "Get header level as integer 
        let l:advancedheadlevel = s:PandocSectionLevel(l:curline,nexline)
        "If advanced is used in primary section, return cursor to start and
        "end
        if (( l:advancedheadlevel == 1 ) && ( a:advanced == 1 )) || ( l:advancedheadlevel == 0 )
                call setpos(".",l:curstart)
        else
                call s:PandocSectionObjectMove(a:inall, a:headerlevel, a:advanced, l:curline,l:nexline,l:advancedheadlevel)
        endif
endfunction "{{{

function! s:PandocSectionObjectMove(inall, headerlevel, advanced, lineone, linetwo, advancedheadlevel) "{{{
        "inside of section i]] i][
        if a:inall == 0
                "Move down for 'inner' movement
                if a:linetwo =~ '^[=-]\+$'
                        call cursor(line(".") + 2, 1)
                elseif a:lineone =~ '^[=-]\+$\|^\s*#\{1,6}.*$'
                        call cursor(line(".") + 1, 1)
                endif
                "Check if last section, primary or not to determine regexes
                if a:headerlevel == 1
                        if s:IsBottom() == 0
                                execute 'silent normal VG'
                        else
                                execute  'silent normal V/^.*\n^[=]\+$\|^\s*#\a.*$'."\r" . 'kk'
                        endif
                elseif a:headerlevel == 2
                        if s:IsBottom() == 0
                                execute 'silent normal VG'
                        else
                                if a:advanced == 0
                                        execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r" . 'kk'
                                endif
                                if a:advanced == 1
                                        call s:PandocAdvancedObjInit(a:advancedheadlevel,0)
                                endif
                        endif
                endif
        endif

        "all of section: a]] a][
        if a:inall == 1
                "Cursor is on header and does not need to move.
                "Check if last section, primary or not to determine regexes
                if a:headerlevel == 1
                        if s:IsBottom() == 0
                                execute 'silent normal VG'
                        else
                                execute  'silent normal V/^.*\n^[=]\+$\|^\s*#\a.*\n'."\r" . 'k'
                        endif
                elseif a:headerlevel == 2
                        if s:IsBottom() == 0
                                execute 'silent normal VG'
                        else
                                if a:advanced == 0
                                        execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r" . 'k'
                                endif
                                if a:advanced == 1
                                        call s:PandocAdvancedObjInit(a:advancedheadlevel,1)
                                endif
                        endif
                endif
        endif
endfunction

"}}}

"Text Object Helper functions"{{{

"Check if next match exists or is at bottom
function! s:IsBottom()"{{{
        return search('^.*\n^[=]\+$\|^\s*#\a.*$', 'Wn')
endfunction
"}}}

"return heading level as integer
function! s:PandocSectionLevel(lineone,linetwo)"{{{ 
        if     a:linetwo =~ '^[=]\+$' 
                return 1              
        elseif a:linetwo =~ '^[-]\+$'
                return 2
        elseif a:lineone =~ '^\#\+\.*'
                return strlen(matchstr(a:lineone,'\#\+',0))
        else 
                return 0
        endif
endfunction"}}}

"Advanced jump functions:"{{{
"called by PandocSectionObject() for low-level headings.
"The commented function is a loop that, according to tpope's :Time command is
"somewhat faster than the function and it's recursive helper below.  However,
"the latter covers an edge case that the former does not: a Setext header
"(above cursor) separated from another, lower-level header by one blank line
"(position of cursor) does not get captured by the visual mode command.

" function! s:PandocAdvancedObjInit(headlevel,inorall)"{{{
"         if a:inorall == 0
"                 execute 'silent normal j'
"         endif
"         execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r"
"         let s:moveup= 1
"         let s:objseclev = s:PandocSectionLevel(getline("."),getline(line(".")+1)) 
"         while s:objseclev > a:headlevel
"                unlet s:objseclev
"                unlet s:moveup
"                if s:IsBottom() == 0
"                        execute 'G'
"                        let s:moveup = 0
"                        break
"                else
"                        execute 'silent normal! gv /^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' . "\r"
"                        let s:moveup = 1
"                endif
"         let s:objseclev = s:PandocSectionLevel(getline("."),getline(line(".")+1)) 
"         endwhile
"         if s:moveup == 1
"                 if a:inorall == 0
"                         execute 'silent normal kk'
"                 elseif a:inorall == 1
"                         execute 'silent normal k'
"                 else 
"                         echo "No upward movement needed."
"                 endif
"         endif
" endfunction"}}}

function! s:PandocAdvancedObjInit(headlevel,inorall)"{{{
        if a:inorall == 0
                execute 'silent normal j'
        endif
        execute 'silent normal V/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' ."\r"
        let s:moveup= 1
        let s:objseclev = s:PandocSectionLevel(getline("."),getline(line(".")+1)) 
        call s:PandocAdvancedObj(a:headlevel,s:objseclev)
        if s:moveup == 1
                if a:inorall == 0
                        execute 'silent normal kk'
                elseif a:inorall == 1
                        execute 'silent normal k'
                else 
                        echo "No upward movement needed."
                endif
        endif
endfunction

function! s:PandocAdvancedObj(orig,lev)
        if a:lev > a:orig
               if s:IsBottom() == 0
                       execute 'silent normal G'
                       let s:moveup = 0
               else
                       execute 'normal! gv/^.*\n^[=-]\+$\|^\s*#\{1,6}.*\n' . "\r"
                       let s:moveup = 1
                       let s:objseclev = s:PandocSectionLevel(getline("."),getline(line(".")+1)) 
                       call s:PandocAdvancedObj(a:orig,s:objseclev)
               endif
        endif
endfunction"}}}
"}}}
"}}}

"Text-Object mappings"{{{
"Visual
xnoremap <script> <buffer> <silent> i]]
                        \ :call <SID>PandocSectionObjectInitialize(0,1,0)<cr>

xnoremap <script> <buffer> <silent> i][
                        \ :call <SID>PandocSectionObjectInitialize(0,2,0)<cr>

xnoremap <script> <buffer> <silent> a]]
                        \ :call <SID>PandocSectionObjectInitialize(1,1,0)<cr>

xnoremap <script> <buffer> <silent> a][
                        \ :call <SID>PandocSectionObjectInitialize(1,2,0)<cr>

"Operator-pending 
omap <script> <buffer> <silent> a]] :normal Va]]<CR>
omap <script> <buffer> <silent> a][ :normal Va][<CR>
omap <script> <buffer> <silent> i]] :normal Vi]]<CR>
omap <script> <buffer> <silent> i][ :normal Vi][<CR>

"Experimental 'advanced' sections for lower lower-level I][ and A ][
"Visual
xnoremap <script> <buffer> <silent> I][
                        \ :call <SID>PandocSectionObjectInitialize(0,2,1)<cr>

xnoremap <script> <buffer> <silent> A][
                        \ :call <SID>PandocSectionObjectInitialize(1,2,1)<cr>
"
"Operator-pending
omap <script> <buffer> <silent> A][ :normal VA][<CR>
omap <script> <buffer> <silent> I][ :normal VI][<CR>

"}}}
"}}}
