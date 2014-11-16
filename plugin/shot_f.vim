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

if exists('g:loaded_shot_f')
  finish
endif
let g:loaded_shot_f = 1

let s:save_cpo = &cpo
set cpo&vim


noremap <silent><expr> <Plug>(shot-f-f)  shot_f#shot_f()
noremap <silent><expr> <Plug>(shot-f-F)  shot_f#shot_F()
noremap <silent><expr> <Plug>(shot-f-t)  shot_f#shot_t()
noremap <silent><expr> <Plug>(shot-f-T)  shot_f#shot_T()

if !get(g:, 'shot_f_no_default_key_mappings', 0) &&
  \!hasmapto('<Plug>(shot-f-f)') &&
  \!hasmapto('<Plug>(shot-f-F)') &&
  \!hasmapto('<Plug>(shot-f-t)') &&
  \!hasmapto('<Plug>(shot-f-T)')
  nmap f  <Plug>(shot-f-f)
  nmap F  <Plug>(shot-f-F)
  nmap t  <Plug>(shot-f-t)
  nmap T  <Plug>(shot-f-T)
  xmap f  <Plug>(shot-f-f)
  xmap F  <Plug>(shot-f-F)
  xmap t  <Plug>(shot-f-t)
  xmap T  <Plug>(shot-f-T)
  omap f  <Plug>(shot-f-f)
  omap F  <Plug>(shot-f-F)
  omap t  <Plug>(shot-f-t)
  omap T  <Plug>(shot-f-T)
end

let g:shot_f_increment_count_key = get(g:, 'shot_f_increment_count_key', "\<CR>")
let g:shot_f_decrement_count_key = get(g:, 'shot_f_decrement_count_key', "\<BS>")


let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
