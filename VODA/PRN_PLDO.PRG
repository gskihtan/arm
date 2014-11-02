********************* SETUP **************************

do p_prepare
color1=[gr+/br]
color2=[gb+/br]

****************** OPEN DATABASE *********************

use pv_1
index on kod to i1 comp

******************** DEFINES *************************

DEFINE WINDOW wpl ;
		FROM INT((SROW()-22)/2),INT((SCOL()-64)/2) ;
		TO INT((SROW()-22)/2)+21,INT((SCOL()-64)/2)+63 ;
		TITLE " Друк платўжного доручення " ;
		FLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE;
		COLOR SCHEME 5

******************************************************

ACTIVATE WINDOW wpl
@ 0,1 TO 12,60 COLOR W/RB    
@ 6,2 TO 6,59  COLOR W/RB    

@ 0,3 SAY "Платник" color w/br
@ 1,27 SAY "F1 - допомога" color w/br
@ 1,3 SAY "Код платника" 
@ 2,3 SAY "Платник" 
@ 3,3 SAY "Рахунок" 
@ 4,3 SAY "Банк платника" 
@ 5,3 SAY "Код банку" 
@ 5,44 SAY "ЗКПО" 

@ 6,3 SAY "Одержувач" color w/br
@ 7,3 SAY "Код одержувача"
@ 7,27 SAY "F1 - допомога" color w/br
@ 8,3 SAY "Одержувач" 
@ 9,3 SAY "Рахунок"
@ 10,3 SAY "Банк одержевача"
@ 11,3 SAY "Код банку"
@ 11,44 SAY "ЗКПО"

@ 13,2 SAY "Сума"
@ 13,13 SAY "Сума лўтерами"
@ 16,2 SAY "Призначення платежу"
@ 19,50 SAY "[ Друк ]"

@ 1,19 GET m.kod1 SIZE 1,7 DEFAULT " ";
	VALID fv_kod1() ERROR [ Код не знайдено ]
@ 7,19 GET m.kod2 SIZE 1,7 DEFAULT " ";
	VALID fv_kod2() ERROR [ Код не знайдено ]

@ 14,2  GET msum    SIZE 1,10 DEFAULT 0.00 VALID fv_sum()
@ 14,13 GET mssum   SIZE 2,47 DEFAULT " "
@ 17,2  GET mspryzn SIZE 2,58 DEFAULT " "
@ 19,50 GET ms_print pict [@*I] size 1,8 defa 1 valid fv_print()
push key
on key
on key label f1 do p_search
READ CYCLE MODAL
pop key
RELEASE WINDOW wpl
close data

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

******************
proc fv_kod1
******************
if not seek(m.kod1)
	return .f.
endif

@ 2,19 SAY pv_1.org_zak color &color1
@ 3,19 SAY pv_1.raxpl   color &color1
@ 4,19 SAY pv_1.bankpl  color &color1
@ 5,19 SAY pv_1.mfopl   color &color1
@ 5,49 SAY pv_1.zkpo    color &color1
copy to out1 next 1

******************
proc fv_kod2
******************
if not seek(m.kod2)
	return .f.
endif

@ 9,19  SAY pv_1.raxpl   color &color2
@ 8,19  SAY pv_1.org_zak color &color2
@ 10,19 SAY pv_1.bankpl  color &color2
@ 11,19 SAY pv_1.mfopl   color &color2
@ 11,49 SAY pv_1.zkpo    color &color2
copy to out2 next 1

******************
proc p_search
******************
mvar=varread()
if inlist(mvar,[KOD1],[KOD2])
	brow normal noedit noappend nodelete
	&mvar = kod
endif

******************
proc fv_print
******************
if not file([out1.dbf]) or not file([out2.dbf])
	return
endif
select 0
use out1
select 0
use out2
do p_print with [prn_pldo]
use in out1
use in out2
select pv_1

**********************
proc fv_sum
**********************
mssum=speeling(msum)
show gets