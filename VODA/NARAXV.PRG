********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

select 0
use dovvul order kodv

select 0
use dovad order kod
set relat to kodv into dovvul

select 0
use dovpil order kodpil

select 0
use zpilga order kodbk
set filter to not deleted()
copy stru to $pilga

select 0
use dovnor order kodnor
set filter to inlist(kodnor,[01],[02],[03],[04],[05],[06],[07],[08])

select 0
use narax order kodbk

******************** DEFINES *************************

	DEFINE WINDOW wnarax ;
		FROM INT((SROW()-19)/2),INT((SCOL()-77)/2) ;
		TO INT((SROW()-19)/2)+18,INT((SCOL()-77)/2)+76 ;
		TITLE " Ввўд,корегування нарахувань " ;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW SYSTEM;
		color schem 8

define popup pop_pil scroll marg prom fields;
tm.kodpil+[│]+dovpil.nazpil+[│]+str(dovpil.pil,3)+[│]+tm.fiopil+[│]+;
dtoc(tm.date);
title [──Назва пўльги─────────%───Пўльговик─────────────────Дўйсна до───]
on select popup pop_pil deact popup

define popup pop_pil1 from 1,14 shad scroll marg;
	prompt field dovpil.kodpil+[ ]+padr(dovpil.nazpil,20)
on select popup pop_pil1 deact popup

define popup pop_nor from 6,44 shad scroll marg;
	prompt field dovnor.kodnor+[ ]+padr(dovnor.naznor,20)
on select popup pop_nor deact popup

************** BEGIN PROGRAMM ************************

ACTIVATE WINDOW wnarax

@ 1,21 GET m.kodbk SIZE 1,7 defa space(7);
	when fw_kodbk();
	valid fv_kodbk();
	error [ Рахунок не знайдено ]

READ CYCLE MODAL NOMOUSE
RELE WIND WNARAX

wait wind nowait [ Хвилинку ]
select zpilga
pack
wait clear

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
proc p_onkey
*****************
on key label F4  do pil_edit
on key label INS do pil_append
on key label F8 do pil_delete

*****************
proc p_offkey
*****************
on key label F4  
on key label INS 
on key label F8

*****************************
func fw_kodbk
*****************************
activ screen
@ 24,0 say padr([ F1 Пошук │ ESC Вихўд │],75) color &m_mescolor
activ wind wnarax
on key label f1 do p_poshuk
clear
@ 1,2 SAY "Особовий рахунок..."
@ 2,2 SAY "Поч.нарахувань....."
@ 3,2 SAY "Опломбовано........"
@ 4,2 SAY "Каналўзацўя........"
@ 5,2 SAY "К-сть прописаних..."
@ 6,2 SAY "Початкове сальдо..."
@ 6,33 SAY "Код норми..   -"
@ 1,31 TO 4,72 COLOR B/BG    
@ 8,2 TO 13,72 COLOR B/BG    
@ 1,33 SAY "Прўзвище,адреса" COLOR B/BG    
@ 15,29 SAY "[ Записати ]"
select dovad

*****************************
func fv_kodbk
*****************************
on key label f1
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
if not seek(mkod)
        on key label f1 do p_poshuk
        return .f.
endif

select narax
store dovad.kodbk to m.kodbk,m_kodbk
show gets

activ screen
@ 24,0 say padr([ Пўльги: │ INS Hовий │ F8 Знищити │ F4 Ред. │],75);
	color &m_mescolor
do p_onkey

activ wind wnarax

@ 2,33 say dovad.fio 
@ 3,33 say allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+[ ]+;
       iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[])

if seek(m.kodbk)
	scatter memvar
else
	scatter memvar blank
	m.kodbk=m_kodbk
	m.kanal=1
	wait wind nowait [ Новий абонент ]
endif

select zpilga
seek m.kodbk
copy to $pilga while m.kodbk==kodbk
select 0
use $pilga alias tm
set relat to kodpil into dovpil

select dovnor
if seek(m.kodnor)
	mnaznor=naznor
else
	mnaznor=[]
endif
@ 6,49 get mnaznor when .f. color w+/gb,w+/gb size 1,20

@ 2,21 get m.datev valid fv_datev()
@ 3,21 get m.oplomb when .f.
@ 4,21 get m.kanal SIZE 1,1
@ 5,21 GET m.kprop SIZE 1,2;
	valid m.kprop>0 error [ Невўрне значення ]
@ 6,21 GET m.saldn size 1,9 when .f.
@ 6,44 GET m.kodnor VALID fv_nor()
@ 8,2 get mpil pict [@&] popup pop_pil when fw_pil();
	size 6,71 defa 1 color w+/gb,w+/gb,b/gb,b/gb
