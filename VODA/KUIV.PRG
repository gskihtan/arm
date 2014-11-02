close all
USE D:\ARM\VODA\ARHIV\2008\NARAX.DBF
set filter to mis = '03'
copy to kuiv1
use
use kuiv1
index on kodbk to ikuiv1 comp
set filter to saldn >= 1000
copy to kuiv2
use
use kuiv2
repl all sv with (svp+stp+svd+std)
repl all opl with (opl+subs)
browse
copy fields kodbk,fio,sv,opl,saldp to kuiv3
clos all


