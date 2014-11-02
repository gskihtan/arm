********************* SETUP **************************
do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************
	DEFINE WINDOW _0k30anmd2 ;
		FROM INT((SROW()-9)/2),INT((SCOL()-47)/2) ;
		TO INT((SROW()-9)/2)+8,INT((SCOL()-47)/2)+44 ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		DOUBLE ;
		COLOR SCHEME 5
************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │ ],75) color &m_mescolor

ACTIVATE WINDOW _0k30anmd2

@ 2,5 SAY "Друк перерахункўв на" SIZE 1,20, 0
@ 2,26 GET m.date SIZE 1,10 DEFAULT ctod([01]+subs(dtoc(date()),3))
@ 5,19 SAY "[ OK ]" SIZE 1,6, 0
@ 5,19 GET msel PICTURE "@*IT" SIZE 1,6,1 ;
	DEFAULT 0 VALID do_print()

READ CYCLE MODAL
RELEASE WINDOW _0k30anmd2

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

func do_print
select * from narax2,dovad;
	where narax2.kodbk==dovad.kodbk;
	into dbf outper
use in dovad
use in narax2
index on kodbk_a to i
select outper
do p_print with [naraxper]
use in outper
