store[ ] to m.kodv,m.kodnor,m.kodm
********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

wait wind nowait [ Хвилинку ]

select 0
use dovlich order kodm

select 0
use dovnor order kodnor
set filter to ov=0.00

select 0
use dovvul order kodv

select 0
use dovad order adr1
set relat to kodv into dovvul

select 0
use lichb order kodbl
set relat to f_adr1([lichb]) into dovad,kodnor into dovnor,;
	kodm into dovlich

wait clear

******************** DEFINES *************************

define wind wlichb from 2,1 to 22,78;
	color schem 10 panel

define popup pvul prom field dovvul.vul;
        from 4,12;
        color scheme 2 marg shad scroll
on select popup pvul deact popup

define popup pnor prom field dovnor.naznor;
        from 6,43;
        color scheme 2 marg shad
on select popup pnor deact popup

define popup pmarka prom field dovlich.marka;
        from 9,43;
        color scheme 2 marg shad scroll
on select popup pmarka deact popup


************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ INS Hовий │ DEL Знищити │]+;
				[ F4 Ред. │ Ctrl+ENTER Об.води │],75) color &m_mescolor

do p_onkey
browse field;
	dovvul.vul :r :h=[Вулиця],;
	bud :r :h=[Буд.],;
	lich :r :h=[№],;
	n_lich :r :h=[Номер],;
	pokn :r :h=[Поч.показ],;
	pokp :r :h=[Кўн.показ],;
	dovlich.marka :r :h=[Марка],;
	dovnor.naznor :r :h=[Цўна],;
	date_vst :r :h=[Дата вст.];
	noappend noedit nodelete wind wlichb;
	title [ Будинковў лўчильники ]

do p_offkey
pack

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
proc p_onkey
*****************
on key label F4  do p_kor
on key label INS do p_add
on key label DEL do p_del
on key label CTRL+ENTER do p_getpok

*****************
proc p_offkey
*****************
on key label F4  
on key label INS 
on key label DEL 
on key label CTRL+ENTER

**********************************************************
proc p_add
**********************************************************
do p_offkey

DEFINE WINDOW wlich1 ;
		FROM INT((SROW()-20)/2),INT((SCOL()-75)/2) ;
		TO INT((SROW()-20)/2)+19,INT((SCOL()-75)/2)+74 ;
		TITLE " Встановлення нового лўчильника " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wlich1

@ 1,2 SAY "Дата встановлення"
@ 4,5 SAY "Вулиця"
@ 7,2  SAY "Лўчильник........."
@ 4,43 SAY "Будинок"
@ 9,2  SAY "Hомер............."
@ 11,2 SAY "Початковий показ.."
@ 13,2 SAY "Середнўй показ...."
@ 7,37 SAY "Цўна"
@ 10,37 SAY "Марка"
@ 3,2 to 5,66 color w/br
@ 6,43 to 8,66 color w/br
@ 9,43 to 11,66 color w/br
@ 3,4 say [Адреса] color w/br
@ 16,28 SAY "[ Записати ]"


scatter memvar blank
m.date_vst=date()
m.nor=space(20)
m.marka=space(10)
m.vul=space(25)

@ 1,20 GET m.date_vst valid fv_date()
@ 4,12 GET m.vul valid fv_vul()	error [ Введўть вулицю ]
@ 4,51 GET m.bud valid fv_bud();
	error [ Будинок не знайдено ]
@ 7,20 GET m.lich valid fv_lich();
	error [ Лўчильник вже ўснуї ]
@ 9,20 GET m.n_lich 
@ 11,20 GET m.pokn
@ 13,20 GET m.poks disable
@ 7,45 GET m.nor valid fv_nor() error [ Введўть цўну ]
@ 10,45 GET m.marka valid fv_marka()
@ 16,28 get mmm001 pict [@*IT] defa 1 size 1,12 valid f_save()

READ CYCLE NOMOUSE MODAL
RELEASE WINDOW wlich1
select lichb
do p_onkey

*//////////////////////
func fv_date
*//////////////////////
key=last()
if key=19 or key=5
	return .f.
endif

