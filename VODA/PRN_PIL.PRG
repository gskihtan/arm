********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovpil order kodpil
index on group to i unique
count to mc
declare a_group [mc+1]
go top
for i=2 to mc+1
	a_group[i]=group+[ ]+nazpil
	if not eof()
		skip
	endif
endfor
a_group[1]=[Всў пўльги]
set index to

******************** DEFINES *************************
DEFINE WINDOW wpil ;
		FROM INT((SROW()-16)/2),INT((SCOL()-59)/2) ;
		TO INT((SROW()-16)/2)+15,INT((SCOL()-59)/2)+58 ;
		TITLE " Друк даних про пiльги " ;
		FLOAT NOCLOSE SHADOW DOUBLE COLOR SCHEME 5

DEFINE POPUP pop_pil;
	PROMPT FIELD kodpil+[ ]+nazpil ;
	SCROLL MARGIN MARK ""

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │ ],75) color &m_mescolor

ACTIVATE WINDOW wpil
@ 1,2 SAY "за"
@ 3,2 SAY "Група :"
@ 12,8 SAY "[ Друкувати ]"
@ 7,2 TO 10,27 COLOR W/RB    

@ 1,5 GET ms_date defa date()
@ 4,2 GET ms_group PICTURE "@^" FROM a_group;
  SIZE 3,25 DEFAULT 1 COLOR SCHEME 5, 6 VALID fv_group()
@ 8,4 GET ms_norm PICTURE "@*C Hорма"		SIZE 1,9 DEFAULT 0
@ 9,4 GET ms_lich PICTURE "@*C Лiчильник"	SIZE 1,13 DEFAULT 0
@ 12,8 GET ms_doit PICTURE "@*IVN " ;
	SIZE 1,13,1 DEFAULT 0 VALID fv_doit()
@ 0,29 GET ms_pil PICTURE "@&N" POPUP pop_pil ;
	SIZE 15,26 DEFAULT " " COLOR SCHEME 6 when .f.

READ CYCLE MODAL
RELEASE WINDOW wpil
RELEASE POPUPS pop_pil

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
function fv_group
*********************
select dovpil
if ms_group=1
	set filter to
else
	set filter to group==left(a_group[ms_group],1)
endif
show get ms_pil

*********************
func fv_doit
*********************
wait wind nowait [ Хвилинку! ]
mgr=[]
if ms_group=1
	mfiltg=[.t.]
else
	mgr=subs(a_group[ms_group],1,1)
	mfiltg=[dovpil.group==mgr]
endif

do case
	case ms_lich=1 and ms_norm=0	
		mfiltn=[out1.kodn='08']
	case ms_lich=0 and ms_norm=1	
		mfiltn=[out1.kodn#'08']
	case ms_lich=1 and ms_norm=1	
		mfiltn=[.t.]
	case ms_lich=0 and ms_norm=0	
		mfiltn=[.f.]
endcase

MAX_OV_PIL = 4

select;
	zpilga.kodpil,;
	iif(dovpil.user==[P],1,0) as cntpil,;
	iif(dovpil.user==[P],0,1) as cntuse,;
	narax.ov/narax.kprop  as ov,;
	narax.ost/narax.kprop as ost,;
	round( iif(narax.ov/narax.kprop < MAX_OV_PIL, narax.ov/narax.kprop, MAX_OV_PIL)*dovnor.tvod*dovpil.pil/100, 4) as sv,;
	round( iif(narax.ost/narax.kprop < MAX_OV_PIL, narax.ost/narax.kprop, MAX_OV_PIL)*dovnor.tstok*dovpil.pil/100, 4) as st,;
	narax.kodn;
	from zpilga,dovpil,narax,dovnor;
	into dbf out1;
	where zpilga.kodpil==dovpil.kodpil;
		and zpilga.kodbk==narax.kodbk;
		and narax.kodn==dovnor.kodnor;
		and not zpilga.del

select;
	out1.kodpil,;
	dovpil.nazpil,;
	dovpil.pil,;
	sum(out1.cntpil) as cntpil,;
	sum(out1.cntuse) as cntuse,;
	sum(out1.ov)  as ov,;
	sum(out1.ost) as ost,;
	round(sum(out1.sv),2)  as sv,;
	round(sum(out1.st),2)  as st;
	from out1,dovpil;
	into dbf out;
	where out1.kodpil==dovpil.kodpil and &mfiltg and &mfiltn;
	order by out1.kodpil;
	group by out1.kodpil

use in narax
use in zpilga
use in out1	
wait clear

select 0
use dovnor order kodnor again
if ms_lich=1
	seek [08]
else
	seek [01]
endif
mtvod=tvod
mtstok=tstok
use

select out
if mgr==[3]
	do p_print with [pilgr_ch]
else
	do p_print with [pilgr]
endif
use in out
