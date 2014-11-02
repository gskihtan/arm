********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************
******************** DEFINES *************************
	DEFINE WINDOW wpil ;
		FROM INT((SROW()-9)/2),INT((SCOL()-49)/2) ;
		TO INT((SROW()-9)/2)+8,INT((SCOL()-49)/2)+48 ;
		TITLE " Друк паспорту чорнобильцўв " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │ ],75) color &m_mescolor


ACTIVATE WINDOW wpil
@ 3,2 SAY "Код пўльги"
@ 6,18 SAY "[ Друк ]"
@ 3,16 SAY "-"
@ 5,0 TO 5,46 COLOR W/RB    
@ 1,7 SAY "Дата......."

@ 1,18 GET mdate SIZE 1,10 DEFAULT date()
@ 3,13 GET mkodpil SIZE 1,2 DEFAULT [50] VALID fv_kod()
@ 3,18 GET mnazpil SIZE 1,20 DEFAULT " " WHEN .f.
@ 6,18 GET ms_print PICT [@*I] SIZE 1,8 defa 1 VALID fv_print() 

READ CYCLE MODAL
RELEASE WINDOW wpil

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
func fv_kod
*********************
use dovpil order kodpil
if seek(mkodpil)
	mnazpil=nazpil
else
	mnazpil=[Код не знайдено]
endif
show gets
use

*********************
func fv_print
*********************
wait wind nowait [ Хвилинку! ]

select;
	zpilga.kodbk,;
	zpilga.n_posv,;
	zpilga.date,;
	zpilga.kc,;
	zpilga.dv,;
	zpilga.gr,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
    dovpil.kodpil,;
    dovpil.nazpil;
    from zpilga,dovad,dovvul,dovpil;
    where zpilga.kodbk==dovad.kodbk;
    	and zpilga.kodpil==dovpil.kodpil;
    	and dovad.kodv==dovvul.kodv;
    	and zpilga.kodpil==mkodpil;
    into dbf out;
    order by zpilga.kodbk
close data
wait clear

use out
*brow normal
do p_print with [prn_pcho]
close data
