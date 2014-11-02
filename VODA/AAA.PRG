close all
use post order kodbk
total on kodbk to $post field suma
use $post alias post
index on kodbk to ipost comp
select 0
use narax
set relat to kodbk into post
repl all opl with post.suma
repl all saldp with saldn+svp+stp+svd+std-opl-subs

close all
use d:\foxpro\voda\salv
index on kodbk to i comp
select 0
use narax
set relat to kodbk into salv
set filter to saldp#salv.saldn-salv.saldk
clear
count to m
?m
copy to out
use out
set relat to kodbk into salv


