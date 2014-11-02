********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

select 0
use dovvul order kodv

select 0
use dovad order adr1
set relat to kodv into dovvul

select 0
use dovnor order kodnor

select 0
use raznarax order type
set relat to kodnor into dovnor,;
	f_adr1([raznarax]) into dovad

select 0
use narax order kodbk

select raznarax

******************** DEFINES *************************

define wind www from 2,2 to 20,61;
	title [Разовў змўни];
	system color schem 10

define popup pop_nor from 6,20 shad scroll marg;
	prompt field dovnor.kodnor+[ ]+padr(dovnor.naznor,20)
on select popup pop_nor deact popup

define popup pvul prom field dovvul.vul;
        from 6,20;
        color scheme 2 marg shad scroll
on select popup pvul deact popup

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ INS Hовий │ DEL Знищити │ F4 Ред. │ ESC Вих. │],75);
	 color &m_mescolor

activ wind www
do p_onkey
brow field;
	asdf = fasdf() :35 :h=[Абоненти],;
	dovnor.naznor :w=.f. :h=[Норма витрат води];
	noappend nodelete noedit
do p_offkey
rele wind www

select raznarax
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

*****************
proc p_offkey
*****************
on key label F4
on key label INS
on key label DEL

********************
func fasdf
********************
if not empty(kodbk1) and not empty(kodbk2)
	return kodbk1+[ - ]+kodbk2
endif
if not empty(kodbk1) and empty(kodbk2)
	return kodbk1
endif
if not empty(dil)
	return [Дўльниця - ]+dil
endif
if not empty(kodv) 
	return allt(dovvul.vul)+[ ]+allt(bud)
endif

******************************************************
proc p_append
******************************************************
do p_offkey

DEFINE WINDOW wrnar ;
		FROM INT((SROW()-16)/2),INT((SCOL()-77)/2) ;
		TO INT((SROW()-13)/2)+15,INT((SCOL()-77)/2)+76 ;
		TITLE " Ввўд разових змўн " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wrnar

do pscr

scatter memvar blank
m.vul=space(25)
mnaznor=[]

@ 0,51 get msel pict [@*I] size 1,22 defa 1 valid fv_group()
@ 1,51 get msel pict [@*I] size 1,22 defa 1 valid fv_kodbk()
@ 2,51 get msel pict [@*I] size 1,22 defa 1 valid fv_dil()
@ 3,51 get msel pict [@*I] size 1,22 defa 1 valid fv_adr()

@ 3,16 GET m.dil DISABLE;
	valid fv_dil1();
	error [ Дўльницю не знайдено ]
@ 7,5 GET m.kodbk1 DISABLE;
	valid fv_kodbk1(1);
	error [ Рахунок не знайдено ]
@ 7,32 GET m.kodbk1 DISABLE;
	valid fv_kodbk1(1);
	error [ Рахунок не знайдено ]
@ 7,48 GET m.kodbk2 DISABLE;
	valid fv_kodbk1(2);
	error [ Рахунок не знайдено ]
@ 11,12 GET m.vul DISABLE;
	valid fv_vul();
	error [ Введўть вулицю ]
@ 11,51 GET m.bud DISABLE;
	valid fv_bud();
	error [ Будинок не знайдено ]
@ 14,14 get m.kodnor DISABLE;
	valid fv_kodnor();
	error [ Невўрне значення ]
@ 14,62 get msel DISABLE pict [@*IT] size 1,6 defa 1 valid fv_OK()
@ 14,17 get mnaznor size 1,20 when .f. color ,w+/br

READ CYCLE MODAL NOMOUSE
RELEASE WINDOW wrnar
do p_onkey

**********************
func fv_group
**********************
SHOW OBJECT 7 ENABLE
SHOW OBJECT 8 ENABLE
SHOW OBJECT 11 ENABLE
SHOW OBJECT 12 ENABLE

SHOW OBJECT 1 DISABLE
SHOW OBJECT 2 DISABLE
SHOW OBJECT 3 DISABLE
SHOW OBJECT 4 DISABLE

**********************
func fv_kodbk
**********************
SHOW OBJECT 6 ENABLE
SHOW OBJECT 11 ENABLE
SHOW OBJECT 12 ENABLE

SHOW OBJECT 1 DISABLE
SHOW OBJECT 2 DISABLE
SHOW OBJECT 3 DISABLE
SHOW OBJECT 4 DISABLE

**********************
func fv_dil
**********************
SHOW OBJECT 5 ENABLE
SHOW OBJECT 11 ENABLE
SHOW OBJECT 12 ENABLE

SHOW OBJECT 1 DISABLE
SHOW OBJECT 2 DISABLE
SHOW OBJECT 3 DISABLE
SHOW OBJECT 4 DISABLE

**********************
func fv_adr
**********************
SHOW OBJECT 9 ENABLE
SHOW OBJECT 10 ENABLE
SHOW OBJECT 11 ENABLE
SHOW OBJECT 12 ENABLE

SHOW OBJECT 1 DISABLE
SHOW OBJECT 2 DISABLE
SHOW OBJECT 3 DISABLE
SHOW OBJECT 4 DISABLE

*********************
func fv_dil1
*********************
select dovad
set order to kodbk
seek(m.dil)
if subs(kodbk,1,1)==m.dil
	mresult=.t.
