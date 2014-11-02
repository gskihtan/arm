close all
SELE 1
create table D:\ARM\VODA\dop2.dbf (kodbk C(7),kodv C(4),vul C(25),bud C(4),kvar C(3),FIO C(25),norma C (14),LL C(3),oplomb D(10),kodnor N(2),kodn N(2),kanal N(1))
APPEND FROM NARAX_09.DBF
copy to DEVKI
CLOS ALL

sele 1
use DEVKI
sele 2
use dovad
index on kodbk to r1
sele 1
set relat to kodbk into dovad
repl all kodv with dovad.kodv
CLOS ALL

sele 1
use DEVKI
sele 2
use dovvul
index on kodv to r1
sele 1
set relat to kodv into dovvul
repl all vul with dovvul.vul
browse
CLOS ALL

sele 1
use DEVKI
sele 2
use dovad
index on kodbk to r1
sele 1
set relat to kodbk into dovad
repl all bud with dovad.bud
repl all kvar with dovad.kvar
browse
CLOS ALL

sele 1
use DEVKI
index on kodnor to r1
*set filter to kodnor = 01
repl all norma with [вул.кол.] for kodnor = 01    
repl all norma with [двор.кол.] for  kodnor = 02  
repl all norma with [кран в хатi] for  kodnor = 03  
repl all norma with [титан] for kodnor = 04  
repl all norma with [газ.кол,котел] for kodnor = 05  
repl all norma with [без пiдiгр.] for kodnor = 06  
repl all norma with [гар.вода] for kodnor = 07  
repl all LL with [лiч] for kodn = 08  
repl all LL with [лiч] for kodn = 11
repl all LL with [опл] for oplomb # {  /  /  }  
browse
CLOS ALL
*use URA_MU
*browse
*copy fields kodbk,vul,bud,kvar,FIO,Saldn,Saldp,ugoda,ugdate,summa_ug,opl_ug
*browse
*clos all
