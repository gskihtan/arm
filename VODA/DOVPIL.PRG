********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovpil in 1 order tag kodpil
use zpilga in 2 order tag kodpil
select dovpil
set relat to kodpil into zpilga

******************** DEFINES *************************

define wind w from 2,2 to 20,68;
	panel color schem 10;
    title [ �������� ���� ]

************** BEGIN PROGRAMM ************************

do p_onkey
@ 24,0 say padr([ INS H���� � DEL ����� �]+;
				[ F4 ���. � F12 ��� � ESC ����� �],75) color &m_mescolor
browse window w field;
	kodpil :r :h=[��� ���죨],;
	nazpil :r :h=[H���� ���죨],;
	us = iif(user=[U],[�����㢠�],iif(user=[P],[���������],[])) :10 :h=[],;
	kodpil1 :h=[���1] :w= user==[U] ,;
	pil	   :r :h=[��業� ���죨],;
	group  :r :h=[��.];
    NOAPPEND NODELETE
do p_offkey
set relat to
pack

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
proc p_onkey
*****************
on key label F4  do p_edit with [EDIT]
on key label INS do p_edit with [CREATE]
on key label DEL do p_delete
on key label F12 do p_print with [dovpil]

*****************
proc p_offkey
*****************
on key label F4  
on key label INS 
on key label DEL 
on key label F12

******************************************************
proc p_edit
******************************************************
parameter mode
push key
on key
if mode==[CREATE]
	MTITLE = " H���� ����� "
	scatter memvar blank
	kod_access=.t.
else
	select dovpil
	if eof()
		wait wind nowait [ �������� ��஦��� ]
		pop key
		return
	endif
	MTITLE = " �����㢠��� "
	scatter memvar
	mrecno=recno()
	kod_access=.f.
endif
	
DEFINE WINDOW wedit;
		FROM INT((SROW()-13)/2),INT((SCOL()-45)/2) ;
		TO INT((SROW()-13)/2)+12,INT((SCOL()-45)/2)+44 ;
		TITLE MTITLE;
		FLOAT NOCLOSE SHADOW DOUBLE COLOR SCHEME 5
ACTIVATE WINDOW wedit
@ 1,2  SAY "��� ���죨......." COLOR W/RB    
@ 2,2  SAY "��� ���죨 ���.." COLOR W/RB
@ 3,2  SAY "H����" COLOR W/RB    
@ 5,2  SAY "��業�" COLOR W/RB    
@ 7,2  SAY "�������" COLOR W/RB    
@ 3,31 SAY "��㯠" COLOR W/RB    
@ 7,27 SAY "[ ������ ]"
@ 6,26 TO 8,39 COLOR W/RB    

@ 1,18 GET m.kodpil ;
	valid not seek(m.kodpil) and len(allt(m.kodpil))=3;
	when kod_access;
	error [ ��� ��� ���� ��� ����४⭨� ]
@ 3,10 GET m.nazpil;
	valid not empty(m.nazpil);
	error [ ������� ����� ���죨 ]
@ 3,37 GET m.group
@ 5,10 GET m.pil SIZE 1,3;
	valid between(m.pil,0,100);
	error [ H���୥ ���祭�� ]
@ 6,10 GET ms_user PICTURE "@^ ���죮���;�����㢠�" SIZE 3,14 ;
	DEFAULT IIF(m.user=[P],1,iif(m.user=[U],3,0));
	COLOR SCHEME 5, 6;
	VALID fv_user()
@ 7,27 get msel pict [@*IT] defa 1 size 1,12 valid p_save()

READ CYCLE MODAL
RELE WIND wedit
pop key

***********************
func fv_user
***********************
m.user=iif(ms_user=1,[P],[U])

***********************
func p_save
***********************
if mode=[CREATE]
	insert into dovpil from memvar
else
	select dovpil
	goto mrecno
	gather memvar
endif

*****************
proc p_delete
*****************
do p_offkey
if recc()=0
	wait wind nowait [ �������� ��஦��� ]
	do p_onkey
	return
endif
if dovpil.kodpil==zpilga.kodpil
	wait wind nowait [ H�������� �����,������ ����㢠��� ]
else
	if deleted()
		if p_confirm([ �������� "]+allt(nazpil)+[" ?],.t.)
			recall
		endif
	else
		mcc=[����� "]+allt(nazpil)+[" ?]
		if p_confirm(mcc,.t.)
			delete
		endif
	endif
endif
do p_onkey

