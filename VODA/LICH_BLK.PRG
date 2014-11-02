*
* „àãª ¡« ­ª÷¢ «÷ç¨«ì­¨ª÷¢
*
********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

DEFINE WINDOW wlich ;
		FROM INT((SROW()-8)/2),INT((SCOL()-60)/2) ;
		TO INT((SROW()-8)/2)+9,INT((SCOL()-60)/2)+65 ;
		TITLE " „à ª ¡« ­ª÷¢ ­  «÷ç¨«ì­¨ª¨ " ;
		NOFLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE ;
		COLOR SCHEME 1

************** BEGIN PROGRAMM ************************

ACTIVATE WINDOW wlich

@ 1,2 SAY "[ ‚á÷å  ¡®­¥­â÷¢  ]" 
@ 2,2 SAY "[ ® ¤÷«ì­¨æ÷     ] -"
@ 3,2 SAY "[ ® ¢ã«¨æ÷       ] -"
@ 4,2 SAY "[ ® ®á. à åã­ª å ] -"
@ 2,24 SAY "¤÷«ì­¨æï ü" COLOR W/B    
@ 3,24 SAY "¢ã«¨æï"		COLOR W/B    
@ 4,24 SAY "§" 			COLOR W/B    
@ 4,35 SAY "¯®"			COLOR W/B    
@ 6,26 SAY "[ „àãª ]"

@ 1,2 GET msf_all PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_all()
@ 2,2 GET msf_dil PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_dil()
@ 3,2 GET msf_vul PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_vul()
@ 4,2 GET msf_kod PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_kod()

@ 6,26 GET ms_print PICTURE "@*IVN " SIZE 1,8 ;
	DEFAULT 0 VALID fv_print() DISABLED

store [] to m.kodv,m.dil,m.kodbk1,m.kodbk2,m.vul,m.bud,mfilter

READ CYCLE
RELEASE WINDOW wlich

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
func fv_all
*********************
show get ms_print enabled
mfilter=[.t.]
_curobj=5

*********************
func fv_dil
*********************
@ 2,35 GET m.dil SIZE 1,1
read
if last()=27
	return
endif

select 0
use dovad order kodbk
seek(m.dil)
mdilexist=subs(kodbk,1,1)==m.dil
use

if not mdilexist
	wait wind nowait [ „÷«ì­¨æî ­¥ §­ ©¤¥­® ]
else
	mfilter=[subs(lich.kodbk,1,1)==m.dil]
	show get ms_print enabled
	_curobj=5
endif

*********************
func fv_vul
*********************
@ 3,35 GET m.vul SIZE 1,25
read
if last()=27
	return
endif

use dovvul order vul
define popup pvul prom field dovvul.vul;
        from 0,35 color scheme 2 marg shad
on select popup pvul deact popup
m.vul=chrtran(m.vul,[©æãª¥­£èé§åóä¨¢ ¯à®«¤¦õïçá¬÷âì¡îù],;
   [‰–“Š…]+CHR(141)+[ƒ˜™‡•ò”ˆ‚€Ž‹„†ôŸ—‘Œö’œžø])
seek(m.vul)
activ popup pvul rest
if last()=27
	use
    return .f.
endif
m.kodv=dovvul.kodv
m.vul=dovvul.vul
use
@ 3,35 say padr(m.vul,25) color w+/gb
@ 4,51 say [¡ã¤.] GET m.bud SIZE 1,4
read
if last()=27
	return
endif
mfilter=[dovad.kodv==m.kodv]
if not empty(m.bud)
	mfilter=mfilter+[ and dovad.bud==m.bud]
endif
show get ms_print enabled
_curobj=5

*********************
func fv_kod
*********************
*use dovad order (vul+bud+kvar)
use dovad order kod
@ 4,26 GET m.kodbk1 SIZE 1,7 valid fv_kodbk(1)
@ 4,38 GET m.kodbk2 SIZE 1,7 valid fv_kodbk(2)
read
if last()=27
	return
endif
use
mfilter=[lich.kodbk>=m.kodbk1 and lich.kodbk<=m.kodbk2]
show get ms_print enabled
_curobj=5

**********************
func fv_kodbk
**********************
parameter m12
m.kodbk=iif(m12=1,m.kodbk1,m.kodbk2)
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
if not seek(mkod)
		wait wind nowait [  åã­®ª ­¥ §­ ©¤¥­® ]
        return .f.
endif
if m12=1
	m.kodbk1=kodbk
else
	m.kodbk2=kodbk
endif
show gets

********************
func fv_print
********************
wait wind nowait [ •¢¨«¨­ªã! ]
select;
	lich.kodbk,;
	lich.lich,;
	lich.n_lich,;
	lich.hvoda,;
	lich.pokn,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr;
    from lich,dovad,dovvul;
	into dbf out;
	where dovad.kodv==dovvul.kodv and lich.kodbk==dovad.kodbk;
		and &mfilter;
	order by dovad.kodbk,lich.lich
*browse
wait clear
do p_print with [lich_blk]
*brow
close data