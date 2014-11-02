close all

create table D:\ARM\VODA\LVS_MOY.dbf (CITY C(6),TEL N(10),FIO C(100),LICH C(20),KO C(5),STATUS N(1),SUMA N(10),kodbk C(7),saldn N(9,2))
APPEND FROM LVS30625.DBF
CLOS ALL

sele 1
use LVS_MOY.dbf
repl all kodbk with lich
clos all

sele 1
use LVS_MOY
sele 2
use narax
index on kodbk to r1
sele 1
set relat to kodbk into narax
repl all saldn with narax.saldn
repl all suma with (saldn*(-100))
clos all

use LVS_MOY
copy fields CITY, TEL, FIO, LICH, KO, STATUS, SUMA to woda_LVS
clos all