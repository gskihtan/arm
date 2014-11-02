********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovnor in 1 order tag kodnor
use narax in 2 order tag kodnor
select dovnor
set relat to kodnor into narax

******************** DEFINES *************************

define wind w from 2,2 to 20,76;
	panel color schem 10;
    title [ Довўдник норм витрат води ]

************** BEGIN PROGRAMM ************************

do p_onkey
@ 24,0 say padr([ INS Hовий │ DEL Знищити │]+;
				[ F4 Ред. │ F12 Друк │ ESC Вихўд │],75) color &m_mescolor
browse window w field;
	kodnor :r :h=[Код],;
	naznor :r :h=[Hазва норми],;
	ov	   :r :h=[Об.води],;
	tvod   :r :h=[Цўна за воду],;
	tstok  :r :h=[Цўна за стоки];
    NOAPPEND NODELETE NOEDIT
do p_offkey
set relat to
pack

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
proc p_onkey
*****************
on key label F4  do p_edit
on key label INS do p_append
on key label DEL do p_delete
on key label F12 do p_print with [dovnor]

*****************
proc p_offkey
*****************
on key label F4  
on key label INS 
on key label DEL 
on key label F12

******************************************************
proc p_append
******************************************************
do p_offkey

DEFINE WINDOW wappend ;
		FROM INT((SROW()-18)/2),INT((SCOL()-40)/2) ;
		TO INT((SROW()-18)/2)+17,INT((SCOL()-40)/2)+39 ;
		TITLE " Hовий запис " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wappend

@ 1,3 SAY "Код норми"
@ 3,3 SAY "Hазва норми"
@ 6,14 SAY "Об'їм"
@ 6,26 SAY "Цўна"
@ 8,4 SAY "Вода"
@ 10,4 SAY "Стоки"
@ 7,2 TO 7,35 COLOR W/RB    
@ 9,2 TO 9,35 COLOR W/RB    
@ 6,12 TO 10,12 COLOR W/RB    
@ 6,24 TO 10,24 COLOR W/RB    
@ 14,13 SAY "[ Записати ]"

scatter memvar blank

@ 1,16 GET m.kodnor;
	valid not seek(m.kodnor) and len(allt(m.kodnor))=2;
	error [ Код вже ўснуї або некоректний ]
@ 3,16 GET m.naznor;
	valid not empty(m.naznor);
	error [ Введўть назву норми ]
@ 8,14 GET m.ov size 1,9
@ 8,26 GET m.tvod size 1,9
@ 10,26 GET m.tstok size 1,9
@ 14,13 get msel pict [@*IT] size 1,12 defa 1 valid p_aOK()

READ CYCLE MODAL NOMOUSE
RELE WIND wappend
do p_onkey
return

*//////////////
func p_aOK
*//////////////
insert into dovnor from memvar
return

*****************
proc p_delete
*****************
do p_offkey
if recc()=0
	wait wind nowait [ Довўдник порожнўй ]
	do p_onkey
	return
endif
if narax.kodnor==dovnor.kodnor
	wait wind nowait [ Hеможливо знищити,ўснують нарахування ]
else
	if deleted()
		if p_confirm(" Вўдновити ? ",.t.)
			recall
		endif
	else
		mcc=[Знищити запис#]+allt(naznor)+[ ?]
		if p_confirm(mcc,.t.)
			delete
		endif
	endif
endif
do p_onkey

******************************************************
proc p_edit
******************************************************
do p_offkey
if recc()=0
	wait wind nowait [ Довўдник порожнўй ]
	do p_onkey
	return
endif

DEFINE WINDOW wedit ;
		FROM INT((SROW()-18)/2),INT((SCOL()-40)/2) ;
		TO INT((SROW()-18)/2)+17,INT((SCOL()-40)/2)+39 ;
		TITLE " Редагування " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wedit

@ 1,3 SAY "Код норми"
@ 3,3 SAY "Hазва норми"
@ 6,14 SAY "Об'їм"
@ 6,26 SAY "Цўна"
@ 8,4 SAY "Вода"
@ 10,4 SAY "Стоки"
@ 7,2 TO 7,35 COLOR W/RB    
@ 9,2 TO 9,35 COLOR W/RB    
@ 6,12 TO 10,12 COLOR W/RB    
@ 6,24 TO 10,24 COLOR W/RB    
@ 14,13 SAY "[ Записати ]"

scatter memvar
mrec=recn()

@ 1,16 GET m.kodnor when .f.
@ 3,16 GET m.naznor;
	valid not empty(m.naznor);
	error [ Введўть назву норми ]
@ 8,14 GET m.ov size 1,9
@ 8,26 GET m.tvod size 1,9
@ 10,26 GET m.tstok size 1,9
@ 14,13 get msel pict [@*IT] size 1,12 defa 1 valid p_eOK()

READ CYCLE MODAL NOMOUSE OBJECT 3
RELE WIND wedit
do p_onkey
return

*//////////////
func p_eOK
*//////////////
goto mrec
gather memvar
return
