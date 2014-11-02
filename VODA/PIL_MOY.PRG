close all
SELE 1
create table D:\ARM\VODA\dop.dbf (CDPR N(12),IDCODE C(10),FIO C(50),RS C(15),YEARIN N(4),MONTHIN N(2),LGCODE N(4),flag N(1),pros C(15),fiopil C(25),tarif N(7,4),ind_pod C(10),n_posv C(10),data1 D(8),data2 D(8),LGKOL N(2),LGPRC N(3),SUMM N(5,2),FACT N(12,6),kodbk C(7),pil N(3),cntpil N(5),sv_4 N(19,4),st_4 N(19,4),sv N(10,2),st N(10,2),LGKAT C(3),kodpil C(2),kodpil_s C(3),kanal N(1))
APPEND FROM t_result.DBF
browse
*set filter to kodpil ='90' or kodpil ='91' or kodpil ='60' or kodpil ='65' or kodpil ='67' or kodpil ='40' 
*delete all for kodpil ='90' or kodpil ='91' or kodpil ='60' or kodpil ='65' or kodpil ='67' or kodpil ='40'
*pack
browse
CLOS ALL

sele 2

USE D:\ARM\VODA\DOP.DBF
repl all cdpr with 03348531
repl all lgcode with 502
repl all lgprc with pil
repl all yearin with 2014
repl all DATA1 with {01.10.2014}
repl all DATA2 with {31.10.2014}
repl all monthin with 11
repl all lgkol with cntpil
*repl all summ with (sv_4+st_4)*lgkol
repl all summ with (sv_4+st_4)*cntpil
repl all rs with kodbk
*repl all fact with (sv+st)*100/lgprc 
repl all fact with (sv+st)*100/pil
repl all IDCODE with IND_POD
repl all PROS with n_posv
repl all FIO with FIOPIL
repl all TARIF with 9.12

repl all kodpil_s with '2' for kodpil = '10'
repl all kodpil_s with '1' for kodpil = '20'
repl all kodpil_s with '15' for kodpil = '15'
repl all kodpil_s with '35' for kodpil = '16'
repl all kodpil_s with '11' for kodpil = '30'
repl all kodpil_s with '12' for kodpil = '32'
repl all kodpil_s with '13' for kodpil = '34'
repl all kodpil_s with '3' for kodpil = '38'
repl all kodpil_s with '88' for kodpil = '44'
repl all kodpil_s with '50' for kodpil = '48'
repl all kodpil_s with '61' for kodpil = '50'
repl all kodpil_s with '62' for kodpil = '52'
repl all kodpil_s with '66' for kodpil = '54'
repl all kodpil_s with '58' for kodpil = '58'
repl all kodpil_s with '80' for kodpil = '71'
repl all kodpil_s with '90' for kodpil = '73'
repl all kodpil_s with '91' for kodpil = '75'
repl all kodpil_s with '81' for kodpil = '77'
repl all kodpil_s with '83' for kodpil = '83'
repl all kodpil_s with '87' for kodpil = '87'
repl all kodpil_s with '100' for kodpil = '43'

browse
clos all

sele 3
use dop
index on kodpil_s to kodp_3
repl all lgkat with kodpil_s
browse
clos all

*browse

sele 1
use dop
sele 2
use narax
index on kodbk to r1
sele 1
set relat to kodbk into narax
repl all kanal with narax.kanal
set filter to kanal = 0
repl all TARIF with 7.90
browse
CLOS ALL


use dop
copy to PIL_MOY
*browse

CLOS ALL
*use z_p
*set filter to kodpil ='90' or kodpil ='91' or kodpil ='60' or kodpil ='65' or kodpil ='67' or kodpil ='40' 
*delete all for kodpil ='90' or kodpil ='91' or kodpil ='60' or kodpil ='65' or kodpil ='67' or kodpil ='40'
*pack
*browse
*CLOS ALL

*use z_p
*index on kodpil to r10

*sele 1
*USE D:\ARM\VODA\PIL_MOY.DBF
*browse
*sele 2
*use D:\ARM\VODA\z_p
*index on KODBK to ir comp
*sele 1
*set relat to KODBK into z_p
**set relat to ind_pod into z_p
*repl all idcode with z_p.Ind_pod  
*repl all PROS with z_p.n_posv
*repl all lgkat with z_p.kodpil_s 
*repl all fio with z_p.fiopil 



*browse
*clos all
use PIL_MOY
copy fields cdpr,idcode,fio,PROS,rs,yearin,monthin,lgcode,DATA1,DATA2,lgkol,LGKAT,lgprc,summ,fact,tarif,flag to woda_pil1
clos all

*sele 1
*create table D1:\ARM\VODA\1.dbf (kanal N(1),kodn C(2),kodnor C(2))

*APPEND FROM woda_pil1.DBF
*browse