@ 15,29 get msave pict [@*IT] defa 1 size 1,12 valid save001()

READ CYCLE MODAL NOMOUSE
m.kodbk=space(7)

select tm
use

do p_offkey

*************************
func fv_datev
*************************
if not empty(m.datev)
	m.oplomb={}
	show gets
endif

*************************
func save001
*************************
select narax
if not seek(m.kodbk)
	append blank
endif
gather memvar

select tm
use

select zpilga
seek m.kodbk
delete while kodbk==m.kodbk
append from $pilga

select 0
use $pilga alias tm

**************************
func fv_nor
**************************
select dovnor
if seek(m.kodnor)
	mnaznor=naznor
	show gets
	return .t.
endif

activ popup pop_nor
if last()=27
	mnaznor=[]
	show gets
	return .f.
endif

m.kodnor=kodnor
mnaznor=naznor
show gets

**************************
func fw_pil
**************************
select tm
if recc()=0
	return .f.
else
	return .t.
endif

************************************************************
proc pil_append
************************************************************
do p_offkey
select tm
	DEFINE WINDOW wpil ;
		FROM INT((SROW()-12)/2),INT((SCOL()-65)/2) ;
		TO INT((SROW()-12)/2)+11,INT((SCOL()-65)/2)+64 ;
		TITLE " Ввўд пўльги " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wpil
scatter memvar blank
m.kodbk=m_kodbk

@ 1,3 SAY "Код пўльги"
@ 7,31 SAY "Примўтка"
@ 1,17 SAY "-"
@ 3,3 SAY "Пўльговик..."
@ 5,3 SAY "Hомер посв.."
@ 6,3 SAY "Група......."
@ 7,3 SAY "KS.........."
@ 8,3 SAY "DV.........."
@ 5,31 SAY "Дўйсне до."
@ 8,54 SAY "[ OK ]"

@ 1,14 GET m.kodpil VALID fv_kodpil()
@ 3,15 GET m.fiopil 
@ 5,15 GET m.n_posv	
@ 5,41 GET m.date 
@ 6,15 GET m.gr size 1,1
@ 7,15 GET m.kc
@ 8,15 GET m.dv 
@ 8,31 GET m.memo 
@ 8,54 get msave pict [@*IT] defa 1 size 1,6 VALID fv_save()

READ CYCLE MODAL NOMOUSE
RELEASE WINDOW wpil
show gets
do p_onkey

*////////////////////
func fv_kodpil
*////////////////////
mkey=last()
if mkey=5 or mkey=19
	return .f.
endif
select dovpil
if seek(m.kodpil)
	@ 1,19 say padr(nazpil,20)
	select tm
	return .t.
endif

activ popup pop_pil1
if last()=27
	@ 1,19 say space(20)
	select tm
	return .f.
endif

m.kodpil=kodpil
@ 1,19 say padr(dovpil.nazpil,20)
show gets

*////////////////////
func fv_save
*////////////////////
insert into tm from memvar

************************************************************
proc pil_edit
************************************************************
do p_offkey
select tm
DEFINE WINDOW wpil ;
		FROM INT((SROW()-12)/2),INT((SCOL()-65)/2) ;
		TO INT((SROW()-12)/2)+11,INT((SCOL()-65)/2)+64 ;
		TITLE " Корегування пўльги " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wpil
scatter memvar
select dovpil
seek m.kodpil
@ 1,19 say padr(nazpil,20)
select tm

@ 1,3 SAY "Код пўльги"
@ 7,31 SAY "Примўтка"
@ 1,17 SAY "-"
@ 3,3 SAY "Пўльговик..."
@ 5,3 SAY "Hомер посв.."
@ 6,3 SAY "Група......."
@ 7,3 SAY "KS.........."
@ 8,3 SAY "DV.........."
@ 5,31 SAY "Дўйсне до."
@ 8,54 SAY "[ OK ]"

@ 1,14 GET m.kodpil VALID fv_kodpil()
@ 3,15 GET m.fiopil 
@ 5,15 GET m.n_posv	
@ 5,41 GET m.date 
@ 6,15 GET m.gr size 1,1
@ 7,15 GET m.kc
@ 8,15 GET m.dv 
@ 8,31 GET m.memo 
@ 8,54 get msave pict [@*IT] defa 1 size 1,6 VALID fv_save1()

READ CYCLE MODAL NOMOUSE
RELEASE WINDOW wpil
show gets
do p_onkey

*///////////////////
func fv_save1
*///////////////////
gather memvar

************************************************************
proc pil_delete
************************************************************
do p_offkey
select tm
m.mes = [ Знищити пўльгу ]+allt(dovpil.nazpil)+[ ?]
if p_confirm(m.mes,.t.)
	delete
	pack
	show gets
endif
do p_onkey
