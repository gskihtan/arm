********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovvul in 1 order tag kodv
use dovad in 2 order tag adr
select dovvul

******************** DEFINES *************************

define wind w from 2,2 to 22,41;
	panel color schem 10;
    title [ �������� �㫨�� ]

************** BEGIN PROGRAMM ************************

do p_onkey
@ 24,0 say padr([ INS H���� � DEL ����� �]+;
				[ F4 ���. � F12 ��� � ESC ����� �],75) color &m_mescolor
browse window w field;
	kodv   :r :h=[��� �㫨��],;
	vul    :r :h=[H���� �㫨��];
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
on key label F12 do p_print with [dovvul]

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
		FROM INT((SROW()-9)/2),INT((SCOL()-45)/2) ;
		TO INT((SROW()-9)/2)+8,INT((SCOL()-45)/2)+44 ;
		TITLE " H���� ����� " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wappend 

@ 5,15 SAY "[ ������ ]"
@ 1,2 SAY "��� �㫨��"
@ 3,2 SAY "H���� �㫨��"

scatter memvar blank

@ 1,16 GET m.kodv valid not seek(m.kodv);
	and len(allt(m.kodv))=4;
	error [ ��� ����४⭨� ��� ��� ���� ] 
@ 3,16 GET m.vul valid not empty(allt(m.vul));
	error [ ������� ����� �㫨�� ] 
@ 5,15 get msel pict [@*IT] defa 1 size 1,12 valid p_aOK()

READ CYCLE NOMOUSE MODAL
RELE WIND wappend
do p_onkey
return

*//////////////
func p_aOK
*//////////////
insert into dovvul from memvar
return

*****************
proc p_delete
*****************
do p_offkey
if recc()=0
	wait wind nowait [ �������� ��஦��� ]
	do p_onkey
	return
endif
select dovad
seek dovvul.kodv
select dovvul
if dovvul.kodv==dovad.kodv
	wait wind nowait [ H�������� ����� ]
else
	if deleted()
		if p_confirm([�������� ����� "]+allt(vul)+[" ?],.t.)
			recall
		endif
	else
		mcc=[����� ����� "]+allt(vul)+[" ?]
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
	wait wind nowait [ �������� ��஦��� ]
	do p_onkey
	return
endif

DEFINE WINDOW wedit ;
		FROM INT((SROW()-9)/2),INT((SCOL()-45)/2) ;
		TO INT((SROW()-9)/2)+8,INT((SCOL()-45)/2)+44 ;
		TITLE " �����㢠� " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wedit

@ 5,15 SAY "[ ������ ]"
@ 1,2 SAY "��� �㫨��"
@ 3,2 SAY "H���� �㫨��"

scatter memvar

@ 1,16 GET m.kodv when .f.
@ 3,16 GET m.vul valid not empty(allt(m.vul));
	error [ ������� ����� �㫨�� ] 
@ 5,15 get msel pict [@*IT] defa 1 size 1,12 valid p_eOK()

READ CYCLE NOMOUSE MODAL
RELE WIND wedit
do p_onkey
return

*//////////////
func p_eOK
*//////////////
gather memvar
return
