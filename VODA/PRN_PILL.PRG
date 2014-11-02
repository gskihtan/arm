********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovpil order kodpil
count to np
declare a_pil [np+1]
go top
for i=2 to np+1
	a_pil[i]=kodpil+[ ]+nazpil
	if not eof()
		skip
	endif
endfor

index on group to ig unique
count to ng
declare a_group [ng+1]
go top
for i=2 to ng+1
	a_group[i]=group+[ ]+nazpil
	if not eof()
		skip
	endif
endfor

store [Всў пўльги] to a_pil[1],a_group[1]
declare a[np+1]
for i=1 to np+1
	a[i]=a_pil[i]
next

******************** DEFINES *************************

	DEFINE WINDOW wpil ;
		FROM INT((SROW()-16)/2),INT((SCOL()-51)/2) ;
		TO INT((SROW()-16)/2)+15,INT((SCOL()-51)/2)+50 ;
		TITLE " Друк списку пўльговикўв " ;
		FLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │ ],75) color &m_mescolor

ACTIVATE WINDOW wpil
@ 11,2 SAY "[ Список     ]"
@ 12,2 SAY "[ Фўн.вўддўл ]"

@ 2,2 GET ms_pil   PICTURE "@*C Пўльга"      DEFAULT 1 valid fv_sel(1)
@ 3,2 GET ms_group PICTURE "@*C Група пўльг" DEFAULT 0 valid fv_sel(2)
@ 0,20 GET ms_mpil PICTURE "@&N" from a ;
	SIZE 15,28 defa 1 COLOR SCHEME 6
@ 11,2 GET ms_doit1 PICTURE "@*IVN " ;
	SIZE 1,14,1 DEFAULT 0 VALID fv_prnlist()
@ 12,2 GET ms_doit2 PICTURE "@*IVN " ;
	SIZE 1,14,1 DEFAULT 0 VALID fv_prnfinv() disabled

READ CYCLE MODAL
RELEASE WINDOW wpil

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
func fv_sel
*********************
parameter nom
if nom=1
	ms_pil=1
	ms_group=0
	ms_mpil=1
	declare a[np+1]
	for i=1 to np+1
		a[i]=a_pil[i]
	next
	show get ms_doit1  enabled
	show get ms_doit2  disabled
	show gets
	_curobj=objnum(ms_mpil)
else
	ms_pil=0
	ms_group=1
	ms_mpil=1
	declare a[ng+1]
	for i=1 to ng+1
		a[i]=a_group[i]
	next
	show get ms_doit1  enabled
	show get ms_doit2  enabled
	show gets
	_curobj=objnum(ms_mpil)
endif
	
*********************
func fv_prnlist
*********************
wait wind nowait [ Хвилинку! ]
do case
case ms_pil=1
	if ms_mpil=1
		mfilter=[.t.]
	else
		mfilter="dovpil.kodpil==subs(a[ms_mpil],1,2)"
	endif
case ms_group=1
	if ms_mpil=1
		mfilter=[.t.]
	else
		mfilter="dovpil.group==subs(a[ms_mpil],1,1)"
	endif
endcase

select;
	zpilga.kodbk,;
	zpilga.n_posv,;
	padr(zpilga.fiopil,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
    dovpil.kodpil,;
    dovpil.group,;
    dovpil.nazpil;
    from zpilga,dovad,dovvul,dovpil;
    where zpilga.kodbk==dovad.kodbk;
    	and zpilga.kodpil==dovpil.kodpil;
    	and dovad.kodv==dovvul.kodv;
    	and &mfilter;
    into dbf out;
    order by dovpil.group,dovpil.kodpil,zpilga.kodbk
close data
wait clear

use out
*brow normal
do p_print with [prn_pill]
use in out

*********************
func fv_prnfinv
*********************

wait wind nowait [ Хвилинку! ]

if ms_mpil=1
	mfilter=[.t.]
else
	mfilter="dovpil.group==subs(a[ms_mpil],1,1)"
endif

select;
	zpilga.kodbk,;
	zpilga.kodpil,;
	iif(zpilga.del, 000, 001) as cntpil;
	from zpilga,dovpil;
	into dbf outcnt;
	where zpilga.kodpil == dovpil.kodpil and &mfilter;
	 and dovpil.user == [P];
	order by zpilga.kodbk

select;
	zpilga.kodbk,;
	zpilga.kodpil,;
	dovpil.kodpil1,;
	sum(1) as cntpil;
	from zpilga,dovpil;
	into dbf outcnt1;
	where zpilga.kodpil == dovpil.kodpil and &mfilter;
	 and dovpil.user == [U];
	 and not zpilga.del;
	order by zpilga.kodbk,dovpil.kodpil1;
	group by zpilga.kodbk,dovpil.kodpil1

index on kodbk + kodpil1 to i comp
select outcnt
set relat to kodbk + kodpil into outcnt1
repl all cntpil with iif(eof([outcnt1]),cntpil,cntpil+outcnt1.cntpil)  

close data

MAX_OV_PIL = 4

select;
	zpilga.kodbk,;
	zpilga.kodpil,;
	dovpil.group,;
	dovpil.nazpil,;
	0000000 as nom,;
	padr(zpilga.fiopil,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
	dovpil.pil as proc,;
	round(narax.ov/narax.kprop,2) as ov,;
	round(narax.ost/narax.kprop,2) as ost,;
	round( iif(narax.ov/narax.kprop < MAX_OV_PIL, narax.ov/narax.kprop, MAX_OV_PIL)*dovnor.tvod*dovpil.pil/100, 4) as sv_4,;
	round( iif(narax.ost/narax.kprop < MAX_OV_PIL, narax.ost/narax.kprop, MAX_OV_PIL)*dovnor.tstok*dovpil.pil/100, 4) as st_4,;
	0000000.00 as sv,;
	0000000.00 as st,;
	00000 as cntpil;
    from zpilga,dovad,dovvul,dovpil,narax,dovnor;
    where zpilga.kodbk==dovad.kodbk;
    	and zpilga.kodbk==narax.kodbk;
    	and narax.kodn==dovnor.kodnor;
    	and zpilga.kodpil==dovpil.kodpil;
    	and dovad.kodv==dovvul.kodv;
    	and &mfilter and dovpil.user == [P];
		and not zpilga.del;
	into dbf out1;
    order by zpilga.kodbk

select 0
use outcnt
index on outcnt.kodbk+outcnt.kodpil to i comp
select out1
set relat to kodbk+kodpil into outcnt
repl all cntpil with outcnt.cntpil
   
close data
wait clear

use out1
repl all ov with ov*cntpil,;
	ost with ost*cntpil,;
	sv with round(sv_4*cntpil, 2),;
	st with round(st_4*cntpil, 2)
select * from out1 into dbf out order by out1.group,out1.kodpil,out1.adr
use in out1

brow normal
do p_print with [prn_p10]
use in out
