shot-f
===

shot-f highlights the characters where the cursor can move directly (by `f`,`F`,`t`,`T`).

Screenshot
---

![screenshot](https://raw.githubusercontent.com/deris/images/master/vim-shot-f/shot_f_usage.gif)


Usage
---

When you type `f`, `F`, `t`, `T`, it highlights the characters where the cursor can move directly (when `t` and `T`, highlights before the character to move).

If you would like to change default key mappings, write following settings to your `.vimrc`.

```vim
" if you want to map comma as prefix, you can use following settings.

" disable default key mappings
let g:shot_f_no_default_key_mappings = 1

" key mappings
nmap ,f  <Plug>(shot-f-f)
nmap ,F  <Plug>(shot-f-F)
nmap ,t  <Plug>(shot-f-t)
nmap ,T  <Plug>(shot-f-T)
xmap ,f  <Plug>(shot-f-f)
xmap ,F  <Plug>(shot-f-F)
xmap ,t  <Plug>(shot-f-t)
xmap ,T  <Plug>(shot-f-T)
omap ,f  <Plug>(shot-f-f)
omap ,F  <Plug>(shot-f-F)
omap ,t  <Plug>(shot-f-t)
omap ,T  <Plug>(shot-f-T)
```

Special Thanks
---

I discussed this plugin's idea with [Linda_pp](https://github.com/rhysd),
and he created first prototype instantly.

Thanks for your kindness and cleverness Linda_pp!


License
---

MIT License