*/////////////////////
func fv_vul
*/////////////////////
select dovvul
set order to vul
if !seek(m.vul)
        m.vul=chrtran(m.vul,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
           [ЙЦУКЕ]+CHR(141)+[ГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
        seek(m.vul)
        activ popup pvul rest
        if last()=27
                return .f.
        endif
endif
m.kodv=dovvul.kodv
m.vul=dovvul.vul
set order to kodv

*/////////////////////
func fv_bud
*/////////////////////
select dovad
if not seek(m.kodv+padr(allt(m.bud),4))
	select lichb
	return .f.
endif
select lichb

*///////////////////////
func fv_lich
*///////////////////////
return not seek(m.kodv+padr(allt(m.bud),4)+m.lich)

*/////////////////////
func fv_nor
*/////////////////////
select dovnor
count to m
if m=0
	wait wind [ Нема даних в довўднику норм ]
	return .f.
endif
set order to naznor
if !seek(m.nor)
        seek(m.nor)
        activ popup pnor rest
        if last()=27
                return .f.
        endif
endif
m.kodnor=dovnor.kodnor
m.nor=dovnor.naznor
set order to kodnor

*////////////////////////
func fv_marka
*///////////////////////
if last()#13
	return .t.
endif
select dovlich
set order to marka
if !seek(m.marka)
        m.marka=chrtran(m.marka,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
           [ЙЦУКЕ]+CHR(141)+[ГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
        seek(m.marka)
        activ popup pmarka rest
        if last()=27
                return .f.
        endif
endif
m.kodm=dovlich.kodm
m.marka=dovlich.marka
set order to kodm

*///////////////////////
func f_save
*///////////////////////
select lichb
insert into lichb from memvar

***************************************************
proc p_kor
***************************************************
do p_offkey
if recc()=0
        wait wind nowait [ Довўдник порожнўй ]
        do p_onkey
        return
endif
DEFINE WINDOW wlich1 ;
		FROM INT((SROW()-20)/2),INT((SCOL()-75)/2) ;
		TO INT((SROW()-20)/2)+19,INT((SCOL()-75)/2)+74 ;
		TITLE " Корегування лўчильника " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wlich1

@ 1,2 SAY "Дата встановлення"
@ 4,5 SAY "Вулиця"
@ 7,2  SAY "Лўчильник........."
@ 4,43 SAY "Будинок"
@ 9,2  SAY "Hомер............."
@ 11,2 SAY "Початковий показ.."
@ 13,2 SAY "Середнўй показ...."
@ 7,37 SAY "Цўна"
@ 10,37 SAY "Марка"
@ 3,2 to 5,66 color w/br
@ 6,43 to 8,66 color w/br
@ 9,43 to 11,66 color w/br
@ 3,4 say [Адреса] color w/br
@ 16,28 SAY "[ Записати ]"


scatter memvar
m.nor=dovnor.naznor
m.marka=dovlich.marka
m.vul=dovvul.vul

@ 1,20 GET m.date_vst valid fv_date()
@ 4,12 GET m.vul valid fv_vul()	error [ Введўть вулицю ]
@ 4,51 GET m.bud valid fv_bud();
	error [ Будинок не знайдено ]
@ 7,20 GET m.lich 
@ 9,20 GET m.n_lich 
@ 11,20 GET m.pokn SIZE 1,12 
@ 13,20 GET m.poks SIZE 1,12 disable
@ 7,45 GET m.nor valid fv_nor() error [ Введўть цўну ]
@ 10,45 GET m.marka valid fv_marka()
@ 16,28 get mmm001 pict [@*IT] defa 1 size 1,12 valid f_save1()

READ CYCLE NOMOUSE MODAL
RELEASE WINDOW wlich1
select lichb
do p_onkey

*///////////////////////
func f_save1
*///////////////////////
select lichb
gather memvar

************************************************
proc p_del
************************************************
if recc()=0
        wait wind nowait [ Довўдник порожнўй ]
        do p_onkey
        return
endif
do p_offkey
if not deleted()
	mmess=[ Знищити лўчильник ]+allt(dovvul.vul)+[ ]+allt(bud)+[ ?]
else
	mmess=[ Вўдновити лўчильник ]+allt(dovvul.vul)+[ ]+allt(bud)+[ ?]
endif

if p_confirm(mmess,.t.)
	if not deleted()
		delete
	else 
		recall
	endif
endif
do p_onkey

***************************************************
proc p_getpok
***************************************************
push key
on key
define wind www from 14,0 to 18,79;
	doub shad color schem 5;
	title [ ]+allt(dovvul.vul)+[ ]+allt(bud)+[ ]
activ wind www
scatter memvar
@ 1,2 say [Поч.показ] get m.pokn when .f.
@ 1,28 say [Кўн.показ] get m.pokp valid fv_001()
@ 1,54 say [Об.води] get m.ov 
READ MODAL NOMOUSE
if last()=13
	repl pokp with m.pokp,ov with m.ov
endif
rele wind www
pop key

*//////////////
func fv_001
*//////////////
ov=m.pokp-m.pokn

	