" syntastic.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-07-08.
" @Last Change: 2012-07-08.
" @Revision:    41


if !exists('g:checksyntax#syntastic#auto')
    " If true, mark syntastic syntax checkers as automatic checkers. See 
    " |g:checksyntax#auto_mode| and |g:checksyntax|.
    let g:checksyntax#syntastic#auto = 0   "{{{2
endif


if !exists('g:checksyntax#syntastic#blacklist')
    " Don't load syntastic syntax checkers for these filetypes.
    let g:checksyntax#syntastic#blacklist = []   "{{{2
endif


if !exists('*SyntasticMake')
    function! SyntasticMake(options)
        " TLogVAR a:options
        let def = {
                    \ 'cmd': a:options.makeprg,
                    \ 'args': '',
                    \ 'efm': a:options.errorformat
                    \ }
        " TLogVAR def
        return checksyntax#Make(def)
    endf
endif


" if !exists('*SyntasticLoadChecker')
"     function! SyntasticLoadChecker(checkers)
"         " dummy
"         throw "CheckSyntax: SyntasticLoadChecker not supported yet"
"     endf
" endif


if !exists('*SyntasticHighlightErrors')
    function! SyntasticHighlightErrors(errors, termfunc, ...)
        " dummy
    endf
endif


function! checksyntax#syntastic#Require(dict, filetype) "{{{3
    " TLogVAR a:filetype
    if index(g:checksyntax#syntastic#blacklist, a:filetype) == -1
        if stridx(&rtp, g:checksyntax#syntastic_dir) >= 0
            exec 'runtime! syntax_checkers/'. a:filetype .'.vim'
        else
            let syntax_checker = g:checksyntax#syntastic_dir .'/syntax_checkers/'. a:filetype .'.vim'
            if filereadable(syntax_checker)
                exec 'source' fnameescape(syntax_checker)
            endif
        endif
        let fn = 'SyntaxCheckers_'. a:filetype .'_GetLocList'
        if exists('*'. fn)
            let def = {
                        \ 'auto': g:checksyntax#syntastic#auto,
                        \ 'listtype': 'loc',
                        \ 'syntastic': fn
                        \ }
            " TLogVAR def
            let a:dict[a:filetype] = def
        else
            call add(g:checksyntax#syntastic#blacklist, a:filetype)
        endif
    endif
endf

