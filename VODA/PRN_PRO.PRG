********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************
******************** DEFINES *************************

DEFINE WINDOW wstatl ;
		FROM INT((SROW()-17)/2),INT((SCOL()-40)/2) ;
		TO INT((SROW()-17)/2)+8,INT((SCOL()-40)/2)+40 ;
		TITLE " Статистика по вст. лўч. " ;
		FLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ESC Вихўд│],75) color &m_mescolor

ACTIVATE WINDOW wstatl
@ 1,2 SAY "Термўн :" 
@ 1,12 SAY "з" 
@ 3,11 SAY "по" 
@ 5,14 SAY "[ Друк ]"

@ 1,14 GET mdate1 defa date()
@ 3,14 GET mdate2 defa date()
@ 5,14 GET ms_print pict [@*IN] defa 1 size 1,8 valid fv_print()

READ CYCLE MODAL
RELEASE WINDOW wstatl

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
proc fv_print
*********************
select;
	lich.kodbk,;
	max(lich.date_vst) as date_vst;
from lich;
into dbf outlich;
where lich.date_vst >= mdate1 and lich.date_vst<=mdate2;
order by kodbk;
group by kodbk

use in lich
use in outlich

select;
	narax.kodnor,;
	sum(1) as cnt_ab,;
	sum(narax.kprop) as kprop,;
	dovnor.ov,;
	dovnor.naznor,;
	dovnor.tvod,;
	dovnor.tstok;
from narax, outlich, dovnor;
into dbf out;
where narax.kodbk == outlich.kodbk;
	and narax.kodnor == dovnor.kodnor;
order by narax.kodnor;
group by narax.kodnor

close data
use out
do p_print with [prn_pro]
close data