else
	mresult=.f.
endif
set order to adr1
select raznarax
return mresult

*********************
func fv_kodbk1
*********************
param mpar
mmkod=iif(mpar=1,m.kodbk1,m.kodbk2)
if len(allt(mmkod))#7
        mkod=val(mmkod)
else
        mkod=val(subs(mmkod,2))
endif

select dovad
morder=order()
set order to kod
mresult=seek(mkod)
mmkod=kodbk
set order to &morder

if mresult
	if mpar=1
		m.kodbk1=mmkod
	else
		m.kodbk2=mmkod
	endif
	show gets
	select narax
	seek mmkod
	select dovnor
	seek narax.kodnor
	mmm=naznor
	select dovad
	wait wind nowait;
	allt(fio)+[,]+allt(dovvul.vul)+[,]+allt(mmm)
endif

set order to adr1
select raznarax
return mresult

**************************
func fv_kodnor
**************************
select dovnor
if seek(m.kodnor)
	mnaznor=naznor
	show gets
	select raznarax
	return .t.
endif

activ popup pop_nor
if last()=27
	mnaznor=[]
	show gets
	select raznarax
	return .f.
endif

m.kodnor=kodnor
mnaznor=naznor
show gets
select raznarax

**********************
func fv_vul
**********************
select dovvul
set order to vul
if !seek(m.vul)
        m.vul=chrtran(m.vul,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
           [ЙЦУКЕ]+CHR(141)+[ГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
        seek(m.vul)
        activ popup pvul rest
        if last()=27
                set order to kodv
                select raznarax
                return .f.
        endif
endif
m.kodv=dovvul.kodv
m.vul=dovvul.vul
set order to kodv
select raznarax

**********************
func fv_bud
**********************
select dovad
if not seek(m.kodv+padr(allt(m.bud),4))
   select raznarax
return .f.
endif
select raznarax

*********************
func fv_OK
*********************
insert into raznarax from memvar

*********************
proc pscr
*********************
@ 0,51 SAY "[ Група ос. рахункўв ]"
@ 1,51 SAY "[ Особовий рахунок   ]"
@ 2,51 SAY "[ Дўльниця           ]"
@ 3,51 SAY "[ Адреса             ]"
*
@ 10,3 TO 12,56 COLOR W/RB    
@ 6,28 TO 8,56 	COLOR W/RB    
@ 6,3 TO 8,26 	COLOR W/RB    
@ 2,3 TO 4,26 	COLOR W/RB    
@ 3,5 SAY "№ дўльницў"
@ 2,5 SAY "Дўльниця" COLOR W/RB    
@ 6,5 SAY "Особовий рахунок" COLOR W/RB    
@ 6,30 SAY "Група ос. рахункўв" COLOR W/RB    
@ 7,30 SAY "з"
@ 7,45 SAY "по"
@ 10,5 SAY "Адреса" COLOR W/RB    
@ 11,5 SAY "Вулиця"
@ 11,43 SAY "Будинок"
@ 14,62 SAY "[ OK ]"
@ 14,4 say [Код норми]

******************************************************
proc p_edit
******************************************************
select raznarax
if recc()=0
	wait wind nowait [ Таблиця порожня ]
	return
endif

do p_offkey

DEFINE WINDOW wrnar ;
		FROM INT((SROW()-16)/2),INT((SCOL()-77)/2) ;
		TO INT((SROW()-13)/2)+15,INT((SCOL()-77)/2)+76 ;
		TITLE " Корегування разових змўн " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wrnar

do pscr

scatter memvar
m.vul=dovvul.vul
mnaznor=dovnor.naznor

mnnr=razindex()
do case
	case mnnr=[0]
		@ 3,16 GET m.dil 	valid fv_dil1();
			error [ Дўльницю не знайдено ]
	case mnnr=[1]
		@ 11,12 GET m.vul 	valid fv_vul();
			error [ Введўть вулицю ]
		@ 11,51 GET m.bud 	valid fv_bud();
		 	error [ Будинок не знайдено ]
	case mnnr=[2]
		@ 7,32 GET m.kodbk1 	valid fv_kodbk1(1);
			error [ Рахунок не знайдено ]
		@ 7,48 GET m.kodbk2 	valid fv_kodbk1(2);
			error [ Рахунок не знайдено ]
	case mnnr=[3]
		@ 7,5 GET m.kodbk1 	valid fv_kodbk1(1);
			error [ Рахунок не знайдено ]
endcase

@ 14,14 get m.kodnor;
	valid fv_kodnor();
	error [ Невўрне значення ]
@ 14,62 get msel pict [@*IT] size 1,6 defa 1 valid fv_OK1()
@ 14,17 get mnaznor size 1,20 when .f. color ,w+/br

READ CYCLE MODAL NOMOUSE
RELEASE WINDOW wrnar
do p_onkey

*********************
func fv_OK1
*********************
select raznarax
gather memvar

*********************************************************
proc p_delete
*********************************************************
do p_offkey
select raznarax
if recc()=0
        wait wind nowait [ Довўдник порожнўй ]
        do p_onkey
        return
endif
if deleted()
       if p_confirm(" Вўдновити ? ",.t.)
                recall
       endif
else
       mcc=[Знищити запис ?]
       if p_confirm(mcc,.t.)
                delete
       endif
endif
do p_onkey
