"============================================================================
"File:        dcc.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  oliver mueller <oliver.mueller at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if exists('g:loaded_syntastic_cpp_dcc_checker')
    finish
endif
let g:loaded_syntastic_cpp_dcc_checker = 1

if !exists('g:syntastic_dcc_config_file')
    let g:syntastic_dcc_config_file = '.syntastic_cpp_config'
endif

if !exists('g:syntastic_cpp_compiler_options')
    let g:syntastic_cpp_compiler_options = ''
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_cpp_dcc_IsAvailable() dict
    if !exists('g:syntastic_cpp_compiler')
        let g:syntastic_cpp_compiler = executable(self.getExec()) ? self.getExec() : 'clang++'
    endif
    call self.log('g:syntastic_cpp_compiler =', g:syntastic_cpp_compiler)
    return executable(expand(g:syntastic_cpp_compiler, 1))
endfunction

function! SyntaxCheckers_cpp_dcc_GetLocList() dict
    let makeprg = self.makeprgBuild({
                \ 'args': '-Xlint',
                \ 'args_before': '-c -S -tPPCE200Z4VEN:simple ' .
                \       '-g -XO -Xenum-is-best -Xsection-split -Xrtti-off ' .
                \       '-Xexceptions-off -ew4265 -ew4504 -Xc++-abr ' .
                \       syntastic#c#ReadConfig(g:syntastic_dcc_config_file)})
    let errorformat = '%A"%f"\, line %l: %trror (etoa:%n): %m,' .
                \     '%A"%f"\, line %l: %tarning (etoa:%n): %m,' .
                \     '%A"%f"\, line %l: catastrophic %trror (etoa:%n): %m,' .
                \     '%A"%f"\, line %l: info (etoa:%n): %m,' .
                \     '%-G%.%#,' .
                \     '%Z%p^,' .
                \     '%-G%.%#'
    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'defaults': {'bufnr': bufnr('')} })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'cpp',
    \ 'name': 'dcc',
    \ 'exec': 'dcc' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
