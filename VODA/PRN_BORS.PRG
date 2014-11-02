********************* SETUP **************************

do p_prepare
m.sborg=0.00

****************** OPEN DATABASE *********************


******************** DEFINES *************************

DEFINE WINDOW wb ;
		FROM INT((SROW()-14)/2),INT((SCOL()-64)/2) ;
		TO INT((SROW()-14)/2)+12,INT((SCOL()-64)/2)+63 ;
		TITLE " „àãª § ¡®à£®¢ £®áâ÷  ¡®­¥­â÷¢ " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc ‚¨å÷¤ ³ ],75) color &m_mescolor
ACTIVATE WINDOW wb

@ 1,2 SAY "„àãª § ¡®à£®¢ ­®áâ÷ ­ " COLOR W/RB    
@ 1,38 SAY "¡®à£ ¡÷«ìè¥ " COLOR W/RB    
@ 3,2 SAY "[ ‚á÷å  ¡®­¥­â÷¢  ]" 
@ 4,2 SAY "[ ® ¤÷«ì­¨æ÷     ] -"
@ 5,2 SAY "[ ® ¢ã«¨æ÷       ] -"
@ 6,2 SAY "[ ® ®á. à åã­ª å ] -"
@ 4,24 SAY "¤÷«ì­¨æï ü" COLOR W/RB    
@ 5,24 SAY "¢ã«¨æï"		COLOR W/RB    
@ 6,24 SAY "§" 			COLOR W/RB    
@ 6,35 SAY "¯®"			COLOR W/RB    
@ 9,26 SAY "[ „àãª ]"

m.date=ctod([01.]+subs(dtoc(date()),4))
@ 1,26 GET m.date 
@ 1,50 GET m.sborg size 1,10

@ 3,2 GET msf_all PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_all()
@ 4,2 GET msf_dil PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_dil()
@ 5,2 GET msf_vul PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_vul()
@ 6,2 GET msf_kod PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_kod()

@ 9,26 GET ms_print PICTURE "@*IVN " SIZE 1,8 ;
	DEFAULT 0 VALID fv_print() DISABLED

store [] to m.kodv,m.dil,m.kodbk1,m.kodbk2,m.vul,m.bud,mfilter
READ CYCLE MODAL
RELEASE WINDOW wb

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
func fv_all
*********************
show get ms_print enabled
mfilter=[.t.]
_curobj=6

*********************
func fv_dil
*********************
@ 4,35 GET m.dil SIZE 1,1
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
	mfilter=[subs(narax.kodbk,1,1)==m.dil]
	show get ms_print enabled
	_curobj=6
endif

*********************
func fv_vul
*********************
@ 5,35 GET m.vul SIZE 1,25
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
@ 5,35 say padr(m.vul,25) color w+/gb
@ 6,51 say [¡ã¤.] GET m.bud SIZE 1,4
read
if last()=27
	return
endif
mfilter=[dovad.kodv==m.kodv]
if not empty(m.bud)
	mfilter=mfilter+[ and dovad.bud==m.bud]
endif
show get ms_print enabled
_curobj=6

*********************
func fv_kod
*********************
use dovad order kod
@ 6,26 GET m.kodbk1 SIZE 1,7 valid fv_kodbk(1)
@ 6,38 GET m.kodbk2 SIZE 1,7 valid fv_kodbk(2)
read
if last()=27
	return
endif
use
mfilter=[narax.kodbk>=m.kodbk1 and narax.kodbk<=m.kodbk2]
show get ms_print enabled
_curobj=6

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

************************
func fv_print
************************
wait wind nowait [ •¢¨«¨­ªã! ]
select;
	narax.kodbk,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
	narax.saldn,;
	narax.subsn,;
	narax.subs,;
	narax.ugoda;
	from narax,dovad,dovvul;
	into dbf out;
	where dovad.kodv==dovvul.kodv and narax.kodbk==dovad.kodbk;
		and &mfilter and narax.saldn>=0;
order by narax.kodbk
wait clear
select out
set filter to saldn-subsn-subs>=m.sborg
browse
do p_print with [prn_borg]
close data
show get ms_print disabled
