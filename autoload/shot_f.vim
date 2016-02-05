" shot-f - highlight the character which can move directly to (by `f`,`F`,`t`,`T`).
" Version: 1.0.0
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
  let mode = mode(1)
  call s:initialize()
  try
    let cnt = v:count1
    while (1)
      call s:highlight_one_of_each_char(a:ft =~# '\l', cnt)

      let cn = getchar()
      if s:unexpected_character(cn)
        continue
      endif
      let c = type(cn) == type(0) ? nr2char(cn) : cn

      let ac = s:get_count_for_adding(c)
      if ac == 0
        break
      endif
      let cnt += ac
      if cnt < 1
        let cnt = 1
      elseif cnt > s:max_count
        let cnt = s:max_count
      endif

      call s:disable_highlight()
    endwhile

    if mode ==# 'n'
      if v:count >= 1
        return "\<Esc>" . cnt . a:ft . c
      endif
      return cnt . a:ft . c
    elseif mode ==? 'v' || mode ==# "\<C-v>"
      return "\<Esc>" . 'gv' . cnt . a:ft . c
    elseif mode ==# 'no'
      return "\<Esc>" . '"' . v:register . cnt . v:operator . a:ft . c
    endif
  finally
    call s:finalize()
  endtry
endfunction

function! s:initialize()
  let s:gcr_save = &guicursor
  set guicursor=n:block-NONE
  let s:t_ve_save = &t_ve
  set t_ve=
  let s:cursor_id = matchadd('ShotFCursor', '\%#')
  let s:max_count = 1
endfunction

function! s:finalize()
  call s:disable_highlight()
  call matchdelete(s:cursor_id)
  set guicursor&
  let &guicursor = s:gcr_save
  let &t_ve = s:t_ve_save
endfunction

function! s:highlight_one_of_each_char(forward, count)
  let line = getline('.')
  let col = col('.') - 1
  let lnum = line('.')

  let start_col = col + 1
  let end_col   = col - 1
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
    if cur_char =~ '[\x01-\x7E]' && char_dict[cur_char] == a:count
      call matchadd(cur_char =~ '[[:blank:]]' ? 'ShotFBlank' : 'ShotFGraph', printf('\%%%dl\%%%dc', lnum, cur_col+1))
    endif
    let s:max_count = char_dict[cur_char] > s:max_count ? char_dict[cur_char] : s:max_count
  endfor

  redraw
endfunction

function! s:disable_highlight()
  for h in filter(getmatches(), 'v:val.group ==# "ShotFGraph" || v:val.group ==# "ShotFBlank"')
    call matchdelete(h.id)
  endfor
endfunction

function! s:get_count_for_adding(c)
  if exists('g:shot_f_increment_count_key') &&
    \a:c ==# g:shot_f_increment_count_key
    return 1
  elseif exists('g:shot_f_decrement_count_key') &&
    \a:c ==# g:shot_f_decrement_count_key
    return -1
  else
    return 0
  endif
endfunction

" \x80\xfd` is sent at fixed interval.
" I don't know reason but it's unexpected.
" So ignore if this character is sent.
function! s:unexpected_character(c)
  return a:c ==# "\x80\xfd`"
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
