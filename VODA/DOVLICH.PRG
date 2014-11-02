********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovlich in 1 order tag kodm
use lich in 2 order tag kodm
select dovlich
set relat to kodm into lich

******************** DEFINES *************************

define wind w from 2,2 to 15,43;
	panel color schem 10;
    title [ Довўдник лўчильникўв ]

************** BEGIN PROGRAMM ************************

do p_onkey
@ 24,0 say padr([ INS Hовий │ DEL Знищити │]+;
				[ F4 Ред. │ F12 Друк │ ESC Вихўд │],75) color &m_mescolor
browse window w field;
	kodm   :r :h=[Код марки],;
	marka  :r :h=[Марка лўчильника],;
	maxp   :r :h=[Розряднўсть];
    NOAPPEND NODELETE NOEDIT
do p_offkey
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
on key label F12 do p_print with [dovlich]

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
		FROM INT((SROW()-7)/2),INT((SCOL()-42)/2) ;
		TO INT((SROW()-7)/2)+6,INT((SCOL()-42)/2)+41 ;
		TITLE " Hовий запис " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wappend 
scatter memvar blank

@ 3,25 SAY "[ Записати ]"
@ 1,2 SAY "Код марки"
@ 2,2 SAY "Марка"
@ 3,2 SAY "Розряднўсть"

@ 1,20 GET m.kodm valid not seek(m.kodm);
	and len(allt(m.kodm))=2;
	error [ Код некоректний або вже ўснуї ] 
@ 2,12 GET m.marka 
@ 3,20 GET m.maxp valid m.maxp>3 size 1,2;
	error [ Hевўрне значення ]
@ 3,25 get msel pict [@*IT] defa 1 size 1,12 valid p_aOK()

READ CYCLE NOMOUSE MODAL
RELE WIND wappend
do p_onkey
return

*//////////////
func p_aOK
*//////////////
insert into dovlich from memvar
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
if dovlich.kodm==lich.kodm
	wait wind nowait [ Hеможливо знищити ]
else
	if deleted()
		if p_confirm("       Вўдновити ?      ",.t.)
			recall
		endif
	else
		mcc=[Знищити запис ]+allt(marka)+[ ?]
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
		FROM INT((SROW()-7)/2),INT((SCOL()-42)/2) ;
		TO INT((SROW()-7)/2)+6,INT((SCOL()-42)/2)+41 ;
		TITLE " Редагування " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wedit 
scatter memvar 

@ 3,25 SAY "[ Записати ]"
@ 1,2 SAY "Код марки"
@ 2,2 SAY "Марка"
@ 3,2 SAY "Розряднўсть"

@ 1,20 GET m.kodm when .f.
@ 2,12 GET m.marka
@ 3,20 GET m.maxp valid m.maxp>3 size 1,2;
	error [ Hевўрне значення ]
@ 3,25 get msel pict [@*IT] defa 1 size 1,12 valid p_eOK()

READ CYCLE NOMOUSE MODAL
RELE WIND wedit
do p_onkey
return

*//////////////
func p_eOK
*//////////////
gather memvar
return
