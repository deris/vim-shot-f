" shot-f - highlight the character which can move directly to (by `f`,`F`,`t`,`T`).
" Version: 0.1.0
" Copyright (C) 2014 deris <deris0126@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

" Public API {{{1

function! shot_f#shot_f()
  return s:shot_f('f')
endfunction

function! shot_f#shot_F()
  return s:shot_f('F')
endfunction

function! shot_f#shot_t()
  return s:shot_f('t')
endfunction

function! shot_f#shot_T()
  return s:shot_f('T')
endfunction

"}}}

" Private {{{1

function! s:shot_f(ft)
  let gcr_save = &guicursor
  set guicursor=n:block-NONE
  let t_ve_save = &t_ve
  set t_ve=
  let id = matchadd('ShotFCursor', '\%#')
  try
    let cnt = v:count1
    while (1)
      call s:highlight_one_of_each_char(a:ft, a:ft =~# '\l', cnt)

      let cn = getchar()
      if s:is_special_char(cn)
        return ''
      endif
      let c = type(cn) == type(0) ? nr2char(cn) : cn
      if exists('g:shot_f_increment_count_key') &&
        \c ==# g:shot_f_increment_count_key
        let cnt += 1
      elseif exists('g:shot_f_decrement_count_key') &&
        \c ==# g:shot_f_decrement_count_key
        let cnt -= 1
      else
        break
      endif
      let cnt = cnt < 1 ? 1 : cnt

      call s:disable_highlight()
    endwhile

    return "\<Esc>" . cnt . a:ft . c
  finally
    call s:disable_highlight()
    call matchdelete(id)
    set guicursor&
    let &guicursor = gcr_save
    let &t_ve = t_ve_save
  endtry
endfunction

function! s:highlight_one_of_each_char(ft, forward, count)
  let line = getline('.')
  let col = col('.') - 1
  let lnum = line('.')

  let start_col = col + 1 + (a:ft ==? 't' ? 1 : 0)
  let end_col   = col - 1 - (a:ft ==? 't' ? 1 : 0)
  if (a:forward && start_col + 1 > len(line) - 1) ||
    \(!a:forward && end_col + 1 < 0)
    return
  endif

  let list = a:forward ? range(start_col, len(line) - 1)
    \                  : reverse(range(0, end_col))
  let char_dict = {}
  for cur_col in list
    let cur_char = line[cur_col]
    let char_dict[cur_char] = get(char_dict, cur_char, 0) + 1
    if char_dict[cur_char] == a:count
      call matchadd(cur_char =~ '[[:blank:]]' ? 'ShotFBlank' : 'ShotFGraph', printf('\%%%dl\%%%dc', lnum, cur_col+1))
    endif
  endfor

  redraw!
endfunction

function! s:disable_highlight()
  for h in filter(getmatches(), 'v:val.group ==# "ShotFGraph" || v:val.group ==# "ShotFBlank"')
    call matchdelete(h.id)
  endfor
endfunction

function! s:is_special_char(c)
  return type(a:c) == type('') && char2nr(a:c) == 128
endfunction

augroup plugin-shot-f-highlight
  autocmd!
  autocmd ColorScheme * highlight default ShotFGraph ctermfg=red ctermbg=NONE cterm=bold guifg=red guibg=NONE gui=bold
  autocmd ColorScheme * highlight default ShotFBlank ctermfg=NONE ctermbg=red cterm=NONE guifg=NONE guibg=red gui=NONE
augroup END

highlight default ShotFGraph ctermfg=red ctermbg=NONE cterm=bold guifg=red guibg=NONE gui=bold
highlight default ShotFBlank ctermfg=NONE ctermbg=red cterm=bold guifg=NONE guibg=red gui=bold
highlight link ShotFCursor Cursor

"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__ "{{{1
" vim: foldmethod=marker
