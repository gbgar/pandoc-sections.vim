"Pandoc-Sections.vim
"Based on Steve Losh's Learn Vimscript the Hard Way
"Potions section movement tutorial
"http://learnvimscriptthehardway.stevelosh.com/chapters/51.html
"Blake Gardner
"WTFPL 2014

function! s:NextSection(type, backwards, visual)
        let nohi=':nohlsearch'
        let linejmp ='0'
        if a:visual
                normal! gv
        endif

        if a:type == 1
                let pattern = '^[=]\+$\|^\s*#\a.*\n'
        elseif a:type == 2
                let pattern = '^[-]\+$\|^\s*#\{2,6}.*\n'
        endif
        if a:backwards
                let dir = '?' 
        else
                let dir = '/'
        endif
        execute 'silent normal! ' . dir . pattern . dir . linejmp . "\r"
        nohlsearch
endfunction

"Undo mappings for sections and set them to new section function
nnoremap <script> <buffer> <silent> ]]
        \ :call <SID>NextSection(1, 0, 0)<cr>

nnoremap <script> <buffer> <silent> [[
        \ :call <SID>NextSection(1, 1, 0)<cr>

nnoremap <script> <buffer> <silent> ][
        \ :call <SID>NextSection(2, 0, 0)<cr>

nnoremap <script> <buffer> <silent> []
        \ :call <SID>NextSection(2, 1, 0)<cr>

xnoremap <script> <buffer> <silent> ]]
        \ :<c-u>call <SID>NextSection(1, 0, 1)<cr>

xnoremap <script> <buffer> <silent> [[
        \ :<c-u>call <SID>NextSection(1, 1, 1)<cr>

xnoremap <script> <buffer> <silent> ][
        \ :<c-u>call <SID>NextSection(2, 0, 1)<cr>

xnoremap <script> <buffer> <silent> []
        \ :<c-u>call <SID>NextSection(2, 1, 1)<cr>

omap <script> <buffer> <silent> ]]
        \ :call <SID>NextSection(1, 0, 0)<cr>

omap <script> <buffer> <silent> [[
        \ :call <SID>NextSection(1, 1, 0)<cr>

omap <script> <buffer> <silent> ][
        \ :call <SID>NextSection(2, 0, 0)<cr>

omap <script> <buffer> <silent> []
        \ :call <SID>NextSection(2, 1, 0)<cr>
