********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

select 0
use dovvul order kodv
select 0
use dovad order kod
set relat to kodv into dovvul
select 0
use narax2 order kodbk
set relat to val(subs(kodbk,2)) into dovad


******************** DEFINES *************************

define wind wnar2 from 2,2 to 20,78	system color schem 8

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ F1 Пошук │ INS Hовий │ Ctrl+DEL Знищити │]+;
                                [ ESC Вих. │],75) color &m_mescolor

on key label f1 do posh1
on key label INS do pins
on key label Ctrl+DEL do pdel

go bott
set delete on
brow wind wnar2;
	field;
		kodbk           :h=[Ос.рах] :v=fv_kodbk(),;
		fio=f_adrf() :40 :h=[Абонент],;
		ovd             :h=[Об.води],;  
		ostd            :h=[Об.ст],;
		svd             :h=[S за воду],;
		std             :h=[S за ст],;
		memo            :h=[Примўтка]
set delete off

on key label f1
on key label INS
on key label Ctrl+DEL

delete all for empty(dovad.kodbk)
pack
close data

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

********************
proc posh1
********************
push key
on key
if empty(dovad.kodbk)
	do poshuk
	if m_result
		repl kodbk with m_kodbk
	endif
	show wind narax2 refresh
endif
pop key

**********************
proc pins
**********************
push key
on key
append blank
show wind narax2 refresh
pop key

**********************
proc pdel
**********************
push key
on key
mrec=recno()
count to m for not deleted()
if mrec>0 and mrec<=recc()
	goto mrec	
endif
if m=0
        wait wind nowait [ Таблиця порожня ]
else
        mcc=[Знищити запис#]+kodbk+[ ]+allt(dovad.fio)+[ ?]
           if p_confirm(mcc,.t.)
                  delete
           endif
endif
show wind narax2 refresh
pop key

*****************
func fv_kodbk
*****************
mkod=iif(len(allt(kodbk))=7,val(subs(kodbk,2)),val(kodbk))
select dovad
if seek(mkod)
	repl narax2.kodbk with kodbk
else
	repl narax2.kodbk with []
endif
select narax2
