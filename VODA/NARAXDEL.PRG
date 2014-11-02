********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

select 0
use dovvul order kodv

select 0
use dovad order kod
set relat to kodv into dovvul

select 0
use narax order kodbk

select 0
use lich order kodbk

select 0
use zpilga order kodbk

******************** DEFINES *************************

DEFINE WINDOW wnardel ;
		FROM INT((SROW()-10)/2),INT((SCOL()-50)/2) ;
		TO INT((SROW()-10)/2)+9,INT((SCOL()-50)/2)+49 ;
		TITLE " Лўквўдацўя абонента " ;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW ;
		SYSTEM ;
		COLOR SCHEME 8


************** BEGIN PROGRAMM ************************

ACTIVATE WINDOW wnardel

m.kodbk=space(7)
merr=[]
@ 1,19 GET m.kodbk when fw_kodbk() valid fv_kodbk();
	error merr

READ CYCLE MODAL
RELEASE WINDOW wnardel

wait wind nowait [ Хвилинку ]
select narax
pack
select lich
pack
select zpilga
pack
wait clear

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************************
func fw_kodbk
*****************************
activ screen
@ 24,0 say padr([ F1 Пошук │ ],75) color &m_mescolor
activ wind wnardel
on key label f1 do p_poshuk
clear
@ 1,2 SAY "Особовий рахунок"
@ 3,2 SAY "Прўзвище -"
@ 4,2 SAY "Адреса   -"
@ 6,17 SAY "[ Лўквўдувати ]"
select dovad

*****************************
func fv_kodbk
*****************************
activ screen
@ 24,0 say padr([],75) color &m_mescolor
activ wind wnardel
on key label f1
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
select dovad
if not seek(mkod)
        on key label f1 do p_poshuk
        merr=[Не можу знайти рахунок]
        return .f.
endif
m.kodbk=dovad.kodbk
m.fio=dovad.fio
select narax
if not seek(m.kodbk)
        on key label f1 do p_poshuk
        merr=[Не можу знайти нарахувань]
        return .f.
endif
if saldn<>0
        on key label f1 do p_poshuk
        merr=[Не можу знищити, ненульове сальдо]
        return .f.
endif
show gets
@ 4,13 say padr(dovvul.vul,20)+padr(allt(dovad.bud)+;
       iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]),8)

@ 3,13 get m.fio
@ 6,17 get msel pict [@*IT] size 1,15 defa 1 valid fv_del()
read modal cycle

m.kodbk=space(7)

**********************
func fv_del
**********************
select dovad
repl fio with m.fio

select narax
seek m.kodbk
delete while kodbk==m.kodbk

select lich
seek m.kodbk+chr(0)
delete while kodbk==m.kodbk

select zpilga
seek m.kodbk
delete while kodbk==m.kodbk

wait wind [ Абонент лўквўдований ] nowait

